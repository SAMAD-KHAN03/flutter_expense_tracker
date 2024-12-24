const functions = require("firebase-functions");
const admin = require("firebase-admin");
const fetch = require("node-fetch");

admin.initializeApp();

exports.sendExpenseReminders = functions.pubsub
  .schedule("every 30 minutes")
  .onRun(async (context) => {
    const db = admin.firestore();
    const now = new Date();
    const oneHourFromNow = new Date(now.getTime() + 60 * 60 * 1000);

    try {
      const usersSnapshot = await db.collection("users").get();

      if (usersSnapshot.empty) {
        console.log("No users found.");
        return null;
      }

      const promises = [];
      usersSnapshot.forEach(async (userDoc) => {
        const userUid = userDoc.id;
        const expensesSnapshot = await db
          .collection("users")
          .doc(userUid)
          .collection("expenses")
          .where("isScheduled", "==", true)
          .where("isEmailSent", "==", true)
          .get();

        if (!expensesSnapshot.empty) {
          const batch = db.batch();

          expensesSnapshot.forEach((expenseDoc) => {
            const expense = expenseDoc.data();
            const requestData = {
              emailBody: `Reminder: You have a scheduled expense "${expense.name}" due on ${expense.dueDate}.`,
              emailSender: "your_verified_email@example.com", // Your SES verified email
              emailReceiver: expense.userEmail,
            };

            // Send HTTP POST request to your Node.js server
            promises.push(
              fetch("http://your-node-server-url/send-email", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(requestData),
              }).then((response) => {
                if (!response.ok) {
                  throw new Error(
                    `Failed to send reminder for expense ID: ${expenseDoc.id}`
                  );
                }
              })
            );

            // Mark the reminder as sent
            batch.update(expenseDoc.ref, { reminderSent: true });
          });

          await batch.commit(); // Update Firestore records
        }
      });

      await Promise.all(promises); // Wait for all HTTP requests to complete
      console.log("Reminders sent successfully.");
    } catch (error) {
      console.error("Error sending reminders:", error);
    }

    return null;
  });

const admin = require("/Users/samad/Documents/MyFlutterProjects/my_expenses/functions/node_modules/firebase-admin");

// Path to your service account JSON file
const serviceAccount = require("../../../nodegetstarted/expensetracker-4bfe7-firebase-adminsdk-zpvl7-2c0b4d973b.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

async function getAccessToken() {
  try {
    const token = await admin.credential.cert(serviceAccount).getAccessToken();
    // console.log("Access Token:", token.access_token);
    return token.access_token;
  } catch (error) {
    console.error("Error generating access token:", error);
    throw error;
  }
}
const PROJECT_ID = "expensetracker-4bfe7";
const DOCUMENT_PATH =
  "users/7VIK3XrRUqMHwTgLkE8SZ4VDGLc2/userProfile/profileDetails";
async function fetchFirestoreDocument() {
  const ACCESS_TOKEN = await getAccessToken(); // Get a fresh access token

  const options = {
    hostname: "firestore.googleapis.com",
    port: 443,
    path: `/v1/projects/${PROJECT_ID}/databases/(default)/documents/${DOCUMENT_PATH}`, // Update project ID and document path
    method: "GET",
    headers: {
      Authorization: `Bearer ${ACCESS_TOKEN}`, // Include the generated token here
    },
  };

  const https = require("https");
  const req = https.request(options, (res) => {
    let data = "";

    res.on("data", (chunk) => {
      data += chunk;
    });

    res.on("end", () => {
      console.log("Document Data:", JSON.parse(data));
    });
  });

  req.on("error", (err) => {
    console.error("Error fetching document:", err);
  });

  req.end();
}

// Call the function
fetchFirestoreDocument();

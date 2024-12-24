import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

DateTime convert(Timestamp input) {
  Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(1708411767000);

  // Convert Timestamp to DateTime
  DateTime dateTime = timestamp.toDate();
  print(dateTime);
  return dateTime;
}

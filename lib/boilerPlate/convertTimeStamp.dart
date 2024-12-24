import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

DateTime convert(Timestamp input) {


  // Convert Timestamp to DateTime
  DateTime dateTime = input.toDate();

  return dateTime;
}

import 'package:flutter/material.dart';
import 'package:laundry_management_system/customer_screen.dart';
import 'package:laundry_management_system/home_screen.dart';
import 'package:laundry_management_system/laundry_database.dart';
import 'package:laundry_management_system/order_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
    // LaundryDatabase.instance.database;
    LaundryDatabase.instance.insertData();
 // LaundryDatabase.instance.showData();
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: OrderScreen()
    ));
}

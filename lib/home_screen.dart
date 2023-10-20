// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> divisions = [];
  String? selectedDivision;
  List<dynamic> districts = [];
  String? selectedDistrict;
  List<dynamic> subDistricts = [];
  String? selectedSubDistrict;

  @override
  void initState() {
    super.initState();
    fetchDivisions();
     //log('Failed to fetch divisions');
  }

  ///fetched division
  Future<void> fetchDivisions() async {
    final response = await http
        .post(Uri.parse('https://teestacourier.com/api/merchant/get-divisions'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("division data: $data");
      setState(() {
        divisions = data['data'];
      });
    } else {
      log('Failed to fetch divisions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dependent Dropdown"),
        centerTitle: true,
      ),
    );
  }
}

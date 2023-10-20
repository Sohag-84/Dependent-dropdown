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
    //fetchDivisions();
    // fetchDistricts("10");
    //fetchSubDistricts("76");
    fetchArea("145");
  }

  ///fetched division
  Future<void> fetchDivisions() async {
    final response = await http.post(
        Uri.parse('https://teestacourier.com/api/merchant/get-divisions'));
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

  ///fetched district
  Future<void> fetchDistricts(String divisionId) async {
    final response = await http.post(
      Uri.parse(
          'https://teestacourier.com/api/merchant/get-district-by-division'),
      body: {"division_id": divisionId},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)["data"];
      log("District data: $data");
      setState(() {
        districts = data['data'];
        selectedDistrict = null;
        subDistricts = [];
        selectedSubDistrict = null;
      });
    } else {
      log('Failed to fetch districts  ${response.statusCode}');
    }
  }

  ///fetched thana
  Future<void> fetchSubDistricts(String districtId) async {
    final response = await http.post(
      Uri.parse('https://teestacourier.com/api/merchant/get-thana-by-district'),
      body: {
        "district_id": districtId,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("Thana data: $data");
      setState(() {
        subDistricts = data['data'];
        selectedSubDistrict = null;
      });
    } else {
      log('Failed to fetch sub-districts. ${response.statusCode}');
    }
  }

  ///fetched area
  Future<void> fetchArea(String thanaId) async {
    final response = await http.post(
      Uri.parse('https://teestacourier.com/api/merchant/get-area-by-thana'),
      body: {
        "thana_id": thanaId,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("Area data: $data");
      setState(() {
        subDistricts = data['data'];
        selectedSubDistrict = null;
      });
    } else {
      log('Failed to fetch sub-districts. ${response.statusCode}');
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

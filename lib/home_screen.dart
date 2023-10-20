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
  Future<void> fetchDistricts(int divisionId) async {
    final response = await http.post(
      Uri.parse(
          'https://teestacourier.com/api/merchant/get-district-by-division'),
      body: {
        "division_id": divisionId.toString(),
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
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
  Future<void> fetchSubDistricts(int districtId) async {
    final response = await http.post(
      Uri.parse('https://teestacourier.com/api/merchant/get-thana-by-district'),
      body: {
        "district_id": districtId.toString(),
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
  Future<void> fetchArea(int thanaId) async {
    final response = await http.post(
      Uri.parse('https://teestacourier.com/api/merchant/get-area-by-thana'),
      body: {
        "thana_id": thanaId.toString(),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Division
            Text(
              "Division",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              value: selectedDivision,
              onChanged: (newValue) {
                setState(() {
                  selectedDivision = newValue;
                  districts = [];
                  selectedDistrict = null;
                  subDistricts = [];
                  selectedSubDistrict = null;
                });
                fetchDistricts(divisions.firstWhere(
                    (division) => division['name'] == newValue)['id']);
              },
              items:
                  divisions.map<DropdownMenuItem<String>>((dynamic division) {
                return DropdownMenuItem<String>(
                  value: division['name'],
                  child: Text(
                    division['name'],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8),

            ///District
            Text(
              "District",
              style: TextStyle(color: Colors.black),
            ),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                labelStyle: TextStyle(color: Colors.blue),
              ),
              value: selectedDistrict,
              onChanged: (newValue) {
                setState(() {
                  selectedDistrict = newValue;
                  subDistricts = [];
                  selectedSubDistrict = null;
                });
                fetchSubDistricts(districts.firstWhere(
                    (district) => district['name'] == newValue)['id']);
              },
              items:
                  districts.map<DropdownMenuItem<String>>((dynamic district) {
                return DropdownMenuItem<String>(
                  value: district['name'],
                  child: Text(
                    district['name'],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 8),

            ///Thana
            Text(
              "Thana",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              value: selectedSubDistrict,
              onChanged: (newValue) {
                setState(() {
                  selectedSubDistrict = newValue;
                });
              },
              items: subDistricts
                  .map<DropdownMenuItem<String>>((dynamic subDistrict) {
                return DropdownMenuItem<String>(
                  value: subDistrict['name'],
                  child: Text(subDistrict['name']),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleRegistrationScreen extends StatefulWidget {
  @override
  _VehicleRegistrationScreenState createState() =>
      _VehicleRegistrationScreenState();
}

class _VehicleRegistrationScreenState extends State<VehicleRegistrationScreen> {
  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();

  final CollectionReference _vehicles =
      FirebaseFirestore.instance.collection('cars');

  Future<void> _registerVehicle() async {
    if (_vehicleNameController.text.isEmpty ||
        _vehicleNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('모든 필드를 입력하세요.')),
      );
      return;
    }

    try {
      await _vehicles.add({
        'name': _vehicleNameController.text.trim(),
        'number': _vehicleNumberController.text.trim(),
        'assignedStaff': '', // 처음에는 담당자가 없음
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('차량이 성공적으로 등록되었습니다.')),
      );

      // 입력 필드 초기화
      _vehicleNameController.clear();
      _vehicleNumberController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('차량 등록에 실패했습니다: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('차량 등록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _vehicleNameController,
              decoration: InputDecoration(
                labelText: '차량 모델',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _vehicleNumberController,
              decoration: InputDecoration(
                labelText: '차량 번호',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _registerVehicle,
              child: Text('차량 등록'),
            ),
          ],
        ),
      ),
    );
  }
}

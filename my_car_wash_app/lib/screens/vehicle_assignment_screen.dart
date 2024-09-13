import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleAssignmentScreen extends StatefulWidget {
  final String vehicleId;

  VehicleAssignmentScreen({required this.vehicleId});

  @override
  _VehicleAssignmentScreenState createState() =>
      _VehicleAssignmentScreenState();
}

class _VehicleAssignmentScreenState extends State<VehicleAssignmentScreen> {
  String? _selectedStaff;
  String? _selectedCompany;
  String? _selectedBranch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('차량 배정'),
      ),
      body: Column(
        children: [
          // 업체별 선택
          DropdownButton<String>(
            hint: Text('업체 선택'),
            value: _selectedCompany,
            onChanged: (newValue) {
              setState(() {
                _selectedCompany = newValue;
              });
            },
            items: ['업체1', '업체2'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // 지점별 선택
          DropdownButton<String>(
            hint: Text('지점 선택'),
            value: _selectedBranch,
            onChanged: (newValue) {
              setState(() {
                _selectedBranch = newValue;
              });
            },
            items: ['지점1', '지점2'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // 담당자 배정
          DropdownButton<String>(
            hint: Text('세차 담당자 선택'),
            value: _selectedStaff,
            onChanged: (newValue) {
              setState(() {
                _selectedStaff = newValue;
              });
            },
            items:
                ['담당자1', '담당자2'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_selectedStaff != null) {
                await FirebaseFirestore.instance
                    .collection('cars')
                    .doc(widget.vehicleId)
                    .update({
                  'assignedStaff': _selectedStaff,
                  'assignedCompany': _selectedCompany,
                  'assignedBranch': _selectedBranch,
                });
                Navigator.pop(context); // 배정 후 목록으로 돌아감
              }
            },
            child: Text('배정 완료'),
          ),
        ],
      ),
    );
  }
}

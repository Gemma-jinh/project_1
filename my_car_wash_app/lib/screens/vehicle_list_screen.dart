import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'vehicle_assignment_screen.dart'; // 배정 화면
import 'vehicle_registration_screen.dart';
import 'vehicle_search_delegate.dart'; //검색기능
import 'excel_upload_screen.dart';

class VehicleListScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('차량 목록'),
        actions: [
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: () {
              // 검색 기능 추가
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ExcelUploadScreen()), //엑셀 업로드 화면으로 이동
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('cars')
            .snapshots(), //Firestore에서 cars컬렉션 데이터를 스트림으로 가져와 차량 목록을 보여줌
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('등록된 차량이 없습니다.'));
          }
          final vehicles = snapshot.data!.docs;
          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              var vehicle = vehicles[index];
              return ListTile(
                title: Text(vehicle['model']),
                subtitle: Text('번호: ${vehicle['number']}'),
                trailing: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VehicleAssignmentScreen(vehicleId: vehicle.id),
                      ),
                    );
                  },
                  child: Text('배정'),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VehicleRegistrationScreen()), // 차량 등록 화면으로 이동
          );
        },
        child: Icon(Icons.add), // 차량 등록 버튼
      ),
    );
  }
}

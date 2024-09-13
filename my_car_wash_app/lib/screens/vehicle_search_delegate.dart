import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleSearchDelegate extends SearchDelegate {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('cars')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff') // 검색 범위
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('검색 결과가 없습니다.'));
        }
        final vehicles = snapshot.data!.docs;
        return ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            var vehicle = vehicles[index];
            return ListTile(
              title: Text(vehicle['name']),
              subtitle: Text('번호: ${vehicle['number']}'),
              onTap: () {
                close(context, vehicle); // 결과 선택 시
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('검색어를 입력하세요.'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('cars')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('추천 차량이 없습니다.'));
        }
        final vehicles = snapshot.data!.docs;
        return ListView.builder(
          itemCount: vehicles.length,
          itemBuilder: (context, index) {
            var vehicle = vehicles[index];
            return ListTile(
              title: Text(vehicle['name']),
              subtitle: Text('번호: ${vehicle['number']}'),
              onTap: () {
                query = vehicle['name']; // 검색창에 클릭한 차량 이름을 입력
                showResults(context); // 검색 결과 표시
              },
            );
          },
        );
      },
    );
  }
}

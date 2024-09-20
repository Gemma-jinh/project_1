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
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
      future: searchVehicles(query), // 검색어를 기반으로 차량 검색
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // 로딩 중 표시
        }

        if (snapshot.hasError) {
          return Center(child: Text('오류 발생: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('검색 결과가 없습니다.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final vehicle = snapshot.data![index];
            return ListTile(
              title: Text(vehicle['vehicleNumber'] ?? '차량번호 없음'),
              subtitle: Text(
                  '모델: ${vehicle['model'] ?? '모델 정보 없음'}\n고객사: ${vehicle['customerName'] ?? '고객사 정보 없음'}\n위치: ${vehicle['location'] ?? '위치 정보 없음'}'),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: searchVehicles(query), // 검색어를 기반으로 제안 표시
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // 로딩 중일 때 표시
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('검색어를 입력하세요.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final vehicle = snapshot.data![index];
            return ListTile(
              title: Text(vehicle['vehicleNumber'] ?? '차량번호 없음'),
              subtitle: Text(
                  '모델: ${vehicle['model'] ?? '모델 정보 없음'}\n고객사: ${vehicle['customerName'] ?? '고객사 정보 없음'}\n위치: ${vehicle['location'] ?? '위치 정보 없음'}'),
              onTap: () {
                query = vehicle['vehicleNumber']!;
                showResults(context); // 검색 결과 표시
              },
            );
          },
        );
      },
    );
  }

  // Firestore에서 차량 번호, 차량 모델, 고객사 명, 위치로 검색하는 함수
  Future<List<Map<String, dynamic>>> searchVehicles(String searchQuery) async {
    // Firestore 쿼리 실행
    final querySnapshot = await FirebaseFirestore.instance
        .collection('cars')
        .where('searchKeywords',
            arrayContains: searchQuery.toLowerCase()) // 여러 필드에 대한 검색
        .get();

    // 검색 결과 반환
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}

//   @override
//   Widget buildResults(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore
//           .collection('cars')
//           .where('name', isGreaterThanOrEqualTo: query)
//           .where('name', isLessThanOrEqualTo: query + '\uf8ff') // 검색 범위
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(child: Text('검색 결과가 없습니다.'));
//         }
//         final vehicles = snapshot.data!.docs;
//         return ListView.builder(
//           itemCount: vehicles.length,
//           itemBuilder: (context, index) {
//             var vehicle = vehicles[index];
//             return ListTile(
//               title: Text(vehicle['name']),
//               subtitle: Text('번호: ${vehicle['number']}'),
//               onTap: () {
//                 close(context, vehicle); // 결과 선택 시
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     if (query.isEmpty) {
//       return Center(child: Text('검색어를 입력하세요.'));
//     }

//     return StreamBuilder<QuerySnapshot>(
//       stream: _firestore
//           .collection('cars')
//           .where('name', isGreaterThanOrEqualTo: query)
//           .where('name', isLessThanOrEqualTo: query + '\uf8ff')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Center(child: Text('추천 차량이 없습니다.'));
//         }
//         final vehicles = snapshot.data!.docs;
//         return ListView.builder(
//           itemCount: vehicles.length,
//           itemBuilder: (context, index) {
//             var vehicle = vehicles[index];
//             return ListTile(
//               title: Text(vehicle['name']),
//               subtitle: Text('번호: ${vehicle['number']}'),
//               onTap: () {
//                 query = vehicle['name']; // 검색창에 클릭한 차량 이름을 입력
//                 showResults(context); // 검색 결과 표시
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }
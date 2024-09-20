import 'package:cloud_firestore/cloud_firestore.dart';

// Firestore에서 데이터를 검색하는 로직을 처리하는 서비스. 검색 조건에 따라 Firestore 쿼리를 실행
//하여 해당 데이터를 불러오는 역할.
class SearchService {
  // 차량 번호, 담당자, 고객사, 차종, 차량 모델, 지역으로 차량 검색
  Future<List<Map<String, dynamic>>> searchVehicles({
    // 검색 기능을 구현하기 위해 사용하는 비동기 함수
    //여러 개의 검색 조건을 받아서, 해당 조건에 맞는 Firestore 데이터를 검색하고, 그 결과를 반환
    // Dart의 비동기 프로그래밍 방식인 Future와 함께 사용.
    String? number,
    String? staffName,
    String? customerName,
    String? model,
    String? type,
    String? location,
  }) async {
    // Firestore 컬렉션에서 'cars' 문서를 조회
    Query query = FirebaseFirestore.instance.collection('cars');

    // 차량 번호로 검색
    if (number != null && number.isNotEmpty) {
      query = query.where('number', isEqualTo: number);
    }

    // 담당자 이름으로 검색
    if (staffName != null && staffName.isNotEmpty) {
      query = query.where('staffName', isEqualTo: staffName);
    }

    // 고객사 이름으로 검색
    if (customerName != null && customerName.isNotEmpty) {
      query = query.where('customerName', isEqualTo: customerName);
    }

    // 차량 모델로 검색
    if (model != null && model.isNotEmpty) {
      query = query.where('model', isEqualTo: model);
    }

    // 차종으로 검색
    if (type != null && type.isNotEmpty) {
      query = query.where('type', isEqualTo: type);
    }

    // 위치로 검색 (고객사의 위치)
    if (location != null && location.isNotEmpty) {
      query = query.where('location', isEqualTo: location);
    }
    // Firestore에서 쿼리 실행 후 결과 가져오기
    QuerySnapshot querySnapshot =
        await query.get(); // 비동기 함수이기 때문에 await 사용하여 호출

    // 검색 결과를 리스트 형태로 변환하여 반환
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
}

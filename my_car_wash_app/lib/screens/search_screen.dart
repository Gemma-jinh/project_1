import 'package:flutter/material.dart';
import '../services/search_service.dart'; // 검색 로직을 담당할 서비스
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 접근

class SearchPage extends StatefulWidget {
  @override // statefulWidget 클래스의 createState 메서드 재정의
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchService _searchService = SearchService();
  String? selectedType;
  String? selectedModel;
  String? selectedRegion;
  String? selectedLocation;
  String? number;
  String? staffName;
  String? customerName;

  //  차량 모델
  Map<String, List<String>> vehicleModelsByType = {
    '경형': ['모닝', '레이'],
    '소형': ['소나타', 'K5'],
    '중형': ['그랜저', '디올뉴그랜저3.5'],
    '대형': ['제네시스', 'K9'],
    '승합(10인승 이하)': ['카니발', '스타렉스'],
    '승합(11인승 이상)': ['스프린터', '마스터'],
  };

  // 지역 및 장소
  Map<String, List<String>> locationsByRegion = {
    '서울': ['강남구', '송파구', '마포구'],
    '경기': ['수원시', '성남시', '용인시'],
    '부산': ['해운대구', '남구', '동래구'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('차량 검색'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 차량 번호 입력
            TextField(
              decoration: InputDecoration(labelText: '차량 번호 입력'),
              onChanged: (value) {
                setState(() {
                  number = value;
                });
              },
            ),
            // 담당자 이름 입력
            TextField(
              decoration: InputDecoration(labelText: '담당자 이름 입력'),
              onChanged: (value) {
                setState(() {
                  staffName = value;
                });
              },
            ),
            // 고객사 이름 입력
            TextField(
              decoration: InputDecoration(labelText: '고객사 이름 입력'),
              onChanged: (value) {
                setState(() {
                  customerName = value;
                });
              },
            ),
            // 지역 선택 Dropdown
            DropdownButton<String>(
              value: selectedRegion,
              hint: Text('지역 선택'),
              items: locationsByRegion.keys
                  .map((region) => DropdownMenuItem<String>(
                        value: region,
                        child: Text(region),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedRegion = value;
                  selectedLocation = null; // 지역 변경 시 장소 초기화
                });
              },
            ),
            // 장소 선택 Dropdown (지역 선택 후)
            if (selectedRegion != null)
              DropdownButton<String>(
                value: selectedLocation,
                hint: Text('장소 선택'),
                items: locationsByRegion[selectedRegion]!
                    .map((location) => DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value;
                  });
                },
              ),
            // 차종 선택 Dropdown
            DropdownButton<String>(
              value: selectedType,
              hint: Text('차종 선택'),
              items: vehicleModelsByType.keys
                  .map((type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                  selectedModel = null; // 차종 변경 시 모델 초기화
                });
              },
            ),
            // 차량 모델 선택 Dropdown (차종 선택 후)
            if (selectedType != null)
              DropdownButton<String>(
                value: selectedModel,
                hint: Text('차량 모델 선택'),
                items: vehicleModelsByType[selectedType]!
                    .map((model) => DropdownMenuItem<String>(
                          value: model,
                          child: Text(model),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedModel = value;
                  });
                },
              ),
            // 검색 버튼
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // 검색 결과 처리 (필요한 조건만 전달)
                var searchResults = await _searchService.searchVehicles(
                  number: number,
                  staffName: staffName,
                  customerName: customerName,
                  model: selectedModel,
                  location: selectedLocation,
                );
                // 검색 결과 출력
                print(searchResults);
              },
              child: Text('검색'),
            ),
          ],
        ),
      ),
    );
  }
}

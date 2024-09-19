import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExcelUploadService {
  static Future<void> processExcelBytes(
      Uint8List fileBytes, String fileName) async {
    try {
      // Firebase Storage에 파일 업로드
      // Reference storageRef =
      //     FirebaseStorage.instance.ref().child('excel_files/$fileName');
      // await storageRef.putFile(file);

      // 업로드된 파일 다운로드 URL 가져오기
      // String downloadUrl = await storageRef.getDownloadURL();

      // 필요시, Firestore에 파일 URL 저장 또는 파일 내용 처리
      // 예시: Firestore에 파일 URL 저장
      // await FirebaseFirestore.instance.collection('uploaded_files').add({
      //   'fileName': fileName,
      //   'fileUrl': downloadUrl,
      //   'uploadedAt': FieldValue.serverTimestamp(),
      // });

      // 엑셀 파일을 처리하여 데이터를 Firestore로 업로드하는 로직 추가 가능
      //     await processExcelFile(file);
      //   } catch (e) {
      //     throw Exception('파일 업로드 실패: $e');
      //   }
      // }

      // 엑셀 파일 파싱 및 Firestore로 데이터 저장
      // static Future<void> processExcelFile(File file) async {
      //   try {
      // var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(fileBytes);
      var sheet = excel.tables[excel.tables.keys.first]!; // 첫 번째 시트 사용

      // 첫 번째 행을 헤더로 간주하여 차량 번호와 모델 열의 위치 찾기
      int numberColumnIndex = 2;
      int modelColumnIndex = 3;
      // var headerRow = sheet.rows.first;

      print("헤더 정보:");
      // 헤더 행에서 '차량번호'와 '모델' 열을 찾음
      // for (int i = 0; i < headerRow.length; i++) {
      //   String headerValue =
      //       _convertToString(headerRow[i]?.value).trim().toLowerCase();
      //   if (headerValue.contains('차량번호')) {
      //     numberColumnIndex = i;
      //   } else if (headerValue == '차종') {
      //     modelColumnIndex = i;
      //   }
      // }
      // 차량번호 열과 모델 열을 찾았는지 확인
      // if (numberColumnIndex != -1 && modelColumnIndex != -1) {
      int autoIncrementNumber = 1;

      // 각 시트의 데이터를 Firestore에 저장하는 로직
      // for (var table in excel.tables.keys) {
      //   var sheet = excel.tables[table]!;
      for (var row in sheet.rows.skip(1)) {
        // 예시: Firestore에 차량 데이터 저장
        // String firstColumnValue =
        //     row.length > 0 ? _convertToString(row[0]?.value) : '';
        // if (firstColumnValue.toLowerCase() == '세차 제외') {
        //   continue;
        // }

        // 차량 번호와 모델 데이터를 각 열에서 정확히 가져오기
        String number = row.length > numberColumnIndex
            ? _convertToString(row[numberColumnIndex]?.value)
            : '';
        String model = row.length > modelColumnIndex
            ? _convertToString(row[modelColumnIndex]?.value)
            : '';

        // 유효한 차량 번호와 모델인 경우 Firestore에 저장
        if (_isValidNumber(number) && _isValidModel(model)) {
          await FirebaseFirestore.instance.collection('cars').add({
            'number': number,
            'model': model,
            'autoNumber': autoIncrementNumber, // 자동 생성 번호
            'createdAt': FieldValue.serverTimestamp(),
          });

          autoIncrementNumber++;

          // String model =
          //     row.length > 3 ? _convertToString(row[3]?.value) : ''; // 차량 모델
          // String number =
          //     row.length > 2 ? _convertToString(row[2]?.value) : ''; // 차량 번호
          // if (number.isNotEmpty) {
          //   await FirebaseFirestore.instance
          //       .collection('cars')
          //       .add({'model': model, 'number': number});
          // }
        }
      }
    } catch (e) {
      print('엑셀 파일 처리 중 오류 발생: $e');
      throw Exception('엑셀 파일 처리 실패: $e');
    }
  }

  // 유효한 차량 번호인지 확인하는 함수
  static bool _isValidNumber(String number) {
    final vehicleNumberRegExp = RegExp(r'^[0-9가-힣\s]+$'); // 차량 번호는 숫자와 한글만 허용
    return vehicleNumberRegExp.hasMatch(number);
  }

  // 모델의 유효성 검사: 문자열인지 확인
  static bool _isValidModel(String model) {
    return model.isNotEmpty; // 간단히 문자열이 비어있지 않은지 확인
  }

  static String _convertToString(dynamic value) {
    if (value == null) {
      return ''; // 값이 없으면 빈 문자열 반환
    } else if (value is SharedString) {
      return value.toString(); // SharedString을 문자열로 변환
    } else {
      return value.toString(); // 다른 유형의 데이터를 문자열로 변환
    }
  }
}

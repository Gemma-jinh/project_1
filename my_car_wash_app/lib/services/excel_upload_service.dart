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

      // var headerRow = sheet.rows.first;
      // debugHeader(headerRow);
      // // 첫 번째 행을 헤더로 간주하여 차량 번호와 모델 열의 위치 찾기
      // int numberColumnIndex = -1;
      // int modelColumnIndex = -1;

      // print("헤더 정보:");
      // // 헤더 행에서 '차량번호'와 '모델' 열을 찾음
      // for (int i = 0; i < headerRow.length; i++) {
      //   String headerValue = _cleanHeaderValue(headerRow[i]?.value);
      //   print("열 $i: $headerValue"); // 헤더 정보를 출력하여 확인
      // }

      // 헤더 행에서 '차량번호'와 '모델' 열을 찾음
      // for (int i = 0; i < headerRow.length; i++) {
      //   String headerValue = cleanHeaderValue(headerRow[i]?.value?.toString());
      //   if (headerValue.contains('차량번호') || headerValue.contains('차량')) {
      //     numberColumnIndex = i;
      //     print('차량번호 열 발견: $i 열');
      //   } else if (headerValue.contains('차종') || headerValue.contains('모델')) {
      //     modelColumnIndex = i;
      //     print('차종/모델 열 발견: $i 열');
      //   }
      // }
      // // 차량번호 열과 모델 열을 찾았는지 확인
      // if (numberColumnIndex != -1 || modelColumnIndex == -1) {
      //   print("차량 번호 열 또는 차종 열을 찾을 수 없습니다.");
      //   return;
      // } else {
      //   print("차량번호 열: $numberColumnIndex, 차종 열: $modelColumnIndex"); // 추가 디버깅
      // }

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
        String? number = '';
        String? model = '';

        // 유효한 차량 번호와 모델인 경우 Firestore에 저장
        // if (_isValidNumber(number) && _isValidModel(model)) {
        //   await FirebaseFirestore.instance.collection('cars').add({
        //     'number': number,
        //     'model': model,
        //     'autoNumber': autoIncrementNumber, // 자동 생성 번호
        //     'createdAt': FieldValue.serverTimestamp(),
        //   });

        //   autoIncrementNumber++;

        // String model =
        //     row.length > 3 ? _convertToString(row[3]?.value) : ''; // 차량 모델
        // String number =
        //     row.length > 2 ? _convertToString(row[2]?.value) : ''; // 차량 번호
        // if (number.isNotEmpty) {
        //   await FirebaseFirestore.instance
        //       .collection('cars')
        //       .add({'model': model, 'number': number});
        // 각 셀의 값을 확인하며 차량번호와 모델 정보를 추출
        for (var cell in row) {
          String cellValue = cell?.value?.toString().trim() ?? '';

          // 차량번호인지 확인 (숫자와 한글이 포함된 형식)
          if (_isNumber(cellValue)) {
            number = cellValue;
          }
          // 모델/차종으로 추정되는 값을 확인
          else if (_isModel(cellValue)) {
            model = cellValue;
          }
        }

        // 차량번호와 모델이 둘 다 있을 때 Firestore에 등록
        if (number!.isNotEmpty && model!.isNotEmpty) {
          await FirebaseFirestore.instance.collection('cars').add({
            'number': number,
            'model': model,
            'uploadedAt': FieldValue.serverTimestamp(),
          });
          print('등록된 차량: 번호=$number, 모델=$model');
        } else {
          print('차량번호 또는 모델 정보가 누락되었습니다.');
        }
      }
    } catch (e) {
      print('엑셀 파일 처리 중 오류 발생: $e');
    }
  }

  // 차량번호인지 확인하는 함수 (숫자와 한글로 구성된 형식 체크)
  static bool _isNumber(String value) {
    final vehicleNumberRegExp = RegExp(r'^[0-9가-힣\s]+$');
    return vehicleNumberRegExp.hasMatch(value);
  }

  // 차량 모델(차종)인지 확인하는 함수 (단순 문자열 체크)
  static bool _isModel(String value) {
    return value.isNotEmpty &&
        !RegExp(r'^[0-9가-힣\s]+$').hasMatch(value); // 숫자나 한글이 아닌 경우 모델로 간주
  }
}

  //   if (number.isEmpty || model.isEmpty) {
  //     print("차량번호 또는 차종 값이 비어 있습니다.");
  //     continue; // 차량번호 또는 차종 값이 없는 경우 다음으로 넘어갑니다.
  //   }

  //   print("차량번호: $number, 차종: $model");
  // }
  //   }
  // } else {
  //   print('차량 번호 열 또는 모델 열을 찾을 수 없습니다.');
  // }
  //   } catch (e) {
  //     print('엑셀 파일 처리 중 오류 발생: $e');
  //   }
  // }

  // 헤더를 디버깅하는 함수
  // static void debugHeader(List<Data?> headerRow) {
  //   print("헤더 정보:");
  //   for (int i = 0; i < headerRow.length; i++) {
  //     String headerValue = headerRow[i]?.value?.toString() ?? 'NULL';
  //     print("열 $i: $headerValue");
  //   }
  // }

  // 헤더 값을 클린하게 처리하는 함수
  // static String _cleanHeaderValue(dynamic value) {
  //   if (value == null) {
  //     return '';
  //   } else {
  //     String cleanValue =
  //         value.toString().trim().replaceAll(RegExp(r'\s+'), ''); // 공백 제거 및 트림
  //     return cleanValue.toLowerCase(); // 소문자로 변환
  //   }
  // }

  // 헤더 값을 정리하는 함수 (공백 제거 및 소문자 변환)
  // static String cleanHeaderValue(String? value) {
  //   if (value == null || value.trim().isEmpty) {
  //     return 'NULL';
  //   } else {
  //     // String cleanValue = value.trim().replaceAll(RegExp(r'\s+'), ''); // 공백 제거
  //     // return cleanValue.toLowerCase(); // 소문자로 변환
  //     return value.trim();
  //   }
  // }

  // 유효한 차량 번호인지 확인하는 함수
  // static bool _isValidNumber(String number) {
  //   final vehicleNumberRegExp = RegExp(r'^[0-9가-힣\s]+$'); // 차량 번호는 숫자와 한글만 허용
  //   return vehicleNumberRegExp.hasMatch(number);
  // }

  // // 모델의 유효성 검사: 문자열인지 확인
  // static bool _isValidModel(String model) {
  //   return model.isNotEmpty; // 간단히 문자열이 비어있지 않은지 확인
  // }

  // static String _convertToString(dynamic value) {
  //   if (value == null) {
  //     return ''; // 값이 없으면 빈 문자열 반환
  //   } else if (value is SharedString) {
  //     return value.toString(); // SharedString을 문자열로 변환
  //   } else {
  //     return value.toString(); // 다른 유형의 데이터를 문자열로 변환
  //   }
  // }


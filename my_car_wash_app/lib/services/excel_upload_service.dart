import 'dart:io';
import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExcelUploadService {
  static Future<void> uploadExcelFile(File file, String fileName) async {
    try {
      // Firebase Storage에 파일 업로드
      Reference storageRef =
          FirebaseStorage.instance.ref().child('excel_files/$fileName');
      await storageRef.putFile(file);

      // 업로드된 파일 다운로드 URL 가져오기
      String downloadUrl = await storageRef.getDownloadURL();

      // 필요시, Firestore에 파일 URL 저장 또는 파일 내용 처리
      // 예시: Firestore에 파일 URL 저장
      await FirebaseFirestore.instance.collection('uploaded_files').add({
        'fileName': fileName,
        'fileUrl': downloadUrl,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      // 엑셀 파일을 처리하여 데이터를 Firestore로 업로드하는 로직 추가 가능
      await processExcelFile(file);
    } catch (e) {
      throw Exception('파일 업로드 실패: $e');
    }
  }

  // 엑셀 파일 파싱 및 Firestore로 데이터 저장
  static Future<void> processExcelFile(File file) async {
    try {
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      // 각 시트의 데이터를 Firestore에 저장하는 로직
      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table]!;
        for (var row in sheet.rows) {
          // 예시: Firestore에 차량 데이터 저장
          await FirebaseFirestore.instance.collection('cars').add({
            'model': row[3]?.value ?? '', // 차량 모델
            'number': row[4]?.value ?? '', // 차량 번호
          });
        }
      }
    } catch (e) {
      throw Exception('엑셀 파일 처리 실패: $e');
    }
  }
}

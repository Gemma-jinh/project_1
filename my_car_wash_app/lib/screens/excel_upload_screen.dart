import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_car_wash_app/services/excel_upload_service.dart'; // 서비스 파일 불러오기

class ExcelUploadScreen extends StatefulWidget {
  @override
  _ExcelUploadScreenState createState() => _ExcelUploadScreenState();
}

class _ExcelUploadScreenState extends State<ExcelUploadScreen> {
  File? _file; // 선택한 파일
  bool _isUploading = false; // 업로드 중 상태 표시

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'], // 엑셀 파일만 허용
    );

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_file == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('파일을 선택하세요.')));
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      String fileName = _file!.path.split('/').last;
      await ExcelUploadService.uploadExcelFile(_file!, fileName); // 서비스 호출

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('파일 업로드 성공')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('업로드 실패: $e')));
    } finally {
      setState(() {
        _isUploading = false;
        _file = null; // 업로드 후 파일 초기화
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('엑셀 파일 업로드'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('파일 선택'),
            ),
            if (_file != null) ...[
              SizedBox(height: 16),
              Text('선택된 파일: ${_file!.path.split('/').last}'),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadFile,
              child:
                  _isUploading ? CircularProgressIndicator() : Text('파일 업로드'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../services/search_service.dart'; // 검색 로직을 담당할 서비스
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore 접근

class SearchPage extends StatefulWidget {
  @override
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
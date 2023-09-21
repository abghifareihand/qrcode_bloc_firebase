import 'package:flutter/material.dart';

class DetailProductPage extends StatelessWidget {
  final String id;
  final Map<String, dynamic> data;
  const DetailProductPage({super.key, required this.id, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Center(
        child: Text(data.toString()),
      ),
    );
  }
}
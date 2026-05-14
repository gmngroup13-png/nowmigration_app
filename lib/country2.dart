import 'dart:io';
import 'package:flutter/material.dart';

class Country2Page extends StatelessWidget {
  final List<File> images;

  const Country2Page({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Country2 Page"),
      ),
    );
  }
}

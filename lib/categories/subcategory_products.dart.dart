import 'package:flutter/material.dart';

class SubCategoryProducts extends StatelessWidget {
  final String mainCategory;
  final String title;
  const SubCategoryProducts(
      {super.key, required this.title, required this.mainCategory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Text(mainCategory),
      ),
    );
  }
}

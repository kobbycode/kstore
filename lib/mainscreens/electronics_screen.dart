import 'package:flutter/material.dart';
import 'package:kobby_store/categories/category_body.dart';
import 'package:kobby_store/categories/header_title.dart';
import 'package:kobby_store/utilities/utilities.dart';

class ElectronicsScreen extends StatefulWidget {
  const ElectronicsScreen({super.key});

  @override
  State<ElectronicsScreen> createState() => _ElectronicsScreenState();
}

class _ElectronicsScreenState extends State<ElectronicsScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CategoryHeader(
            headerTitle: 'Electronics',
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: GridView.count(
              mainAxisSpacing: 10,
              crossAxisSpacing: 2,
              crossAxisCount: 2,
              children: List.generate(
                electronics.length,
                (index) {
                  return CategoryBody(
                    mainCategoryName: 'Electronics',
                    subCategoryName: electronics[index],
                    subCategoryLabel: electronics[index],
                    assetName: 'images/electronics/electronics$index.jpg',
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

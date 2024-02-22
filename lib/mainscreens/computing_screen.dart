import 'package:flutter/material.dart';
import 'package:kobby_store/categories/category_body.dart';
import 'package:kobby_store/categories/header_title.dart';
import 'package:kobby_store/utilities/utilities.dart';

class ComputingScreen extends StatefulWidget {
  const ComputingScreen({super.key});

  @override
  State<ComputingScreen> createState() => _ComputingScreenState();
}

class _ComputingScreenState extends State<ComputingScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CategoryHeader(
            headerTitle: 'Computing',
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: GridView.count(
              mainAxisSpacing: 10,
              crossAxisSpacing: 2,
              crossAxisCount: 2,
              children: List.generate(
                computing.length,
                (index) {
                  return CategoryBody(
                    mainCategoryName: 'Computing',
                    subCategoryName: computing[index],
                    subCategoryLabel: computing[index],
                    assetName: 'images/computing/computing$index.jpg',
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

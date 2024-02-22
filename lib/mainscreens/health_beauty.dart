import 'package:flutter/material.dart';
import 'package:kobby_store/categories/category_body.dart';
import 'package:kobby_store/categories/header_title.dart';
import 'package:kobby_store/utilities/utilities.dart';

class HealthBeautyScreen extends StatefulWidget {
  const HealthBeautyScreen({super.key});

  @override
  State<HealthBeautyScreen> createState() => _HealthBeautyScreenState();
}

class _HealthBeautyScreenState extends State<HealthBeautyScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CategoryHeader(
            headerTitle: 'Health & Beauty',
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: GridView.count(
              mainAxisSpacing: 10,
              crossAxisSpacing: 2,
              crossAxisCount: 2,
              children: List.generate(
                healthBeauty.length,
                (index) {
                  return CategoryBody(
                    mainCategoryName: 'healthBeauty',
                    subCategoryName: healthBeauty[index],
                    subCategoryLabel: healthBeauty[index],
                    assetName: 'images/healthBeauty/healthBeauty$index.jpg',
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

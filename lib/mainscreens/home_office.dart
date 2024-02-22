import 'package:flutter/material.dart';
import 'package:kobby_store/categories/category_body.dart';
import 'package:kobby_store/categories/header_title.dart';
import 'package:kobby_store/utilities/utilities.dart';

class HomeOfficeScreen extends StatefulWidget {
  const HomeOfficeScreen({super.key});

  @override
  State<HomeOfficeScreen> createState() => _HomeOfficeScreenState();
}

class _HomeOfficeScreenState extends State<HomeOfficeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CategoryHeader(
            headerTitle: 'Home & Office',
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: GridView.count(
              mainAxisSpacing: 10,
              crossAxisSpacing: 2,
              crossAxisCount: 2,
              children: List.generate(
                homeOffice.length,
                (index) {
                  return CategoryBody(
                    mainCategoryName: 'Home & Office',
                    subCategoryName: homeOffice[index],
                    subCategoryLabel: homeOffice[index],
                    assetName: 'images/homeOffice/homeOffice$index.jpg',
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

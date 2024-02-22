import 'package:flutter/material.dart';
import 'package:kobby_store/categories/category_body.dart';
import 'package:kobby_store/categories/header_title.dart';
import 'package:kobby_store/utilities/utilities.dart';

class AppliancesScreen extends StatefulWidget {
  const AppliancesScreen({super.key});

  @override
  State<AppliancesScreen> createState() => _AppliancesScreenState();
}

class _AppliancesScreenState extends State<AppliancesScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CategoryHeader(
            headerTitle: 'Appliances',
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: GridView.count(
              mainAxisSpacing: 10,
              crossAxisSpacing: 2,
              crossAxisCount: 2,
              children: List.generate(
                appliances.length,
                (index) {
                  return CategoryBody(
                    mainCategoryName: 'Appliances',
                    subCategoryName: appliances[index],
                    subCategoryLabel: appliances[index],
                    assetName: 'images/appliances/appliance$index.jpg',
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

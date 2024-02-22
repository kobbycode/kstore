import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kobby_store/categories/subcategory_products.dart.dart';
import 'package:kobby_store/common/widgets/frosted_glass.dart';

class CategoryBody extends StatelessWidget {
  final String mainCategoryName;
  final String subCategoryName;
  final String subCategoryLabel;
  final String assetName;

  const CategoryBody({
    super.key,
    required this.mainCategoryName,
    required this.subCategoryName,
    required this.subCategoryLabel,
    required this.assetName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryProducts(
              title: subCategoryName,
              mainCategory: mainCategoryName,
            ),
          ),
        );
      },
      child: Column(
        children: [
          FrostedGlassBox(
            theWidth: 100,
            theHeight: 100,
            gradientColors: const [
              Color.fromRGBO(140, 194, 79, 1),
              Color.fromARGB(255, 79, 167, 194),
            ],
            borderColor: const Color.fromARGB(255, 79, 167, 194),
            child: Image.asset(
              assetName,
              height: 85,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subCategoryLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.fredoka(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

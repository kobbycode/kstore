import 'package:flutter/material.dart';
import 'package:kobby_store/common/widgets/category_vertical_image_text.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ImageVerticalText(
      image: 'images/category/electronics.png',
      title: 'Electronics',
      textColor: const Color(0XFFFAFEFF).withOpacity(0.9),
      onTap: () {},
    );
  }
}

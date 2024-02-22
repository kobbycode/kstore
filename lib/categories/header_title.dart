import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryHeader extends StatelessWidget {
  final String headerTitle;
  const CategoryHeader({
    super.key,
    required this.headerTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: Text(
        headerTitle,
        style: GoogleFonts.fredoka(
          fontSize: 24,
          color: Colors.blueGrey,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

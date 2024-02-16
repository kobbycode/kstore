import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomSearchContainer extends StatelessWidget {
  final String text;
  final Widget? icon;
  final bool showBackground, showBorder;

  const CustomSearchContainer({
    Key? key,
    required this.text,
    this.icon,
    this.showBackground = true,
    this.showBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: showBorder
              ? Border.all(
                  color: const Color(0XFFFAFEFF),
                )
              : null,
          color: showBackground ? const Color(0XFFFAFEFF) : Colors.transparent,
        ),
        child: Row(
          children: [
            if (icon != null) Container(child: icon),
            const SizedBox(width: 20),
            Text(
              text,
              style: GoogleFonts.fredoka(
                color: const Color.fromARGB(255, 28, 146, 155),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

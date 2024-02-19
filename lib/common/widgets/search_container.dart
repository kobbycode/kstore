import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kobby_store/mainscreens/search_screen.dart';

class CustomSearchContainer extends StatelessWidget {
  final String text;
  final Widget? icon;
  final double? horizontalPadding;
  final bool showBackground, showBorder;
  // final void Function()? onTap;

  const CustomSearchContainer({
    Key? key,
    required this.text,
    this.icon,
    this.showBackground = true,
    this.showBorder = true,
    this.horizontalPadding = 24.0,
    // this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchScreen(),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding!),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: showBorder
                ? Border.all(
                    color: const Color.fromARGB(255, 28, 146, 155),
                  )
                : null,
            color:
                showBackground ? const Color(0XFFFAFEFF) : Colors.transparent,
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
      ),
    );
  }
}

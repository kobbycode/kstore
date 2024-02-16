import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeading extends StatelessWidget {
  final String title;
  final Color textColor;
  final bool showButton;
  final String? buttonName;
  final void Function()? onPress;
  const SectionHeading({
    super.key,
    required this.title,
    this.buttonName = 'View All',
    this.onPress,
    required this.textColor,
    this.showButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.fredoka(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (showButton)
          TextButton(
            onPressed: onPress,
            child: Text(
              buttonName!,
              style: GoogleFonts.fredoka(),
            ),
          ),
      ],
    );
  }
}

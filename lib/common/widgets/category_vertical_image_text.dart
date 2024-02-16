import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kobby_store/common/widgets/frosted_glass.dart';

class ImageVerticalText extends StatelessWidget {
  final String image, title;
  final Color? textColor;
  final void Function()? onTap;
  const ImageVerticalText({
    super.key,
    required this.image,
    required this.title,
    this.onTap,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Column(
          children: [
            FrostedGlassBox(
              theWidth: 56,
              theHeight: 56,
              theChild: Image.asset(
                image,
                fit: BoxFit.cover,
                width: 48,
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              width: 55,
              child: Center(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.fredoka(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

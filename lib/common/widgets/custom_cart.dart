import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomCartItem extends StatelessWidget {
  final Color? color;
  final VoidCallback onPress;
  final double? iconSize;
  final double? fontSize;
  const CustomCartItem({
    super.key,
    this.color,
    required this.onPress,
    this.iconSize,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onPress,
          icon: SvgPicture.asset(
            'images/icons/shopping_bag.svg',
            width: iconSize,
            color: color,
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: const Color(0XFF24697E),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                '0',
                style: GoogleFonts.fredoka(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

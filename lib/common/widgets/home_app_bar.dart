import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kobby_store/common/widgets/appbar.dart';
import 'package:kobby_store/common/widgets/custom_cart.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, you are welcome back',
            style: GoogleFonts.fredoka(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Alex Ofori',
            style: GoogleFonts.fredoka(
              fontSize: 24,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
      actions: [
        CustomCartItem(
          onPress: () {},
          iconSize: 21,
        ),
      ],
    );
  }
}

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
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: const Color(0XFFFAFEFF).withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Alex Ofori',
            style: GoogleFonts.fredoka(
              fontSize: 24,
              color: const Color(0XFFFAFEFF),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        CustomCartItem(
          onPress: () {},
          iconSize: 21,
          color: const Color(0XFFFAFEFF),
        ),
      ],
    );
  }
}

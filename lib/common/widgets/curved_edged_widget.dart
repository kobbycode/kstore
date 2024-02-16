import 'package:flutter/material.dart';
import 'package:kobby_store/common/widgets/custom_circles.dart';
import 'package:kobby_store/common/widgets/custom_curve_urge_card.dart';

class CurvedWidgetCard extends StatelessWidget {
  final Widget child;
  const CurvedWidgetCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCurvedEdgeCard(
      child: Container(
        color: const Color.fromARGB(255, 28, 146, 155),
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 400,
          child: Stack(
            children: [
              Positioned(
                top: 150,
                right: 250,
                child: CircularContainer(
                  color: const Color(
                    0XFFFAFEFF,
                  ).withOpacity(0.1),
                ),
              ),
              Positioned(
                top: -150,
                right: -250,
                child: CircularContainer(
                  color: const Color(
                    0XFFFAFEFF,
                  ).withOpacity(0.1),
                ),
              ),
              Positioned(
                top: -100,
                right: 300,
                child: CircularContainer(
                  color: const Color(
                    0XFFFAFEFF,
                  ).withOpacity(0.1),
                ),
              ),
              Positioned(
                top: 100,
                right: -300,
                child: CircularContainer(
                  color: const Color(
                    0XFFFAFEFF,
                  ).withOpacity(0.1),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

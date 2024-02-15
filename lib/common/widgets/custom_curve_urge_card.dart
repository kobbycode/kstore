import 'package:flutter/material.dart';
import 'package:kobby_store/common/widgets/custom_curve_edge.dart';

class CustomCurvedEdgeCard extends StatelessWidget {
  final Widget? child;
  const CustomCurvedEdgeCard({
    super.key,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomCurvedEdge(),
      child: child,
    );
  }
}

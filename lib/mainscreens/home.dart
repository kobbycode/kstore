import 'package:flutter/material.dart';
import 'package:kobby_store/common/widgets/curved_edged_widget.dart';
import 'package:kobby_store/common/widgets/home_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CurvedWidgetCard(
              child: Column(
                children: [
                  HomeAppBar(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

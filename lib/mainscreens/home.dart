import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kobby_store/common/widgets/curved_edged_widget.dart';
import 'package:kobby_store/common/widgets/home_app_bar.dart';
import 'package:kobby_store/common/widgets/search_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Header
            CurvedWidgetCard(
              child: Column(
                children: [
                  //AppBar
                  const HomeAppBar(),
                  const SizedBox(height: 32),
                  //Search Box
                  CustomSearchContainer(
                    text: 'Search',
                    icon: SvgPicture.asset(
                      'images/icons/search.svg',
                      width: 23,
                      height: 18,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

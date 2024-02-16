import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kobby_store/common/widgets/curved_edged_widget.dart';
import 'package:kobby_store/common/widgets/home_app_bar.dart';
import 'package:kobby_store/common/widgets/home_categories.dart';
import 'package:kobby_store/common/widgets/search_container.dart';
import 'package:kobby_store/common/widgets/section_header.dart';

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
                    onTap: () {},
                    text: 'Search',
                    icon: SvgPicture.asset(
                      'images/icons/search.svg',
                      width: 23,
                      height: 18,
                    ),
                  ),

                  const SizedBox(height: 32),

                  //Categories Heading
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        const SectionHeading(
                          title: 'Search Categories',
                          textColor: Color(0XFFFAFEFF),
                          showButton: false,
                        ),

                        const SizedBox(height: 16),

                        //Categories
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                              itemCount: 6,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (_, index) {
                                return const HomeCategories();
                              }),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

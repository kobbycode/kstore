import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kobby_store/categories/electronics.dart';
import 'package:kobby_store/common/images/category_image.dart';
import 'package:kobby_store/common/widgets/search_container.dart';
import 'package:kobby_store/mainscreens/appliances_screen.dart';
import 'package:kobby_store/mainscreens/computing_screen.dart';
import 'package:kobby_store/mainscreens/electronics_screen.dart';
import 'package:kobby_store/mainscreens/gaming.dart';
import 'package:kobby_store/mainscreens/health_beauty.dart';
import 'package:kobby_store/mainscreens/home_office.dart';
import 'package:kobby_store/utilities/utilities.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final PageController _pageController = PageController();
  IconData icon = Icons.arrow_downward;
  int currentPageIndex = 0;

  @override
  void initState() {
    _pageController.addListener(_pageChanged);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _pageChanged() {
    setState(() {
      currentPageIndex = _pageController.page!.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: CustomSearchContainer(
          horizontalPadding: 0,
          text: 'Search Items',
          showBorder: true,
          icon: SvgPicture.asset(
            'images/icons/search.svg',
            width: 16,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: sideBar(size),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: categoryWidget(size),
          ),
          Positioned(
            top: 530,
            right: 0,
            child: Visibility(
              visible: currentPageIndex != 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.withOpacity(0.19),
                      Colors.yellow,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: () {
                    if (currentPageIndex > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  elevation: 0,
                  highlightElevation: 0,
                  backgroundColor: Colors.transparent,
                  child: SvgPicture.asset('images/icons/arrowUp.svg'),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Visibility(
              visible: currentPageIndex != mainCategory.length - 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color.fromRGBO(140, 194, 79, 1),
                      const Color.fromARGB(255, 79, 167, 194).withOpacity(0.19),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    if (currentPageIndex < mainCategory.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  elevation: 0,
                  highlightElevation: 0,
                  backgroundColor: Colors.transparent,
                  child: SvgPicture.asset('images/icons/arrowDown.svg'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sideBar(Size size) {
    return SizedBox(
      width: size.width * 0.2,
      height: size.height * 0.8,
      child: ListView.builder(
        itemCount: mainCategory.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.bounceInOut);
            },
            child: Container(
              height: 100,
              margin: const EdgeInsets.symmetric(
                vertical: 3,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: index == currentPageIndex
                    ? Colors.grey[200]
                    : const Color.fromARGB(255, 79, 194, 127).withOpacity(0.2),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    mainCategory[index],
                    style: GoogleFonts.fredoka(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.blueGrey,
                      letterSpacing: 0.8,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget categoryWidget(Size size) {
    return Container(
      height: size.height * 0.9,
      width: size.width * 0.8,
      color: Colors.white,
      child: PageView.builder(
        controller: _pageController,
        itemCount: mainCategory.length,
        onPageChanged: (value) {
          setState(() {
            currentPageIndex = value;
          });
        },
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return const ElectronicsScreen();
            case 1:
              return const AppliancesScreen();
            case 2:
              return const HealthBeautyScreen();
            case 3:
              return const HomeOfficeScreen();
            case 4:
              return const ComputingScreen();
            case 5:
              return const GamingScreen();
            default:
              return const Center(
                child: Text("No Category Available"),
              );
          }
        },
      ),
    );
  }
}

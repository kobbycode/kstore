import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kobby_store/common/images/category_image.dart';
import 'package:kobby_store/common/widgets/search_container.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    // Make the first category selected after moving to other page and back
    for (var e in categoryList) {
      e.isSelected = false;
    }
    setState(() {
      categoryList[0].isSelected = true;
    });
    super.initState();
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
        ],
      ),
    );
  }

  Widget sideBar(Size size) {
    return SizedBox(
      width: size.width * 0.28,
      height: size.height * 0.8,
      child: ListView.builder(
        itemCount: categoryList.length,
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
                color: categoryList[index].isSelected == true
                    ? Colors.white
                    : const Color.fromARGB(255, 79, 167, 194).withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 79, 167, 194)
                        .withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    categoryList[index].text,
                    style: GoogleFonts.fredoka(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 79, 167, 194),
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
      width: size.width * 0.72,
      color: Colors.white,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          for (var e in categoryList) {
            e.isSelected = false;
          }
          setState(() {
            categoryList[value].isSelected = true;
          });
        },
        scrollDirection: Axis.vertical,
        children: const [
          Center(
            child: Text('Electronics'),
          ),
          Center(
            child: Text('Appliances'),
          ),
          Center(
            child: Text('Computing'),
          ),
          Center(
            child: Text('Gaming'),
          ),
          Center(
            child: Text('Home & Beauty'),
          ),
          Center(
            child: Text('Home & Office'),
          ),
        ],
      ),
    );
  }
}

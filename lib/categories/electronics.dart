import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kobby_store/common/widgets/frosted_glass.dart';
import 'package:kobby_store/utilities/utilities.dart';

class ElectronicsPage extends StatelessWidget {
  const ElectronicsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Text(
              'Electronics',
              style: GoogleFonts.fredoka(
                fontSize: 24,
                color: Colors.blueGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.70,
            child: GridView.count(
              mainAxisSpacing: 50,
              crossAxisSpacing: 15,
              crossAxisCount: 2,
              children: List.generate(
                electronics.length,
                (index) {
                  return Column(
                    children: [
                      FrostedGlassBox(
                        theWidth: 100,
                        theHeight: 100,
                        gradientColors: const [
                          Color.fromRGBO(140, 194, 79, 1),
                          Color.fromARGB(255, 79, 167, 194),
                        ],
                        borderColor: const Color.fromARGB(255, 79, 167, 194),
                        child: Image.asset(
                          'images/electronics/electronics$index.jpg',
                          height: 85,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        electronics[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fredoka(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

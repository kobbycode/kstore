import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kobby_store/common/controllers/home_controllers.dart';
import 'package:kobby_store/common/widgets/carousel_rounded_image.dart';
import 'package:kobby_store/common/widgets/custom_circles.dart';

class PromoCarousel extends StatelessWidget {
  const PromoCarousel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Column(
      children: [
        CarouselSlider(
          items: const [
            CarouselRoundedImage(
              imageUrl: 'images/banners/banner1.jpg',
            ),
            CarouselRoundedImage(
              imageUrl: 'images/banners/banner2.jpg',
            ),
            CarouselRoundedImage(
              imageUrl: 'images/banners/banner3.jpg',
            ),
            CarouselRoundedImage(
              imageUrl: 'images/banners/banner4.jpg',
            ),
          ],
          options: CarouselOptions(
            onPageChanged: (index, _) => controller.updatePageIndicator(index),
            viewportFraction: 1,
            enlargeCenterPage: true,
            aspectRatio: 16 / 9,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(seconds: 1),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Center(
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 4; i++)
                  CircularContainer(
                    height: 4,
                    width: 20,
                    margin: const EdgeInsets.only(right: 10),
                    color: controller.carouselCurrentIndex.value == i
                        ? Colors.amber
                        : Colors.grey,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

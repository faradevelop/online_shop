import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SliderWidget extends StatefulWidget {
  const SliderWidget({super.key, required this.images});

  final List<String> images;

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            enlargeCenterPage: true,
            viewportFraction: 1,
            aspectRatio: 2.2,
            //height: 160,
            autoPlay: false,
            autoPlayInterval: const Duration(seconds: 3),
            //autoPlayCurve: Curves.easeIn,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          itemCount: widget.images.length,
          itemBuilder: (context, itemIndex, pageViewIndex) {
            return Container(
              margin: const EdgeInsets.only(left: 14, right: 14),
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.images[itemIndex],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Iconsax.add);
                    },
                  )
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.images.length,
              (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: index == currentIndex ? 16 : 6,
                  height: 6,
                  margin: const EdgeInsets.only(
                    left: 5,
                  ),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(50)),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

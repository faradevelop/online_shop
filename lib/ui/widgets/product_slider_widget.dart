import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductSliderWidget extends StatefulWidget {
  const ProductSliderWidget({super.key, required this.images});

  final List<String> images;

  @override
  State<ProductSliderWidget> createState() => _ProductSliderWidgetState();
}

class _ProductSliderWidgetState extends State<ProductSliderWidget> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          itemCount: widget.images.length,
          options: CarouselOptions(
            viewportFraction: 1,
            height: MediaQuery.of(context).size.width*0.8,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, reason) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    errorBuilder: (context, error, stackTrace) => const Icon(Iconsax.add),
                    width: MediaQuery.of(context).size.width/2,
                    height: MediaQuery.of(context).size.width/2,
                    widget.images[itemIndex],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),

        Visibility(
          visible: widget.images.length>1,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: currentIndex == index ? 20 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: currentIndex == index
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).hintColor,
                  ),
                  margin: const EdgeInsets.only(right: 5),
                );
              }),
            ),
          ),
        )
      ],
    );
  }
}

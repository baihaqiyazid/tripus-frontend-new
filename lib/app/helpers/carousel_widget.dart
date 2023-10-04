import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FeedsCarousel extends StatefulWidget {

  List<Widget> imageSliders;
  FeedsCarousel(this.imageSliders);

  @override
  State<StatefulWidget> createState() {
    return _FeedsCarouselState();
  }
}

class _FeedsCarouselState extends State<FeedsCarousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
        CarouselSlider(
          items: widget.imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              viewportFraction: 1,
              enableInfiniteScroll: false,
              autoPlay: false,
              enlargeCenterPage: false,
              aspectRatio: 4/5,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageSliders.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ]
    );
  }
}
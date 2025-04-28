import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lifeblood_blood_donation_app/components/small_button.dart';

class CarouselContainer extends StatefulWidget {
  const CarouselContainer({super.key});

  @override
  State<CarouselContainer> createState() => _CarouselState();
}

class _CarouselState extends State<CarouselContainer> {
  final List<String> imageList = [
    'assets/images/donation_event_1.jpg',
    'assets/images/donation_event_2.jpg',
  ];

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    //to set width as device width
    double deviceWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black.withOpacity(0.5),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              CarouselSlider(
                items: imageList
                    .map((e) => Center(
                          child: Image.asset(
                            e,
                            width: deviceWidth,
                            fit: BoxFit.fitWidth,
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                    initialPage: 0,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 10),
                    enlargeCenterPage: true,
                    enlargeFactor: 0.5,
                    onPageChanged: (value, _) {
                      setState(() {
                        _currentPage = value;
                      });
                    }),
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SmallButton(
                      buttonLabel: "See All Events",
                      buttonHeight: 40,
                      buttonWidth: 130,
                      buttonColor: Colors.white,
                      borderColor: Colors.black,
                      labelColor: Colors.black,
                      onTap: () {
                        Navigator.pushNamed(context, '/events');
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        buildCarouselIndicator(),
      ],
    );
  }

  Widget buildCarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < imageList.length; i++)
          Container(
            margin: EdgeInsets.all(5),
            height: i == _currentPage ? 10 : 5,
            width: i == _currentPage ? 10 : 5,
            decoration: BoxDecoration(
              color: i == _currentPage
                  ? Colors.red
                  : Color(0xFFEB1C36).withOpacity(0.33),
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}

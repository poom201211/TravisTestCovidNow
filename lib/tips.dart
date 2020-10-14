import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_options.dart';

class TipsPage extends StatefulWidget {
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  List imgList = [
    'assets/facts1.jpg',
    'assets/facts2.jpg',
    'assets/facts3.jpg',
    'assets/facts4.jpg',
    'assets/facts5.jpg',
    'assets/facts6.jpg',
  ];

  List textList = [
    'A SHORTNESS OF BREATH\nThis means you are finding it difficult to get air into your lungs.',
    'A NEW CONTINUOUS COUGH\nThis means coughing a lot for more than an hour, or 3 or more coughing episodes in 24 hours.',
    'A HIGH FEVER\nThis means you feel hot to touch on your chest or back (you do not need to measure your temperature).',
    'Gather information that will help you accurately determine your risk so that you can take reasonable precautions.',
    'CORONAVIRUS CAN HANDLE THE HEAT',
    'CORONAVIRUS IS NOT AFRAID OF COLD WEATHER',
  ];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'COVID FACTS',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          //Moving covid facts
          Positioned(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/main.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      child: CarouselSlider(
                        items: imgList.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Image.asset(i),
                              );
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 280.0,
                          initialPage: 0,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          onPageChanged: (value, reason) {
                            setState(() {
                              index = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(5),
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.brown[400],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Text(
                        textList[index],
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

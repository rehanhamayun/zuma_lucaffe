import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class Splash extends StatefulWidget {
  Splash({Key? key, required this.page}) : super(key: key);
  final page;
  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>widget.page)));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
              body: Container(
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.white,
                Color.fromRGBO(185, 26, 25, 1),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.only(top: 30, left: 10, bottom: 15),
                      //   child: Image.asset(
                      //     'assets/LucaffeSolo.png',
                      //     width: 200,
                      //   ),
                      // ),
                      Image.asset(
                'assets/lucaffeSolo.png',
                height: size.height * 0.35,
              ),
                      const SizedBox(
                        height: 50,
                        width: 50,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballSpinFadeLoader,
                          colors: [Colors.white],
                          strokeWidth: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
  }
}
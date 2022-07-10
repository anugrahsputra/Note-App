import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    getInit();

    super.initState();
  }

  void getInit() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: SvgPicture.asset('assets/Just_Note_It_Logo.svg'),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../common/colors.dart'; // make sure you have this
import '../common/common.dart'; // getInternetStatus() function
import '../common/widgets/no_connectivity.dart';
import 'home/home.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  Future<void> checkConnectivity() async {
    if (await getInternetStatus()) {
      Timer(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Home()),
        );
      });
    } else {
      Navigator.of(context, rootNavigator: true)
          .push(
        MaterialPageRoute(builder: (context) => const NoConnectivity()),
      )
          .then((_) => checkConnectivity());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.4),
            SizedBox(
              width: 130,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: size.height * 0.45),
            Text(
              'Copyright \u00a9 2023',
              style: GoogleFonts.poppins(color: AppColors.black),
            ),
          ],
        ),
      ),
    );
  }
}

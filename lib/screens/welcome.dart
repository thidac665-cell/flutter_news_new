import 'dart:async';
import 'package:flutter/material.dart';
import '../common/colors.dart';
import '../common/common.dart';
import '../common/widgets/no_connectivity.dart';
import 'home/home.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> checkConnectivity() async {
    try {
      if (await getInternetStatus()) {
        if (!mounted) return;

        _timer = Timer(const Duration(seconds: 2), () {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Home()),
          );
        });
      } else {
        if (!mounted) return;
        Navigator.of(context, rootNavigator: true)
            .push(
          MaterialPageRoute(builder: (context) => const NoConnectivity()),
        )
            .then((_) {
          if (!mounted) return;
          checkConnectivity();
        });
      }
    } catch (e) {
      debugPrint("Connectivity error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.4),
                SizedBox(
                  width: 130,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.newspaper, size: 120);
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.45),
                Text(
                  'Copyright © 2023',
                  style: TextStyle(color: AppColors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

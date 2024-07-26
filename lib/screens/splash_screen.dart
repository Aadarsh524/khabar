// lib/splash_screen.dart
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khabar/bloc/cubit.dart';
import 'package:khabar/repository/new_repository.dart';
import 'package:khabar/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              NewsCubit(repository: NewsRepository())..fetchNews(),
          child: const HomeScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Center(
            child: CircularProgressIndicator(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50, // Adjust this value to move the logo up or down
            child: Center(
              child: Image.asset('assets/images/logo.png', height: 150),
            ),
          ),
        ],
      ),
    );
  }
}

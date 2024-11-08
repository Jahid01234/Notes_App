import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes_app/presentation/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),(){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context)=> const HomeScreen(),
       ),
      );
     }
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.redAccent.shade700,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                const SizedBox(height: 280,),
                // image ....
                Image.asset(
                  "assets/images/notes_logo.png",
                  height: 180,
                  width: 200,
                ),
                const SizedBox(height: 220,),
                // Text  ....
                const Text("Notes App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8,),
                // loading circle
                const CircularProgressIndicator(
                  color: Colors.white,
                ),


            ],
          ),
      ),
    );
  }
}

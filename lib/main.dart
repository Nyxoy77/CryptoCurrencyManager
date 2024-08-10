import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_ex_currency/pages/homepage.dart';
import 'package:get_ex_currency/services/register_services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await registerServices();
  await registerAssest();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      routes: {
        "/home": (context) =>  Homepage(),
      },
      initialRoute: "/home",
    );
  }
}

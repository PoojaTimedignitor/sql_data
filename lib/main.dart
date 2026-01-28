import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sql_db/provider/spl_provider.dart';
import 'package:sql_db/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: HomeScreen(),
  //   );
  // }

  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> SqlDbProvider())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}

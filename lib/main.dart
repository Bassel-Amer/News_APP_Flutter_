import 'package:flutter/material.dart';
import 'package:newsapp/core/routes/route.dart';


void main() {
  runApp( MyApp(router: RouterOfPages()));
}

class MyApp extends StatelessWidget {

  final RouterOfPages router;

  const MyApp({super.key, required this.router});



  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

onGenerateRoute: router.generator,      
    );
  }
}


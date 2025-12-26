import 'package:flutter/material.dart';
import 'routes.dart';

class LazaApp extends StatelessWidget {
  const LazaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Laza',
      initialRoute: AppRoutes.root,
      routes: AppRoutes.routes,
    );
  }
}

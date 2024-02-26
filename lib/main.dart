import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/provider/cart_provider_class.dart';
import 'package:shopping_cart/shopping_page.dart';

void main() {
  runApp(MultiProvider(
     providers: [
       ChangeNotifierProvider.value(value:CartProvider()),
     ],
    child: const MyApp(),
       ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme:  AppBarTheme(color: Colors.orange.shade300,titleTextStyle: const TextStyle(color: Colors.black87,fontSize: 18)),
        primaryColor: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyShoppingPage(),
    );
  }
}



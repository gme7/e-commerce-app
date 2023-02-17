import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/view/screen/product_screen.dart';
import 'package:ecommerce/viewmodel/products_vm.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductsVM(),
        ),
      ],
      child: MaterialApp(
        title: 'Online Shop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue[200],
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: Colors.blueGrey[100]),
        ),
        home: const ProductScreen(),
      ),
    );
  }
}

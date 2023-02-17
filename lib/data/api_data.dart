import 'dart:async';
import 'dart:convert';

import 'package:ecommerce/model/product_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

Future<List<Product>> fetchProducts() async {
  try {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      return ((jsonDecode(response.body) as List)
          .map((i) => Product.fromJson(i))
          .toList());
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Products');
    }
  } catch (e) {
    throw Exception('Failed to load Products');
  }
}

Future<List<Product>> getProducts(String query) async {
  final url = Uri.parse('https://fakestoreapi.com/products');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List products = json.decode(response.body);

    return products.map((json) => Product.fromJson(json)).where((product) {
      final titleLower = product.title.toLowerCase();
      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();
  } else {
    throw Exception('Failed to load Products');
  }
}

Future<List<Product>> getPriceSortedProducts(reverse) async {
  try {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var prods = ((jsonDecode(response.body) as List)
          .map((i) => Product.fromJson(i))
          .toList());
      if (!reverse) {
        prods.sort((a, b) => a.price.compareTo(b.price));
      } else {
        prods.sort((a, b) => b.price.compareTo(a.price));
      }

      return prods;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Products');
    }
  } catch (e) {
    throw Exception('Failed to load Products');
  }
}

Future<List<Product>> getRatingSortedProducts(reverse) async {
  try {
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      var prods = ((jsonDecode(response.body) as List)
          .map((i) => Product.fromJson(i))
          .toList());
      if (!reverse) {
        prods.sort((a, b) => a.rating["rate"].compareTo(b.rating["rate"]));
      } else {
        prods.sort((a, b) => b.rating["rate"].compareTo(a.rating["rate"]));
      }

      return prods;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Products');
    }
  } catch (e) {
    throw Exception('Failed to load Products ');
  }
}

import 'package:flutter/widgets.dart';
import 'package:ecommerce/model/product_model.dart';

class ProductsVM with ChangeNotifier {
  List<Product> lst = [];
  double total = 0.0;
  int index = 0;

  add(int id, String image, String name, double price, dynamic rating,
      int count) {
    if (!exists(id)) {
      total += price;
      lst.add(Product(
          id: id,
          image: image,
          title: name,
          price: price,
          rating: rating,
          count: count));
    } else {
      if (count > lst[index].count!) {
        total += price;
      } else if (count < lst[index].count!) {
        total -= price;
      }

      lst[index].count = count;
    }
    notifyListeners();
  }

  del(int index) {
    total -= lst[index].price;
    lst.removeAt(index);
    notifyListeners();
  }

  exists(id) {
    for (var p in lst) {
      if (p.id == id) {
        index = lst.indexOf(p);
        return true;
      }
    }

    return false;
  }
}

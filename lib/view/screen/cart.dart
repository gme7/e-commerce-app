import 'package:ecommerce/utils/color_themes.dart';
import 'package:ecommerce/view/widgets/cart_item.dart';
import 'package:ecommerce/viewmodel/products_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  double totalCost = 0;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Consumer<ProductsVM>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: mainColor,
          toolbarHeight: 50,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              child:
                  const Icon(Icons.arrow_back, color: Colors.white, size: 25),
              onTap: () => Navigator.pop(context),
            ),
          ),
          title: Center(
            child: Text(
              "Cart Products (${value.lst.length})",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            height: screenSize.height,
            width: double.infinity,
            child: ListView.builder(
              itemCount: value.lst.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: Colors.red,
                  ),
                  onDismissed: (direction) {
                    value.del(index);
                  },
                  child: CartItem(
                    screenSize: screenSize,
                    image: value.lst[index].image,
                    itemName: value.lst[index].title,
                    price: value.lst[index].price,
                    count: value.lst[index].count!,
                    del: () {},
                  ),
                );
              },
            ),
          ),
        ),
        bottomSheet: Container(
          color: Colors.grey[200],
          height: 50,
          child: Center(
            child: Text("Total: \$${value.total}"),
          ),
        ),
      ),
    );
  }
}

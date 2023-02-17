import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/utils/color_themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/view/screen/cart.dart';
import 'package:ecommerce/view/widgets/cart_counter.dart';
import 'package:ecommerce/viewmodel/products_vm.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
    required this.id,
    required this.image,
    required this.price,
    required this.rating,
    required this.itemName,
  }) : super(key: key);

  final String image, itemName;
  final double price;
  final dynamic rating;
  final int id;
  @override
  ProductDetailsState createState() => ProductDetailsState();
}

class ProductDetailsState extends State<ProductDetails> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        toolbarHeight: 50,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen()));
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 15, top: 8, bottom: 8),
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Icon(Icons.shopping_cart_rounded,
                          color: textColor, size: 25)),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Consumer<ProductsVM>(
                      builder: (context, value, child) => CartCounter(
                        count: value.lst.length.toString(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: Icon(Icons.arrow_back, color: textColor, size: 25),
            onTap: () => Navigator.pop(context),
          ),
        ),
        title: Center(
          child: Text(
            "Product Details",
            style: TextStyle(color: textColor),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: textColor,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.blue[200]!.withOpacity(0.3),
                    offset: const Offset(0, 0),
                    blurRadius: 3,
                    spreadRadius: 3)
              ]),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      height: size.height * 0.45,
                      // fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      imageUrl: widget.image,
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        color: shadeColor,
                        child: Text(
                          "\$${widget.price}",
                          style: TextStyle(color: mainColor, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: double.infinity,
                  child: Divider(
                    endIndent: 1,
                    thickness: 2,
                    color: mainColor,
                  )),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  widget.itemName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  width: double.infinity,
                  child: Divider(
                    endIndent: 1,
                    thickness: 2,
                    color: mainColor,
                  )),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      count += 1;
                    });
                  },
                  icon: Icon(
                    Icons.add,
                    color: mainColor,
                  ),
                ),
                Text("$count"),
                IconButton(
                    onPressed: () {
                      setState(() {
                        if (count > 1) {
                          count -= 1;
                        }
                      });
                    },
                    icon: Icon(
                      Icons.remove,
                      color: mainColor,
                    )),
              ]),
              Consumer<ProductsVM>(
                builder: (context, value, child) => InkWell(
                  onTap: () {
                    value.add(widget.id, widget.image, widget.itemName,
                        widget.price, widget.rating, count);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                        height: size.height * 0.05,
                        width: size.width * 0.75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: mainColor),
                        child: Center(
                          child: Text(
                            "Add to Cart",
                            style: TextStyle(
                              color: textColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Sold: ${widget.rating["count"]}"),
                  TextButton.icon(
                      onPressed: () {},
                      label: Text("${widget.rating["rate"]}"),
                      icon: Icon(
                        Icons.star,
                        color: mainColor,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ))
                ],
              ),
              Container(
                color: Colors.grey[200],
                alignment: Alignment.center,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                child: const Text(
                    "About the product. something abut it. The quality. How to use it. What makes it different."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

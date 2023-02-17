import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/data/api_data.dart';
import 'package:ecommerce/model/product_model.dart';
import 'package:ecommerce/utils/color_themes.dart';
import 'package:ecommerce/view/screen/cart.dart';
import 'package:ecommerce/view/screen/product_details.dart';
import 'package:ecommerce/view/widgets/cart_counter.dart';
import 'package:ecommerce/view/widgets/search_widget.dart';
import 'package:ecommerce/viewmodel/products_vm.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  ProductScreenState createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  late Future<List<Product>> products;
  String query = '';
  Timer? debouncer;
  bool reverse = false;

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;

    return Scaffold(
      body: FutureBuilder<List<Product>>(

          /// create a future variable on state class
          future: products,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  snap: true,
                  expandedHeight: 160,
                  flexibleSpace: PreferredSize(
                    preferredSize: Size(size.width, 50),
                    child: Container(
                      margin: const EdgeInsets.only(top: 80),
                      child: Column(children: [
                        Flexible(
                          child: buildSearch(),
                        ),
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                const SizedBox(width: 15),
                                InkWell(
                                  onTap: () {
                                    priceSortProduct(reverse);
                                  },
                                  child: const Icon(Icons.sort_rounded,
                                      color: Colors.white),
                                ),
                                InkWell(
                                  onTap: () {
                                    priceSortProduct(reverse);
                                  },
                                  child: const Text(
                                    "Pirce",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                InkWell(
                                  onTap: () {
                                    rateSortProduct(reverse);
                                  },
                                  child: const Icon(
                                    Icons.sort_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    rateSortProduct(reverse);
                                  },
                                  child: const Text(
                                    "Rating",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  backgroundColor: mainColor,
                  actions: [
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 15, top: 8, bottom: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 5, bottom: 5),
                            child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: Icon(Icons.shopping_cart_rounded,
                                        color: textColor, size: 25)),
                                Positioned(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Consumer<ProductsVM>(
                                      builder: (context, value, child) =>
                                          CartCounter(
                                        count: value.lst.length.toString(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.menu_rounded, color: textColor, size: 25),
                  ),
                  title: Center(
                    child: Text(
                      "Store",
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 15),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: (itemWidth / itemHeight),
                  ),
                  delegate: SliverChildBuilderDelegate(
                      childCount: snapshot.data!.length, (context, index) {
                    return InkWell(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(bottom: 60),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              imageUrl: snapshot.data![index].image,
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 55,
                                margin: const EdgeInsets.all(5),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text(
                                          "${snapshot.data![index].rating["rate"]}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const Icon(
                                          Icons.star,
                                          size: 20,
                                        ),
                                        Text(
                                          "Sold: ${snapshot.data![index].rating["count"]}",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ]),
                                      Flexible(
                                        child: Text(
                                          snapshot.data![index].title,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            bottom: 55,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                color: shadeColor,
                                height: 25,
                                margin: const EdgeInsets.all(5),
                                child: Text(
                                  "\$${snapshot.data![index].price}",
                                  style:
                                      TextStyle(fontSize: 18, color: mainColor),
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  width: double.infinity,
                                  child: Divider(
                                    endIndent: 1,
                                    thickness: 2,
                                    color: mainColor,
                                  )),
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetails(
                                id: snapshot.data![index].id,
                                image: snapshot.data![index].image,
                                price: snapshot.data![index].price,
                                rating: snapshot.data![index].rating,
                                itemName: snapshot.data![index].title),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ]);
            } else if (snapshot.hasError) {
              return CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  snap: true,
                  expandedHeight: 160,
                  flexibleSpace: PreferredSize(
                    preferredSize: Size(size.width, 50),
                    child: Container(
                      margin: const EdgeInsets.only(top: 80),
                      child: Column(children: [
                        Flexible(
                          child: buildSearch(),
                        ),
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                const SizedBox(width: 15),
                                InkWell(
                                  onTap: () {
                                    priceSortProduct(reverse);
                                  },
                                  child: const Icon(Icons.sort_rounded,
                                      color: Colors.white),
                                ),
                                InkWell(
                                  onTap: () {
                                    priceSortProduct(reverse);
                                  },
                                  child: const Text(
                                    "Pirce",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                InkWell(
                                  onTap: () {
                                    rateSortProduct(reverse);
                                  },
                                  child: const Icon(
                                    Icons.sort_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    rateSortProduct(reverse);
                                  },
                                  child: const Text(
                                    "Rating",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  backgroundColor: mainColor,
                  actions: [
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 0, right: 15, top: 8, bottom: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, top: 5, bottom: 5),
                            child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: Icon(Icons.shopping_cart_rounded,
                                        color: textColor, size: 25)),
                                Positioned(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Consumer<ProductsVM>(
                                      builder: (context, value, child) =>
                                          CartCounter(
                                        count: value.lst.length.toString(),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.menu_rounded, color: textColor, size: 25),
                  ),
                  title: Center(
                    child: Text(
                      "Store",
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Text('${snapshot.error}'),
                ),
              ]);
            }

            return CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                expandedHeight: 160,
                flexibleSpace: PreferredSize(
                  preferredSize: Size(size.width, 50),
                  child: Container(
                    margin: const EdgeInsets.only(top: 80),
                    child: Column(children: [
                      Flexible(
                        child: buildSearch(),
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(top: 5),
                          child: Row(
                            children: [
                              const SizedBox(width: 15),
                              InkWell(
                                onTap: () {
                                  priceSortProduct(reverse);
                                },
                                child: const Icon(Icons.sort_rounded,
                                    color: Colors.white),
                              ),
                              InkWell(
                                onTap: () {
                                  priceSortProduct(reverse);
                                },
                                child: const Text(
                                  "Pirce",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 15),
                              InkWell(
                                onTap: () {
                                  rateSortProduct(reverse);
                                },
                                child: const Icon(
                                  Icons.sort_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  rateSortProduct(reverse);
                                },
                                child: const Text(
                                  "Rating",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                backgroundColor: mainColor,
                actions: [
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 15, top: 8, bottom: 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CartScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Icon(Icons.shopping_cart_rounded,
                                      color: textColor, size: 25)),
                              Positioned(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Consumer<ProductsVM>(
                                    builder: (context, value, child) =>
                                        CartCounter(
                                      count: value.lst.length.toString(),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                ],
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.menu_rounded, color: textColor, size: 25),
                ),
                title: Center(
                  child: Text(
                    "Store",
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ]);
          }),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search product',
        onChanged: searchProduct,
      );

  Future searchProduct(String query) async => debounce(() async {
        var prods = getProducts(query);
        if (!mounted) return;

        setState(() {
          this.query = query;
          products = prods;
        });
      });

  Future priceSortProduct(rev) async => debounce(() async {
        var prods = getPriceSortedProducts(rev);
        if (!mounted) return;

        setState(() {
          products = prods;
          reverse = !reverse;
        });
      });

  Future rateSortProduct(rev) async => debounce(() async {
        var prods = getRatingSortedProducts(rev);
        if (!mounted) return;

        setState(() {
          products = prods;
          reverse = !reverse;
        });
      });
}

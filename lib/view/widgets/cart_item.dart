import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CartItem extends StatefulWidget {
  const CartItem(
      {Key? key,
      required this.screenSize,
      required this.image,
      required this.itemName,
      required this.price,
      required this.del,
      required this.count})
      : super(key: key);

  final Size screenSize;
  final String image, itemName;
  final double price;
  final Function del;
  final int count;

  @override
  CartItemState createState() => CartItemState();
}

class CartItemState extends State<CartItem> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    count = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: widget.screenSize.height * 0.25,
      width: widget.screenSize.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.blue[200]!.withOpacity(0.3),
                offset: const Offset(0, 0),
                blurRadius: 3,
                spreadRadius: 3)
          ]),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            widget.itemName,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 22),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              height: widget.screenSize.height * 0.13,
              width: widget.screenSize.width * 0.3,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              imageUrl: widget.image,
            ),
          ),
          Column(children: [
            Container(
              alignment: Alignment.center,
              child: Text("(${widget.count}) \$${widget.price}"),
            ),
          ]),
        ]),
      ]),
    );
  }
}

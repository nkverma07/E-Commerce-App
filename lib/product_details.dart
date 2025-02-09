// Product Detail Page
import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  final Function(dynamic) addToCart;
  final Function(dynamic) removeFromCart;
  final bool isInCart;

  ProductDetailPage({
    required this.product,
    required this.addToCart,
    required this.removeFromCart,
    required this.isInCart,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late bool isAddedToCart;
  void initState() {
    super.initState();
    isAddedToCart = widget.isInCart;
  }

  void toggleCart() {
    setState(() {
      if (isAddedToCart) {
        widget.removeFromCart(widget.product);
      } else {
        widget.addToCart(widget.product);
      }
      isAddedToCart = !isAddedToCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product["title"])),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(widget.product["image"], height: 200)),
            SizedBox(height: 20),
            Text(widget.product["title"],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("\$${widget.product["price"]}",
                style: TextStyle(fontSize: 18, color: Colors.green)),
            SizedBox(height: 10),
            Text("Category: ${widget.product["category"]}",
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            SizedBox(height: 10),
            Text(widget.product["description"],
                maxLines: 2, style: TextStyle(fontSize: 14)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: isAddedToCart ? Colors.red : Colors.blue,
              ),
              child: Text(isAddedToCart ? "Remove from Cart" : "Add to Cart"),
            ),
          ],
        ),
      ),
    );
  }
}

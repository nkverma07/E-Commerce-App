import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final List<dynamic> cartItems;
  final Function(dynamic) removeFromCart;
  final VoidCallback clearCart;

  CartScreen(this.cartItems, this.removeFromCart, this.clearCart);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: widget.cartItems.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      var product = widget.cartItems[index];

                      return Dismissible(
                        key: Key(product["id"].toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            widget.removeFromCart(product);
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: Image.network(product["image"], width: 50),
                            title: Text(product["title"],
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            subtitle: Text(
                              "\$${product["price"]}",
                              style: TextStyle(color: Colors.green),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  widget.removeFromCart(product);
                                });
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: widget.clearCart,
                    child: Text("Remove All Items"),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ],
            ),
    );
  }
}

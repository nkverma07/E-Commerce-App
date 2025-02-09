import 'dart:convert';

import 'package:e_commerce_app/cart_screen.dart';
import 'package:e_commerce_app/product_details.dart';
import 'package:e_commerce_app/products_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> products = [];
  List<String> categories = [];
  List<dynamic> topRatedProducts = [];
  List<dynamic> filteredProducts = [];
  String selectedCategory = "All"; // Default: Show all products

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse("https://fakestoreapi.com/products"); // API URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        products = data;
        categories = ["All"] +
            data
                .map((product) => product["category"].toString())
                .toSet()
                .toList();
        filteredProducts = products; // Initially, show all products
        topRatedProducts = getTopRatedProducts(data);
      });
    }
  }

  List<dynamic> getTopRatedProducts(List<dynamic> products) {
    products.sort((a, b) =>
        b["rating"]["rate"].compareTo(a["rating"]["rate"])); // Sort descending
    return products.take(3).toList(); // Take top 3 highest-rated products
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredProducts = category == "All"
          ? products
          : products
              .where((product) => product["category"] == category)
              .toList();
    });
  }

  void updateProductList(List<dynamic> newProducts) {
    setState(() {
      filteredProducts = newProducts;
    });
  }

  List<dynamic> cartItems = [];

  void addToCart(dynamic product) {
    setState(() {
      if (!cartItems.contains(product)) {
        cartItems.add(product);
      }
    });
  }

  void clearCart() {
    setState(() {
      cartItems.clear();
    });
  }

  void removeFromCart(dynamic product) {
    setState(() {
      cartItems.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Commerce App"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: ProductSearch(categories, filterByCategory));
            },
          ),
          SizedBox(
            width: 20,
          ),
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                if (cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartItems.length.toString(),
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CartScreen(cartItems, removeFromCart, clearCart)),
              );
            },
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: products.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loader if data is not yet loaded
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Slider
                  Container(
                    height: 70,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: PageView.builder(
                      itemCount: topRatedProducts.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Image.network(
                              topRatedProducts[index]["image"],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                            Container(
                              color:
                                  Colors.black.withOpacity(0.3), // Add overlay
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.all(10),
                              child: Text(
                                topRatedProducts[index]["title"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 4,
                                    fontWeight: FontWeight.normal),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Categories Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Categories",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            filterByCategory(categories[index]);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: selectedCategory == categories[index]
                                  ? Colors.blue.shade100
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Center(
                              child: Text(
                                categories[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: selectedCategory == categories[index]
                                      ? Colors.blue
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 15),

                  // Product Listing
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Products",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  filteredProducts.isEmpty
                      ? Center(
                          child: Text("No products available in this category",
                              style: TextStyle(fontSize: 16)))
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: filteredProducts.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (context, index) {
                            var product = filteredProducts[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(
                                      product: product,
                                      addToCart: addToCart,
                                      removeFromCart: removeFromCart,
                                      isInCart: cartItems.contains(product),
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Image.network(product["image"],
                                        height: 100, fit: BoxFit.cover),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Text(product["title"],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text("\$${product["price"]}",
                                              style: TextStyle(
                                                  color: Colors.green)),
                                          SizedBox(height: 5),
                                          ElevatedButton(
                                            onPressed: () {
                                              addToCart(product);
                                            },
                                            child: Text(
                                                cartItems.contains(product)
                                                    ? "Added"
                                                    : "Add to Cart"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products-provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = "/productdetails";

  @override
  Widget build(BuildContext context) {
    String ID = ModalRoute.of(context).settings.arguments;
    final productData =
        Provider.of<Products>(context, listen: false).searchByID(ID);
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
      ),
      body: Column(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            child: Image.network(productData.imageUrl),
          ),
          Text(
            "\$${productData.price}",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "${productData.title}",
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}

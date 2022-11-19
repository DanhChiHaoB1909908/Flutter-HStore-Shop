import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products-provider.dart';
import 'product-card.dart';

class Favorite extends StatefulWidget {
  static const routeName = "/favorite";

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).favoriteItems;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SHOP",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text("Favorites",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
          ),
          Container(
            width: double.infinity,
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              scrollDirection: Axis.vertical,
              //physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 7.0,
                  mainAxisSpacing: 7.0),
              itemCount: products.length,
              itemBuilder: (context, index) => ChangeNotifierProvider.value(
                  value: products[index], child: product_card()),
            ),
          ),
        ],
      ),
    );
  }
}

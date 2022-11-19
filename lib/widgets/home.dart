import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products-provider.dart';

import './product-card.dart';

class Home extends StatelessWidget {
  static const routeName = "/home";

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              "Recommended for you",
              // style: Theme.of(context).textTheme.titleMedium,
              style: TextStyle(
                fontFamily: "SourceSans Pro",
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            height: 270,
            width: double.infinity,
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              scrollDirection: Axis.vertical,
              // physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 7.0,
                  mainAxisSpacing: 7.0),
              itemCount: products.length < 10 ? products.length : 8,
              itemBuilder: (context, index) => ChangeNotifierProvider.value(
                  value: products[index], child: product_card()),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              "All Products",
              // style: Theme.of(context).textTheme.titleMedium,
              style: TextStyle(
                fontFamily: "SourceSans Pro",
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 270,
            child: ListView.builder(
              itemBuilder: (_, i) => ListTile(
                title: Text(
                  products[i].title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(products[i].imageUrl),
                ),
                subtitle: Text("\$${products[i].price}"),
              ),
              itemCount: products.length,
            ),
          )
        ],
      ),
    );
  }
}

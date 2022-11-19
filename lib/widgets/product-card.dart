import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth-provider.dart';
import '../providers/cart-provider.dart';
import '../providers/product-provider.dart';
import '../screens/ProductDetailsScreen.dart';

class product_card extends StatefulWidget {
  @override
  State<product_card> createState() => _product_cardState();
}

class _product_cardState extends State<product_card> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Product>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetailsScreen.routeName, arguments: data.id);
          },
          child: Image.network(
            data.imageUrl,
            height: 500,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          title: Text(
            data.title,
            softWrap: true,
            style: TextStyle(
              fontFamily: "SourceSans Pro",
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          leading: Consumer<Product>(
            // this favorite icon button will only update if data changes in database.
            builder: (ctx, data, child) => IconButton(
              onPressed: () => data.toggleFavorite(authData.token, authData.userId),
              icon: Icon(
                  data.isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
          ),
          trailing: Consumer<Cart>(
            builder: (_, cartData, child) => IconButton(
              onPressed: () {
                cartData.addCartItems(
                    data.id, data.title, data.price, data.imageUrl);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    textColor: Colors.red,
                    label: "Undo",
                    onPressed: () {
                      cartData.removeSingleItemQuantity(data.id);
                    },
                    key: Key(data.id),
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Added to Cart !"),
                    ],
                  ),
                ));
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order-provider.dart';
import '../providers/cart-provider.dart' show Cart;
import '../widgets/cart-card.dart';

class CartScreen extends StatefulWidget {
  static const routeName = "/cart_screen";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "SHOPPING CART",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.red),
      body: cartData.cart_items.length == 0
          ? Center(
              child: Text("No Cart Item Added"),
            )
          : Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "TOTAL AMOUNT :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        //Spacer(),
                        Chip(
                          backgroundColor: Colors.red.shade50,
                          label: Text(
                              "${cartData.totalAmount.toStringAsFixed(2)}"),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          labelPadding: EdgeInsets.all(1),
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.4,
                              fontSize: 14),
                        ),
                        SizedBox(width: 5),
                        OrderButton(cartData),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, i) {
                      return Cart_Card(
                        serialNo: i + 1,
                        id: cartData.cart_items.values.toList()[i].id,
                        title: cartData.cart_items.values.toList()[i].title,
                        price: cartData.cart_items.values.toList()[i].price,
                        quantity:
                            cartData.cart_items.values.toList()[i].quantity,
                        imageUrl:
                            cartData.cart_items.values.toList()[i].imageUrl,
                      );
                    },
                    itemCount: cartData.cartItemsCount,
                  ),
                ),
              ],
            ),
    );
  }
}

class OrderButton extends StatefulWidget {
  Cart cart;

  OrderButton(this.cart);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.cartItemsCount <= 0 || _isLoading) ? null : () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Order>(context, listen: false).addOrder(
            widget.cart.totalAmount, widget.cart.cart_items.values.toList());
        setState(() {
          _isLoading = false;
        });
        widget.cart.clear();
      },
      child: _isLoading ? CircularProgressIndicator(value: 2,) : Text(
        "ORDER NOW",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.red.shade500,
        ),
      ),
    );
  }
}

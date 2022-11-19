import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/order-provider.dart';

class OrderItemView extends StatefulWidget {
  final int OrderIndex;

  OrderItemView(this.OrderIndex);

  @override
  State<OrderItemView> createState() => _OrderItemViewState();
}

class _OrderItemViewState extends State<OrderItemView> {
  var _expanded = false;

  Widget build(BuildContext context) {
    final OrderProviderData = Provider.of<Order>(context);
    return Card(
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          ListTile(
            title: Text(
              "\$${(OrderProviderData.OrderList[widget.OrderIndex].TotalAmount).toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "${DateFormat('dd/MM/yyyy hh:mm').format(OrderProviderData.OrderList[widget.OrderIndex].dateTime)}",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              height: min(OrderProviderData
                  .OrderList[widget.OrderIndex].CartItemList.length * 20.0 + 0, 200),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //padding: EdgeInsets.all(2.0),
              child: ListView.builder(
                  itemBuilder: (ctx, index) => Row(children: [
                        Text(
                          "${OrderProviderData.OrderList[widget.OrderIndex].CartItemList[index].title}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        Spacer(),
                        Text(
                          "${OrderProviderData.OrderList[widget.OrderIndex].CartItemList[index].quantity} x \$${OrderProviderData.OrderList[widget.OrderIndex].CartItemList[index].price}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ]),
                  itemCount: OrderProviderData
                      .OrderList[widget.OrderIndex].CartItemList.length),
            ),
        ],
      ),
    );
  }
}

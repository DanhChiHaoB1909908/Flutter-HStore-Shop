import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order-provider.dart';
import '../widgets/order-card.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _orderObtained;

  Future _processodOrderObtaining() {
      return Provider.of<Order>(context, listen: false).fetchOrders();
  }

  @override
  initState() {
    _orderObtained = _processodOrderObtaining();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Orders",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
          future: _orderObtained,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.error != null) {
              return Center(child: Text("You may have not order before."));
            } else {
              return Consumer<Order>(builder: (_, OrderProviderData, child) {
                return OrderProviderData.OrderList.length <= 0
                    ? Center(child: Text("No orders."))
                    : Column(
                  children: [
                    Container(
                      child: Expanded(
                        child: ListView.builder(
                          itemBuilder: (ctx, OrderIndex) =>
                              OrderItemView(OrderIndex),
                          itemCount: OrderProviderData.OrderList.length,
                        ),
                      ),
                    ),
                  ],
                );
              });
            }
          }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart-provider.dart';

class Cart_Card extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final int serialNo;
  final String imageUrl;

  const Cart_Card(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity,
      @required this.serialNo,
      @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        padding: EdgeInsets.only(right: 15),
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete_outline,
          size: 25,
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(id);
      },
      confirmDismiss: (direction) {
        return showDialog(context: context, builder: (ctx) => AlertDialog(
          title: Text("Are you sure ?", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Do you want to remove the item ?"),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop(true);
            }, child: Text("YES"),),
            TextButton(onPressed: (){
              Navigator.of(context).pop(false);
            }, child: Text("NO"),),
          ],
        ));
      },
      key: ValueKey(id),
      child: Card(
        margin: EdgeInsets.all(2),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            title: Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Total : \$${quantity * price}",
            ),
            trailing: Text(
              "x${quantity}",
            ),
            // leading: Text(
            //   "${serialNo}",
            //   textAlign: TextAlign.center,
            // ),
            leading: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}

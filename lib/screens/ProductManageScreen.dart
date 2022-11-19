import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products-provider.dart';
import './AddNewScreen.dart';
import './EditScreen.dart';

class ProductManageScreen extends StatelessWidget {
  static const routeName = "/manager";

  Future<void> _refresh(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchAndSetData(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    final scaffold = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddNewScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
        title: Text(
          "Manage Products",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator(),)
            : RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () => _refresh(context),
                child: Consumer<Products>(
                  builder: (ctx, productsData, _) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemBuilder: (_, i) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      productsData.items[i].imageUrl)),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 200,
                                    child: Text(
                                      productsData.items[i].title,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                  Text(
                                    "\$ ${productsData.items[i].price}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                    EditScreen.routeName,
                                    arguments: productsData.items[i].id,
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  try {
                                    await productsData.deleteProduct(
                                        productsData.items[i].id);
                                  } catch (error) {
                                    scaffold.showSnackBar(SnackBar(
                                      content: Text("Deleting Failed!"),
                                      duration: Duration(milliseconds: 500),
                                    ));
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      itemCount: productsData.items.length,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

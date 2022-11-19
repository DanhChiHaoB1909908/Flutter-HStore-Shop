import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../providers/product-provider.dart';
import '../providers/products-provider.dart';

class AddNewScreen extends StatefulWidget {
  static const routeName = "/add-new-product-screen";

  @override
  State<AddNewScreen> createState() => _AddNewScreen();
}

class _AddNewScreen extends State<AddNewScreen> {
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Temporary Values for adding into product.
  var title = "";
  var des = "";
  var price = 0.0;
  var url = "";

  var _isLoading = false;

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    setState(() {});
  }

  Future<void> _saveForm() async {
    _formKey.currentState.validate();
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final newProdItem =
        Product(title: title, description: des, price: price, imageUrl: url);
    try {
      await Provider.of<Products>(context, listen: false)
          .addProduct(newProdItem);
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text("An error occurred!"),
                content: Text("Something went wrong"),
                actions: [
                  TextButton(
                    child: Text("Okay"),
                    onPressed: () {
                      Navigator.of(ctx).pop(); // removes the dialog.
                      // until we press okay, it waits for us, because of the await keyword.
                    },
                  ),
                ],
              ));
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  } // function ends here.

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(
              Icons.save_outlined,
            ),
          ),
        ],
        title: Text(
          "Add New Product",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: ListView(children: [
                  TextFormField(
                    //initialValue: "${args["Title"]}",
                    decoration: InputDecoration(
                      hintText: "Red Shirt",
                      label: Text(
                        "Title",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      title = value;
                    },
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return "Provide a title.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    //initialValue: "\$${args["Price"]}",
                    decoration: InputDecoration(
                      hintText: "\$9.99",
                      label: Text(
                        "Price",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      price = double.parse(value);
                    },
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return "Set a price.";
                      }
                      if (double.tryParse(input) == null) {
                        return "Provide a valid number.";
                      }
                      if (double.parse(input) < 0) {
                        return "Should be a greater number.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    //initialValue: "${args["Description"]}",
                    decoration: InputDecoration(
                      hintText: "A red shirt - it is pretty red!",
                      label: Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) {
                      des = value;
                    },
                    validator: (input) {
                      if (input.isEmpty) {
                        return "Provide a description.";
                      }
                      if (input.length < 10) {
                        return "Should at least contain 10 characters.";
                      }
                      return null;
                    },
                    //textInputAction: TextInputAction.next,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, right: 12),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                          // image: DecorationImage(
                          //   fit: BoxFit.cover,
                          //   image: NetworkImage(_imageUrlController.text.isEmpty
                          //       ? 'https://scontent.fccu11-1.fna.fbcdn.net/v/t1.6435-9/29244092_1881987471874252_4979572236735217664_n.png?stp=dst-png&_nc_cat=110&ccb=1-6&_nc_sid=85a577&efg=eyJpIjoidCJ9&_nc_ohc=-Hk3IVq2KMIAX-9r2Yq&_nc_oc=AQnQEDY6aDZ8VuU_iv3N9f8JeMeqLmBr3Vc72ea18NjwtJwxqLuHrQAfsj4Ato91l_QO4U_KBZyuK74sFrV7MzEW&_nc_ht=scontent.fccu11-1.fna&oh=00_AT_6D1q2DO-pxI7N-_HJeQeXqeutSUxG8k_dH8cAu7y-SA&oe=62A21DA8'
                          //       : _imageUrlController.text),
                          // ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: "https://image.jpg",
                              labelText: "Image URL",
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                          //initialValue: "${args['ImageURL']}",
                          controller: _imageUrlController,
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          onSaved: (value) {
                            url = value;
                          },
                          onFieldSubmitted: (_) => _saveForm,
                          validator: (input) {
                            if (input.isEmpty) {
                              return "Provide a image url.";
                            }
                            if (!input.startsWith("http")) {
                              return "Should be a valid url starting with http or https.";
                            }
                            if (!input.endsWith(".jpeg") ||
                                !input.endsWith(".jpg") ||
                                !input.endsWith(".png")) {
                              return "Invalid url";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
    );
  }
}

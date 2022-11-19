import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product-provider.dart';
import '../providers/products-provider.dart';

class EditScreen extends StatefulWidget {
  static const routeName = "/edit-screen";

  @override
  State<EditScreen> createState() => _EditScreen();
}

class _EditScreen extends State<EditScreen> {
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Product _editedProduct = Product(
    title: "",
    description: "",
    price: 0.0,
    imageUrl: "",
    category: null,
    id: null,
    isFavorite: false,
  );

  // Values for showing //initialValue on form.
  var _initValues = {
    "title": "",
    "description": "",
    "price": 0.0,
  };

  var _initS = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initS) {
      final productId = ModalRoute.of(context).settings.arguments;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context).searchByID(productId.toString());
        _initValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _initS = false;
    }
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    setState(() {});
  }

  void _saveForm() {
    _formKey.currentState.validate();
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct);
    } catch (error) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text("An error occurred!"),
                content: Text("Something went wrong."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Okay"))
                ],
              )
      );
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          "Edit Product",
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: ListView(children: [
                  TextFormField(
                    initialValue: _initValues['title'],
                    decoration: InputDecoration(
                      //hintText: "Red Shirt",
                      label: Text(
                        "Title",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      _editedProduct = Product(
                        title: value,
                        description: _editedProduct.description,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        category: _editedProduct.category,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                    validator: (input) {
                      if (input == null || input.isEmpty) {
                        return "Enter a title for product.";
                      }
                      if (input.startsWith(RegExp(r'[A-Z][a-z]'))) {
                        return "Enter alphabets only.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _initValues['price'].toString(),
                    decoration: InputDecoration(
                      //hintText: "\$9.99",
                      label: Text(
                        "Price",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) {
                      _editedProduct = Product(
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        price: double.parse(value),
                        imageUrl: _editedProduct.imageUrl,
                        category: _editedProduct.category,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                      );
                    },
                    validator: (input) {
                      if (input.isEmpty) {
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
                    initialValue: _initValues['description'],
                    decoration: InputDecoration(
                      //hintText: "A red shirt - it is pretty red!",
                      label: Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    onSaved: (value) {
                      _editedProduct = Product(
                        title: _editedProduct.title,
                        description: value,
                        price: _editedProduct.price,
                        imageUrl: _editedProduct.imageUrl,
                        category: _editedProduct.category,
                        id: _editedProduct.id,
                        isFavorite: _editedProduct.isFavorite,
                      );
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
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(_imageUrlController.text.isEmpty
                                ? 'https://scontent.fccu11-1.fna.fbcdn.net/v/t1.6435-9/29244092_1881987471874252_4979572236735217664_n.png?stp=dst-png&_nc_cat=110&ccb=1-6&_nc_sid=85a577&efg=eyJpIjoidCJ9&_nc_ohc=-Hk3IVq2KMIAX-9r2Yq&_nc_oc=AQnQEDY6aDZ8VuU_iv3N9f8JeMeqLmBr3Vc72ea18NjwtJwxqLuHrQAfsj4Ato91l_QO4U_KBZyuK74sFrV7MzEW&_nc_ht=scontent.fccu11-1.fna&oh=00_AT_6D1q2DO-pxI7N-_HJeQeXqeutSUxG8k_dH8cAu7y-SA&oe=62A21DA8'
                                : _imageUrlController.text),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                              //hintText: "https://image.jpg",
                              labelText: "Image URL",
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold)),
                          ////initialValue: _initValues['url'],
                          controller: _imageUrlController,
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          onSaved: (value) {
                            _editedProduct = Product(
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              price: _editedProduct.price,
                              imageUrl: value,
                              category: _editedProduct.category,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                            );
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

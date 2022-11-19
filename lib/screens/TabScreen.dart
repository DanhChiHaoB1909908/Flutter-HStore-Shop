import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products-provider.dart';
import '../providers/cart-provider.dart';
import '../screens/CartScreen.dart';
import '../widgets/badge.dart';
import '../widgets/drawer.dart';
import '../widgets/home.dart';
import '../widgets/categories.dart';
import '../widgets/offers.dart';
import '../widgets/wallet.dart';

enum PopupItemValue {
  favorites,
  my_account,
  settings,
}

class TabScreen extends StatefulWidget {
  static const routeName = "tabScreen";

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Widget> _pages;
  int _pageIndex = 0;

  var _isLoading = false;
  var _fetched = false;

  @override
  void initState() {
    _pages = [
      Home(),
      Categories(),
      Offers(),
      Wallet(),
    ];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Products>(context, listen: false)
        .fetchAndSetData()
        .then((_) => setState(() {
              _isLoading = false;
            }));
    super.didChangeDependencies();
  }

  void tabSelectionHandler(int value) {
    setState(() {
      _pageIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "H-Store",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red,
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.account_circle),
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text("Account"), value: PopupItemValue.my_account),
              PopupMenuItem(
                  child: Text("Settings"), value: PopupItemValue.settings),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              value: cart.cartItemsCount,
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _pages[_pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: tabSelectionHandler,
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            label: "Categories",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer_outlined), label: "Offers"),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "Wallet",
          ),
        ],
      ),
    );
  }
}

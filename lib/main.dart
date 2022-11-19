import 'package:demo_shop_app/screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/TabScreen.dart';
import './widgets/home.dart';
import './widgets/categories.dart';
import './widgets/offers.dart';
import './widgets/wallet.dart';
import './screens/ProductDetailsScreen.dart';
import './providers/products-provider.dart';
import './providers/cart-provider.dart';
import './screens/CartScreen.dart';
import './widgets/favorite.dart';
import './providers/order-provider.dart';
import './screens/OrderScreen.dart';
import './screens/ProductManageScreen.dart';
import './screens/AddNewScreen.dart';
import './screens/AuthScreen.dart';
import './screens/EditScreen.dart';
import './providers/auth-provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // adding multiple providers.
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products(null, null, []),
            update: (ctx, auth, preProds) =>
                Products(auth.userId, auth.token, preProds.items)),
        ChangeNotifierProxyProvider<Auth, Order>(
            create: (ctx) => Order(null, null, []),
            update: (ctx, auth, preOrders) =>
                Order(auth.token, auth.userId, preOrders.OrderList)),
        ChangeNotifierProvider.value(value: Cart()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shop',
          theme: ThemeData(
            fontFamily: "SourceSans Pro",
            primarySwatch: Colors.red,
          ),
          home: (auth.isAuth)
              ? TabScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authDataSnapshot) =>
                      authDataSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            AuthScreen.routeName: (context) => AuthScreen(),
            TabScreen.routeName: (context) => TabScreen(),
            Home.routeName: (context) => Home(),
            Categories.routeName: (context) => Categories(),
            Offers.routeName: (context) => Offers(),
            Wallet.routeName: (context) => Wallet(),
            ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
            Favorite.routeName: (context) => Favorite(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routeName: (context) => OrderScreen(),
            ProductManageScreen.routeName: (context) => ProductManageScreen(),
            AddNewScreen.routeName: (context) => AddNewScreen(),
            EditScreen.routeName: (context) => EditScreen(),
          },
        ),
      ),
    );
  }
}

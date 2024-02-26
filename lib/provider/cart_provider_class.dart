


import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/db_helper/db_helper_class.dart';
import 'package:shopping_cart/modal/cart_modal.dart';

class CartProvider extends ChangeNotifier {

  DbHelper? dbHelper = DbHelper.instance;

   int _counter=0;
   int get counter => _counter;

   double _totalPrice=0.00;
   double get totalPrice => _totalPrice;

   late Future<List<Cart>> _cart;
   Future<List<Cart>> get cart => _cart;

   Future<List<Cart>> getCartList()async{
   _cart=dbHelper!.getCartList();
   //getCartPreferences();
    return _cart;
   }



   _setCartPreferences()async{
     SharedPreferences sp=await SharedPreferences.getInstance();
     await sp.setInt('counter',_counter);
     await sp.setDouble('total_price',_totalPrice);
     notifyListeners();
   }

    getCartPreferences()async{
     SharedPreferences sp=await SharedPreferences.getInstance();
    _counter= sp.getInt('counter') ?? 0;
     _totalPrice=sp.getDouble('total_price') ?? 0.00;
     notifyListeners();
     print(_totalPrice.toString());
     print(_counter.toString());
    }

    void addCounter(){
     _counter++;
     _setCartPreferences();
     notifyListeners();
    }

   void removeCounter(){
     _counter--;
     _setCartPreferences();
     notifyListeners();
    }

    int getCounter(){
     // getCartPreferences();
     return _counter;
    }

   void addTotalPrice(double price){
   //  print('price:'+price.toString());
     //print('total'+_totalPrice.toString());
     _totalPrice += price;
     notifyListeners();
     //print(_totalPrice.toString());
     _setCartPreferences();
     notifyListeners();
   }

   void removeTotalPrice(double price){
     _totalPrice = _totalPrice - price;
     notifyListeners();
     _setCartPreferences();
     notifyListeners();
   }

   double getTotalPrice(){
     //getCartPreferences();
     return _totalPrice;
   }

}
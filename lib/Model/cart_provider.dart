import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/Model/cart_model.dart';
import 'package:shopping_cart/Model/db_helper.dart';
class CartProvider with ChangeNotifier{
  DBHelper db=DBHelper();

  int _counter =0;
  int get counter=> _counter;

  double _totalPrice=0.0;
  double get totalPrice=> _totalPrice;

  late Future<List<CartModel>> _cart;
   Future<List<CartModel>> get cart=> _cart;

   Future<List<CartModel>> getData()async{
     _cart=db.getCartList();
     return _cart;

   }
  void setPref()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_Price', _totalPrice);
    notifyListeners();

  }

  void getPref()async{
    SharedPreferences prefs=await SharedPreferences.getInstance();
    _counter=prefs.getInt('cart_item') ?? 0;
    _totalPrice=prefs.getDouble('total_Price') ?? 0.0;
    notifyListeners();

  }
  void addTotalPrice(double productPrice){
    _totalPrice=_totalPrice+productPrice;
    setPref();
    notifyListeners();
  }


  void removeTotalPrice(double productPrice){
    _totalPrice=_totalPrice-productPrice;
    setPref();
    notifyListeners();
  }
  double getTotalPrice(){
    getPref();
    return _totalPrice;
  }




  void addCounter(){
    _counter++;
    setPref();
    notifyListeners();
  }
  void removeCounter(){
    _counter--;
    setPref();
    notifyListeners();
  }
  int getCounter(){
    getPref();
    return _counter;
  }








}
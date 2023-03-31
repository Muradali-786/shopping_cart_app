import 'package:shopping_cart/Model/cart_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DBHelper{

  static Database? _db;

  Future<Database?> get db async{
    if(_db!=null){

      return _db;

    }
    _db=await initDatabase();
    return _db;

  }
  initDatabase()async{
  io.Directory documentDirectory=await getApplicationDocumentsDirectory();
  String path=join(documentDirectory.path,'cart.db');
  var db=await openDatabase(path,version: 1,onCreate: _onCreate);
  return db;
  }
  _onCreate(Database db ,int version)async {
    await db.execute(
        'CREATE TABLE cart(id INTEGER PRIMARY KEY , productId VARCHAR UNIQUE , productName TEXT ,initialPrice INTEGER ,productPrice INTEGER ,quantity INTEGER , unitTag TEXT , image TEXT )'
    );
  }

    Future<CartModel> insert(CartModel cartModel)async{
      var dbClient=await db;
      await dbClient!.insert('cart', cartModel.toMap());
      return cartModel;


    }
  Future <List<CartModel>> getCartList()async{
    var dbClient=await db;
   final List<Map<String ,Object?>> queryResult=await dbClient!.query('cart');
   return queryResult.map((e) => CartModel.fromMap(e)).toList();



  }
  Future <int> delete(int id)async{
    var dbClient=await db;
   return await dbClient!.delete(
     'cart',
     where: 'id=?',
     whereArgs: [id]

   );

  }

  Future<int> updateQuantity(CartModel cartModel)async{
    var dbClient=await db;
    return await dbClient!.update(
        'cart',
        cartModel.toMap(),
        where: 'id=?',
        whereArgs: [cartModel.id]
    );

  }





}



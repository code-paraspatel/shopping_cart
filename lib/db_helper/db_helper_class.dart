

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shopping_cart/modal/cart_modal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper{


   DbHelper._privetConstructor();
   static final DbHelper instance = DbHelper._privetConstructor();
  Database? _database;

  Future<Database?> get database async {
    if(_database != null){
      return  _database;
    }
    _database= await initDatabase();
    return _database;
  }

   initDatabase() async {
    Directory directory=await getApplicationDocumentsDirectory();
    String path=join(directory.path,'product.db');
    var db=await openDatabase(path,version: 1,onCreate: _onCreate);
    return db;
   }

       _onCreate(Database db, int version) async {
     await db.execute('''CREATE TABLE product (
                   id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
                   productId TEXT,
                   productName TEXT,
                   initialValue INTEGER,
                   totalProductPrice INTEGER,
                   quantity INTEGER,
                   unitTag TEXT,
                   images  TEXT )''');
  }

      Future<List<Cart>> getCartList()async{
        Database? db= await database;
        List<Map<String,dynamic>> result=await db!.query('product');
        List<Cart> data= result.map((e) => Cart.fromMap(e)).toList();
        data.sort((a, b) => b.id!.compareTo(a.id!));
        return data;
      }

      Future<Cart> insertCard (Cart cart) async{
        Database? db=await database;
       await db!.insert('product', cart.toMap());
        return cart;
      }

       Future<int> updateCart(Cart cart)async{
        print(cart.toMap());
        Database? db=await database;
        return await db!.update('product',cart.toMap(),where:'id=?',whereArgs: [cart.id]);
      }


      Future<int> deleteCart(int id)async{
        Database? db=await database;
         var result =await db!.delete('product',where:'id=?',whereArgs:[id]);
        return result;
      }

}
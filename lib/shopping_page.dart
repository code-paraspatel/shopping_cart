
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';
import 'package:shopping_cart/cart_list_page.dart';
import 'package:shopping_cart/db_helper/db_helper_class.dart';
import 'package:shopping_cart/modal/cart_modal.dart';
import 'package:shopping_cart/product_list.dart';
import 'package:shopping_cart/provider/cart_provider_class.dart';

class MyShoppingPage extends StatefulWidget {
  const MyShoppingPage({super.key});

  @override
  State<MyShoppingPage> createState() => _MyShoppingPageState();
}

class _MyShoppingPageState extends State<MyShoppingPage> {

  DbHelper? dbHelper = DbHelper.instance;

  List productList=ProductList.productList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartProvider>(context,listen: false).getCartPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
        builder:(context, cartProvider, _) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Shopping App'),
              actions:  [
                badges.Badge(
                  position: badges.BadgePosition.topEnd(),
                  showBadge: cartProvider.getCounter().toString()=='0'?false:true,
                  badgeContent:  Text(cartProvider.getCounter().toString(),style: const TextStyle(fontSize: 8),),
                  badgeStyle: const badges.BadgeStyle(badgeColor: Colors.white54,),
                  badgeAnimation:  const badges.BadgeAnimation.fade(animationDuration: Duration(milliseconds: 200)),
                  child:  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MyCartListPage(),));
                    },
                      child: const Icon(Icons.shopping_bag_outlined,size: 30,)),
                ),
                const SizedBox(width: 15,),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                      itemCount: productList.length,
                      itemBuilder:(context, index) {
                        return Card(
                          // color: Colors.transparent,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image(
                                  image: AssetImage(productList[index]['image'].toString(),),
                                  fit: BoxFit.fill,
                                  height: 70,
                                  width: 70,
                                  centerSlice: Rect.largest,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(productList[index]['Name'].toString(),style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                      const SizedBox(height: 1,),
                                      Text('₨ '+productList[index]['prices'].toString()+' / '+productList[index]['unit'].toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                        ),),
                                      const SizedBox(height: 5,),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: InkWell(
                                          onTap: () {
                                            dbHelper!.insertCard(
                                                Cart(
                                                  //  id: index,
                                                    productId: index.toString(),
                                                    productName: productList[index]['Name'].toString(),
                                                    initialValue: productList[index]['prices'],
                                                    totalProductPrice:productList[index]['prices'],
                                                    quantity:1,
                                                    images:productList[index]['image'].toString() ,
                                                    unitTag: productList[index]['unit'].toString())
                                            ).then((value) {
                                              cartProvider.addTotalPrice(double.parse(productList[index]['prices'].toString()));
                                              cartProvider.addCounter();
                                              print('Data added in cart');
                                            }).onError((error, stackTrace) {
                                              print('error:${error.toString()}');
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: Colors.orange.shade200
                                            ),
                                            child: const Center(child: Text('Add Cart',style: TextStyle(fontSize: 10),)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }, ))
              ],
            ),
          );
        }, );
  }
}

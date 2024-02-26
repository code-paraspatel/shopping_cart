import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/db_helper/db_helper_class.dart';
import 'package:shopping_cart/modal/cart_modal.dart';
import 'package:shopping_cart/provider/cart_provider_class.dart';

class MyCartListPage extends StatefulWidget {
  const MyCartListPage({super.key});

  @override
  State<MyCartListPage> createState() => _MyCartListPageState();
}

class _MyCartListPageState extends State<MyCartListPage> {
  DbHelper? dbHelper = DbHelper.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CartProvider>(context,listen: false).getCartPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('My CartList'),
            actions: [
              badges.Badge(
                position: badges.BadgePosition.topEnd(),
                ignorePointer: true,
                showBadge: cartProvider.getCounter().toString()=='0'?false:true,
                badgeStyle: const badges.BadgeStyle(badgeColor: Colors.white54),
                //stackFit: StackFit.expand,
                badgeContent:  Text(cartProvider.getCounter().toString(),style: const TextStyle(fontSize: 8),),
                badgeAnimation: const badges.BadgeAnimation.fade(
                    animationDuration: Duration(milliseconds: 300)),
                child: InkWell(
                  onTap: () {
                   // cartProvider.getCartPreferences();
                  },
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                  child: FutureBuilder(
                future: cartProvider.getCartList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if(snapshot.data!.isEmpty){
                      return const Center(child: Text('No Item In Cart'));
                    }else{
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            // color: Colors.transparent,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image(
                                    image: AssetImage(
                                      snapshot.data![index].images.toString(),
                                    ),
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
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data![index].productName
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  await dbHelper!.deleteCart(snapshot.data![index].id!).then((value) {
                                                    cartProvider.removeCounter();
                                                    cartProvider.removeTotalPrice(double.parse(snapshot.data![index].totalProductPrice.toString()));
                                                  }).onError((error, stackTrace) {
                                                    throw(error.toString());
                                                  });

                                                },
                                                icon: const Icon(
                                                  Icons.close,
                                                  size: 25,
                                                )),
                                          ],
                                        ),
                                        Text(
                                          '₨ ${snapshot.data![index].totalProductPrice.toString()} / ${snapshot.data![index].unitTag.toString()}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                color: Colors.orange.shade200),
                                            child:  Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        int _quantity=snapshot.data![index].quantity!;
                                                        int price=snapshot.data![index].initialValue!;
                                                        _quantity--;
                                                        int newPrice= price*_quantity;
                                                        if(_quantity > 0) {
                                                          dbHelper!.updateCart(
                                                              Cart(
                                                                  id: snapshot
                                                                      .data![index]
                                                                      .id,
                                                                  productId: snapshot
                                                                      .data![index]
                                                                      .productId
                                                                      .toString(),
                                                                  productName: snapshot
                                                                      .data![index]
                                                                      .productName
                                                                      .toString(),
                                                                  initialValue: snapshot
                                                                      .data![index]
                                                                      .initialValue!,
                                                                  totalProductPrice: newPrice,
                                                                  quantity: _quantity,
                                                                  images: snapshot
                                                                      .data![index]
                                                                      .images
                                                                      .toString(),
                                                                  unitTag: snapshot
                                                                      .data![index]
                                                                      .unitTag
                                                                      .toString()
                                                              )).then((value) {
                                                            _quantity = 0;
                                                            newPrice = 0;
                                                            cartProvider
                                                                .removeTotalPrice(
                                                                double.parse(
                                                                    snapshot
                                                                        .data![index]
                                                                        .initialValue!
                                                                        .toString()
                                                                ));
                                                          }).onError((error,
                                                              stackTrace) {
                                                            throw(error
                                                                .toString());
                                                          });
                                                        }
                                                      },
                                                      child: const Icon(Icons.remove)),
                                                  Text(snapshot.data![index].quantity!.toString()),
                                                  InkWell(
                                                      onTap:(){
                                                        int _quantity=snapshot.data![index].quantity!;
                                                        int price=snapshot.data![index].initialValue!;
                                                        _quantity++;
                                                        int newPrice = price * _quantity;
                                                        dbHelper!.updateCart(
                                                            Cart(
                                                                id: snapshot
                                                                    .data![index]
                                                                    .id,
                                                                productId: snapshot
                                                                    .data![index]
                                                                    .productId
                                                                    .toString(),
                                                                productName: snapshot
                                                                    .data![index]
                                                                    .productName
                                                                    .toString(),
                                                                initialValue: snapshot
                                                                    .data![index]
                                                                    .initialValue!,
                                                                totalProductPrice: newPrice,
                                                                quantity: _quantity,
                                                                images: snapshot
                                                                    .data![index]
                                                                    .images
                                                                    .toString(),
                                                                unitTag: snapshot
                                                                    .data![index]
                                                                    .unitTag
                                                                    .toString()
                                                            )).then((value) {
                                                          _quantity = 0;
                                                          newPrice = 0;
                                                          cartProvider
                                                              .addTotalPrice(
                                                              double.parse(
                                                                  snapshot
                                                                      .data![index]
                                                                      .initialValue
                                                                      .toString()
                                                              ));
                                                        }).onError((error,
                                                            stackTrace) {
                                                          throw(error.toString());
                                                        });

                                                      },


                                                      child: const Icon(Icons.add)),

                                                ],
                                              ),
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
                        },
                      );
                    }
                  } else {
                    return const Center(child: Text('No Item In Cart'));
                  }
                },
              )),
              Visibility(
                visible: cartProvider.getTotalPrice().toString()=='0.0'?false:true,
                child:  Card(
                  shape: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide.none
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                    child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Price: ',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w400),),
                        Text(
                          '₨ ${cartProvider.getTotalPrice().toString()}',style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

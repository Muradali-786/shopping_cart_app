import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/Model/cart_model.dart';
import 'package:shopping_cart/Model/db_helper.dart';

import '../Model/cart_provider.dart';

class cartScreen extends StatefulWidget {
  const cartScreen({Key? key}) : super(key: key);

  @override
  State<cartScreen> createState() => _cartScreenState();
}

class _cartScreenState extends State<cartScreen> {
  DBHelper? dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My products'),
        actions: [
          Center(
            child: Badge(
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, index) {
                  return Text(
                    value.getCounter().toString(),
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  );
                },
              ),
              child: const Icon(Icons.shopping_bag_rounded),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          children: [
            FutureBuilder(
                future: cart.getData(),
                builder: (context, AsyncSnapshot<List<CartModel>> snapshot) {

                  if (snapshot.hasData) {
                    if(snapshot.data!.isEmpty ){
                      return Column(
                        children:const [
                        Image(
                              width: 400,
                              height: 400,
                              image: AssetImage('assets/emptyCart.jpg')),
                          Center(child: Text('cart is empty',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),))
                        ],
                      );

                    }
                    else{
                      return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Image(
                                                height: 100,
                                                width: 100,
                                                image: NetworkImage(snapshot
                                                    .data![index].image
                                                    .toString())),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          snapshot
                                                              .data![index].productName
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                              FontWeight.w500),
                                                        ),
                                                        InkWell(
                                                            onTap: () {
                                                              dbHelper!.delete(snapshot
                                                                  .data![index].id!);
                                                              cart.removeCounter();
                                                              cart.removeTotalPrice(
                                                                  double.parse(
                                                                    snapshot.data![index]
                                                                        .productPrice
                                                                        .toString(),
                                                                  ));
                                                            },
                                                            child: Icon(Icons.delete))
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      snapshot.data![index].unitTag
                                                          .toString() +
                                                          " " +
                                                          r"$" +
                                                          snapshot
                                                              .data![index].productPrice
                                                              .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Container(
                                                        height: 35,
                                                        width: 100,
                                                        decoration: BoxDecoration(
                                                            color: Colors.green,
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                                5)),
                                                        child: Center(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(6.0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  InkWell
                                                                    (
                                                                      onTap: (){
                                                                        int quantity=snapshot.data![index].quantity!;
                                                                        int price=snapshot.data![index].initialPrice!;
                                                                        quantity--;
                                                                        int? newPrice=price*quantity;
                                                                        if(quantity>0){
                                                                          dbHelper!.updateQuantity(
                                                                              CartModel(id: snapshot.data![index].id!,
                                                                                productId: snapshot.data![index].id!.toString(),
                                                                                productName: snapshot.data![index].productName!,
                                                                                initialPrice: snapshot.data![index].initialPrice!,
                                                                                productPrice: newPrice,
                                                                                quantity: quantity,
                                                                                unitTag:snapshot.data![index].unitTag.toString() ,
                                                                                image: snapshot.data![index].image.toString(),
                                                                              )

                                                                          ).then((value){
                                                                            newPrice=0;
                                                                            quantity=0;
                                                                            cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));

                                                                          }).onError((error, stackTrace){

                                                                            print(error.toString());
                                                                          });

                                                                        }





                                                                      },
                                                                      child: Icon(Icons.remove,color: Colors.white,)

                                                                  ),
                                                                  Text(
                                                                    snapshot.data![index].quantity.toString(),
                                                                    style: TextStyle(
                                                                        color: Colors.white),
                                                                  ),
                                                                  InkWell(
                                                                      onTap: (){
                                                                        int quantity=snapshot.data![index].quantity!;
                                                                        int price=snapshot.data![index].initialPrice!;
                                                                        quantity++;
                                                                        int? newPrice=price*quantity;
                                                                        dbHelper!.updateQuantity(
                                                                            CartModel(id: snapshot.data![index].id!,
                                                                              productId: snapshot.data![index].id!.toString(),
                                                                              productName: snapshot.data![index].productName!,
                                                                              initialPrice: snapshot.data![index].initialPrice!,
                                                                              productPrice: newPrice,
                                                                              quantity: quantity,
                                                                              unitTag:snapshot.data![index].unitTag.toString() ,
                                                                              image: snapshot.data![index].image.toString(),
                                                                            )

                                                                        ).then((value){

                                                                          newPrice=0;
                                                                          quantity=0;
                                                                          cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));

                                                                        }).onError((error, stackTrace){

                                                                          print(error.toString());
                                                                        });



                                                                      },
                                                                      child: Icon(Icons.add,color: Colors.white,))
                                                                ],
                                                              ),
                                                            )),
                                                      ),
                                                    )
                                                  ],
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }));
                    }



                  }
                  return Text('');
                }),
            Consumer<CartProvider>(builder: (context, value, child) {
              return Visibility(
                visible: value.getTotalPrice().toStringAsFixed(2)=="0.00"? false : true,
                child: Column(
                  children: [
                    reUsable(
                        title: 'Sub Total',
                        value: r'$' + value.getTotalPrice().toStringAsFixed(2)),
                    reUsable(title: "Dicount "+r"$" ,value: '20'r'$',),
                    reUsable(title: 'Total Price', value: value.getTotalPrice().toString())

                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class reUsable extends StatelessWidget {
  final String value, title;

  reUsable({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.subtitle1),
          Text(
            value,
            style: Theme.of(context).textTheme.subtitle2,
          )
        ],
      ),
    );
  }
}

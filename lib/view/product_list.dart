import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart/Model/cart_model.dart';
import 'package:shopping_cart/Model/cart_provider.dart';
import 'package:shopping_cart/Model/db_helper.dart';
import 'package:shopping_cart/view/cart_screen.dart';


class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);


  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  DBHelper? dbHelper=DBHelper();
  List<String> productName = [
    'Mango',
    'Orange',
    'Grapes',
    'Banana',
    'Chery',
    'Peach',
    'Mixed Fruit Basket',
  ];
  List<String> productUnit = [
    'KG', 'Dozen', 'KG', 'Dozen', 'KG', 'KG', 'KG',
  ];
  List<int> productPrice = [10, 20, 30, 40, 50, 60, 70];
  List<String> productImage = [
    'https://image.shutterstock.com/image-photo/mango-isolated-on-white-background-600w-610892249.jpg',
    'https://image.shutterstock.com/image-photo/orange-fruit-slices-leaves-isolated-600w-1386912362.jpg',
    'https://image.shutterstock.com/image-photo/green-grape-leaves-isolated-on-600w-533487490.jpg',
    'https://media.istockphoto.com/photos/banana-picture-id1184345169?s=612x612',
    'https://media.istockphoto.com/photos/cherry-trio-with-stem-and-leaf-picture-id157428769?s=612x612',
    'https://media.istockphoto.com/photos/single-whole-peach-fruit-with-leaf-and-slice-isolated-on-white-picture-id1151868959?s=612x612',
    'https://media.istockphoto.com/photos/fruit-background-picture-id529664572?s=612x612',
  ];
  @override
  Widget build(BuildContext context) {
    final cart=Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('PRODUCT LIST'),
        actions: [


          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>cartScreen()));

            },
            child: Center(
              child: Badge(
                badgeContent:  Consumer<CartProvider>(
                  builder: (context , value ,child){
                    return Text(value.getCounter().toString(), style: TextStyle(fontSize: 16, color: Colors.white),
                    );
                  },
                ),
                child: const Icon(Icons.shopping_bag_rounded),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          )


        ],
      ),
      body: Column(
        children: [

          Expanded(
              child: ListView.builder(
                  itemCount: productImage.length,
                  itemBuilder: (context,index){
                
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Image(
                               height: 100,
                               width: 100,
                               image: NetworkImage(productImage[index].toString())),
                         ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(productName[index].toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(productUnit[index].toString()+" "+r"$"+productPrice[index].toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)

                                ,SizedBox(height: 5,),

                               Align(
                                 alignment: Alignment.centerRight,
                                 child:  InkWell(
                                   onTap:(){
                                     dbHelper!.insert(
                                       CartModel(
                                           id: index,
                                           productId: index.toString(),
                                           productName: productName[index].toString(),
                                           initialPrice: productPrice[index],
                                           productPrice: productPrice[index],
                                           quantity: 1,
                                           unitTag: productUnit[index].toString(),
                                           image: productImage[index].toString())
                                     ).then((value){
                                       print('value is added to cartt');
                                       cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                       cart.addCounter();
                                     }).onError((error, stackTrace) {

                                       print(error.toString());
                                     });

                    },
                                   child: Container(
                                     margin: EdgeInsets.only(right: 5),
                                     height: 35,
                                     width: 100,
                                     decoration: BoxDecoration(
                                         color: Colors.green,
                                         borderRadius: BorderRadius.circular(8)
                                     ),
                                     child: Center(
                                       child: Text('ADD TO CART',style: TextStyle(color: Colors.white)),
                                     ),
                                   ),
                                 ),
                               )

                              ],
                            ),
                          )
                          
                        ],
                      )
                    ],
                  ),
                );
                
                
              })
          
          )
          
          
        ],
      ),
    );
  }
}

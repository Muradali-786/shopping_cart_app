class CartModel{

  late final int? id;
  final String? productId;
  final String? productName;
  final int? initialPrice;
  final int? productPrice;
  final int? quantity;
  final String? unitTag;
  final String? image;
 CartModel({
    required this.id,
   required this.productId,
   required this.productName,
   required this.initialPrice,
   required this.productPrice,
   required this.quantity,
   required this.unitTag,
   required this.image,

 });
  CartModel.fromMap(Map<dynamic,dynamic> res):
        id=res['id'],
        productId=res['productId'],
        productName=res['productName'],
        productPrice=res['productPrice'],
        initialPrice=res['initialPrice'],
        quantity=res['quantity'],
        unitTag=res['unitTag'],
        image=res['image'];

  Map<String,Object?> toMap(){

    return {
      'id':id,
      'productId':productId,
      'productName':productName,
      'productPrice':productPrice,
      'initialPrice':initialPrice,
      'quantity':quantity,
      'unitTag':unitTag,
      'image':image,
    };

  }

}
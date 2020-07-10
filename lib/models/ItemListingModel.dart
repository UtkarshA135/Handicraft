class ItemListingModel {
  final double itemPrice;
  final String itemName;
  final String url;
  ItemListingModel(
   this.itemPrice,
   this.itemName,
    this.url
  );

  factory ItemListingModel.fromJson(dynamic json){
  return ItemListingModel(
    
    json['price'] +0.0,
    json['itemName'],
    json['url'],
  );
}
}

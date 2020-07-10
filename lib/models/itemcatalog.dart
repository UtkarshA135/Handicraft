class ItemCatalogModel {
  double itemPrice=0.0;
  bool isAdded=false;
  final String itemName;

  ItemCatalogModel(
  
   this.itemName,
    
  );

  factory ItemCatalogModel.fromJson(dynamic json){
  return ItemCatalogModel(
    
    json,
    
  );
}
}

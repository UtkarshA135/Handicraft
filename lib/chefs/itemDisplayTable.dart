import 'package:cottage_app/chefs/full_screen_image.dart';
import 'package:cottage_app/models/itemListingModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ItemsListTable extends StatelessWidget {
  List<ItemListingModel> itemListings;

  ItemsListTable({this.itemListings});
  
  List<DataRow> itemsRows=new List();

  Widget build(BuildContext context) {
    for (var itemobj in itemListings) {
      itemsRows.add(DataRow(cells: [
    DataCell(CircleAvatar  ( child: InkWell(
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => FullScreenImage(photoUrl: itemobj.url)));
                            }),),
        backgroundImage :itemobj.url!=null?
        NetworkImage(itemobj.url):AssetImage("assets/jute.jpg"),
        radius: 20,
        )),
        DataCell(Text('${itemobj.itemName}',style: TextStyle(color:Colors.grey[700],fontSize: 15),)),
      DataCell(Text('${itemobj.itemPrice}',style: TextStyle(color:Colors.grey[700],fontSize: 15),)),],));
      
    }
  print (itemListings.length);
    return (itemListings == null)
        ? CupertinoActivityIndicator()
        : SingleChildScrollView(
         
            child: DataTable(
            
              
          columns: kTableColumns,
             
             rows: itemsRows,
             // rows: ItemTableDataSource(source: itemListings),
            ),
          );
  }
}

////// Columns in table.
const kTableColumns = <DataColumn>[DataColumn(
    label: const Text('Pic',style: TextStyle(fontSize: 16),),
),

  DataColumn(
    label: const Text('Item',style: TextStyle(fontSize: 16),),
    
  ),
  DataColumn(
    label: const Text('Price',style: TextStyle(fontSize: 16),),
    tooltip: 'Price',
    numeric: true,
  ),
  
];

////// Data source class for obtaining row data for PaginatedDataTable.
class ItemTableDataSource extends DataTableSource {
  int _selectedCount = 0;

 

  ItemTableDataSource({
    this.source,
  });
  List<ItemListingModel> source;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= source.length) return null;
    final ItemListingModel itemElement = source[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
        DataCell(CircleAvatar  ( 
        backgroundImage :itemElement.url!=null?
        NetworkImage(itemElement.url):AssetImage("assets/jute.jpg"),
        radius: 20,
        )),
      DataCell(Text('${itemElement.itemName}',style: TextStyle(color:Colors.grey[700],fontSize: 15),)),
      DataCell(Text("\u20B9 ${itemElement.itemPrice}",style: TextStyle(color:Colors.grey[700],fontSize: 15),)),
     
  
    ]);
  }

  @override
  int get rowCount => source.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

import 'package:cottage_app/chefs/full_screen_image.dart';
import 'package:cottage_app/models/itemListingModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as painting;

class OrderItemsTable extends StatefulWidget {
  List<dynamic> itemListings;
  OrderItemsTable({Key key, this.itemListings}) : super(key: key);

  @override
  _OrderItemsTableState createState() =>
      _OrderItemsTableState(itemListings: itemListings);
}

class _OrderItemsTableState extends State<OrderItemsTable> {
  List<dynamic> itemListings;

  _OrderItemsTableState({this.itemListings});
  

  List<DataRow> itemsRows=new List();

  _buildRows(){
    for (var itemobj in itemListings) {
      var totalcost=itemobj['quantity'] * itemobj['itemPrice']??0;
      itemsRows.add(DataRow(cells: [
         DataCell(CircleAvatar  ( child: InkWell(
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => FullScreenImage(photoUrl: itemobj['url'])));
                            }),),
        backgroundImage :  itemobj['url']!=null?
        NetworkImage( itemobj['url']):AssetImage("assets/jute.jpg"),
        radius: 20,
        )),
        DataCell(Text('${itemobj['itemName']}',style: painting.TextStyle(color:Colors.grey[700],fontSize: 15),)),
      DataCell(Text('${itemobj['quantity']??1}',style: painting.TextStyle(color:Colors.grey[700],fontSize: 15),)),
      DataCell(Text("${totalcost}",style: painting.TextStyle(color:Colors.grey[700],fontSize: 15),)),
      ],));
      
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _buildRows();
  }
  @override
  Widget build(BuildContext context) {
  print (itemListings.length);
    return (itemListings == null)
        ? CircularProgressIndicator()
        : SingleChildScrollView(
          scrollDirection: Axis.horizontal,
            child: DataTable(
            
              
          columns: kTableColumns,
             
             rows: itemsRows,
             // rows: ItemTableDataSource(source: itemListings),
            ),
          );
  }
}

class NetWorkImage {
}

////// Columns in table.
const kTableColumns = <DataColumn>[
    DataColumn(
    label: const Text('Pic',style: painting.TextStyle(fontSize: 16),),
    
  ),
  DataColumn(
    label: const Text('Item Name',style: painting.TextStyle(fontSize: 16),),
    
  ),
  DataColumn(
    label: const Text('Qty',style: painting.TextStyle(fontSize: 16),),
    tooltip: 'Quantity',
    numeric: true,
  ),
  
  DataColumn(
    label: const Text('Price (\u20B9)',style: painting.TextStyle(fontSize: 16),),
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

  BuildContext get context => null;

  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= source.length) return null;
    final ItemListingModel itemElement = source[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
        DataCell(CircleAvatar  ( child: InkWell(
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => FullScreenImage(photoUrl: itemElement.url)));
                            }),),
        backgroundImage :itemElement.url!=null?
        NetworkImage(itemElement.url):AssetImage("assets/jute.jpg"),
        radius: 20,
        )),
      DataCell(Text('${itemElement.itemName}',style: painting.TextStyle(color:Colors.grey[700],fontSize: 15),)),
      DataCell(Text("\u20B9 ${itemElement.itemPrice}",style: painting.TextStyle(color:Colors.grey[700],fontSize: 15),)),
     
  
    ]);
  }

  @override
  int get rowCount => source.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}

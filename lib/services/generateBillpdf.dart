import 'package:cottage_app/models/orderData.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter_share/flutter_share.dart';

reportView(
    context, OrderData orderData, bool isSeller, double billamount) async {
  final pw.Document pdf = pw.Document();
  final font1 = await rootBundle.load('fonts/Pacifico-Regular.ttf');
  PdfImage _kiranasevalogo = PdfImage.file(
    pdf.document,
    bytes:
        (await rootBundle.load('assets/foodie.jpg')).buffer.asUint8List(),
  );
  final PdfColor baseColor = PdfColors.red800;
  final PdfColor accentColor = PdfColors.blueGrey900;
  List<List<String>> billtableitems = new List();
  billtableitems.add(<String>['Item Name', 'Quantity', 'Total Price']);
  var totalcost;
  orderData.items.forEach((item) => {
        totalcost = item['quantity'] * item['itemPrice'],
        billtableitems.add(<String>[
          item['itemName'].toString(),
          item['quantity'].toString(),
          'Rs.$totalcost'
        ])
      });

  pw.PageTheme _buildTheme(PdfPageFormat pageFormat, pw.Font base) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final format = DateFormat.Hm('en_US').add_MMMMd();
    return format.format(date);
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Header(
        level: 0,
        child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: <pw.Widget>[
              pw.Text('Local Kitchens | Invoice', textScaleFactor: 2),
              pw.Image(_kiranasevalogo, height: 50),
            ]));
  }

  pdf.addPage(pw.MultiPage(
      pageTheme: _buildTheme(
        PdfPageFormat.a4,
        font1 != null ? pw.Font.ttf(font1) : null,
      ),
      /* pageFormat:
          PdfPageFormat.a4.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),*/
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        return _buildHeader(context);
      },
      footer: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (pw.Context context) => <pw.Widget>[
            pw.Text(
                'This is an automatically generated invoice for your order at ${orderData.storeName} placed at ${_formatDate(orderData.timeoforder.toDate())}',
                textAlign: pw.TextAlign.center),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Header(
                level: 2,
                text: (isSeller) ? 'Buyer Details : ' : 'Seller Details :'),
            pw.Paragraph(
                text: (isSeller)
                    ? 'Name : ${orderData.buyerName}'
                    : 'Name : ${orderData.sellerName}'),
            pw.Paragraph(
                text: (isSeller)
                    ? 'Phone : ${orderData.buyerContact}'
                    : 'Phone : ${orderData.sellerContact}'),
            pw.Header(level: 2, text: 'Items : '),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Table.fromTextArray(context: context, data: billtableitems),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Header(level: 3, text: 'Bill Amount : Rs.$billamount'),
            
            (!isSeller)?pw.Header(
                level: 3,
                text:
                    'Transaction Status : ${orderData.isDelivered ? 'Successful' : 'Pending'}'):pw.Text(''),
            (!isSeller)?pw.Text('as of ${_formatDate(DateTime.now())}',
                textAlign: pw.TextAlign.right):pw.Text(''),
            pw.Padding(padding: const pw.EdgeInsets.all(10)),
            pw.Header(level: 1, text: '')
          ]));

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/report.pdf';
  final File file = File(path);
  await file.writeAsBytes(pdf.save());
  material.Navigator.of(context).push(
    material.MaterialPageRoute(
      builder: (_) => PDFViewerScaffold(
          appBar: material.AppBar(
            title: material.Text(
              'Digital Invoice',
              style: material.TextStyle(fontFamily: 'Archia'),
            ),
            centerTitle: true,
            backgroundColor: material.Colors.red[800],
            actions: <material.Widget>[
              material.IconButton(icon: material.Icon(material.Icons.share),
              onPressed: ()=>
            FlutterShare.shareFile(
      title: 'Local Kitchens Invoice',
      chooserTitle: 'Local Kitchens Invoice',
      text: 'E-bill for order on Local Kitchens',
      filePath: path,
    ),)],
          ),
          path: path),
    ),
  );
}
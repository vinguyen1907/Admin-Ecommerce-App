import 'dart:io';

import 'package:admin_ecommerce_app/extensions/date_time_extension.dart';
import 'package:admin_ecommerce_app/extensions/double_extension.dart';
import 'package:admin_ecommerce_app/models/order.dart';
import 'package:admin_ecommerce_app/models/order_product_detail.dart';
import 'package:admin_ecommerce_app/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:universal_html/html.dart' as html;

class PdfUtils {
  static Future<void> openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future<void> saveDocumentOnWeb(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();

    // Create a blob from the bytes
    final blob = html.Blob([bytes], 'application/pdf');

    // Create a URL from the Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create an anchor element and use it to download the PDF
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = name;
    html.document.body!.children.add(anchor);

    // Trigger the download
    anchor.click();

    // Cleanup: remove the anchor element from the DOM
    html.document.body!.children.remove(anchor);

    // Cleanup: revoke the object URL to free memory
    html.Url.revokeObjectUrl(url);
  }

  Future<void> generateInvoice(
      {required OrderModel order,
      required List<OrderProductDetail> orderItems}) async {
    var myTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load('assets/fonts/Poppins-Regular.ttf')),
      bold: Font.ttf(await rootBundle.load('assets/fonts/Poppins-Medium.ttf')),
      italic:
          Font.ttf(await rootBundle.load('assets/fonts/Poppins-SemiBold.ttf')),
      // boldItalic:
      //     Font.ttf(await rootBundle.load('assets/fonts/Poppins-Bold.ttf')),
    );
    var pdf = Document(
      theme: myTheme,
    );

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(order),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        buildTitle(order),
        buildInvoice(orderItems),
        Divider(),
        buildTotal(order),
      ],
      footer: (context) => buildFooter(order),
    ));

    if (kIsWeb) {
      await saveDocumentOnWeb(name: 'invoice-${order.id}.pdf', pdf: pdf);
    } else {
      final pdfFile =
          await saveDocument(name: 'invoice-${order.id}.pdf', pdf: pdf);
      PdfUtils.openFile(pdfFile);
    }
  }

  static Widget buildHeader(OrderModel order) {
    final String customerAddress = Utils().getFullAddress(
        street: order.address.street,
        state: order.address.state,
        city: order.address.city,
        country: order.address.country);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 1 * PdfPageFormat.cm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // buildSupplierAddress(invoice.supplier),
            buildCustomerAddress(
                customerName: order.customerName,
                customerAddress: customerAddress),

            Container(
              height: 50,
              width: 50,
              child: BarcodeWidget(
                barcode: Barcode.qrCode(),
                data: order.id,
              ),
            ),
          ],
        ),
        SizedBox(height: 1 * PdfPageFormat.cm),
        buildInvoiceInfo(order),

        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.end,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     // buildCustomerAddress(invoice.customer),
        //     buildInvoiceInfo(order),
        //   ],
        // ),
      ],
    );
  }

  static Widget buildCustomerAddress(
          {required String customerName, required String customerAddress}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customerName, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customerAddress),
        ],
      );

  static Widget buildInvoiceInfo(OrderModel order) {
    final titles = <String>[
      'Order Number:',
      'Order date:',
      'Date of invoice:',
    ];
    final data = <String>[
      order.id,
      order.createdAt.toDate().toDateTimeFormat(),
      DateTime.now().toDateTimeFormat(),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(
          title: title,
          value: value,
          width: 400,
        );
      }),
    );
  }

  // static Widget buildSupplierAddress(Supplier supplier) => Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
  //         SizedBox(height: 1 * PdfPageFormat.mm),
  //         Text(supplier.address),
  //       ],
  //     );

  static Widget buildTitle(OrderModel invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          // Text(invoice.info.description),
          // SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(List<OrderProductDetail> orderItems) {
    final headers = ['#', 'Name', 'Unit Price', 'Quantity', 'Total'];
    final List<List<String>> data = [];
    for (int i = 0; i < orderItems.length; i++) {
      final item = orderItems[i];
      data.add([
        '${i + 1}',
        item.productName,
        item.productPrice.toPriceString(),
        '${item.quantity}',
        item.totalPrice.toPriceString(),
      ]);
    }

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(OrderModel order) {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Amount',
                  value: order.orderSummary.amount.toPriceString(),
                  unite: true,
                ),
                buildText(
                  title: 'Shipping',
                  value: order.orderSummary.shipping.toPriceString(),
                  unite: true,
                ),
                buildText(
                  title: 'Promotion',
                  value: order.orderSummary.promotionDiscount.toPriceString(),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: order.orderSummary.total.toPriceString(),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(OrderModel invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(title: 'FASHION SHOP', value: ""),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Address',
              value: "Beaverton, One Bowerman Drive, United States"),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return SizedBox(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: style),
            Text(value, style: unite ? style : null),
          ],
        ));
  }
}

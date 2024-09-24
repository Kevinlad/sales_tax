class SalesBill {
  final String invoiceNo;
  final String firmName;
  final String customerName;
  final String billingName;
  final String phoneNumber;
  final String date;
  final List<SaleItem>? items; // Optional items list
  final double totalAmount;

  SalesBill({
    required this.invoiceNo,
    required this.firmName,
    required this.customerName,
    this.billingName = '',
    required this.phoneNumber,
    required this.date,
    this.items, // Optional
    required this.totalAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'invoiceNo': invoiceNo,
      'firmName': firmName,
      'customerName': customerName,
      'billingName': billingName,
      'phoneNumber': phoneNumber,
      'date': date,
      'items': items?.map((item) => item.toJson()).toList(), // Handle null
      'totalAmount': totalAmount,
    };
  }

  factory SalesBill.fromJson(Map<String, dynamic> json) {
    return SalesBill(
      invoiceNo: json['invoiceNo'],
      firmName: json['firmName'],
      customerName: json['customerName'],
      billingName: json['billingName'] ?? '',
      phoneNumber: json['phoneNumber'],
      date: json['date'],
      items: json['items'] != null
          ? (json['items'] as List<dynamic>)
              .map((item) => SaleItem.fromJson(item))
              .toList()
          : [], // Handle null items
      totalAmount: json['totalAmount'],
    );
  }
}

class SaleItem {
  final String itemName;
  final int quantity;
  final double price;
  final double tax;
  final double discount;

  SaleItem({
    required this.itemName,
    required this.quantity,
    required this.price,
    required this.tax,
    required this.discount,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'quantity': quantity,
      'price': price,
      'tax': tax,
      'discount': discount
    };
  }

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
        itemName: json['itemName'],
        quantity: json['quantity'],
        price: json['price'],
        tax: json['tax'],
        discount: json['discount']);
  }
}

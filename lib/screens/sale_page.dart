import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xianinfotech_task/screens/add_items.dart';
import 'package:xianinfotech_task/widgets/charge.dart';
import 'package:xianinfotech_task/screens/home_screen.dart';
import 'package:xianinfotech_task/controller/sale_controlller.dart';

import '../model/sales_model.dart';

class SalePage extends StatefulWidget {
  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final SaleController saleController = Get.put(SaleController());
  int selectedNumber = 1;
  late String invoiceNo;
  final customer = TextEditingController();
  final billingname = TextEditingController();

  final phone = TextEditingController();
  bool isCredit = true;
  int selectedInvoiceNumber = 1;
  String firmName = "xianinfotech LLP"; // Ex
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    invoiceNo = '23-24-01-$selectedInvoiceNumber';
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    print(invoiceNo);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sale'),
        leading: const Icon(Icons.arrow_back),
        actions: [
          // const Icon(Icons.settings),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        // Toggle buttons for Credit and Cash
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ToggleButtons(
                              borderRadius: BorderRadius.circular(8),
                              selectedColor: Colors.white,
                              fillColor: Colors.green,
                              isSelected: [isCredit, !isCredit],
                              onPressed: (int index) {
                                setState(() {
                                  isCredit = index ==
                                      0; // true for Credit, false for Cash
                                });
                              },
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    'Credit',
                                    style: TextStyle(
                                      color: isCredit
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    'Cash',
                                    style: TextStyle(
                                      color: !isCredit
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () {
                                // Handle settings button
                              },
                            ),
                          ],
                        ),
                        const Divider(),
                        // Invoice Number and Date section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text('Invoice No. '),
                                  Text('23-24-01-'),
                                  DropdownButton<int>(
                                    value: selectedInvoiceNumber,
                                    items:
                                        List.generate(30, (index) => index + 1)
                                            .map<DropdownMenuItem<int>>(
                                                (int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text(value.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (int? newValue) {
                                      if (newValue != null) {
                                        setState(() {
                                          selectedInvoiceNumber = newValue;
                                          invoiceNo =
                                              '23-24-01-$selectedInvoiceNumber';
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Date'),
                                  Text(currentDate),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        // Firm Name Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text('Firm Name: '),
                                  Text(
                                    firmName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight
                                            .bold), // Optional styling for firm name
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: customer,
                      decoration: const InputDecoration(
                        labelText: 'Customer *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: billingname,
                      decoration: const InputDecoration(
                        labelText: 'Billing Name (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildSaleItemList(),
                    GestureDetector(
                      onTap: () async {
                        final newItem = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddItemsToSalePage()),
                        );

                        if (newItem != null) {
                          saleController
                              .addItem(newItem); // Add the new item to the list
                        }
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.add_circle_outline, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Add Items (Optional)',
                              style: TextStyle(color: Colors.blue)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Amount'),
                        Text('-------------------'),
                      ],
                    ),
                    // const Spacer(),
                    Obx(() {
                      if (saleController.saleItems.isNotEmpty) {
                        return Column(
                          children: [
                            ChargeWidget(
                              totalAmount: calculateTotalAmount(),
                            ), // This is your charge widget
                            const Divider(),
                          ],
                        );
                      } else {
                        return const SizedBox
                            .shrink(); // Return an empty widget when no items are present
                      }
                    }),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Your current plan may not support some features.',
              style: TextStyle(color: Colors.red),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Handle Save & New
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Background color
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey), // Border color
                      ),
                      child: const Center(
                        child: Text(
                          'Save & New',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      final salesBill = SalesBill(
                        invoiceNo: invoiceNo,
                        firmName: 'xianinfotech LLP',
                        customerName: customer.text,
                        billingName: billingname.text,
                        phoneNumber: phone.text,
                        date: currentDate,
                        items: saleController.saleItems,
                        totalAmount: 12, // Replace with actual total
                      );
                      saleController.addSalesBill(salesBill);
                      Get.to(() => HomeScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      decoration: BoxDecoration(
                        color: Colors.red, // Background color
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: const Center(
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.blue),
                  onPressed: () {
                    // Handle Share
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calculateTotalAmount() {
    return saleController.saleItems.fold(0, (total, item) {
      return total + (item.quantity * item.price);
    });
  }

  Widget buildSaleItemList() {
    return Obx(() {
      return saleController.saleItems.isEmpty
          ? const Center(child: Text(''))
          : ListView.builder(
              shrinkWrap: true,
              itemCount: saleController.saleItems.length,
              itemBuilder: (context, index) {
                final item = saleController.saleItems[index];
                return buildSaleItemCard(item);
              },
            );
    });
  }

  Widget buildSaleItemCard(SaleItem item) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.itemName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  item.price.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.quantity} x ${item.price} = ${item.quantity * item.price}',
                  style: const TextStyle(color: Colors.grey),
                ),
                Text(
                  'Discount: ${item.discount}%',
                  style: const TextStyle(color: Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Tax: ${item.tax}%'),
          ],
        ),
      ),
    );
  }
}

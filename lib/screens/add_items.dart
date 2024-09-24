import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/sale_controlller.dart';
import '../model/sales_model.dart';

class AddItemsToSalePage extends StatefulWidget {
  @override
  _AddItemsToSalePageState createState() => _AddItemsToSalePageState();
}

class _AddItemsToSalePageState extends State<AddItemsToSalePage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  // final TextEditingController _taxController = TextEditingController();
  final TextEditingController _additionalCESSController =
      TextEditingController();

  bool _showTotalsAndTaxes = false;

  double _subtotal = 0.0;
  double _discount = 0.0;
  double _tax = 0.0;
  double _additionalCESS = 0.0;
  double _totalAmount = 0.0;

  // Example list of saved items
  final List<String> _items = [
    '.com domain name',
    '.com domain registration',
    '.com domain renewal',
    '.in domain renewal fee',
    '.org domain renewal',
    '.sa.com',
    'Adding columns to database, change in ad...',
    'Additional charges',
    'Additional features',
    'Admission management balance',
  ];

  final GlobalKey _key = GlobalKey();
  final SaleController salesController = Get.put(SaleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Items to Sale'),
        leading: const Icon(Icons.arrow_back),
        actions: [
          const Icon(Icons.settings),
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
                    // Item Name Input with onTap to open the popup menu near the field
                    TextFormField(
                      key: _key,
                      controller: _itemController,
                      decoration: const InputDecoration(
                        labelText: 'Item Name',
                        hintText: 'Select an item',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      onTap: () {
                        _showPopupMenu();
                      },
                    ),
                    const SizedBox(height: 16),

                    // Quantity, Unit, Rate, and Tax Row
                    Row(
                      children: [
                        // Quantity Input
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _quantityController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _calculateSubtotal();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Unit Dropdown
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Unit',
                              border: OutlineInputBorder(),
                            ),
                            items: <String>['Unit1', 'Unit2', 'Unit3']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (_) {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        // Rate Input
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _rateController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Rate (Price/Unit)',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              _calculateSubtotal();
                            },
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Tax Dropdown
                        Expanded(
                          flex: 1,
                          child: DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Tax',
                              border: OutlineInputBorder(),
                            ),
                            items: <String>['None', '5%', '10%', '18%']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                if (value != 'None') {
                                  _tax =
                                      double.parse(value!.replaceAll('%', ''));
                                } else {
                                  _tax = 0.0;
                                }
                                _calculateTotalAmount();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showTotalsAndTaxes) _buildTotalsAndTaxesSection(),
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
                      _saveItem();
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
          )
        ],
      ),
    );
  }

  // Function to show popup menu near the TextFormField
  void _showPopupMenu() async {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    String? selectedItem = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height,
        offset.dx + renderBox.size.width,
        offset.dy,
      ),
      items: _items.map((String item) {
        return PopupMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );

    if (selectedItem != null) {
      setState(() {
        _itemController.text = selectedItem;

        // Set the rate to 650 for each selected item
        _rateController.text = '650';

        _showTotalsAndTaxes =
            true; // Show totals and taxes section when item selected

        _calculateSubtotal(); // Recalculate subtotal when item is selected
      });
    }
  }

  void _saveItem() {
    SaleItem newItem = SaleItem(
      itemName: _itemController.text,
      quantity: (double.tryParse(_quantityController.text) ?? 0.0).toInt(),
      price: double.tryParse(_rateController.text) ?? 0.0,
      discount: _discount,
      tax: _tax,
    );
    Navigator.pop(context, newItem);
    // salesController.addItem(newItem);
  }

// Calculate the subtotal (rate x quantity)
  void _calculateSubtotal() {
    double quantity = double.tryParse(_quantityController.text) ?? 0.0;
    double rate = double.tryParse(_rateController.text) ?? 0.0;
    setState(() {
      _subtotal = quantity * rate;
      _calculateTotalAmount(); // Automatically update total
    });
  }

// Calculate the total amount based on subtotal, discount, tax, and additional CESS
  void _calculateTotalAmount() {
    double discountAmount = (_subtotal * _discount) / 100;
    double taxAmount = (_subtotal - discountAmount) * _tax / 100;
    setState(() {
      _totalAmount = _subtotal - discountAmount + taxAmount + _additionalCESS;
    });
  }

  // Build "Totals & Taxes" Section UI
  Widget _buildTotalsAndTaxesSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Totals & Taxes',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),

          // Subtotal display
          _buildRow('Subtotal (Rate x Qty)', _subtotal.toStringAsFixed(2)),
          const SizedBox(
            height: 5,
          ),
          // Discount Input
          Row(
            children: [
              Expanded(
                  child:
                      _buildNumberInputField('Discount', _discountController)),
              const SizedBox(width: 10),

              // Tax Display
              _buildRow('Tax %', '$_tax%'),
            ],
          ),
          const SizedBox(height: 10),

          // Additional CESS Input
          _buildNumberInputField('Additional CESS', _additionalCESSController),

          // Total Amount display
          const SizedBox(height: 20),
          _buildRow(
              'Total Amount',
              _totalAmount
                  .toStringAsFixed(2)), // This will update when total changes
        ],
      ),
    );
  }

  // Helper function to build a row of key-value pairs
  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Helper function to build a number input field
  Widget _buildNumberInputField(
      String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          if (controller == _discountController) {
            _discount = double.tryParse(value) ?? 0.0;
          } else if (controller == _additionalCESSController) {
            _additionalCESS = double.tryParse(value) ?? 0.0;
          }
          _calculateTotalAmount();
        });
      },
    );
  }
}

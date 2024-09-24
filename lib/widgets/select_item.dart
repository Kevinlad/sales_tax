import 'package:flutter/material.dart';

class SelectableItemsPage extends StatefulWidget {
  @override
  _SelectableItemsPageState createState() => _SelectableItemsPageState();
}

class _SelectableItemsPageState extends State<SelectableItemsPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();
  final TextEditingController _additionalCESSController = TextEditingController();

  bool _showTotalsAndTaxes = false;

  double _subtotal = 690.00; // Example subtotal
  double _discount = 0.0;
  double _tax = 0.0;
  double _additionalCESS = 0.0;
  double _totalAmount = 690.00;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Name Input with onTap to open the popup menu near the field
            TextFormField(
              key: _key,
              controller: _itemController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                hintText: 'Select an item',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () {
                _showPopupMenu();
              },
            ),
            SizedBox(height: 20),
            
            // Display "Totals & Taxes" only if an item is selected
            if (_showTotalsAndTaxes) _buildTotalsAndTaxesSection(),
          ],
        ),
      ),
    );
  }

  // Function to show popup menu near the TextFormField
  void _showPopupMenu() async {
    final RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
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
        _showTotalsAndTaxes = true; // Show totals and taxes section
      });
    }
  }

  // Build "Totals & Taxes" Section UI
  Widget _buildTotalsAndTaxesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Totals & Taxes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),

        // Subtotal display
        _buildRow('Subtotal (Rate x Qty)', _subtotal.toStringAsFixed(2)),

        // Discount input
        Row(
          children: [
            Expanded(child: _buildNumberInputField('Discount', _discountController)),
            SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Tax %',
                  border: OutlineInputBorder(),
                ),
                items: <String>['None', '5%', '10%', '18%'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    if (value != 'None') {
                      _tax = double.parse(value!.replaceAll('%', ''));
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
        SizedBox(height: 10),

        // Additional CESS input
        _buildNumberInputField('Additional CESS', _additionalCESSController),

        // Total Amount display
        SizedBox(height: 20),
        _buildRow('Total Amount', _totalAmount.toStringAsFixed(2)),
      ],
    );
  }

  // Helper function to build a row of key-value pairs
  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Helper function to build a number input field
  Widget _buildNumberInputField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
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

  // Calculate the total amount based on subtotal, discount, tax, and additional CESS
  void _calculateTotalAmount() {
    double discountAmount = (_subtotal * _discount) / 100;
    double taxAmount = (_subtotal - discountAmount) * (_tax / 100);
    _totalAmount = (_subtotal - discountAmount) + taxAmount + _additionalCESS;
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // If you're using GetX

class ChargeWidget extends StatefulWidget {
  final double totalAmount;
  const ChargeWidget({Key? key, required this.totalAmount}) : super(key: key);

  @override
  _ChargeWidgetState createState() => _ChargeWidgetState();
}

class _ChargeWidgetState extends State<ChargeWidget> {
  final TextEditingController _shippingController = TextEditingController();
  bool _isReceived = false; // Whether the payment is received
  double totalAmount = 0.0;
  late double balanceDue;
  String? _selectedPaymentType = 'Cash';
  String? _selectedState; // State of Supply
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    balanceDue = widget.totalAmount;
  }

  @override
  Widget build(BuildContext context) {
  

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Charges',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _shippingController,
                  decoration: const InputDecoration(
                    labelText: 'Shipping',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Total Amount Section
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      widget.totalAmount.toStringAsFixed(2),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Received Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _isReceived,
                      onChanged: (value) {
                        setState(() {
                          _isReceived = value!;
                          balanceDue = _isReceived ? 0 : widget.totalAmount;
                        });
                      },
                    ),
                    const Text('Received'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Balance Due Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Balance Due',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                balanceDue.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Payment Type Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                value: _selectedPaymentType,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentType = newValue;
                  });
                },
                items: <String>['Cash', 'Card', 'UPI', 'Net Banking']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        const Icon(Icons.attach_money),
                        const SizedBox(width: 5),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 10),

          GestureDetector(
            onTap: () {
              // Add payment type logic
            },
            child: const Text(
              '+ Add Payment Type',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          const SizedBox(height: 20),

          // State of Supply Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'State of Supply',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                hint: const Text('Select State'),
                value: _selectedState,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedState = newValue;
                  });
                },
                items: <String>[
                  'Maharashtra',
                  'Gujarat',
                  'Karnataka',
                  'Tamil Nadu'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Transportation Details Section
          TextButton(
            onPressed: () {
              // Handle transportation details navigation or display
            },
            child: const Text(
              'Transportation Details',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),

          // Description Input Section
          const Text(
            'Description',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Add Note',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 20),

          // Add more fields as necessary...

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String companyName;
  final String transactionId;
  final String date;
  final String total;
  final String balance;

  TransactionCard({
    required this.companyName,
    required this.transactionId,
    required this.date,
    required this.total,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  companyName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '#$transactionId',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Chip(
                  padding: EdgeInsets.all(-2),
                  label: Text(
                    'SALE',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  // labelPadding:
                  //     EdgeInsets.symmetric(horizontal: 4.0, vertical: -4.0),
                ),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // const Chip(
                    //   label: Text(
                    //     'SALE',
                    //     style: TextStyle(color: Colors.white),
                    //   ),
                    //   backgroundColor: Colors.green,
                    //   // labelPadding:
                    //   //     EdgeInsets.symmetric(horizontal: 4.0, vertical: -4.0),
                    // ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          total,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Balance',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          balance,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.print),
                      color: Colors.grey,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                      color: Colors.grey,
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

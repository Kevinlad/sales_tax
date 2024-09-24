import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:xianinfotech_task/screens/add_items.dart';
import 'package:xianinfotech_task/screens/sale_page.dart';
import 'package:xianinfotech_task/widgets/transcation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white30,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.person),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "xianinfotec LLP",
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Icon(Icons.notifications),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.settings)
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Transaction Details Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[100], // White background
                          side: const BorderSide(
                              color: Colors.red, width: 2), // Red outline
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Transaction Details",
                          style: TextStyle(
                            color: Colors.red, // Red text color
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Party Details Button
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Colors.grey, width: 2), // Grey outline
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 12),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Party Details",
                          style: TextStyle(
                            color: Colors.grey, // Grey text color
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Quick Links",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),

                // Quick Links Row
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Add Txn
                      _buildQuickLinkItem(
                        icon: Icons.receipt,
                        label: "Add Txn",
                        iconBgColor: Colors.red[100],
                        iconColor: Colors.red,
                      ),
                      // Sale Report
                      _buildQuickLinkItem(
                        icon: FontAwesomeIcons.fileInvoiceDollar,
                        label: "Sale Report",
                        iconBgColor: Colors.blue[100],
                        iconColor: Colors.black,
                      ),
                      // Txn Settings
                      _buildQuickLinkItem(
                        icon: Icons.settings,
                        label: "Txn Settings",
                        iconBgColor: Colors.blue[100],
                        iconColor: Colors.black,
                      ),
                      // Show All
                      _buildQuickLinkItem(
                        icon: Icons.arrow_forward,
                        label: "Show All",
                        iconBgColor: Colors.blue[100],
                        iconColor: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search for a transaction',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: const Icon(Icons.filter_list),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('sales').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final transactions = snapshot.data!.docs;
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      var transactionData =
                          transactions[index].data() as Map<String, dynamic>;
                      return TransactionCard(
                        companyName: transactionData['customerName'],
                        transactionId: transactionData['invoiceNo'],
                        date: transactionData['date'],
                        total: "12000",
                        balance: "12000",
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Logic to add a new sale
          Get.to(() => SalePage());
        },
        backgroundColor: Colors.red,
        icon: const Icon(Icons.add),
        label: const Text("Add New Sale"),
      ),
    );
  }

  Widget _buildQuickLinkItem({
    required IconData icon,
    required String label,
    required Color? iconBgColor,
    required Color? iconColor,
  }) {
    return Column(
      children: [
        // Icon with background
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        // Label
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

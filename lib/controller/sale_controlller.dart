import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:xianinfotech_task/model/sales_model.dart';

// class SaleController extends GetxController {
//   var saleItems = <SaleItem>[].obs;

//   void addItem(SaleItem item) {
//     saleItems.add(item);
//   }

//   void clearItems() {
//     saleItems.clear();
//   }
//    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Function to store sales bill in Firestore
//   Future<void> addSalesBill(SalesBill salesBill) async {
//     try {
//       await _firestore.collection('sales').add(salesBill.toJson());
//       Get.snackbar('Success', 'Sales bill added successfully');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to add sales bill: $e');
//     }
//   }
//    RxList<SalesBill> salesBills = <SalesBill>[].obs; // List of already created sales bills
//   RxInt selectedInvoiceNumber = 1.obs; // The selected invoice number
//   RxList<int> availableInvoiceNumbers = <int>[].obs; // List of available invoice numbers

//   @override
//   void onInit() {
//     super.onInit();
//     updateAvailableInvoiceNumbers();
//   }

//   // Method to add a sales bill
//   // void addSalesBill(SalesBill salesBill) {
//   //   salesBills.add(salesBill);
//   //   updateAvailableInvoiceNumbers(); // Update the available numbers when a new sale is added
//   // }

//   // Method to update the available invoice numbers based on already created invoices
//   void updateAvailableInvoiceNumbers() {
//     final List<int> usedInvoiceNumbers = salesBills
//         .map((bill) => int.parse(bill.invoiceNo.split('-').last))
//         .toList();

//     availableInvoiceNumbers.value = List.generate(100, (index) => index + 1) // Assuming a max of 100 invoices
//         .where((invoiceNum) => !usedInvoiceNumbers.contains(invoiceNum))
//         .toList();

//     // Automatically select the first available invoice number
//     if (availableInvoiceNumbers.isNotEmpty) {
//       selectedInvoiceNumber.value = availableInvoiceNumbers.first;
//     }
//   }

//   // Method to set selected invoice number when user picks from dropdown
//   void setSelectedInvoiceNumber(int number) {
//     selectedInvoiceNumber.value = number;
//   }
// }
class SaleController extends GetxController {
  // List of sale items
  var saleItems = <SaleItem>[].obs;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List of sales bills
  RxList<SalesBill> salesBills = <SalesBill>[].obs; // List of created sales bills

  // Selected and available invoice numbers
  RxInt selectedInvoiceNumber = 1.obs;
  RxList<int> availableInvoiceNumbers = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    updateAvailableInvoiceNumbers(); // Initialize available invoice numbers
  }

  // Add item to sale
  void addItem(SaleItem item) {
    saleItems.add(item);
  }

  // Clear sale items
  void clearItems() {
    saleItems.clear();
  }

  // Add sales bill to Firestore
  Future<void> addSalesBill(SalesBill salesBill) async {
    try {
      await _firestore.collection('sales').add(salesBill.toJson());
      Get.snackbar('Success', 'Sales bill added successfully');

      // After successful addition, add bill to local list and update available numbers
      salesBills.add(salesBill);
      updateAvailableInvoiceNumbers(); // Refresh available invoice numbers

    } catch (e) {
      Get.snackbar('Error', 'Failed to add sales bill: $e');
    }
  }

  // Update available invoice numbers
  void updateAvailableInvoiceNumbers() {
    // Get the last part of the invoice numbers (e.g., 23-24-01-5 -> 5)
    final List<int> usedInvoiceNumbers = salesBills
        .map((bill) => int.parse(bill.invoiceNo.split('-').last))
        .toList();

    // Generate a list of available numbers excluding the used ones
    availableInvoiceNumbers.value = List.generate(100, (index) => index + 1)
        .where((num) => !usedInvoiceNumbers.contains(num))
        .toList();

    // Automatically set the first available number as selected
    if (availableInvoiceNumbers.isNotEmpty) {
      selectedInvoiceNumber.value = availableInvoiceNumbers.first;
    }
  }

  // Set the selected invoice number when changed from the dropdown
  void setSelectedInvoiceNumber(int number) {
    selectedInvoiceNumber.value = number;
  }
}

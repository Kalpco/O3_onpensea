import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/gold_price_model.dart';
import '../model/transaction_model.dart';
import '../model/users_details_model.dart';
import '../service/digigold_service.dart';

class DigiGoldController extends GetxController {
  var goldPrice = GoldPriceModel(goldPrice: "-", goldUnit: "mg").obs;
  var transactions = <TransactionModel>[].obs;
  var userDetails = Rxn<UserDetailsModel>(); // Make userDetails nullable
  var isLoading = false.obs;
  var transactionType = ''.obs;
  var isUserNewDigigoldCustomer = true.obs; // Add this flag

  final DigiGoldService _service = DigiGoldService();

  @override
  void onInit() {
    super.onInit();
    // Fetch initial data
    fetchAllData();
  }

  void fetchAllData() {
    fetchUserDetails();
    fetchGoldPrice();
    fetchTransactions();
  }

  void fetchGoldPrice() async {
    isLoading.value = true;
    try {
      var fetchedPrice = await _service.fetchGoldPrice();
      if (fetchedPrice != null) {
        goldPrice.value = fetchedPrice;
      }
    } catch (e) {
      print("Error fetching gold price: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchTransactions() async {
    isLoading.value = true;
    try {
      var fetchedTransactions = await _service.fetchTransactions();
      transactions.value = fetchedTransactions;
    } catch (e) {
      print("Error fetching transactions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void fetchUserDetails() async {
    isLoading.value = true;
    try {
      var details = await _service.fetchUserDetails();
      if (details == null) {
        print("users details is null");
        // If no user details are returned, consider the user as a new customer
        isUserNewDigigoldCustomer.value = true;
      } else {
        userDetails.value = details;
        isUserNewDigigoldCustomer.value = false;
      }
    } catch (e) {
      print("Error fetching user details: $e");
      userDetails.value = null;
      isUserNewDigigoldCustomer.value = true; // Set to true in case of an error
    } finally {
      isLoading.value = false;
    }
  }


  void setTransactionType(String type) {
    transactionType.value = type;
  }

  void refreshData() {
    fetchAllData();
  }
}

// digigold_buy_sell_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpensea/features/scheme/Screens/digigold/widgets/digigold_buy_info.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../authentication/screens/login/Controller/LoginController.dart';
import '../../../../product/apiService/capturePaymentAPI.dart';
import '../../../../product/apiService/paymentOrderAPI.dart';
import '../../../../product/models/capture_payment_success.dart';
import '../../../../product/models/order_api_success.dart';
import '../../../../product/models/razorpay_failure_response.dart';
import '../model/gold_price_model.dart';
import '../service/digigold_service.dart';
import '../widgets/digigold_sell_info.dart';
import 'digigold_success_page.dart';
import '../controller/digigold_controller.dart';

class DigiGoldBuySellScreen extends StatefulWidget {
  DigiGoldBuySellScreen({Key? key}) : super(key: key);

  @override
  _DigiGoldBuySellScreenState createState() => _DigiGoldBuySellScreenState();
}

class _DigiGoldBuySellScreenState extends State<DigiGoldBuySellScreen> {

  final RazorpayOrderAPI razorpayOrderAPI =
  RazorpayOrderAPI(ApiConstants.key, ApiConstants.secretId);

  final RazorpayCapturePayment capturePayment =
  RazorpayCapturePayment(ApiConstants.key, ApiConstants.secretId);

  late RazorpaySuccessResponseDTO razorpaySuccessResponseDTO;
  late CapturePaymentRazorPay capturePaymentRazorPayResponse;
  late RazorpayFailureResponse razorpayFailureResponse;
  late Razorpay _razorpay;


  TextEditingController amountController = TextEditingController(text: '0');
  final DigiGoldService _service = DigiGoldService();
  final DigiGoldController controller = Get.find<DigiGoldController>();
  final loginController = Get.put(LoginController());


  Future<void> _submitTransaction() async {
    String amount = amountController.text;
    String type = controller.transactionType.value;
    String pricePerMgWithGst = controller.goldPrice.value.goldPrice;
    String pricePerMgNoGst = _PricePerMgNoGst(pricePerMgWithGst);



    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    // Calculate the weight in mg based on the entered amount
    String weightInMg = _calculateWeightInMg(amount, pricePerMgWithGst);

    // If the transaction type is "sell", validate the entered weight
    if (type == "sell") {
      double enteredWeight = double.parse(amount);
      double currentBalance = double.parse(controller.userDetails.value?.weightInMg ?? "0");

      if (enteredWeight > currentBalance) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insufficient gold balance. Please enter a valid amount to sell.')),
        );
        return;
      }
    }

    // Prepare the DTO with dynamic values based on type
    Map<String, dynamic> dto = {
      "userId": int.parse(loginController.userData['userId'].toString()),
      "pricePerMgNoGst": double.parse(pricePerMgNoGst),
      "pricePerMgWithGst": double.parse(pricePerMgWithGst),
      "vaultTransactionType": type,
      "weight_mg": (type == "sell") ? double.parse(amount) : double.parse(weightInMg),
      "transactionId": "123", // Update this with your actual transaction ID logic,
      "amount": (type == "sell") ? double.parse(_calculateAmountToRecievePerMgOfGold("7.56", amount)) :  double.parse(amount),

      "vendorBuyingRate":11.1,
      "vendorSellingRate":12.3,
      "kalpcoBuyingRate":23.3,
      "kalpcoSellingRate":23.33

    };

    bool success = await _service.submitTransaction(dto);
    if (success) {
      Get.off(() => const DigigoldSuccessPage());
      controller.refreshData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction failed. Please try again.')),
      );
    }
  }


  Future<void> _updateIsUserNewCustomer(bool isNew) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUserNewDigigoldCustomer', isNew);
  }

  String _PricePerMgNoGst(String pricePerMgWithGst) {
    return (double.parse(pricePerMgWithGst) -
        (0.03 * double.parse(pricePerMgWithGst))).toStringAsFixed(2);
  }

  String _calculateWeightInMg(String amount, String currentGoldPriceWithGst) {
    double totalGoldPurchased =
        ((1 * double.parse(amount)) / double.parse(currentGoldPriceWithGst));
    return totalGoldPurchased.toStringAsFixed(2);
  }

  double _calculateTextWidth(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.size.width;
  }

  String _calculateAmountToRecievePerMgOfGold(
      String sellingGoldPriceMg, String enterMgOfGoldToSell) {
    double amountToRecieve =
        double.parse(sellingGoldPriceMg) * double.parse(enterMgOfGoldToSell);
    return amountToRecieve.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    String transactionType = controller.transactionType.value;
    String pricePerMgWithGst = controller.goldPrice.value.goldPrice;
    //String pricePerMgNoGst = _PricePerMgNoGst(pricePerMgWithGst);
    bool isBuying = transactionType == "buy";

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: U_Colors.yaleBlue,
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQFmHHdwWdudHrnE0l0otJtZ1BNBlI1_KyfACB7XIoMUFE8YT0xDSbhvqD9Mn_MHPAMDmQ&usqp=CAU',
                  ),
                  radius: 40,
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 16),
                Text(
                  isBuying ? 'Buying from MMTC-PAMP' : 'Selling to MMTC-PAMP',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '99.99% pure 24K gold',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final textWidth =
                            _calculateTextWidth(amountController.text);

                        return SizedBox(
                          width: textWidth + 60,
                          child: TextField(
                            controller: amountController,
                            style: const TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              prefixIcon: isBuying
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.only(right: 4.0),
                                      child: Text(
                                        '₹',
                                        style: TextStyle(
                                          fontSize: 48,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  : null,
                              suffixText: isBuying ? '' : 'mg',
                              // Show 'mg' when selling
                              suffixStyle: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 0,
                                minHeight: 0,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Using the ternary operator to switch between widgets
                isBuying
                    ? DigigoldBuyInfo(
                        weightInMg: amountController.text.isEmpty
                            ? "0"
                            : (_calculateWeightInMg(amountController.text,
                                controller.goldPrice.value.goldPrice)),
                        pricePerMgNoGst: _PricePerMgNoGst(
                            controller.goldPrice.value.goldPrice),
                        pricePerMgWithGst: controller.goldPrice.value.goldPrice,
                      )
                    : DigigoldSellInfo(
                        amountToRecieveOnSellingMgOfGold:
                            amountController.text.isEmpty
                                ? "0"
                                : _calculateAmountToRecievePerMgOfGold(
                                    "7.56", amountController.text),
                        sellingPriceOfGoldPerMg: "7.56",
                        currentBalanceMgOfGold:
                            double.parse(controller.userDetails.value!.weightInMg).toStringAsFixed(2),
                      ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: _submitTransaction,
              backgroundColor: U_Colors.whiteColor,
              icon: const Icon(Icons.check, color: U_Colors.yaleBlue),
              label: Text(
                '${controller.transactionType == "buy" ? "Buy": "Sell"}', // Add your desired text here
                style: TextStyle(
                  color: U_Colors.yaleBlue, // Match the color of the icon
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

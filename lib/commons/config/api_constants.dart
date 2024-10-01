import 'package:flutter_dotenv/flutter_dotenv.dart';



class ApiConstants {

  static String? INVESTMENTMS_URL = dotenv.env['INVESTMENT_BASE_URL'];
  static String? USERS_URL = dotenv.env['USERS_BASE_URL'];
  static String? PORTFOLIO_URL = dotenv.env['PORTFOLIO_BASE_URL'];
  static String? TRANSACTION_BASE_URL = dotenv.env['TRANSACTION_BASE_URL'];
  static String? PRODUCTS_BASE_URL = dotenv.env['PRODUCTS_BASE_URL'];
  static String? WALLET_BASE_URL = dotenv.env['WALLET_BASE_URL'];
  static String? CART_BASE_URL = dotenv.env['CART_BASE_URL'];


}
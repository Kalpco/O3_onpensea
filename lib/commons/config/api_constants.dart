import 'package:flutter_dotenv/flutter_dotenv.dart';



class ApiConstants {

  static String? INVESTMENTMS_URL = dotenv.env['INVESTMENT_BASE_URL'];
  static String? USERS_URL = dotenv.env['USERS_BASE_URL'];
  static String? PORTFOLIO_URL = dotenv.env['PORTFOLIO_BASE_URL'];
  static String? TRANSACTION_BASE_URL = dotenv.env['TRANSACTION_BASE_URL'];
  static String? TRANSACTION_MASTER_BASE_URL = dotenv.env['TRANSACTION_MASTER_BASE_URL'];
  static String? PRODUCTS_BASE_URL = dotenv.env['PRODUCTS_BASE_URL'];
  static String? WALLET_BASE_URL = dotenv.env['WALLET_BASE_URL'];
  static String? CART_BASE_URL = dotenv.env['CART_BASE_URL'];
  static String? DIGIGOLD_BASE_URL = dotenv.env['DIGIGOLD_BASE_URL'];
  static String? INVOICE_DOWNLOAD = dotenv.env['INVOICE_DOWNLOAD'];
  static String? COUPON_URL = dotenv.env['COUPON_BASE_URL'];
  static String? AUTHENTICATION_URL = dotenv.env['AUTH_BASE_URL'];


  static String? USER_LOGIN = "$AUTHENTICATION_URL/login";
  static String? USER_REGISTRATION = "$AUTHENTICATION_URL/register";


}
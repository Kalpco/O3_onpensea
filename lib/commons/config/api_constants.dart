import 'package:flutter_dotenv/flutter_dotenv.dart';



class ApiConstants {

  static final String INVESTMENTMS_URL = dotenv.env['INVESTMENT_BASE_URL'] ?? '';
  static final String USERS_URL = dotenv.env['USERS_BASE_URL'] ?? '';
  static final String PORTFOLIO_URL = dotenv.env['PORTFOLIO_BASE_URL'] ?? '';
  static final String TRANSACTION_BASE_URL = dotenv.env['TRANSACTION_BASE_URL'] ?? '';
  static final String TRANSACTION_MASTER_BASE_URL = dotenv.env['TRANSACTION_MASTER_BASE_URL'] ?? '';
  static final String PRODUCTS_BASE_URL = dotenv.env['PRODUCTS_BASE_URL'] ?? '';
  static final String WALLET_BASE_URL = dotenv.env['WALLET_BASE_URL'] ?? '';
  static final String CART_BASE_URL = dotenv.env['CART_BASE_URL'] ?? '';
  static final String DIGIGOLD_BASE_URL = dotenv.env['DIGIGOLD_BASE_URL'] ?? '';
  static final String INVOICE_DOWNLOAD = dotenv.env['INVOICE_DOWNLOAD'] ?? '';
  static final String COUPON_URL = dotenv.env['COUPON_BASE_URL'] ?? '';
  static final String AUTHENTICATION_URL = dotenv.env['AUTHENTICATION_URL'] ?? '';

  static final String USER_LOGIN = "$AUTHENTICATION_URL/login";
  static final String USER_REGISTER = "$AUTHENTICATION_URL/register";
  static final String USER_REGISTERATION_OTP = "$AUTHENTICATION_URL/registrationOTP";

}
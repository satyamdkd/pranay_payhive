class URLs {
  static String baseURl = "https://payhive.in/api/auth";
  static String googleAPIKEY = "AIzaSyBV93sZuyUT9XwKbnVKWByrHE0V5VsYCg0";
  static String axisKeyTest = "rzp_test_S2vPPNhr3i1Pgr";
  static String razorPayKeyTest = "rzp_test_IlEozMRLgfVCGp";
  static String razorPayKeyLive = "rzp_live_hlifXpcyda4tLf";
  static String axisKeyLive = "rzp_live_S2vZVd3ZXnIC1S";
  static const String token = "/refresh";
  static const String loginOrRegister = "/registerlogin";
  static const String getUserData = "/getuserdata";
  static const String getDashboardData = "/dashboard";
  static const String getUserDropDown = "/setaccountfor";
  static const String addBank = "/add-bank";
  static const String addAddress = "/addupdate-address";
  static const String deleteAddress = "/delete-address";
  static const String defaultAddress = "/set-default-address";
  static const String getCardType = "/get-cardtype";
  static const String getAllCards = "/get-card";
  static const String posRequest = "/pos-request";
  static const String addBeneficiary = "/add-beneficiary";
  static const String walletPayout = "/wallet-payout";
  static const String getPosBankList = "/getposbank";
  static const String getBeneficiaryBankList = "/getbeneficiarylist";
  static const String deleteBeneficiary = "/delete-beneficiary";
  static const String serialNumberList = "/getuserserial";
  static const String getPosRequestList = "/getposrequestlist";
  static const String walletHistory = "/wallet-history";
  static const String getCashfreeOrderById = "/order-payment-cashfree";
  static const String generateRazorPayOrderId = "/order-generate";
  static const String generateCashfreeOrderId = "/order-generate-cashfree";
  static const String sendPaymentDetailToServer = "/order-payment";
  static const String storeLocation = "/user-location";
  static const String shopLicence = "/shop-licence";
  static const String transactionDetailWithStatus = "/wallet-history-details";

  /// --------------------------------------------------------------------------
  /// -------------------------------- BBPS ------------------------------------
  /// --------------------------------------------------------------------------

  static const String bbpsAuthToken = "/bbps-authtoken";
  static const String bbpsGetAllCategories = "/bbps-categories";
  static const String bbpsGetAllBillers = "/bbps-billers";
  static const String bbpsBillFetchRequest = "/bills-fetch-request";
  static const String bbpsBillFetchResponse = "/bills-fetch-response";
  static const String bbpsPaymentRequest = "/bills-payment-request";
  static const String bbpsPaymentResponse = "/bills-payment-response";
}

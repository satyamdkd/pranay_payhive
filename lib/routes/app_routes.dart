part of 'pages.dart';

abstract class Routes {
  Routes._();
  static const home = _Paths.home;
  static const splash = _Paths.splash;
  static const salaryReg = _Paths.salaryReg;
  static const dashboard = _Paths.dashboard;
  static const bankDetail = _Paths.bankDetail;
  static const addAddress = _Paths.addAddress;
  static const personalDetails = _Paths.personalDetails;
  static const posRequest = _Paths.posRequest;
  static const listPosRequest = _Paths.listPosRequest;
  static const vendorPay = _Paths.vendorPay;
  static const walletHistory = _Paths.walletHistory;
  static const billCategories = _Paths.billCategories;
  static const fetchBill = _Paths.fetchBill;
  static const fetchedBill = _Paths.fetchedBill;
  static const transactionHistoryBillPay = _Paths.transactionHistoryBillPay;
  static const transactionDetailBillPay = _Paths.transactionDetailBillPay;
  static const creditCardBillPay = _Paths.creditCardBillPay;
  static const shopLicense = _Paths.shopLicense;
  static const dthRecharge = _Paths.dthRecharge;
  static const electricity = _Paths.electricity;
  static const fastTag = _Paths.fastTag;
  static const gasBooking = _Paths.gasBooking;
  static const transactionDetailWithStatusPage =
      _Paths.transactionDetailWithStatusPage;
  static const reverifyAadhaar = _Paths.reverifyAadhaar;
}

abstract class _Paths {
  _Paths._();
  static const home = '/home';
  static const splash = '/splash';
  static const salaryReg = '/salaryReg';
  static const dashboard = '/dashboard';
  static const bankDetail = '/bankDetail';
  static const addAddress = '/addAddress';
  static const personalDetails = '/personalDetails';
  static const posRequest = '/posRequest';
  static const listPosRequest = '/listPosRequest';
  static const vendorPay = '/vendorPay';
  static const walletHistory = '/walletHistory';
  static const billCategories = '/billCategories';
  static const fetchBill = '/fetchBill';
  static const fetchedBill = '/fetchedBill';
  static const transactionHistoryBillPay = '/transactionHistoryBillPay';
  static const transactionDetailBillPay = '/transactionDetailBillPay';
  static const creditCardBillPay = '/creditCardBillPay';
  static const shopLicense = '/shopLicense';
  static const dthRecharge = '/dthRecharge';
  static const electricity = '/electricity';
  static const fastTag = '/fastTag';
  static const gasBooking = '/gasBooking';
  static const transactionDetailWithStatusPage =
      '/transactionDetailWithStatusPage';
  static const reverifyAadhaar = '/reverify-aadhar';
}

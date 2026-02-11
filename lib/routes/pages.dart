import 'package:get/get.dart';
import 'package:payhive/modules/address/binding/address_binding.dart';
import 'package:payhive/modules/address/view/address_details.dart';
import 'package:payhive/modules/auth/salary/binding/salary_binding.dart';
import 'package:payhive/modules/auth/salary/view/login_reg_phone.dart';
import 'package:payhive/modules/bank/binding/bank_binding.dart';
import 'package:payhive/modules/bank/view/bank_details.dart';
import 'package:payhive/modules/bill_fetched/binding/bill_fetched_binding.dart';
import 'package:payhive/modules/bill_fetched/view/bill_fetched.dart';
import 'package:payhive/modules/bill_pay_categories/binding/bill_cat_binding.dart';
import 'package:payhive/modules/bill_pay_categories/view/bill_categories.dart';
import 'package:payhive/modules/dashboard/binding/dashboard_binding.dart';
import 'package:payhive/modules/dashboard/view/dashboard.dart';
import 'package:payhive/modules/fetch_bill/binding/fetch_bill_binding.dart';
import 'package:payhive/modules/fetch_bill/view/fetch_bill.dart';
import 'package:payhive/modules/list_pos_req/binding/binding.dart';
import 'package:payhive/modules/list_pos_req/view/list_pos_request.dart';
import 'package:payhive/modules/pay_vendor/binding/vendor_pay_binding.dart';
import 'package:payhive/modules/pay_vendor/view/vendor_pay.dart';
import 'package:payhive/modules/personal_details/binding/personal_detail_binding.dart';
import 'package:payhive/modules/personal_details/view/personal_details.dart';
import 'package:payhive/modules/pos/binding/binding.dart';
import 'package:payhive/modules/pos/view/pos_request.dart';
import 'package:payhive/modules/recharge_and_bill_pay/credit_card/binding/credit_card_binding.dart';
import 'package:payhive/modules/recharge_and_bill_pay/credit_card/view/credit_card_view.dart';
import 'package:payhive/modules/recharge_and_bill_pay/dth/binding/dth_binding.dart';
import 'package:payhive/modules/recharge_and_bill_pay/dth/view/dth_all_billers.dart';
import 'package:payhive/modules/recharge_and_bill_pay/electricity/binding/electricity_binding.dart';
import 'package:payhive/modules/recharge_and_bill_pay/electricity/view/electricity_all_billers.dart';
import 'package:payhive/modules/recharge_and_bill_pay/fastag/binding/fastag_binding.dart';
import 'package:payhive/modules/recharge_and_bill_pay/gas/binding/gas_binding.dart';
import 'package:payhive/modules/recharge_and_bill_pay/gas/view/gas_all_billers.dart';
import 'package:payhive/modules/reverify_aadhar/view/reverify_aadhar_view.dart';
import 'package:payhive/modules/shop_lincence/binding/shop_licence_binding.dart';
import 'package:payhive/modules/shop_lincence/view/shop_licence_detail.dart';
import 'package:payhive/modules/splash/binding/splash_binding.dart';
import 'package:payhive/modules/splash/view/splash.dart';
import 'package:payhive/modules/transaction_detail_bill_pay/binding/transaction_history_bill_pay_binding.dart';
import 'package:payhive/modules/transaction_detail_bill_pay/view/transaction_detail_bill_pay.dart';
import 'package:payhive/modules/transaction_detail_with_status/binding/trans_detal_with_status_binding.dart';
import 'package:payhive/modules/transaction_detail_with_status/view/trans_detal_with_status.dart';
import 'package:payhive/modules/transaction_history_bill_pay/binding/transaction_history_bill_pay_binding.dart';
import 'package:payhive/modules/transaction_history_bill_pay/view/transaction_history_bill_pay.dart';
import 'package:payhive/modules/wallet_history/binding/wallet_history_binding.dart';
import 'package:payhive/modules/wallet_history/view/wallet_history.dart';
import '../modules/recharge_and_bill_pay/fastag/view/fastag_all_billers.dart';
import '../modules/reverify_aadhar/binding/reverify_aadhar_binding.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => const Splash(),
      binding: SplashBinding(),
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: _Paths.salaryReg,
      page: () => const LoginRegViaPhone(),
      binding: SalaryBinding(),
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: _Paths.dashboard,
      page: () => const Dashboard(),
      binding: DashBoardBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.bankDetail,
      page: () => const BankDetailsPage(),
      binding: BankBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.addAddress,
      page: () => const AddressPage(),
      binding: AddressBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.personalDetails,
      page: () => const PersonalDetails(),
      binding: PersonalDetailBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.posRequest,
      page: () => const PosRequest(),
      binding: PosBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.listPosRequest,
      page: () => const ListPosRequest(),
      binding: ListPosBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.vendorPay,
      page: () => const VendorPaymentScreen(),
      binding: VendorPayBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.walletHistory,
      page: () => const WalletHistoryScreen(),
      binding: WalletHistoryBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.billCategories,
      page: () => const BillPayCategories(),
      binding: BillCatBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.fetchBill,
      page: () => const FetchBillPage(),
      binding: FetchBillBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.fetchedBill,
      page: () => const BillFetchedPage(),
      binding: BillFetchedBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.transactionHistoryBillPay,
      page: () => const TransactionHistoryBillPay(),
      binding: TransactionHistoryBillPayBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.transactionDetailBillPay,
      page: () => const TransactionDetailBillPay(),
      binding: TransactionDetailBillPayBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.creditCardBillPay,
      page: () => const CreditCardView(),
      binding: CreditCardBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.shopLicense,
      page: () => const ShopLicencePage(),
      binding: ShopLicenceBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.dthRecharge,
      page: () => const DthBillers(),
      binding: DthBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.electricity,
      page: () => const ElectricityAllBillers(),
      binding: ElectricityBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.transactionDetailWithStatusPage,
      page: () => const TransactionDetailWithStatus(),
      binding: TransactionDetailWithStatusBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.transactionDetailWithStatusPage,
      page: () => const FastagAllBillers(),
      binding: FastagBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.transactionDetailWithStatusPage,
      page: () => const TransactionDetailWithStatus(),
      binding: TransactionDetailWithStatusBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.fastTag,
      page: () => const FastagAllBillers(),
      binding: FastagBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.gasBooking,
      page: () => const GasAllBillers(),
      binding: GasBinding(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: _Paths.reverifyAadhaar,
      page: () => ReverifyAadharView(),
      binding: ReverifyAadharBinding(),
      transition: Transition.leftToRight,
    ),
  ];
}

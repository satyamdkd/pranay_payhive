import 'package:get/get.dart';
import 'package:payhive/modules/auth/salary/controller/salaried_controller.dart';
import 'package:payhive/modules/dashboard/controller/dashboard_controller.dart';
import 'package:payhive/modules/recharge_and_bill_pay/credit_card/controller/credit_card_controller.dart';
import 'package:payhive/modules/recharge_and_bill_pay/dth/controller/dth_controller.dart';
import 'package:payhive/modules/recharge_and_bill_pay/electricity/controller/electricity_controller.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/utils/check_connectivity/check_connection.dart';
import 'package:payhive/utils/helper/shared_pref.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

setUpDi() async {
  locator.registerSingleton<SharedPref>(
    SharedPref(),
  );
  locator.registerSingleton<SalariedController>(
    Get.put(SalariedController()),
  );
  locator.registerSingleton<ConnectivityService>(
    Get.put(ConnectivityService()),
  );

  connectivityService.controllerBindings.addAll({
    Routes.creditCardBillPay: () => Get.put(
          CredCardController(),
          tag: Routes.creditCardBillPay,
        ),
    Routes.dthRecharge: () => Get.put(
          DthController(),
          tag: Routes.dthRecharge,
        ),
    Routes.electricity: () => Get.put(
          ElectricityController(),
          tag: Routes.electricity,
        ),
    Routes.dashboard: () => Get.put(
          DashBoardController(),
          tag: Routes.dashboard,
        ),
  });
}

final sharedPref = locator.get<SharedPref>();
final salariedController = locator.get<SalariedController>();
final connectivityService = locator.get<ConnectivityService>();

String userName = '';
String phoneNumber = '';
String userId = '';
String userEmail = '';
String token = '';
String bbPSAuthToken = '';
DateTime? bbPSAuthTokenTime;
String fcmToken = '';
String marginPerTransaction = '15.0';
String minCreditCardBillPay = '100';

bool isSelfieReUploading = false;

bool forIOS = false;

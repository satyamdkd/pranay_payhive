import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:payhive/constants/urls.dart';
import 'package:payhive/modules/dashboard/repo/dashboard_repo.dart';
import 'package:payhive/modules/dashboard/view/widgets/user_inactive.dart';
import 'package:payhive/modules/dashboard/widget/session_expired.dart';
import 'package:payhive/routes/pages.dart';
import 'package:payhive/services/di/di.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/utils/widgets/error.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/upload_aadhar.dart';

class DashBoardController extends GetxController {
  /*----------------------------------------------------------------------------

    LOCATION SERVICE
    FETCHING LOCATION OF THE DEVICE AFTER EVERY 1 MINUTE AND SENDING IT
    TO THE SERVER

  ----------------------------------------------------------------------------*/

  autoLogout() async {
    salariedController.mobileController.clear();
    salariedController.isLoginScreenDisabled.value = false;
    salariedController.isOTPShotPhone.value = false;
    salariedController.isIgnoringMobile.value = false;
    salariedController.isEditingPhone.value = true;
    await sharedPref.logout();
    Get.offAllNamed(Routes.splash);
  }

  sendLatLongToAPi(lat, long, city, state, country) async {
    try {
      var res = await repo!.sendDataToApi(lat, long, city, state, country);
      if (res is ApiFailure) {
        if (res.message.toString().toLowerCase().contains('unauth')) {
          autoLogout();
        }
      }
    } catch (e) {
      autoLogout();
      debugPrint(e.toString());
    }
  }

  getLocation() async {
    double latitude = 0.0;
    double longitude = 0.0;
    String city = '';
    String country = '';
    String state = '';

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('permission Denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('permission deniedForever');
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;

      longitude = position.longitude;

      debugPrint('the latitude $longitude and longitude $longitude');

      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );
      debugPrint('place mark ${placemarks.first.locality}');

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        city = place.locality!;
        state = place.administrativeArea!;
        country = place.country!;
        debugPrint('my city $city');
        debugPrint('my state $state');
        debugPrint('my country $country');

        await sendLatLongToAPi(latitude, longitude, city, state, country);
      }
    } catch (e) {
      debugPrint('inside  catch block $e');
    }
  }

  DashboardRepo? repo;

  RxDouble toolbarOpacity = 0.0.obs;

  void handleScroll() {
    final double offset = scrollController.offset;
    toolbarOpacity.value = offset;
    update();
  }

  onBackButton() async {
    if (bottomNavIndex.value != 0) {
      bottomNavIndex.value = 0;
    } else {
      exit(0);
    }
    update();
  }

  setToken() async {
    var tokenMap = await sharedPref.getToken();
    token = tokenMap.toString();
    debugPrint('USER TOKEN FROM DASHBOARD: $token');
    Future.delayed(const Duration(milliseconds: 500), () async {
      repo = DashboardRepo();

      await getUserData();

      ///  await getHomePageData();
      await dashboardApi();
    });
  }

  Timer? timer;

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    setToken();
    scrollController.addListener(handleScroll);

    /*--------------------------------------------------------------------------

                                LOCATION SERVICE

    --------------------------------------------------------------------------*/

    // timer = Timer.periodic(
    //   const Duration(seconds: 50),
    //   (Timer timer) async {
    //     getLocation();
    //   },
    // );
  }

  RxBool dashboardLoading = false.obs;
  RxBool isPosAssigned = false.obs;
  RxBool isPanUploaded = false.obs;
  RxBool isAadharUploaded = false.obs;
  RxBool isBusinessPhotoUploaded = false.obs;
  RxBool isBankUploaded = false.obs;
  RxString walletAmount = "0.0".obs;
  RxString accountType = "agent".obs;
  RxString isProfilePicApproved = "approve".obs;

  RxString accountStatus = "active".obs;

  dashboardApi() async {
    try {
      dashboardLoading.value = true;
      update();

      final response = await repo!.getDashboardData();

      if (response is ApiSuccess) {
        accountStatus.value = response.data['data']['status'];
        if (response.data['data']['status'] == 'inactive') {
          showUnclosableSnackbar(Get.context!);

          /// Get.offAll(() => const AccountInactivePage());
          /// return;
        }
        isPosAssigned.value = response.data['data']['posassignuser'];
        isPanUploaded.value = response.data['data']['ispanupload'];
        isAadharUploaded.value = response.data['data']['isaadharupload'];
        isProfilePicApproved.value =
            response.data['data']['profile_status'] ?? 'approve';

        /// isProfilePicApproved.value = response.data['data']['profile_status'];
        isBusinessPhotoUploaded.value =
            response.data['data']['isbussinessupload'];
        accountType.value = response.data['data']['account_type'] ?? '';
        isBankUploaded.value = response.data['data']['isbankupload'];
        walletAmount.value = response.data['data']['userwallet'].toString();
        marginPerTransaction =
            response.data['data']['margin_per_trans'].toString();
        minCreditCardBillPay =
            response.data['data']['min_credit_card_bill'].toString();

        // if (!isPanUploaded.value ||
        //     !isAadharUploaded.value ||
        //     !isBankUploaded.value ||
        //     isProfilePicApproved.value != 'approve') {
        //   showDocumentUploadDialog();
        // }

        if (isPanUploaded.value ||
            !isAadharUploaded.value ||
            !isBankUploaded.value ||
            isProfilePicApproved.value != 'approve') {
          showDocumentUploadDialog();
        }
      } else if (response is ApiFailure) {
        if (response.message
            .toString()
            .toLowerCase()
            .contains('unauthenticated')) {
          Get.to(() => const SessionExpiredScreen());
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      dashboardLoading.value = false;
      update();
    }
  }

  int count = 0;
  final ScrollController scrollController = ScrollController();

  getHomePageData() async {}
  RxBool hideTitle = true.obs;
  RxInt bottomNavIndex = 0.obs;

  bottomNavPressed(index) {
    bottomNavIndex.value = index;
    dashboardApi();

    if (bottomNavIndex.value == 1) {
      walletHistory();
    }
    if (bottomNavIndex.value == 4) {
      getUserData();
    }

    update();
  }

  Map<String, dynamic>? userDetails;

  List addressList = [];

  setAddress(list) async {
    debugPrint(list.toString());
    addressList = [];
    if (list != null && list != []) {
      addressList = list;
    }

    update();
  }

  RxBool isLoadingUserData = false.obs;
  String? phone;

  getUserData() async {
    try {
      if (await sharedPref.getTempMobile() != null) {
        phone = await sharedPref.getTempMobile();
      }

      isLoadingUserData.value = true;
      update();
      final response = await repo!.userData(mobileNumber: phone);

      if (response is ApiSuccess) {
        final data = response.data;
        userDetails = data;
        setAddress(data['data']['address']);
      } else if (response is ApiFailure) {
        debugPrint(response.message.toString());
      } else {
        debugPrint(response.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingUserData.value = false;
      update();

      if (userDetails != null) {
        userName = "${userDetails?['data']['name'] ?? ''}".split(' ').first;
        phoneNumber = "${userDetails?['data']['phone'] ?? ''}";
        userId = "${userDetails?['data']['id'] ?? ''}";
        userEmail = "${userDetails?['data']['email'] ?? ''}";
      }
    }
  }

  RxBool personalDetailsOpen = false.obs;
  RxBool personalDetailsOpenForChildWidget = false.obs;

  RxBool userAddressOpen = false.obs;
  RxBool userAddressForChildWidget = false.obs;

  RxBool aboutPayLixOpen = false.obs;
  RxBool aboutPayLixForChildWidget = false.obs;

  RxBool shopLicenceOpen = false.obs;
  RxBool shopLicenceForChildWidget = false.obs;

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  /// ------------------------------- Profile -----------------------------------
  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  helpCenter() async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: "mailto",
      path: "admin@payhive.in",
      query: encodeQueryParameters(<String, String>{
        "subject": "Payhive : Customer's issue",
        'body': 'Type your queries or issues here'
      }),
    );

    launchUrl(emailLaunchUri);
  }

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  /// ------------------------------- Wallet -----------------------------------
  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  RxInt expandedIndex = (-1).obs;

  RxInt walletStatusIndex = 1.obs;

  RxBool walletHistoryLoading = false.obs;

  Map<String, dynamic>? walletHistoryRes;

  walletHistory() async {
    try {
      walletHistoryLoading.value = true;
      update();

      final response = await repo!.getWalletHistory();

      if (response is ApiSuccess) {
        walletHistoryRes = response.data;
      } else if (response is ApiFailure) {}
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      walletHistoryLoading.value = false;
      update();
    }
  }

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  /// ------------------------------ ADD MONEY ---------------------------------
  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  /*----------------------------------------------------------------------------

                                   RAZOR PAY

  ----------------------------------------------------------------------------*/

  RxBool isLoadingPayment = false.obs;

  String orderId = '';

  generateOrderId(context) async {
    try {
      isLoadingPayment.value = true;
      update();
      final response = await repo!.generateRazorPayOrderId(addMoneyAmount.text);

      if (response is ApiSuccess) {
        final data = response.data;

        if (data['status'] == 1) {
          finalAmount =
              double.parse(data['data']['details']['amount'].toString());
          orderId = data['data']['order_id'];
          debugPrint(orderId.toString());
          initialisePaymentViaRazorPay(addMoneyAmount.text, context);
        } else if (data['status'] == 0) {
          errorDialog(context: context, message: data['msg']);
        }
      } else if (response is ApiFailure) {
        debugPrint(response.message.toString());
        errorDialog(context: context, message: response.message.toString());
      } else {
        debugPrint(response.toString());
        errorDialog(context: context, message: 'Something went wrong');
      }
    } catch (e) {
      debugPrint(e.toString());
      if (e is ApiFailure) {
        errorDialog(context: context, message: e.message.toString());
      }
    } finally {
      isLoadingPayment.value = false;
      update();
      FocusScope.of(context).requestFocus(FocusNode());
    }
  }

  int popUpCount = 0;

  var selectedCategory = 0.obs;
  var selectedSettlement = 0.obs;

  final FocusNode focusNode = FocusNode();

  void removeFocus() {
    focusNode.unfocus();
  }

  TextEditingController addMoneyAmount = TextEditingController();

  validateAddMoney(context) async {
    if (addMoneyAmount.text.isEmpty) {
      errorDialog(
        context: context,
        message: 'Please enter the amount to be added to your wallet.',
        title: 'Enter amount',
      );
    } else if (double.parse(addMoneyAmount.text.toString()) < 1 ||
        double.parse(addMoneyAmount.text.toString()) > 99999) {
      addMoneyAmount.clear();
      errorDialog(
        context: context,
        message: 'Please enter an amount between 1 and 99,999.',
        title: 'Add money',
      );
    } else {
      generateOrderId(context);

      /// OLD CODE CASHFREE DISABLED
      /// showToggle(context);
    }
  }

  Razorpay razorpay = Razorpay();
  double finalAmount = 0;
  initialisePaymentViaRazorPay(amount, context) async {
    popUpCount = 0;

    var options = {
      'name': 'Payhive',
      'key': URLs.axisKeyLive,
      'amount': finalAmount,
      'order_id': orderId.toString(),
      'description': '--',
      'retry': {'enabled': true, 'max_count': 1},
      'notes': {
        'notes': '--',
        'notes_key_1': '--',
        'notes_key_2': '--',
      },
      'send_sms_hash': true,
      'readonly': {
        'contact': false,
        'email': false,
        'name': false,
      },
      'prefill': {
        'contact': phoneNumber.toString(),
        'email': userEmail.toString()
      },
      'theme': {'color': '#1D283A'},
      'method': {
        'card': true,
        'upi': false,
        'netbanking': false,
        'wallet': false,
        'paylater': false,
      }
    };

    razorpay.clear();

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR,
        (PaymentFailureResponse response) {
      handlePaymentErrorResponse(response, context);
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS,
        (PaymentSuccessResponse response) {
      handlePaymentSuccessResponse(response, context);
    });
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET,
        (ExternalWalletResponse response) {
      handleExternalWallet(response, context);
    });

    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay open error: $e');
      if (popUpCount == 0) {
        popUpCount++;
        errorDialog(
          context: context,
          message: 'Payment initialization failed',
          title: 'Error',
          onTap: () => Get.back(),
        );
      }
    }
  }

  void handlePaymentErrorResponse(
      PaymentFailureResponse response, context) async {
    /*
    * Payment Failure Response contains three values:
    * 1. Code
    * 2. Message
    * 3. Error
    */

    debugPrint(response.code.toString());
    debugPrint(response.message.toString());
    debugPrint(response.error.toString());

    if (popUpCount == 0) {
      popUpCount++;
      Future.delayed(const Duration(milliseconds: 500), () async {
        sendPaymentDetailToServer(context, 'failure');
      });
      errorDialog(
          context: context,
          message: 'Your payment is failed\n${response.message}',
          title: 'Payment failed',
          onTap: () {
            addMoneyAmount.clear();
            Get.back();
            Get.back();
          });
    }
  }

  String? orderIdReceivedFromRazor;
  String? paymentIDReceivedFromRazor;
  String? signatureReceivedFromRazor;

  void handlePaymentSuccessResponse(
      PaymentSuccessResponse response, context) async {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    */

    debugPrint(response.orderId.toString());
    debugPrint(response.paymentId.toString());
    debugPrint(response.signature.toString());
    debugPrint(response.data.toString());

    orderIdReceivedFromRazor = response.orderId.toString();
    paymentIDReceivedFromRazor = response.paymentId.toString();
    signatureReceivedFromRazor = response.signature.toString();
    if (popUpCount == 0) {
      popUpCount++;
      Future.delayed(const Duration(milliseconds: 500), () async {
        sendPaymentDetailToServer(context, 'success');
      });
      successDialog(
        context: context,
        message:
            'payment is successfully received. your order id is : $orderIdReceivedFromRazor',
        title: 'Payment Done',
        onTap: () {
          addMoneyAmount.clear();
          Get.back();
          Get.offAllNamed(Routes.dashboard);
        },
      );
    }
  }

  void handleExternalWallet(ExternalWalletResponse response, context) {
    debugPrint('External Wallet is ${response.walletName.toString()}');
  }

  /*----------------------------------------------------------------------------

                                   CASH FREE

  ----------------------------------------------------------------------------*/

  generateCashfreeOrderId(context) async {
    try {
      isLoadingPayment.value = true;
      update();
      final response = await repo!.generateCashfreeOrderId(addMoneyAmount.text);

      if (response is ApiSuccess) {
        final data = response.data;

        if (data['status'] == 1) {
          finalAmount = double.parse(data['data']['order_amount'].toString());
          orderId = data['data']['order_id'];
          paymentSessionId = data['data']['payment_session_id'];
          debugPrint(orderId.toString());
        } else if (data['status'] == 0) {
          errorDialog(context: context, message: data['msg']);
        }
      } else if (response is ApiFailure) {
        debugPrint(response.message.toString());
      } else {
        debugPrint(response.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoadingPayment.value = false;
      update();
      makeCashfreePayment(context);
    }
  }

  String paymentSessionId = "";
  CFEnvironment environment = CFEnvironment.SANDBOX;

  CFSession? createSession() {
    try {
      String oid = orderId;
      String spi = paymentSessionId;
      var session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(oid)
          .setPaymentSessionId(spi)
          .build();
      return session;
    } on CFException catch (e) {
      debugPrint(e.message.toString());
    }
    return null;
  }

  makeCashfreePayment(context) async {
    try {
      var session = createSession();
      var cfWebCheckout =
          CFWebCheckoutPaymentBuilder().setSession(session!).build();
      var cfPaymentGateway = CFPaymentGatewayService();
      cfPaymentGateway.setCallback((vP) {
        debugPrint("VP: ${vP.toString()}");
        getCashFreeOrderById(context, vP.toString());
      }, (response, val) {
        debugPrint("RESPONSE: ${response.getMessage().toString()}");
        debugPrint("VAL: ${val.toString()}");
        getCashFreeOrderById(context, val.toString());
      });
      cfPaymentGateway.doPayment(cfWebCheckout);
    } catch (e) {
      debugPrint(e.toString());
    } finally {}
  }

  getCashFreeOrderById(context, id) async {
    try {
      final response = await repo!.getCashfreeOrderById(id);

      if (response is ApiSuccess) {
        debugPrint(
            'PAYMENT STATUS : ${response.data['status']} ${response.data['data']['order_status']}');

        if (response.data['status'] == 1) {
          debugPrint(
              'PAYMENT STATUS : ${response.data['status']} ${response.data['data']['order_status']}');

          if (response.data['data']['order_status'].toString() == "PAID") {
            successDialog(
              context: context,
              message:
                  'payment is successfully received. your order id is : ${response.data['data']['order_id']}',
              title: 'Payment Done',
              onTap: () {
                addMoneyAmount.clear();
                Get.back();
                Get.back();
              },
            );

            Future.delayed(const Duration(milliseconds: 500), () async {
              sendPaymentDetailToServer(context, 'success');
            });
          } else {
            warningDialog(
                context: context,
                message:
                    'your payment is ${response.data['data']['order_status']}',
                onTap: () {
                  addMoneyAmount.clear();
                  Get.back();
                  Get.back();
                });

            Future.delayed(const Duration(milliseconds: 500), () async {
              sendPaymentDetailToServer(
                  context, response.data['data']['order_status'].toString());
            });
          }
        } else {
          errorDialog(
            context: context,
            message: response.data['msg'],
            onTap: () {
              addMoneyAmount.clear();
              Get.back();
              Get.back();
            },
          );

          Future.delayed(const Duration(milliseconds: 500), () async {
            sendPaymentDetailToServer(context, 'failure');
          });
        }
      } else if (response is ApiFailure) {
        errorDialog(
          context: context,
          message: 'something went wrong!',
          onTap: () {
            addMoneyAmount.clear();
            Get.back();
            Get.back();
          },
        );

        Future.delayed(const Duration(milliseconds: 500), () async {
          sendPaymentDetailToServer(context, 'failure');
        });
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  /// --------------------------- SEND TO SERVER -------------------------------
  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  /*----------------------------------------------------------------------------

    PAYMENT DETAILS
    SUCCESS,FAILURE : SENDING DATA TO THE SERVER AFTER MAKING THE PAYMENT
    IN BOTH THE SCENARIO WHETHER WE GOT SUCCESS OR FAILURE.

  ----------------------------------------------------------------------------*/

  sendPaymentDetailToServer(context, status) async {
    try {
      final response = await repo!.sendPaymentDetails(
        method: 'Razorpay',
        amount: addMoneyAmount.text,
        orderId: orderId.toString(),
        paymentId: '$paymentIDReceivedFromRazor',
        paymentCat: selectedCategory.value == 1 ? 'Non-Utilities' : 'Utilities',

        /// settlementType: selectedSettlement.value == 0
        ///     ? 'Instant'
        ///     : selectedSettlement.value == 1
        ///         ? 'T+1'
        ///         : 'T+5',
        settlementType: 'Instant',
        status: status,
      );

      if (response is ApiSuccess) {
        final data = response.data;
        if (data['data']['status'] == 1) {}
      } else if (response is ApiFailure) {
        debugPrint(response.message.toString());
      } else {
        debugPrint(response.toString());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// Show your unclosable snackbar at top
  void showUnclosableSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.orange,
          ),
          child: Text(
            "Your account is not yet active. Please wait for up to 4 hours, or you will be notified once your account is activated.",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.height / 50,
                ),
            textAlign: TextAlign.center,
          ),
        ),
        duration: const Duration(days: 365), // Never auto-dismiss
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
        dismissDirection: DismissDirection.none,

        /// Unclosable
      ),
    );
  }
}

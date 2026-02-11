import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/pay_vendor/model/beneficiary_list.dart';
import 'package:payhive/modules/pay_vendor/repo/vendor_pay_repo.dart';
import 'package:payhive/modules/pay_vendor/view/add_beneficiary.dart';
import 'package:payhive/services/di/di.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/utils/helper/text_capitalization.dart';
import 'package:payhive/utils/widgets/error.dart';
import 'package:payhive/utils/widgets/pin/pin.dart';
import 'package:payhive/utils/widgets/snackbar.dart';

class VendorPaymentController extends GetxController {
  VendorPayRepo repo = VendorPayRepo();

  @override
  void onInit() {
    super.onInit();
    getAllBeneficiaryList();
    /// cfPaymentGatewayService.setCallback(_onSuccess, _onError);
  }

  RxBool isLoadingBeneficiaries = false.obs;

  BeneficiaryListModel? beneficiaryListModel;
  List<Item> beneficiaryList = [];

  getAllBeneficiaryList() async {
    beneficiaryListModel = null;
    beneficiaryList = [];
    tempList = [];
    isLoadingBeneficiaries.value = true;
    update();

    try {
      final response = await repo.getBeneficiaryList();

      if (response is ApiSuccess) {
        final data = response.data;
        beneficiaryListModel = BeneficiaryListModel.fromJson(data);

        if (data['status'] == 1) {
          if (response.data['data'] != null && response.data['data'] != []) {
            for (int i = 0; i < response.data['data'].length; i++) {
              beneficiaryList.add(beneficiaryListModel!.item![i]);
              tempList.add(beneficiaryListModel!.item![i]);
            }
          }
        } else {}
      } else if (response is ApiFailure) {
        showSnackBar(message: response.message);
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(message: 'Something went wrong');
    } finally {
      isLoadingBeneficiaries.value = false;
      update();
    }
  }

  List<Item> tempList = [];

  TextEditingController searchedText = TextEditingController();

  onSearchTextChanged(String text) async {
    beneficiaryList.clear();
    if (text.isEmpty) {
      beneficiaryList.addAll(tempList);

      update();
      return;
    }

    for (var userDetail in tempList) {
      if (userDetail.name!.toLowerCase().contains(text.toLowerCase())) {
        beneficiaryList.add(userDetail);
      }
    }

    if (kDebugMode) {
      print(beneficiaryList);
    }

    update();
  }

  deleteBeneficiary(context, id) async {
    isLoadingBeneficiaries.value = true;
    update();

    try {
      final response = await repo.deleteBeneficiary(id);

      if (response is ApiSuccess) {
        final data = response.data;

        isLoadingBeneficiaries.value = false;
        update();

        if (data['status'] == 1) {
          successDialog(
            context: context,
            message: data['msg'],
            title: 'Delete Beneficiary',
            onTap: () {
              Get.back();
              getAllBeneficiaryList();
            },
          );
        } else {
          _showError(context: context, message: data['msg']);
        }
      } else if (response is ApiFailure) {
        _showError(context: context, message: response.message);
      }
    } catch (e) {
      debugPrint(e.toString());
      _showError(context: context, message: 'Something went wrong');
    }
  }

  RxBool confirmBankVisible = false.obs;

  TextEditingController ifsc = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController reason = TextEditingController();

  validateBeneficiaryForm({context}) {
    if (accountNumber.text.trim().isEmpty) {
      errorDialog(
        context: context,
        message: 'Kindly enter your bank account number',
        title: 'Bank account',
      );
    } else if (ifsc.text.isEmpty) {
      errorDialog(
        context: context,
        message: 'Kindly enter IFSC code.',
        title: 'IFSC code',
      );
    } else if (phone.text.trim().isEmpty) {
      errorDialog(
        context: context,
        message: 'Kindly enter your phone number',
        title: 'Phone number',
      );
    } else if (phone.text.trim().length != 10) {
      errorDialog(
        context: context,
        message: 'Kindly enter valid phone number',
        title: 'Phone number',
      );
    } else {
      addBeneficiary(context: context);
    }
  }

  RxBool isAddingBeneficiary = false.obs;

  Map<String, dynamic>? responseOfAddBeneficiary;
  addBeneficiary({context, bool isReasonAvailable = false, id}) async {
    isAddingBeneficiary.value = true;
    update();
    try {
      final response = await repo.addBeneficiary(
          ifsc: ifsc.text,
          accountNumber: accountNumber.text,
          phone: phone.text,
          reason: reason.text,
          id: id);

      if (response is ApiSuccess) {
        final data = response.data;

        if (data['status'] == 1) {
          isAddingBeneficiary.value = false;
          update();

          if (isReasonAvailable == true) {
            successDialog(
              context: context,
              message:
                  "${capitalizeFirstCharacter(responseOfAddBeneficiary?['data']['name'])} has been successfully added as beneficiary.",
              title: "Add Beneficiary",
              onTap: () {
                Get.back();
                Get.back();
              },
            );
          } else {
            responseOfAddBeneficiary = data;
            confirmBankVisible.value = true;
            update();
          }
        } else {
          _showError(context: context, message: data['msg']);
        }
      } else if (response is ApiFailure) {
        _showError(context: context, message: response.message);
      }
    } catch (e) {
      debugPrint(e.toString());
      _showError(context: context, message: 'Something went wrong');
    } finally {
      isAddingBeneficiary.value = false;
      update();
    }
  }

  _showError({required context, required String message}) {
    errorDialog(context: context, message: message);
  }

  onTapAddBeneficiaryButton() {
    confirmBankVisible.value = false;
    accountNumber.clear();
    ifsc.clear();
    phone.clear();
    reason.clear();

    Get.to(
      () => const AddBeneficiary(),
      transition: Transition.downToUp,
      duration: const Duration(seconds: 1),
    )!
        .then((v) {
      getAllBeneficiaryList();
    });
  }

  Item? payeeDetails;

  TextEditingController amount = TextEditingController();

  validateTransfer(context) async {
    if (amount.text.isEmpty) {
      errorDialog(
        context: context,
        message: 'Please enter amount',
        title: 'Transfer amount',
      );
    } else {
      pinController.clear();
      pinBottomSheet(context);
    }
  }

  TextEditingController pinController = TextEditingController();

  RxBool isLoadingTransfer = false.obs;

  validatePIN() {
    String first = pinController.text;
    String second = phoneNumber;

    String lastFourFirst =
        first.length >= 4 ? first.substring(first.length - 4) : first;
    String lastFourSecond =
        second.length >= 4 ? second.substring(second.length - 4) : second;

    return lastFourFirst == lastFourSecond;
  }

  transferMoney(context) async {
    if (validatePIN()) {
      isLoadingTransfer.value = true;
      update();

      try {
        final response = await repo.transferMoneyToVendor(
          amount:
              '${double.parse(amount.text.toString()) + double.parse(marginPerTransaction)}',
          id: payeeDetails!.fundAccountId.toString(),
        );

        if (response is ApiSuccess) {
          final data = response.data;

          if (data['status'] == 1) {
            successDialog(
                context: context,
                message: data['msg'],
                onTap: () {
                  Get.back();
                  Get.back();
                  Get.back();
                });
          } else {
            _showError(context: context, message: data['msg']);
          }
        } else if (response is ApiFailure) {
          _showError(context: context, message: response.message);
        }
      } catch (e) {
        debugPrint(e.toString());
        _showError(context: context, message: 'Something went wrong');
      } finally {
        isLoadingTransfer.value = false;
        update();
      }
    } else {
      errorDialog(
          context: context,
          message: "Please enter correct PIN",
          title: "Incorrect PIN");
    }
  }

  /// --------------------------------------------------------------------------
  /// ------------------------------- CASHFREE ---------------------------------
  /// --------------------------------------------------------------------------

  // double finalAmount = 0;
  // TextEditingController addMoneyAmount = TextEditingController();
  // RxBool isLoadingPayment = false.obs;
  //
  // CFEnvironment environment = CFEnvironment.SANDBOX;
  // CFPaymentGatewayService cfPaymentGatewayService = CFPaymentGatewayService();
  // String orderId = '';
  // String paymentSessionId = '';
  //
  // generateCashfreeOrderId(context) async {
  //   try {
  //     isLoadingPayment.value = true;
  //     update();
  //     final response = await repo.generateCashfreeOrderId(addMoneyAmount.text);
  //
  //     if (response is ApiSuccess) {
  //       final data = response.data;
  //
  //       if (data['status'] == 1) {
  //         finalAmount = double.parse(data['data']['order_amount'].toString());
  //         orderId = data['data']['order_id'];
  //         paymentSessionId = data['data']['payment_session_id'];
  //         makeCashfreePayment(context);
  //         debugPrint(orderId.toString());
  //       } else if (data['status'] == 0) {
  //         errorDialog(context: context, message: data['msg']);
  //       }
  //     } else if (response is ApiFailure) {
  //       debugPrint(response.message.toString());
  //     } else {
  //       debugPrint(response.toString());
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   } finally {
  //     isLoadingPayment.value = false;
  //     update();
  //   }
  // }
  //
  // CFSession? createSession() {
  //   try {
  //     String oid = orderId;
  //     String spi = paymentSessionId;
  //     var session = CFSessionBuilder()
  //         .setEnvironment(environment)
  //         .setOrderId(oid)
  //         .setPaymentSessionId(spi)
  //         .build();
  //     return session;
  //   } on CFException catch (e) {
  //     debugPrint(e.message.toString());
  //   }
  //   return null;
  // }
  //
  // void _onSuccess(String orderId) {
  //   debugPrint("Payment Successful: $orderId");
  // }
  //
  // void _onError(CFErrorResponse error, String orderId) {
  //   debugPrint("Payment Failed: ${error.getMessage()}");
  // }
  //
  // makeCashfreePayment(context) async {
  //   try {
  //     var session = createSession();
  //     var cfWebCheckout =
  //         CFWebCheckoutPaymentBuilder().setSession(session!).build();
  //     var cfPaymentGateway = CFPaymentGatewayService();
  //     cfPaymentGateway.setCallback((vP) {
  //       debugPrint("VP: ${vP.toString()}");
  //       getCashFreeOrderById(context, vP.toString());
  //     }, (response, val) {
  //       debugPrint("RESPONSE: ${response.getMessage().toString()}");
  //       debugPrint("VAL: ${val.toString()}");
  //       getCashFreeOrderById(context, val.toString());
  //     });
  //     cfPaymentGateway.doPayment(cfWebCheckout);
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   } finally {}
  // }

  // getCashFreeOrderById(context, id) async {
  //   try {
  //     final response = await repo.getCashfreeOrderById(id);
  //
  //     if (response is ApiSuccess) {
  //       debugPrint(
  //           'PAYMENT STATUS : ${response.data['status']} ${response.data['data']['order_status']}');
  //
  //       if (response.data['status'] == 1) {
  //         debugPrint(
  //             'PAYMENT STATUS : ${response.data['status']} ${response.data['data']['order_status']}');
  //
  //         if (response.data['data']['order_status'].toString() == "PAID") {
  //           successDialog(
  //             context: context,
  //             message:
  //                 'payment is successfully received. your order id is : ${response.data['data']['order_id']}',
  //             title: 'Payment Done',
  //             onTap: () {
  //               addMoneyAmount.clear();
  //               Get.back();
  //               Get.back();
  //             },
  //           );
  //
  //           Future.delayed(const Duration(milliseconds: 500), () async {
  //             sendPaymentDetailToServer(context, 'success');
  //           });
  //         } else {
  //           warningDialog(
  //               context: context,
  //               message:
  //                   'your payment is ${response.data['data']['order_status']}',
  //               onTap: () {
  //                 addMoneyAmount.clear();
  //                 Get.back();
  //                 Get.back();
  //               });
  //
  //           Future.delayed(const Duration(milliseconds: 500), () async {
  //             sendPaymentDetailToServer(
  //                 context, response.data['data']['order_status'].toString());
  //           });
  //         }
  //       } else {
  //         errorDialog(
  //           context: context,
  //           message: response.data['msg'],
  //           onTap: () {
  //             addMoneyAmount.clear();
  //             Get.back();
  //             Get.back();
  //           },
  //         );
  //
  //         Future.delayed(const Duration(milliseconds: 500), () async {
  //           sendPaymentDetailToServer(context, 'failure');
  //         });
  //       }
  //     } else if (response is ApiFailure) {
  //       errorDialog(
  //         context: context,
  //         message: 'something went wrong!',
  //         onTap: () {
  //           addMoneyAmount.clear();
  //           Get.back();
  //           Get.back();
  //         },
  //       );
  //
  //       Future.delayed(const Duration(milliseconds: 500), () async {
  //         sendPaymentDetailToServer(context, 'failure');
  //       });
  //     } else {}
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
}

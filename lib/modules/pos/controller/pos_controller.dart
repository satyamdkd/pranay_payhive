import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payhive/modules/list_pos_req/model/all_pos_request.dart';
import 'package:payhive/modules/pos/model/bank_data.dart';
import 'package:payhive/modules/pos/model/serial_number_model.dart';
import 'package:payhive/modules/pos/repo/pos_repo.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/error.dart';
import 'package:payhive/utils/widgets/image_bottomsheet.dart';
import 'package:payhive/utils/widgets/snackbar.dart';

class PosController extends GetxController {
  POSRepo repo = POSRepo();

  PosRequestItem? posData;

  @override
  void onInit() {
    super.onInit();

    getSerialNumber();
  }

  List<String> tempCardType = [];
  List<String> tempCards = [];

  setDataIfEditing() async {
    var args = Get.arguments;

    debugPrint(args.toString());

    if (args != null) {
      isEditingPageLoading.value = true;
      update();

      posData = args;
      posReqId = posData!.id.toString();
      selectDate.text = posData!.transactionDate!;
      amount.text = posData!.amount!;
      serialNumber.text = posData!.serialno!;
      selectedCardType = posData!.cardTypeName!;
      selectedBank = posData!.bankName!;
      serialNumber.text = posData!.serialno!;
      selectedSerialNumber = posData!.serialno!;

      serialNumberId = posData!.serialno;

      cardTypeID = posData!.cardtypeid!.toString();
      cardID = posData!.poscardid.toString();

      bankID = posData!.bankid!.toString();

      tidToSendInApi = posData!.tid!;
      tid.text = 'TID : ${posData!.tid}';

      hideMidTid.value = true;
      selectedCard = posData!.cardName!;
      rRNSlipNumber.text = posData!.rrnNumber!;

      document.text = posData!.chargeSlip!;

      callAPIsIfEditing();
    }
  }

  RxBool isEditingPageLoading = false.obs;

  callAPIsIfEditing() async {
    try {
      await onClickSerialNumber();
      await getCardType();
      await getAllCards();

      midTidList = [];
      update();
      var data = bankModel!.data!
          .firstWhere((element) => element.bankname == selectedBank);
      bankID = data.bankid.toString();

      debugPrint(bankID.toString());

      if (data.devices != null && data.devices!.isNotEmpty) {
        midTidList.addAll(data.devices!);
        debugPrint('Length : ${midTidList.length.toString()}');
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isEditingPageLoading.value = false;
      update();
    }
  }

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Map<String, dynamic>? bankModelData;
  BankData? bankModel;

  List<BankItem>? bankList = [];
  List<String>? bankStringList = [];
  List<String>? cardTYPE = [];
  RxBool isBankListLoading = false.obs;

  List<MidTid> midTidList = [];
  RxBool hideMidTid = false.obs;

  getBankId() {
    midTidList = [];
    update();
    var data = bankModel!.data!
        .firstWhere((element) => element.bankname == selectedBank);
    bankID = data.bankid.toString();

    debugPrint(bankID.toString());

    if (data.devices != null && data.devices!.isNotEmpty) {
      midTidList.addAll(data.devices!);
      debugPrint('Length : ${midTidList.length.toString()}');
    }

    update();
    getCardType();
  }

  getBankList() async {
    try {
      bankList = [];
      bankStringList = [];

      cardTypeModel = null;
      cardTYPEStringList = [];
      cardTYPEList = [];

      cardsStringList = [];
      cardsList = [];
      cardsModel = null;

      isBankListLoading.value = true;
      update();

      final response = await repo.getBankList(serialNumberId);

      if (response is ApiSuccess) {
        final data = response.data;
        bankModel = BankData.fromJson(data);

        if (data['status'] == 1) {
          if (response.data['data'] != null && response.data['data'] != []) {
            for (int i = 0; i < response.data['data'].length; i++) {
              if (response.data['data'][i]['bankname'] != null &&
                  response.data['data'][i]['bankname'] != '') {
                bankList!.add(BankItem.fromJson(response.data['data'][i]));
                bankStringList?.add(response.data['data'][i]['bankname']);
              }
            }
          }
        } else {
          _showError(data['msg']);
        }
      } else if (response is ApiFailure) {
        _showError(response.message);
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(message: 'Something went wrong.', title: 'Payhive');
    } finally {
      isBankListLoading.value = false;

      if (tempCardType.isNotEmpty) {
        cardTYPEStringList.addAll(tempCardType);
        cardsStringList.addAll(tempCards);
      }
      update();
    }
  }

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  SerialNumberModel? cardTypeModel;
  List<String> cardTYPEStringList = [];
  List<SerialNumberItem> cardTYPEList = [];
  RxBool cardTypeLoading = false.obs;
  RxBool hideCardType = false.obs;
  String selectedCardType = '';
  String cardTypeID = '';

  getCardType() async {
    try {
      cardTypeModel = null;
      cardTYPEStringList = [];
      cardTYPEList = [];

      cardsStringList = [];
      cardsList = [];
      cardsModel = null;

      cardTypeLoading.value = true;
      update();

      final response = await repo.getCardTYPE(bankID);

      if (response is ApiSuccess) {
        final data = response.data;
        cardTypeModel = SerialNumberModel.fromJson(data);

        if (data['status'] == 1) {
          if (response.data['data'] != null && response.data['data'] != []) {
            for (int i = 0; i < response.data['data'].length; i++) {
              if (response.data['data'][i]['cardtype_name'] != null &&
                  response.data['data'][i]['cardtype_name'] != '') {
                cardTYPEList
                    .add(SerialNumberItem.fromJson(response.data['data'][i]));
                cardTYPEStringList
                    .add(response.data['data'][i]['cardtype_name']);
              }
            }
          }
        } else {
          _showError(data['msg']);
        }
      } else if (response is ApiFailure) {
        _showError(response.message);
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(message: 'Something went wrong.', title: 'Payhive');
    } finally {
      cardTypeLoading.value = false;
      debugPrint(cardTYPEStringList.toString());

      update();
    }
  }

  getCardTypeId() {
    var data = cardTypeModel!.data!
        .firstWhere((element) => element.cardType == selectedCardType);
    cardTypeID = data.id.toString();

    debugPrint(cardTypeID.toString());

    getAllCards();
    update();
  }

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  SerialNumberModel? cardsModel;
  List<String> cardsStringList = [];
  List<SerialNumberItem> cardsList = [];
  RxBool cardsLoading = false.obs;
  String cardID = '';

  getCardId() {
    var data = cardsModel!.data!.firstWhere(
        (element) => element.cardname!.trim() == selectedCard!.trim());
    cardID = data.poscardid.toString();

    debugPrint(cardID.toString());

    update();
  }

  getAllCards() async {
    try {
      cardsStringList = [];
      cardsList = [];
      cardsModel = null;
      cardsLoading.value = true;
      update();

      final response = await repo.getAllCards(cardTypeID, bankID);

      if (response is ApiSuccess) {
        final data = response.data;
        cardsModel = SerialNumberModel.fromJson(data);

        if (data['status'] == 1) {
          if (response.data['data'] != null && response.data['data'] != []) {
            for (int i = 0; i < response.data['data'].length; i++) {
              if (response.data['data'][i]['cardname'] != null &&
                  response.data['data'][i]['cardname'] != '') {
                cardsList
                    .add(SerialNumberItem.fromJson(response.data['data'][i]));
                cardsStringList.add(response.data['data'][i]['cardname']);
              }
            }
          }
        } else {
          _showError(data['msg']);
        }
      } else if (response is ApiFailure) {
        _showError(response.message);
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(message: 'Something went wrong.', title: 'PayLix');
    } finally {
      cardsLoading.value = false;
      update();
    }
  }

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  List<String> serialNumberStringList = [];
  List<SerialNumberItem> serialNumberList = [];
  RxBool serialNumberLoading = false.obs;
  SerialNumberModel? serialNumberModel;
  String? serialNumberId;

  onClickSerialNumber() async {
    var data = serialNumberModel!.data!
        .firstWhere((element) => element.serialno == selectedSerialNumber);
    serialNumberId = data.id.toString();

    getBankList();
  }

  getSerialNumber() async {
    try {
      serialNumberList = [];
      serialNumberStringList = [];
      serialNumberLoading.value = true;
      update();

      final response = await repo.getSerialNumberList();

      if (response is ApiSuccess) {
        final data = response.data;
        serialNumberModel = SerialNumberModel.fromJson(data);

        if (data['status'] == 1) {
          if (response.data['data'] != null && response.data['data'] != []) {
            for (int i = 0; i < response.data['data'].length; i++) {
              serialNumberStringList
                  .add(response.data['data'][i]['serialno'].toString());
              serialNumberList
                  .add(SerialNumberItem.fromJson(response.data['data'][i]));
            }
          }
        } else {
          _showError(data['msg']);
        }
      } else if (response is ApiFailure) {
        _showError(response.message);
      }
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(message: 'Something went wrong.', title: 'PayLix');
    } finally {
      serialNumberLoading.value = false;
      update();

      setDataIfEditing();
    }
  }

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  pickDocument(context) async {
    AppBottomSheet.kImagePickerBottomSheet(
      context,
      onCameraTap: () async {
        Get.close(1);
        pickMyFile(ImageSource.camera);
      },
      onGalleryTap: () async {
        Get.close(1);
        pickMyFile(ImageSource.gallery);
      },
    );
  }

  final ImagePicker _picker = ImagePicker();

  pickMyFile(ImageSource source) async {
    XFile? image = await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (image != null) {
      file = File(image.path);
      document.text = image.name;
      update();
    }
  }

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  TextEditingController selectDate = TextEditingController();

  dateTimePicker(context) async {
    final DateTime? pickedDate = await showDatePicker(
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: appColors.primaryLight, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: appColors.primaryColor, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: appColors.primaryColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      final date = pickedDate;
      selectDate.text = '${date.day}/${date.month}/${date.year}';
      update();
    }
  }

  TextEditingController serialNumber = TextEditingController();

  TextEditingController amount = TextEditingController();
  TextEditingController rRNSlipNumber = TextEditingController();
  TextEditingController mid = TextEditingController();
  TextEditingController tid = TextEditingController();
  TextEditingController document = TextEditingController();

  File? file;
  String? selectedBank;
  String? bankID;
  String? tidToSendInApi;
  String? midToSendInApi;
  String? selectedCard;

  String? selectedSerialNumber;
  RxBool hideSerialNumber = true.obs;

  validatePOSForm(context) {
    if (selectDate.text.isEmpty) {
      errorDialog(
        context: context,
        message: 'Kindly select transaction date.',
        title: 'Select Date',
      );
    } else if (amount.text.trim().isEmpty) {
      errorDialog(
        context: context,
        message: 'Kindly enter your amount',
        title: 'Transaction Amount',
      );
    } else if (serialNumber.text.isEmpty) {
      errorDialog(
          context: context,
          message: 'Kindly select serial number',
          title: 'Serial number');
    } else if (selectedBank == null) {
      errorDialog(
        context: context,
        message: 'Kindly select bank',
        title: 'Bank',
      );
    } else if (selectedCardType == '') {
      errorDialog(
        context: context,
        message: 'Kindly select card type',
        title: 'Card Type',
      );
    } else if (selectedCard == null) {
      errorDialog(
        context: context,
        message: 'Kindly select card network type',
        title: 'Card Network Type',
      );
    } else if (tidToSendInApi == null) {
      errorDialog(
        context: context,
        message: 'Kindly select TID',
        title: 'TID',
      );
    } else if (rRNSlipNumber.text.trim().isEmpty) {
      errorDialog(
        context: context,
        message: 'Kindly enter RRN',
        title: 'RRN',
      );
    } else if (document.text.isEmpty) {
      errorDialog(
        context: context,
        message: 'Kindly upload your slip',
        title: 'Upload slip',
      );
    } else {
      posRequest(context);
    }
    update();
  }

  RxBool isLoading = false.obs;

  String? posReqId;

  posRequest(context) async {
    try {
      isLoading.value = true;
      update();

      final response = await repo.posRequest(
        posReqId: posReqId,
        date: selectDate.text,
        amount: amount.text,
        serialNumberId: serialNumber.text,
        bankId: bankID!,
        tid: tidToSendInApi!,
        cardType: selectedCard!,
        rrn: rRNSlipNumber.text,
        doc: file,
        cardTypeId: cardTypeID,
        posCardId: cardID,
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
              });

          /// Future.delayed(Duration.zero, () {
          ///   showSnackBar(
          ///       message: 'P.O.S Requested successfully', title: 'P.O.S');
          /// });
          ///
          /// Get.back();
        } else {
          errorDialog(context: context, message: data['msg']);

          /// _showError(data['msg']);
        }
      } else if (response is ApiFailure) {
        errorDialog(context: context, message: response.message);

        /// _showError(response.message);
      }
    } catch (e) {
      debugPrint(e.toString());
      errorDialog(context: context, message: 'Something went wrong.');

      /// showSnackBar(message: 'Something went wrong.', title: 'PayLix');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  _showError(String message) {
    update();

    showSnackBar(
      message: message,
      title: "PayLix",
      color: appColors.red,
    );
  }

  /// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
}

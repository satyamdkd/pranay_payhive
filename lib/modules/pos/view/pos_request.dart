import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart' show Lottie;
import 'package:payhive/modules/pos/controller/pos_controller.dart';
import 'package:payhive/modules/pos/view/view_doc.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';

class PosRequest extends GetView<PosController> {
  const PosRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.white,
      appBar: appBar(),
      body: SingleChildScrollView(
        child: GetBuilder<PosController>(
            init: controller,
            builder: (ctx) {
              return controller.isEditingPageLoading.value
                  ? SizedBox(
                      height: MediaQuery.sizeOf(context).height - 100,
                      width: MediaQuery.sizeOf(context).width,
                      child: Center(
                        child: Lottie.asset(
                          'assets/lottie/wave_loading.json',
                          width: width,
                          height: height / 3,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(height: height / 25),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: height / 30),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: appColors.primaryLight, width: 0.5),
                            gradient: const LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [-2, 1],
                              colors: [
                                Color(0xffffffff),
                                Color(0xffffffff),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(height / 30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.2),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(height / 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: height / 120),
                                selectBank(context),
                                SizedBox(height: height / 30),
                                enterAmount(),
                                SizedBox(height: height / 30),
                                selectSerialNumber(),
                                serialNumberListWidget(context),
                                controller.isBankListLoading.value
                                    ? Lottie.asset(
                                        'assets/lottie/wave_loading.json',
                                        width: width,
                                        height: height / 5)
                                    : controller.bankStringList != null &&
                                            controller
                                                .bankStringList!.isNotEmpty
                                        ? selectBankList(context)
                                        : SizedBox(height: height / 30),
                                if (controller.selectedBank != null)
                                  selectTID(),
                                midTidListWidget(context),
                                if (controller.selectedBank != null)
                                  SizedBox(height: height / 30),
                                rnnNumber(),
                                SizedBox(height: height / 30),
                                doc(context),
                                if (controller.file != null ||
                                    controller.document.text.isNotEmpty)
                                  SizedBox(height: height / 60),
                                if (controller.file != null ||
                                    controller.document.text.isNotEmpty)
                                  viewOrDelete(context),
                                SizedBox(height: height / 30),
                                controller.isLoading.value == false
                                    ? submit(context)
                                    : Lottie.asset(
                                        'assets/lottie/wave_loading.json',
                                        width: width,
                                        height: height / 4),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: height / 25),
                      ],
                    );
            }),
      ),
    );
  }

  Row viewOrDelete(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            controller.file = null;
            controller.document.clear();
            controller.update();
          },
          child: Text(
            "DELETE",
            style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.redAccent,
                letterSpacing: 1,
                fontSize: height / 30,
                fontWeight: FontWeight.w700),
          ),
        ),
        SizedBox(
          width: width / 30,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
              ViewDocument(
                docPath: controller.document.text,
                file: controller.file,
              ),
            );
          },
          child: Text(
            "VIEW  ",
            style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.green,
                letterSpacing: 2,
                fontSize: height / 30,
                fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  InkWell doc(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.pickDocument(context);
      },
      child: IgnorePointer(
        ignoring: true,
        child: customTextField(
          textEditingController: controller.document,
          title: '',
          fullTag: 'Upload slip',
          filled: true,
          readOnly: true,
          fillColor: appColors.primaryColor.withValues(alpha: 0.8),
          border: false,
          keyboardType: TextInputType.number,
          textColor: appColors.white,
          hintColor: appColors.white,
          prefixIcon: Container(
            padding: EdgeInsets.symmetric(
              vertical: height / 30,
              horizontal: width / 60,
            ),
            child: Icon(
              Icons.upload_file_rounded,
              size: height / 18,
              color: appColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget rnnNumber() {
    return customTextField(
      textEditingController: controller.rRNSlipNumber,
      title: '',
      fullTag: 'Enter RRN From Slip',
      filled: true,
      fillColor: appColors.primaryColor.withValues(alpha: 0.8),
      border: false,
      keyboardType: TextInputType.text,
      textColor: appColors.white,
      hintColor: appColors.white,
      prefixIcon: Container(
        padding: EdgeInsets.symmetric(
          vertical: height / 30,
          horizontal: width / 60,
        ),
        child: Icon(
          Icons.receipt_rounded,
          size: height / 18,
          color: appColors.white,
        ),
      ),
    );
  }

  InkWell selectTID() {
    return InkWell(
      onTap: () {
        controller.hideMidTid.value = !controller.hideMidTid.value;

        controller.hideSerialNumber.value = true;
        controller.update();
      },
      child: IgnorePointer(
        ignoring: true,
        child: customTextField(
          textEditingController: controller.tid,
          title: '',
          fullTag: 'Select T.I.D',
          filled: true,
          readOnly: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: controller.hideMidTid.value == false
                ? BorderRadius.only(
                    topLeft: Radius.circular(width / 50),
                    topRight: Radius.circular(width / 50),
                  )
                : BorderRadius.circular(width / 50),
            borderSide: BorderSide.none,
          ),
          fillColor: appColors.primaryColor.withValues(alpha: 0.8),
          border: false,
          textColor: appColors.white,
          hintColor: appColors.white,
          prefixIcon: Container(
            padding: EdgeInsets.symmetric(
              vertical: height / 30,
              horizontal: width / 30,
            ),
            child: Icon(
              Icons.confirmation_number_rounded,
              size: height / 18,
              color: appColors.white,
            ),
          ),
          suffixIcon: Container(
            padding: EdgeInsets.symmetric(
              vertical: height / 30,
              horizontal: width / 30,
            ),
            child: Icon(
              Icons.arrow_drop_down_rounded,
              size: height / 18,
              color: appColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Column selectBankList(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height / 20),
        if (controller.bankStringList != null &&
            controller.bankStringList!.isNotEmpty)
          Text(
            'Select Bank',
            style: context.textTheme.bodySmall!.copyWith(
              fontSize: height / 28,
              letterSpacing: 2,
              color: appColors.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        SizedBox(height: height / 40),
        if (controller.bankStringList != null &&
            controller.bankStringList!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Wrap(
              spacing: width / 60,
              runSpacing: width / 60,
              children: List.generate(
                controller.bankStringList!.length,
                (ind) {
                  final bank = controller.bankStringList![ind];
                  final isSelected = controller.selectedBank == bank;

                  return IntrinsicWidth(
                    child: InkWell(
                      onTap: () {
                        controller.selectedBank = bank;

                        controller.selectedCardType = '';
                        controller.selectedCard = null;
                        controller.tidToSendInApi = null;
                        controller.tid.clear();

                        controller.getBankId();

                        controller.update();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          vertical: height / 80,
                          horizontal: width / 30,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isSelected
                                  ? appColors.primaryColor
                                  : appColors.grey,
                              width: 0.5),
                          gradient: isSelected
                              ? LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topRight,
                                  stops: const [-2, 1],
                                  colors: [
                                    appColors.primaryLight
                                        .withValues(alpha: 0.7),
                                    appColors.primaryColor,
                                  ],
                                )
                              : const LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  stops: [-2, 1],
                                  colors: [
                                    Color(0xffffffff),
                                    Color(0xffffffff),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(height / 90),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Text(
                          controller.bankStringList![ind],
                          style: context.textTheme.bodySmall!.copyWith(
                            fontSize: height / 30,
                            letterSpacing: 1,
                            color: isSelected
                                ? appColors.white
                                : appColors.textExtraLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        controller.cardTypeLoading.value
            ? Lottie.asset('assets/lottie/wave_loading.json',
                width: width, height: height / 5)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height / 30),
                  if (controller.cardTYPEStringList.isNotEmpty)
                    Text(
                      'Card Type',
                      style: context.textTheme.bodySmall!.copyWith(
                        fontSize: height / 28,
                        letterSpacing: 2,
                        color: appColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  SizedBox(height: height / 40),
                  if (controller.cardTYPEStringList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Wrap(
                        spacing: width / 60,
                        runSpacing: width / 60,
                        children: List.generate(
                          controller.cardTYPEStringList.length,
                          (ind) {
                            final card = controller.cardTYPEStringList[ind];
                            final isSelected =
                                controller.selectedCardType == card;

                            return IntrinsicWidth(
                              child: InkWell(
                                onTap: () {
                                  controller.selectedCardType = card;

                                  controller.selectedCard = null;
                                  controller.tidToSendInApi = null;
                                  controller.tid.clear();

                                  controller.getCardTypeId();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: height / 80,
                                    horizontal: width / 30,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: isSelected
                                            ? appColors.primaryColor
                                            : appColors.grey,
                                        width: 0.5),
                                    gradient: isSelected
                                        ? LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topRight,
                                            stops: const [-2, 1],
                                            colors: [
                                              appColors.primaryLight
                                                  .withValues(alpha: 0.7),
                                              appColors.primaryColor,
                                            ],
                                          )
                                        : const LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            stops: [-2, 1],
                                            colors: [
                                              Color(0xffffffff),
                                              Color(0xffffffff),
                                            ],
                                          ),
                                    borderRadius:
                                        BorderRadius.circular(height / 90),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.grey.withValues(alpha: 0.2),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    controller.cardTYPEStringList[ind],
                                    style:
                                        context.textTheme.bodySmall!.copyWith(
                                      fontSize: height / 30,
                                      letterSpacing: 1,
                                      color: isSelected
                                          ? appColors.white
                                          : appColors.textExtraLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  SizedBox(height: height / 30),
                ],
              ),
        controller.cardsLoading.value
            ? Lottie.asset(
                'assets/lottie/wave_loading.json',
                width: width,
                height: height / 5,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.cardsStringList.isNotEmpty)
                    Text(
                      'Card Network Type',
                      style: context.textTheme.bodySmall!.copyWith(
                        fontSize: height / 28,
                        letterSpacing: 2,
                        color: appColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  SizedBox(height: height / 40),
                  if (controller.cardsStringList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Wrap(
                        spacing: width / 60,
                        runSpacing: width / 60,
                        children: List.generate(
                          controller.cardsStringList.length,
                          (ind) {
                            final card = controller.cardsStringList[ind];
                            final isSelected = controller.selectedCard == card;

                            return IntrinsicWidth(
                              child: InkWell(
                                onTap: () {
                                  controller.selectedCard = card;

                                  controller.getCardId();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: height / 80,
                                    horizontal: width / 30,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: isSelected
                                            ? appColors.primaryColor
                                            : appColors.grey,
                                        width: 0.5),
                                    gradient: isSelected
                                        ? LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topRight,
                                            stops: const [-2, 1],
                                            colors: [
                                              appColors.primaryLight
                                                  .withValues(alpha: 0.7),
                                              appColors.primaryColor,
                                            ],
                                          )
                                        : const LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.topRight,
                                            stops: [-2, 1],
                                            colors: [
                                              Color(0xffffffff),
                                              Color(0xffffffff),
                                            ],
                                          ),
                                    borderRadius:
                                        BorderRadius.circular(height / 90),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.grey.withValues(alpha: 0.2),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    controller.cardsStringList[ind],
                                    style:
                                        context.textTheme.bodySmall!.copyWith(
                                      fontSize: height / 30,
                                      letterSpacing: 1,
                                      color: isSelected
                                          ? appColors.white
                                          : appColors.textExtraLight,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
        SizedBox(height: height / 16),
      ],
    );
  }

  InkWell selectSerialNumber() {
    return InkWell(
      onTap: () {
        controller.hideSerialNumber.value = !controller.hideSerialNumber.value;

        controller.hideMidTid.value = true;

        controller.update();
      },
      child: IgnorePointer(
        ignoring: true,
        child: customTextField(
          textEditingController: controller.serialNumber,
          title: '',
          fullTag: 'Select Serial Number',
          filled: true,
          readOnly: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: controller.hideSerialNumber.value == false
                ? BorderRadius.only(
                    topLeft: Radius.circular(width / 50),
                    topRight: Radius.circular(width / 50),
                  )
                : BorderRadius.circular(width / 50),
            borderSide: BorderSide.none,
          ),
          fillColor: appColors.primaryColor.withValues(alpha: 0.8),
          border: false,
          textColor: appColors.white,
          hintColor: appColors.white,
          prefixIcon: Container(
            padding: EdgeInsets.symmetric(
              vertical: height / 30,
              horizontal: width / 30,
            ),
            child: Icon(
              Icons.confirmation_number_rounded,
              size: height / 18,
              color: appColors.white,
            ),
          ),
          suffixIcon: Container(
            padding: EdgeInsets.symmetric(
              vertical: height / 30,
              horizontal: width / 30,
            ),
            child: Icon(
              Icons.arrow_drop_down_rounded,
              size: height / 18,
              color: appColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget enterAmount() {
    return customTextField(
      textEditingController: controller.amount,
      title: '',
      fullTag: 'Enter Amount',
      filled: true,
      inputFormatter: [
        FilteringTextInputFormatter.deny(
        RegExp(r'[!@#$%^&*(),.?":{}|<>-]'))
    ],
      fillColor: appColors.primaryColor.withValues(alpha: 0.8),
      border: false,
      keyboardType: TextInputType.number,
      textColor: appColors.white,
      hintColor: appColors.white,
      prefixIcon: Container(
        padding: EdgeInsets.symmetric(
          vertical: height / 30,
          horizontal: width / 60,
        ),
        child: Icon(
          Icons.currency_rupee_rounded,
          size: height / 18,
          color: appColors.white,
        ),
      ),
    );
  }

  InkWell selectBank(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.dateTimePicker(context);
      },
      child: IgnorePointer(
        ignoring: true,
        child: customTextField(
          textEditingController: controller.selectDate,
          title: '',
          fullTag: 'Select Date',
          filled: true,
          readOnly: true,
          fillColor: appColors.primaryColor.withValues(alpha: 0.8),
          border: false,
          textColor: appColors.white,
          hintColor: appColors.white,
          prefixIcon: Container(
            padding: EdgeInsets.symmetric(
              vertical: height / 30,
              horizontal: width / 30,
            ),
            child: Icon(
              CupertinoIcons.calendar,
              size: height / 18,
              color: appColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget submit(BuildContext context) {
    return customButton(
      title: "Submit",
      onTap: () {
        controller.validatePOSForm(context);
      },
      border: Border.all(
        color: appColors.primaryColor,
        width: 0.35,
      ),
      gradColor: [
        appColors.primaryLight.withValues(alpha: 0.7),
        appColors.primaryColor,
      ],
      passedHeight: height / 8,
      context: context,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: appColors.white,
        fontWeight: FontWeight.w500,
        fontSize: height / 24,
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: appColors.primaryColor,
      leadingWidth: width,
      leading: Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(bottom: width / 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            backButton(),
          ],
        ),
      ),
    );
  }

  Widget midTidListWidget(context) {
    if (controller.midTidList.isNotEmpty) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: controller.hideMidTid.value == false
            ? (controller.serialNumberStringList.length < 5
                ? controller.serialNumberStringList.length * height / 7
                : height / 2.9)
            : 0,
        padding: EdgeInsets.only(top: width / 30),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          border: Border.all(
              width: 0.5, color: appColors.primaryColor.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.25),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: controller.midTidList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                controller.hideMidTid.value = true;
                controller.mid.text =
                    controller.midTidList[index].mid.toString();
                controller.tid.text =
                    'TID : ${controller.midTidList[index].tid.toString()}';
                controller.tidToSendInApi =
                    controller.midTidList[index].tid.toString();
                controller.midToSendInApi =
                    controller.midTidList[index].tid.toString();
                debugPrint(controller.mid.toString());

                controller.update();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width / 40.0, vertical: height / 80.0),
                margin: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
                decoration: BoxDecoration(
                    gradient: controller.midTidList[index].tid ==
                            controller.tidToSendInApi
                        ? LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: const [-2, 1],
                            colors: [
                              appColors.primaryLight,
                              appColors.red,
                            ],
                          )
                        : const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [-2, 1],
                            colors: [
                              Color(0xffffffff),
                              Color(0xffffffff),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                  '${controller.selectedBank} - TID ${controller.midTidList[index].tid!}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: controller.midTidList[index].tid ==
                            controller.tidToSendInApi
                        ? appColors.white
                        : appColors.black,
                    fontSize: height / 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget serialNumberListWidget(context) {
    if (controller.serialNumberStringList.isNotEmpty) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: controller.hideSerialNumber.value == false
            ? (controller.serialNumberStringList.length < 5
                ? controller.serialNumberStringList.length * height / 7
                : height / 2.9)
            : 0,
        padding: EdgeInsets.only(top: width / 30),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          border: Border.all(
              width: 0.5, color: appColors.primaryColor.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.25),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: controller.serialNumberStringList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                controller.selectedBank = null;
                controller.selectedCardType = '';
                controller.selectedCard = null;
                controller.tidToSendInApi = null;
                controller.tid.clear();

                controller.midTidList.clear();

                controller.hideSerialNumber.value = true;
                controller.selectedSerialNumber =
                    controller.serialNumberStringList[index];

                controller.serialNumber.text =
                    controller.serialNumberStringList[index];
                controller.update();

                controller.onClickSerialNumber();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width / 40.0, vertical: height / 80.0),
                margin: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
                decoration: BoxDecoration(
                    gradient: controller.serialNumberStringList[index] ==
                            controller.selectedSerialNumber
                        ? LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: const [-2, 1],
                            colors: [
                              appColors.primaryLight,
                              appColors.red,
                            ],
                          )
                        : const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            stops: [-2, 1],
                            colors: [
                              Color(0xffffffff),
                              Color(0xffffffff),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                  ' ${controller.serialNumberStringList[index]} '.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: controller.serialNumberStringList[index] ==
                            controller.selectedSerialNumber
                        ? appColors.white
                        : appColors.black,
                    letterSpacing: 1,
                    fontSize: height / 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          },
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  GestureDetector backButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Row(
        children: [
          SizedBox(width: width / 30),
          Icon(
            Icons.arrow_back_ios_new_rounded,
            size: height / 14,
            color: appColors.white,
          ),
          SizedBox(width: width / 80),
          Text(
            " P.O.S Request",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.white,
              letterSpacing: 1,
              fontWeight: FontWeight.w400,
              fontSize: height / 18,
            ),
          ),
        ],
      ),
    );
  }
}

///-----------------------------------------------------------------------------
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart' show Lottie;
// import 'package:payhive/modules/pos/controller/pos_controller.dart';
// import 'package:payhive/modules/pos/view/view_doc.dart';
// import 'package:payhive/utils/screen_size.dart';
// import 'package:payhive/utils/theme/apptheme.dart';
// import 'package:payhive/utils/widgets/textfield.dart';
//
// class PosRequest extends GetView<PosController> {
//   const PosRequest({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: appColors.white,
//       appBar: appBar(),
//       body: SingleChildScrollView(
//         child: GetBuilder<PosController>(
//             init: controller,
//             builder: (ctx) {
//               return Column(
//                 children: [
//                   SizedBox(height: height / 25),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: height / 30),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: appColors.primaryLight,
//                         width: 0.5
//                       ),
//                       gradient: const LinearGradient(
//                         begin: Alignment.bottomLeft,
//                         end: Alignment.topRight,
//                         stops: [-2, 1],
//                         colors: [
//                           Color(0xffffffff),
//                           Color(0xffffffff),
//                         ],
//                         /// colors: [
//                         ///   Color(0xffA903D2),
//                         ///   Color(0xff5033A4),
//                         /// ],
//                       ),
//                       borderRadius: BorderRadius.circular(height / 20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.2),
//                           spreadRadius: 5,
//                           blurRadius: 7,
//                           offset:
//                               const Offset(0, 3), // changes position of shadow
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(height / 30.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(height: height / 120),
//                           InkWell(
//                             onTap: () {
//                               controller.dateTimePicker(context);
//                             },
//                             child: IgnorePointer(
//                               ignoring: true,
//                               child: customTextField(
//                                 textEditingController: controller.selectDate,
//                                 title: '',
//                                 fullTag: 'Select Date',
//                                 filled: true,
//                                 readOnly: true,
//                                 fillColor:
//                                     appColors.bgColorHome.withOpacity(0.5),
//                                 border: false,
//                                 textColor: appColors.white,
//                                 hintColor: appColors.white,
//                                 prefixIcon: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: height / 30,
//                                     horizontal: width / 30,
//                                   ),
//                                   child: Icon(
//                                     CupertinoIcons.calendar,
//                                     size: height / 18,
//                                     color: appColors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: height / 30),
//                           customTextField(
//                             textEditingController: controller.amount,
//                             title: '',
//                             fullTag: 'Enter Amount',
//                             filled: true,
//                             fillColor: appColors.bgColorHome.withOpacity(0.5),
//                             border: false,
//                             keyboardType: TextInputType.number,
//                             textColor: appColors.white,
//                             hintColor: appColors.white,
//                             prefixIcon: Container(
//                               padding: EdgeInsets.symmetric(
//                                 vertical: height / 30,
//                                 horizontal: width / 60,
//                               ),
//                               child: Icon(
//                                 Icons.currency_rupee_rounded,
//                                 size: height / 18,
//                                 color: appColors.white,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: height / 30),
//                           InkWell(
//                             onTap: () {
//                               controller.hideSerialNumber.value =
//                                   !controller.hideSerialNumber.value;
//
//                               controller.hideMidTid.value = true;
//
//                               controller.update();
//                             },
//                             child: IgnorePointer(
//                               ignoring: true,
//                               child: customTextField(
//                                 textEditingController: controller.serialNumber,
//                                 title: '',
//                                 fullTag: 'Select Serial Number',
//                                 filled: true,
//                                 readOnly: true,
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: controller
//                                               .hideSerialNumber.value ==
//                                           false
//                                       ? BorderRadius.only(
//                                           topLeft: Radius.circular(width / 50),
//                                           topRight: Radius.circular(width / 50),
//                                         )
//                                       : BorderRadius.circular(width / 50),
//                                   borderSide: BorderSide.none,
//                                 ),
//                                 fillColor:
//                                     appColors.bgColorHome.withOpacity(0.5),
//                                 border: false,
//                                 textColor: appColors.white,
//                                 hintColor: appColors.white,
//                                 prefixIcon: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: height / 30,
//                                     horizontal: width / 30,
//                                   ),
//                                   child: Icon(
//                                     Icons.confirmation_number_rounded,
//                                     size: height / 18,
//                                     color: appColors.white,
//                                   ),
//                                 ),
//                                 suffixIcon: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: height / 30,
//                                     horizontal: width / 30,
//                                   ),
//                                   child: Icon(
//                                     Icons.arrow_drop_down_rounded,
//                                     size: height / 18,
//                                     color: appColors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           serialNumberListWidget(context),
//                           controller.isBankListLoading.value
//                               ? Lottie.asset('assets/lottie/wave_loading.json',
//                                   width: width, height: height / 5)
//                               : controller.bankStringList != null &&
//                                       controller.bankStringList!.isNotEmpty
//                                   ? Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         SizedBox(height: height / 20),
//                                         if (controller.bankStringList != null &&
//                                             controller
//                                                 .bankStringList!.isNotEmpty)
//                                           Text(
//                                             'Select Bank',
//                                             style: context.textTheme.bodySmall!
//                                                 .copyWith(
//                                               fontSize: height / 28,
//                                               letterSpacing: 2,
//                                               color: appColors.white,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         SizedBox(height: height / 40),
//                                         if (controller.bankStringList != null &&
//                                             controller
//                                                 .bankStringList!.isNotEmpty)
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 10.0),
//                                             child: Wrap(
//                                               spacing: width / 60,
//                                               runSpacing: width / 60,
//                                               children: List.generate(
//                                                 controller
//                                                     .bankStringList!.length,
//                                                 (ind) {
//                                                   final bank = controller
//                                                       .bankStringList![ind];
//                                                   final isSelected =
//                                                       controller.selectedBank ==
//                                                           bank;
//
//                                                   return IntrinsicWidth(
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         controller.hideMidTid
//                                                             .value = false;
//
//                                                         controller
//                                                                 .selectedBank =
//                                                             bank;
//                                                         controller.getBankId();
//                                                         controller.update();
//                                                       },
//                                                       child: Container(
//                                                         alignment:
//                                                             Alignment.center,
//                                                         padding: EdgeInsets
//                                                             .symmetric(
//                                                           vertical: height / 80,
//                                                           horizontal:
//                                                               width / 30,
//                                                         ),
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           border: Border.all(
//                                                               color: isSelected
//                                                                   ? appColors
//                                                                       .white
//                                                                   : appColors
//                                                                       .grey),
//                                                           gradient: isSelected
//                                                               ? LinearGradient(
//                                                                   begin: Alignment
//                                                                       .bottomLeft,
//                                                                   end: Alignment
//                                                                       .topRight,
//                                                                   stops: const [
//                                                                     -2,
//                                                                     1
//                                                                   ],
//                                                                   colors: [
//                                                                     appColors
//                                                                         .primaryLight,
//                                                                     appColors
//                                                                         .red,
//                                                                   ],
//                                                                 )
//                                                               : const LinearGradient(
//                                                                   begin: Alignment
//                                                                       .bottomLeft,
//                                                                   end: Alignment
//                                                                       .topRight,
//                                                                   stops: [
//                                                                     -2,
//                                                                     1
//                                                                   ],
//                                                                   colors: [
//                                                                     Color(
//                                                                         0xffffffff),
//                                                                     Color(
//                                                                         0xffffffff),
//                                                                   ],
//                                                                 ),
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(
//                                                                       height /
//                                                                           90),
//                                                           boxShadow: [
//                                                             BoxShadow(
//                                                               color: Colors.grey
//                                                                   .withOpacity(
//                                                                       0.2),
//                                                               spreadRadius: 5,
//                                                               blurRadius: 7,
//                                                               offset: const Offset(
//                                                                   0,
//                                                                   3), // changes position of shadow
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         child: Text(
//                                                           controller
//                                                                   .bankStringList![
//                                                               ind],
//                                                           style: context
//                                                               .textTheme
//                                                               .bodySmall!
//                                                               .copyWith(
//                                                             fontSize:
//                                                                 height / 30,
//                                                             letterSpacing: 1,
//                                                             color: isSelected
//                                                                 ? appColors
//                                                                     .white
//                                                                 : appColors
//                                                                     .textExtraLight,
//                                                             fontWeight:
//                                                                 FontWeight.w500,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                         if (controller.selectedBank != null)
//                                           SizedBox(height: height / 30),
//                                         if (controller.selectedBank != null)
//                                           InkWell(
//                                             onTap: () {
//                                               controller.hideMidTid.value =
//                                                   !controller.hideMidTid.value;
//
//                                               controller.hideSerialNumber
//                                                   .value = true;
//                                               controller.update();
//                                             },
//                                             child: IgnorePointer(
//                                               ignoring: true,
//                                               child: customTextField(
//                                                 textEditingController:
//                                                     controller.tid,
//                                                 title: '',
//                                                 fullTag: 'Select T.I.D',
//                                                 filled: true,
//                                                 readOnly: true,
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                   borderRadius: controller
//                                                               .hideMidTid
//                                                               .value ==
//                                                           false
//                                                       ? BorderRadius.only(
//                                                           topLeft:
//                                                               Radius.circular(
//                                                                   width / 50),
//                                                           topRight:
//                                                               Radius.circular(
//                                                                   width / 50),
//                                                         )
//                                                       : BorderRadius.circular(
//                                                           width / 50),
//                                                   borderSide: BorderSide.none,
//                                                 ),
//                                                 fillColor: appColors.bgColorHome
//                                                     .withOpacity(0.5),
//                                                 border: false,
//                                                 textColor: appColors.white,
//                                                 hintColor: appColors.white,
//                                                 prefixIcon: Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                     vertical: height / 30,
//                                                     horizontal: width / 30,
//                                                   ),
//                                                   child: Icon(
//                                                     Icons
//                                                         .confirmation_number_rounded,
//                                                     size: height / 18,
//                                                     color: appColors.white,
//                                                   ),
//                                                 ),
//                                                 suffixIcon: Container(
//                                                   padding: EdgeInsets.symmetric(
//                                                     vertical: height / 30,
//                                                     horizontal: width / 30,
//                                                   ),
//                                                   child: Icon(
//                                                     Icons
//                                                         .arrow_drop_down_rounded,
//                                                     size: height / 18,
//                                                     color: appColors.white,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         midTidListWidget(context),
//                                         controller.cardTypeLoading.value
//                                             ? Lottie.asset(
//                                                 'assets/lottie/wave_loading.json',
//                                                 width: width,
//                                                 height: height / 5)
//                                             : Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   SizedBox(height: height / 30),
//                                                   if (controller
//                                                       .cardTYPEStringList
//                                                       .isNotEmpty)
//                                                     Text(
//                                                       'Card Type',
//                                                       style: context
//                                                           .textTheme.bodySmall!
//                                                           .copyWith(
//                                                         fontSize: height / 28,
//                                                         letterSpacing: 2,
//                                                         color: appColors.white,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                     ),
//                                                   SizedBox(height: height / 40),
//                                                   if (controller
//                                                       .cardTYPEStringList
//                                                       .isNotEmpty)
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               left: 10.0),
//                                                       child: Wrap(
//                                                         spacing: width / 60,
//                                                         runSpacing: width / 60,
//                                                         children: List.generate(
//                                                           controller
//                                                               .cardTYPEStringList
//                                                               .length,
//                                                           (ind) {
//                                                             final card = controller
//                                                                     .cardTYPEStringList[
//                                                                 ind];
//                                                             final isSelected =
//                                                                 controller
//                                                                         .selectedCardType ==
//                                                                     card;
//
//                                                             return IntrinsicWidth(
//                                                               child: InkWell(
//                                                                 onTap: () {
//                                                                   controller
//                                                                           .selectedCardType =
//                                                                       card;
//
//                                                                   controller
//                                                                       .getCardTypeId();
//                                                                 },
//                                                                 child:
//                                                                     Container(
//                                                                   alignment:
//                                                                       Alignment
//                                                                           .center,
//                                                                   padding:
//                                                                       EdgeInsets
//                                                                           .symmetric(
//                                                                     vertical:
//                                                                         height /
//                                                                             80,
//                                                                     horizontal:
//                                                                         width /
//                                                                             30,
//                                                                   ),
//                                                                   decoration:
//                                                                       BoxDecoration(
//                                                                     border: Border.all(
//                                                                         color: isSelected
//                                                                             ? appColors.white
//                                                                             : appColors.grey),
//                                                                     gradient: isSelected
//                                                                         ? LinearGradient(
//                                                                             begin:
//                                                                                 Alignment.bottomLeft,
//                                                                             end:
//                                                                                 Alignment.topRight,
//                                                                             stops: const [
//                                                                               -2,
//                                                                               1
//                                                                             ],
//                                                                             colors: [
//                                                                               appColors.primaryLight,
//                                                                               appColors.red,
//                                                                             ],
//                                                                           )
//                                                                         : const LinearGradient(
//                                                                             begin:
//                                                                                 Alignment.bottomLeft,
//                                                                             end:
//                                                                                 Alignment.topRight,
//                                                                             stops: [
//                                                                               -2,
//                                                                               1
//                                                                             ],
//                                                                             colors: [
//                                                                               Color(0xffffffff),
//                                                                               Color(0xffffffff),
//                                                                             ],
//                                                                           ),
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(height /
//                                                                             90),
//                                                                     boxShadow: [
//                                                                       BoxShadow(
//                                                                         color: Colors
//                                                                             .grey
//                                                                             .withOpacity(0.2),
//                                                                         spreadRadius:
//                                                                             5,
//                                                                         blurRadius:
//                                                                             7,
//                                                                         offset: const Offset(
//                                                                             0,
//                                                                             3), // changes position of shadow
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   child: Text(
//                                                                     controller
//                                                                             .cardTYPEStringList[
//                                                                         ind],
//                                                                     style: context
//                                                                         .textTheme
//                                                                         .bodySmall!
//                                                                         .copyWith(
//                                                                       fontSize:
//                                                                           height /
//                                                                               30,
//                                                                       letterSpacing:
//                                                                           1,
//                                                                       color: isSelected
//                                                                           ? appColors
//                                                                               .white
//                                                                           : appColors
//                                                                               .textExtraLight,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             );
//                                                           },
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   SizedBox(height: height / 30),
//                                                 ],
//                                               ),
//                                         controller.cardsLoading.value
//                                             ? Lottie.asset(
//                                                 'assets/lottie/wave_loading.json',
//                                                 width: width,
//                                                 height: height / 5,
//                                               )
//                                             : Column(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   if (controller.cardsStringList
//                                                       .isNotEmpty)
//                                                     Text(
//                                                       'Card Network Type',
//                                                       style: context
//                                                           .textTheme.bodySmall!
//                                                           .copyWith(
//                                                         fontSize: height / 28,
//                                                         letterSpacing: 2,
//                                                         color: appColors.white,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                       ),
//                                                     ),
//                                                   SizedBox(height: height / 40),
//                                                   if (controller.cardsStringList
//                                                       .isNotEmpty)
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.only(
//                                                               left: 10.0),
//                                                       child: Wrap(
//                                                         spacing: width / 60,
//                                                         runSpacing: width / 60,
//                                                         children: List.generate(
//                                                           controller
//                                                               .cardsStringList
//                                                               .length,
//                                                           (ind) {
//                                                             final card = controller
//                                                                     .cardsStringList[
//                                                                 ind];
//                                                             final isSelected =
//                                                                 controller
//                                                                         .selectedCard ==
//                                                                     card;
//
//                                                             return IntrinsicWidth(
//                                                               child: InkWell(
//                                                                 onTap: () {
//                                                                   controller
//                                                                           .selectedCard =
//                                                                       card;
//
//                                                                   controller
//                                                                       .getCardId();
//                                                                 },
//                                                                 child:
//                                                                     Container(
//                                                                   alignment:
//                                                                       Alignment
//                                                                           .center,
//                                                                   padding:
//                                                                       EdgeInsets
//                                                                           .symmetric(
//                                                                     vertical:
//                                                                         height /
//                                                                             80,
//                                                                     horizontal:
//                                                                         width /
//                                                                             30,
//                                                                   ),
//                                                                   decoration:
//                                                                       BoxDecoration(
//                                                                     border: Border.all(
//                                                                         color: isSelected
//                                                                             ? appColors.white
//                                                                             : appColors.grey),
//                                                                     gradient: isSelected
//                                                                         ? LinearGradient(
//                                                                             begin:
//                                                                                 Alignment.bottomLeft,
//                                                                             end:
//                                                                                 Alignment.topRight,
//                                                                             stops: const [
//                                                                               -2,
//                                                                               1
//                                                                             ],
//                                                                             colors: [
//                                                                               appColors.primaryLight,
//                                                                               appColors.red,
//                                                                             ],
//                                                                           )
//                                                                         : const LinearGradient(
//                                                                             begin:
//                                                                                 Alignment.bottomLeft,
//                                                                             end:
//                                                                                 Alignment.topRight,
//                                                                             stops: [
//                                                                               -2,
//                                                                               1
//                                                                             ],
//                                                                             colors: [
//                                                                               Color(0xffffffff),
//                                                                               Color(0xffffffff),
//                                                                             ],
//                                                                           ),
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(height /
//                                                                             90),
//                                                                     boxShadow: [
//                                                                       BoxShadow(
//                                                                         color: Colors
//                                                                             .grey
//                                                                             .withOpacity(0.2),
//                                                                         spreadRadius:
//                                                                             5,
//                                                                         blurRadius:
//                                                                             7,
//                                                                         offset: const Offset(
//                                                                             0,
//                                                                             3), // changes position of shadow
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                   child: Text(
//                                                                     controller
//                                                                             .cardsStringList[
//                                                                         ind],
//                                                                     style: context
//                                                                         .textTheme
//                                                                         .bodySmall!
//                                                                         .copyWith(
//                                                                       fontSize:
//                                                                           height /
//                                                                               30,
//                                                                       letterSpacing:
//                                                                           1,
//                                                                       color: isSelected
//                                                                           ? appColors
//                                                                               .white
//                                                                           : appColors
//                                                                               .textExtraLight,
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .w500,
//                                                                     ),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             );
//                                                           },
//                                                         ),
//                                                       ),
//                                                     ),
//                                                 ],
//                                               ),
//                                         SizedBox(height: height / 16),
//                                       ],
//                                     )
//                                   : SizedBox(height: height / 30),
//                           customTextField(
//                             textEditingController: controller.rRNSlipNumber,
//                             title: '',
//                             fullTag: 'Enter RRN From Slip',
//                             filled: true,
//                             fillColor: appColors.bgColorHome.withOpacity(0.5),
//                             border: false,
//                             keyboardType: TextInputType.number,
//                             textColor: appColors.white,
//                             hintColor: appColors.white,
//                             prefixIcon: Container(
//                               padding: EdgeInsets.symmetric(
//                                 vertical: height / 30,
//                                 horizontal: width / 60,
//                               ),
//                               child: Icon(
//                                 Icons.receipt_rounded,
//                                 size: height / 18,
//                                 color: appColors.white,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: height / 30),
//                           InkWell(
//                             onTap: () {
//                               controller.pickDocument(context);
//                             },
//                             child: IgnorePointer(
//                               ignoring: true,
//                               child: customTextField(
//                                 textEditingController: controller.document,
//                                 title: '',
//                                 fullTag: 'Upload slip',
//                                 filled: true,
//                                 readOnly: true,
//                                 fillColor:
//                                     appColors.bgColorHome.withOpacity(0.5),
//                                 border: false,
//                                 keyboardType: TextInputType.number,
//                                 textColor: appColors.white,
//                                 hintColor: appColors.white,
//                                 prefixIcon: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: height / 30,
//                                     horizontal: width / 60,
//                                   ),
//                                   child: Icon(
//                                     Icons.upload_file_rounded,
//                                     size: height / 18,
//                                     color: appColors.white,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           if (controller.file != null ||
//                               controller.document.text.isNotEmpty)
//                             SizedBox(height: height / 60),
//                           if (controller.file != null ||
//                               controller.document.text.isNotEmpty)
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     controller.file = null;
//                                     controller.document.clear();
//                                     controller.update();
//                                   },
//                                   child: Text(
//                                     "Delete",
//                                     style: theme.textTheme.bodySmall?.copyWith(
//                                         color: Colors.redAccent,
//                                         fontSize: height / 28,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: width / 30,
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     Navigator.of(context).push(
//                                       ViewDocument(
//                                         docPath: controller.document.text,
//                                         file: controller.file,
//                                       ),
//                                     );
//                                   },
//                                   child: Text(
//                                     "View  ",
//                                     style: theme.textTheme.bodySmall?.copyWith(
//                                         color: appColors.green,
//                                         fontSize: height / 28,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           SizedBox(height: height / 20),
//                           controller.isLoading.value == false
//                               ? SizedBox(
//                                   width: width,
//                                   height: height / 8,
//                                   child: OutlinedButton(
//                                     style: ElevatedButton.styleFrom(
//                                       foregroundColor: appColors.white,
//                                       minimumSize: const Size(88, 36),
//                                       side: BorderSide(
//                                           width: 0.8, color: appColors.white),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                           Radius.circular(height / 40.0),
//                                         ),
//                                       ),
//                                     ),
//                                     onPressed: () {
//                                       controller.validatePOSForm();
//                                     },
//                                     child: Text(
//                                       "Submit",
//                                       style: theme.textTheme.bodyLarge
//                                           ?.copyWith(
//                                               color: appColors.white,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: height / 24),
//                                     ),
//                                   ))
//                               : Lottie.asset('assets/lottie/wave_loading.json',
//                                   width: width, height: height / 4),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: height / 25),
//                 ],
//               );
//             }),
//       ),
//     );
//   }
//
//   AppBar appBar() {
//     return AppBar(
//       backgroundColor: appColors.primaryColor,
//       leadingWidth: width,
//       leading: Container(
//         alignment: Alignment.bottomLeft,
//         padding: EdgeInsets.only(bottom: width / 30),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             backButton(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget midTidListWidget(context) {
//     if (controller.midTidList.isNotEmpty) {
//       return AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         height: controller.hideMidTid.value == false
//             ? (controller.serialNumberStringList.length < 5
//                 ? controller.serialNumberStringList.length * height / 7
//                 : height / 2.9)
//             : 0,
//         padding: EdgeInsets.only(top: width / 30),
//         decoration: BoxDecoration(
//           color: appColors.white,
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(10),
//             bottomRight: Radius.circular(10),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: const Offset(0, 3), // changes position of shadow
//             ),
//           ],
//         ),
//         child: ListView.builder(
//           itemCount: controller.midTidList.length,
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {
//                 controller.hideMidTid.value = true;
//                 controller.mid.text =
//                     controller.midTidList[index].mid.toString();
//                 controller.tid.text =
//                     'TID : ${controller.midTidList[index].tid.toString()}';
//                 controller.tidToSendInApi =
//                     controller.midTidList[index].tid.toString();
//                 controller.midToSendInApi =
//                     controller.midTidList[index].tid.toString();
//                 debugPrint(controller.mid.toString());
//
//                 controller.update();
//                 controller.getCardType();
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: width / 40.0, vertical: height / 80.0),
//                 margin: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
//                 decoration: BoxDecoration(
//                     gradient: controller.midTidList[index].tid ==
//                             controller.tidToSendInApi
//                         ? LinearGradient(
//                             begin: Alignment.bottomLeft,
//                             end: Alignment.topRight,
//                             stops: const [-2, 1],
//                             colors: [
//                               appColors.primaryLight,
//                               appColors.red,
//                             ],
//                           )
//                         : const LinearGradient(
//                             begin: Alignment.bottomLeft,
//                             end: Alignment.topRight,
//                             stops: [-2, 1],
//                             colors: [
//                               Color(0xffffffff),
//                               Color(0xffffffff),
//                             ],
//                           ),
//                     borderRadius: BorderRadius.circular(4)),
//                 child: Text(
//                   '${controller.selectedBank} - TID ${controller.midTidList[index].tid!}',
//                   style: theme.textTheme.labelMedium?.copyWith(
//                     color: controller.midTidList[index].tid ==
//                             controller.tidToSendInApi
//                         ? appColors.white
//                         : appColors.black,
//                     fontSize: height / 28,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     } else {
//       return const SizedBox();
//     }
//   }
//
//   Widget serialNumberListWidget(context) {
//     if (controller.serialNumberStringList.isNotEmpty) {
//       return AnimatedContainer(
//         duration: const Duration(milliseconds: 500),
//         height: controller.hideSerialNumber.value == false
//             ? (controller.serialNumberStringList.length < 5
//                 ? controller.serialNumberStringList.length * height / 7
//                 : height / 2.9)
//             : 0,
//         padding: EdgeInsets.only(top: width / 30),
//         decoration: BoxDecoration(
//           color: appColors.white,
//           borderRadius: const BorderRadius.only(
//             bottomLeft: Radius.circular(10),
//             bottomRight: Radius.circular(10),
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 5,
//               blurRadius: 7,
//               offset: const Offset(0, 3), // changes position of shadow
//             ),
//           ],
//         ),
//         child: ListView.builder(
//           itemCount: controller.serialNumberStringList.length,
//           shrinkWrap: true,
//           itemBuilder: (BuildContext context, int index) {
//             return InkWell(
//               onTap: () {
//                 controller.hideSerialNumber.value = true;
//                 controller.selectedSerialNumber =
//                     controller.serialNumberStringList[index];
//
//                 controller.serialNumber.text =
//                     controller.serialNumberStringList[index];
//                 controller.update();
//
//                 controller.onClickSerialNumber();
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: width / 40.0, vertical: height / 80.0),
//                 margin: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
//                 decoration: BoxDecoration(
//                     gradient: controller.serialNumberStringList[index] ==
//                             controller.selectedSerialNumber
//                         ? LinearGradient(
//                             begin: Alignment.bottomLeft,
//                             end: Alignment.topRight,
//                             stops: const [-2, 1],
//                             colors: [
//                               appColors.primaryLight,
//                               appColors.red,
//                             ],
//                           )
//                         : const LinearGradient(
//                             begin: Alignment.bottomLeft,
//                             end: Alignment.topRight,
//                             stops: [-2, 1],
//                             colors: [
//                               Color(0xffffffff),
//                               Color(0xffffffff),
//                             ],
//                           ),
//                     borderRadius: BorderRadius.circular(4)),
//                 child: Text(
//                   ' ${controller.serialNumberStringList[index]} '.toUpperCase(),
//                   style: theme.textTheme.labelMedium?.copyWith(
//                     color: controller.serialNumberStringList[index] ==
//                             controller.selectedSerialNumber
//                         ? appColors.white
//                         : appColors.black,
//                     letterSpacing: 1,
//                     fontSize: height / 28,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
//     } else {
//       return const SizedBox();
//     }
//   }
//
//   GestureDetector backButton() {
//     return GestureDetector(
//       onTap: () {
//         Get.back();
//       },
//       child: Row(
//         children: [
//           SizedBox(width: width / 30),
//           Icon(
//             Icons.arrow_back_ios_new_rounded,
//             size: height / 14,
//             color: appColors.white,
//           ),
//           SizedBox(width: width / 80),
//           Text(
//             " P.O.S Request",
//             style: theme.textTheme.labelMedium?.copyWith(
//               color: appColors.white,
//               letterSpacing: 1,
//               fontWeight: FontWeight.w400,
//               fontSize: height / 18,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

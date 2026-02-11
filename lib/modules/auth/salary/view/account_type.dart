import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/auth/salary/controller/salaried_controller.dart';
import 'package:payhive/modules/auth/salary/view/annual_income.dart';
import 'package:payhive/modules/auth/salary/view/complete_your_kyc.dart';
import 'package:payhive/modules/auth/salary/view/email_verification.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/snackbar.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AccountType extends GetView<SalariedController> {
  AccountType({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (v, t) {
        Get.offAll(() => EmailVerification());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appColors.primaryColor,
        body: body(context),
      ),
    );
  }

  LinearPercentIndicator progress() {
    return LinearPercentIndicator(
      width: width,
      animation: true,
      animationDuration: 2500,
      padding: EdgeInsets.zero,
      lineHeight: height / 100,
      percent: 0.3,
      backgroundColor: appColors.primaryExtraLight,
      progressColor: appColors.green,
    );
  }

  Container text() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: width / 20,
        left: width / 15,
        right: width / 20,
      ),
      child: Text(
        "Select Income Source",
        style: theme.textTheme.headlineSmall?.copyWith(
            color: appColors.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: height / 18),
      ),
    );
  }

  Widget body(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_drop_down.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              progress(),
              GetBuilder(
                  init: controller,
                  builder: (ctx) {
                    return Column(
                      children: [
                        spacing(passedHeight: height / 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.only(
                                  left: width / 18, top: width / 20),
                              child: Container(
                                height: height / 12,
                                width: height / 4,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(width / 100),
                                  border: Border.all(
                                    color: appColors.primaryLight,
                                    width: 0.4,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Get.offAll(EmailVerification(),
                                        transition: Transition.leftToRight,
                                        duration:
                                            const Duration(milliseconds: 500));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.arrow_back_ios_rounded,
                                        size: height / 25,
                                        color: appColors.primaryLight,
                                      ),
                                      Text(
                                        " Back ",
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: appColors.primaryLight,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            if (controller.isAnnualIncomeDisabled.value)
                              Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(
                                    right: width / 18, top: width / 20),
                                child: Container(
                                  height: height / 12,
                                  width: height / 4,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(width / 100),
                                    border: Border.all(
                                      color: appColors.primaryLight,
                                      width: 0.4,
                                    ),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(const CompleteYourKYC(),
                                          transition: Transition.rightToLeft,
                                          duration: const Duration(
                                              milliseconds: 500));
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          " Next ",
                                          style: theme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: appColors.primaryLight,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: height / 25,
                                          color: appColors.primaryLight,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Column(
                          children: [
                            spacing(passedHeight: height / 60),
                            Padding(
                              padding: EdgeInsets.only(
                                top: height / 30,
                                left: width / 15,
                                right: width / 15,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Select Income Source",
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                            color: appColors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: height / 18),
                                  ),
                                  if (controller.firstTapped.value)
                                    Container(
                                      child: customButton(
                                        passedHeight: height / 14,
                                        passedWidth: width / 5.8,
                                        title: "Change",
                                        context: context,
                                        onTap: () {
                                          controller.accountTypeSetAndHidden
                                                  .value =
                                              !controller
                                                  .accountTypeSetAndHidden
                                                  .value;

                                          controller.hideSearchListBusinessType
                                              .value = true;
                                          controller
                                              .hideSearchListFormOfBusiness
                                              .value = true;

                                          controller.hideSearchListAnnualIncome
                                              .value = true;
                                          controller.update();
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            spacing(passedHeight: height / 40),
                            ...List.generate(
                              list.length,
                              (ind) => Padding(
                                padding: EdgeInsets.only(
                                    left: width / 20.0, right: width / 20.0),
                                child: InkWell(
                                  onTap: () {
                                    controller.accountTypeIndex = ind;
                                    controller.firstTapped.value = true;
                                    controller.accountTypeSetAndHidden.value =
                                        true;

                                    controller.update();
                                    controller.salariedAPI(step: '5');
                                  },
                                  child: controller.accountTypeIndex == ind ||
                                          !controller
                                              .accountTypeSetAndHidden.value
                                      ? item(
                                          list[ind],
                                          ind,
                                          listTitle[ind],
                                          listSubtitle[ind],
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                            ),
                            if (controller.isAccountTypeLoading.value)
                              Lottie.asset('assets/lottie/wave_loading.json',
                                  width: width / 2, height: height / 3.5),
                            if (!controller.isAccountTypeLoading.value &&
                                controller.firstTapped.value)
                              annualIncome(context)
                          ],
                        ),
                      ],
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  annualIncome(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Column(
        children: [
          spacing(passedHeight: height / 20),
          if (controller.accountTypeIndex == 1)
            Column(
              children: [
                businessType(),
                searchedBusinessTypeListWidget(),
                spacing(passedHeight: height / 20),
                formOfBusiness(),
                searchedFormOfBusinessListWidget(),
                spacing(passedHeight: height / 20),
              ],
            ),
          if (controller.accountTypeIndex == 2)
            Column(
              children: [
                partnerShipType(),
                partnershipTypeListWidget(),
                spacing(passedHeight: height / 20),
              ],
            ),
          annual(),
          searchedAnnualIncomeListWidget(),
          spacing(passedHeight: height / 20),
          spacing(passedHeight: height / 20),
          if (controller.accountTypeIndex == 1 &&
              controller.annualIncomeController.text.isNotEmpty &&
              controller.businessTypeController.text.isNotEmpty &&
              controller.formOfBusinessController.text.isNotEmpty)
            controller.annualIncomeLoading.value
                ? Container(
                    padding: EdgeInsets.symmetric(
                      vertical: height / 30,
                      horizontal: width / 30,
                    ),
                    child: CupertinoActivityIndicator(
                      color: appColors.primaryLight,
                      radius: height / 20,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                        left: width / 20.0, right: width / 20.0),
                    child: customButton(
                        title: "Continue",
                        context: context,
                        onTap: () {
                          controller.salariedAPI(step: '6');
                        }),
                  ),
          if (controller.accountTypeIndex == 2 &&
              controller.annualIncomeController.text.isNotEmpty &&
              controller.partnerShipTypeController.text.isNotEmpty)
            controller.annualIncomeLoading.value
                ? Container(
                    padding: EdgeInsets.symmetric(
                      vertical: height / 30,
                      horizontal: width / 30,
                    ),
                    child: CupertinoActivityIndicator(
                      color: appColors.primaryLight,
                      radius: height / 20,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                        left: width / 20.0, right: width / 20.0),
                    child: customButton(
                        title: "Continue",
                        context: context,
                        onTap: () {
                          controller.salariedAPI(step: '6');
                        }),
                  ),
          if ((controller.accountTypeIndex != 1 &&
                  controller.accountTypeIndex != 2) &&
              controller.annualIncomeController.text.isNotEmpty)
            controller.annualIncomeLoading.value
                ? Lottie.asset('assets/lottie/wave_loading.json',
                    width: width / 2, height: height / 3.5)
                : Padding(
                    padding: EdgeInsets.only(
                        left: width / 20.0, right: width / 20.0),
                    child: customButton(
                        title: "Continue",
                        context: context,
                        onTap: () {
                          controller.salariedAPI(step: '6');
                        }),
                  ),
          spacing(passedHeight: height / 20),
        ],
      ),
    );
  }

  Widget searchedAnnualIncomeListWidget() {
    if (controller.annualStringList != null &&
        controller.annualStringList!.isNotEmpty) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: controller.hideSearchListAnnualIncome.value == false
            ? height / 2
            : 0,
        margin: EdgeInsets.only(
          left: width / 20.0,
          right: width / 20.0,
        ),
        padding: EdgeInsets.only(top: width / 30),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: controller.annualStringList!.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                controller.hideSearchListAnnualIncome.value = true;
                controller.update();
                controller.annualIncomeController.text =
                    controller.annualStringList![index];
                controller.setAnnualIncomeValue(
                    controller.annualIncomeController.text);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width / 20.0,
                  vertical: width / 30.0,
                ),
                margin: EdgeInsets.only(
                  left: width / 30.0,
                  right: width / 30.0,
                ),
                decoration: controller.annualStringList![index] ==
                        controller.annualIncomeController.text
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          stops: const [-1, 2.0],
                          colors: [
                            appColors.primaryColor,
                            appColors.primaryColor,
                          ],
                        ),
                      )
                    : null,
                child: Text(
                  controller.annualStringList![index],
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: controller.annualStringList![index] ==
                            controller.annualIncomeController.text
                        ? appColors.white
                        : appColors.black,
                    fontSize: height / 36,
                    fontWeight: FontWeight.w300,
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

  Widget searchedBusinessTypeListWidget() {
    if (controller.businessTypeStringList != null &&
        controller.businessTypeStringList!.isNotEmpty) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: controller.hideSearchListBusinessType.value == false
            ? height / 2
            : 0,
        margin: EdgeInsets.only(
          left: width / 20.0,
          right: width / 20.0,
        ),
        padding: EdgeInsets.only(top: width / 30),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: controller.businessTypeStringList!.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                controller.hideSearchListBusinessType.value = true;
                controller.update();
                controller.businessTypeController.text =
                    controller.businessTypeStringList![index];
                controller.setBusinessTypeValue(
                    controller.businessTypeController.text);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width / 20.0,
                  vertical: width / 30.0,
                ),
                margin: EdgeInsets.only(
                  left: width / 30.0,
                  right: width / 30.0,
                ),
                decoration: controller.businessTypeStringList![index] ==
                        controller.businessTypeController.text
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          stops: const [-1, 2.0],
                          colors: [
                            appColors.primaryColor,
                            appColors.primaryColor,
                          ],
                        ),
                      )
                    : null,
                child: Text(
                  controller.businessTypeStringList![index],
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: controller.businessTypeStringList![index] ==
                            controller.businessTypeController.text
                        ? appColors.white
                        : appColors.black,
                    fontSize: height / 36,
                    fontWeight: FontWeight.w300,
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

  Widget partnershipTypeListWidget() {
    if (controller.partnershipTypeStringList != null &&
        controller.partnershipTypeStringList!.isNotEmpty) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: controller.hideSearchListPartnershipType.value == false
            ? height / 2
            : 0,
        margin: EdgeInsets.only(
          left: width / 20.0,
          right: width / 20.0,
        ),
        padding: EdgeInsets.only(top: width / 30),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: controller.partnershipTypeStringList!.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                controller.hideSearchListPartnershipType.value = true;
                controller.update();
                controller.partnerShipTypeController.text =
                    controller.partnershipTypeStringList![index];
                controller.partnershipTypeValue(
                    controller.partnerShipTypeController.text);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width / 20.0,
                  vertical: width / 30.0,
                ),
                margin: EdgeInsets.only(
                  left: width / 30.0,
                  right: width / 30.0,
                ),
                decoration: controller.partnershipTypeStringList![index] ==
                        controller.partnerShipTypeController.text
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          stops: const [-1, 2.0],
                          colors: [
                            appColors.primaryColor,
                            appColors.primaryColor,
                          ],
                        ),
                      )
                    : null,
                child: Text(
                  controller.partnershipTypeStringList![index],
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: controller.partnershipTypeStringList![index] ==
                            controller.partnerShipTypeController.text
                        ? appColors.white
                        : appColors.black,
                    fontSize: height / 36,
                    fontWeight: FontWeight.w300,
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

  Widget searchedFormOfBusinessListWidget() {
    if (controller.formOfBusinessStringList != null &&
        controller.formOfBusinessStringList!.isNotEmpty) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: controller.hideSearchListFormOfBusiness.value == false
            ? height / 2
            : 0,
        margin: EdgeInsets.only(
          left: width / 20.0,
          right: width / 20.0,
        ),
        padding: EdgeInsets.only(top: width / 30),
        decoration: BoxDecoration(
          color: appColors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListView.builder(
          itemCount: controller.formOfBusinessStringList!.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                controller.hideSearchListFormOfBusiness.value = true;
                controller.update();
                controller.formOfBusinessController.text =
                    controller.formOfBusinessStringList![index];
                controller.setFormOfBusinessValue(
                    controller.formOfBusinessController.text);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width / 20.0,
                  vertical: width / 30.0,
                ),
                margin: EdgeInsets.only(
                  left: width / 30.0,
                  right: width / 30.0,
                ),
                decoration: controller.formOfBusinessStringList![index] ==
                        controller.formOfBusinessController.text
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.topRight,
                          stops: const [-1, 2.0],
                          colors: [
                            appColors.primaryColor,
                            appColors.primaryColor,
                          ],
                        ),
                      )
                    : null,
                child: Text(
                  controller.formOfBusinessStringList![index],
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: controller.formOfBusinessStringList![index] ==
                            controller.formOfBusinessController.text
                        ? appColors.white
                        : appColors.black,
                    fontSize: height / 36,
                    fontWeight: FontWeight.w300,
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

  Widget annual() {
    return InkWell(
      onTap: () {
        controller.accountTypeSetAndHidden.value = true;
        controller.hideSearchListBusinessType.value = true;
        controller.hideSearchListFormOfBusiness.value = true;
        controller.hideSearchListPartnershipType.value = true;


        controller.hideSearchListAnnualIncome.value =
            !controller.hideSearchListAnnualIncome.value;
        controller.update();
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: width / 20.0,
          right: width / 20.0,
        ),
        child: IgnorePointer(
          ignoring: true,
          child: customTextField(
            readOnly: true,
            textEditingController: controller.annualIncomeController,
            title: "",
            fullTag: controller.accountTypeIndex == 1
                ? "Annual Turnover"
                : "Annual Income",
            enabledBorder: OutlineInputBorder(
              borderRadius: controller.hideSearchListAnnualIncome.value == false
                  ? BorderRadius.only(
                      topLeft: Radius.circular(width / 50),
                      topRight: Radius.circular(width / 50),
                    )
                  : BorderRadius.circular(width / 50),
              borderSide: BorderSide(
                color: appColors.black.withOpacity(0.35),
                width: 0.6,
              ),
            ),
            textColor: appColors.black,
            prefixIcon: Container(
              padding: EdgeInsets.all(width / 26),
              child: Image.asset(
                "assets/temp/annual_income.png",
                fit: BoxFit.contain,
                height: height / 90,
                width: height / 90,
              ),
            ),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: appColors.black.withOpacity(0.4),
              size: height / 14,
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
      ),
    );
  }

  Widget businessType() {
    return InkWell(
      onTap: () {
        controller.accountTypeSetAndHidden.value = true;

        controller.hideSearchListAnnualIncome.value = true;
        controller.hideSearchListFormOfBusiness.value = true;
        controller.hideSearchListPartnershipType.value = true;

        controller.hideSearchListBusinessType.value =
            !controller.hideSearchListBusinessType.value;
        controller.update();
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: width / 20.0,
          right: width / 20.0,
        ),
        child: IgnorePointer(
          ignoring: true,
          child: customTextField(
            readOnly: true,
            textEditingController: controller.businessTypeController,
            title: "",
            fullTag: "Nature of business",
            enabledBorder: OutlineInputBorder(
              borderRadius: controller.hideSearchListBusinessType.value == false
                  ? BorderRadius.only(
                      topLeft: Radius.circular(width / 50),
                      topRight: Radius.circular(width / 50),
                    )
                  : BorderRadius.circular(width / 50),
              borderSide: BorderSide(
                color: appColors.black.withOpacity(0.35),
                width: 0.6,
              ),
            ),
            textColor: appColors.black,
            prefixIcon: Container(
              padding: EdgeInsets.all(width / 26),
              child: Image.asset(
                "assets/temp/annual_income.png",
                fit: BoxFit.contain,
                height: height / 90,
                width: height / 90,
              ),
            ),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: appColors.black.withOpacity(0.4),
              size: height / 14,
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
      ),
    );
  }

  Widget partnerShipType() {
    return InkWell(
      onTap: () {
        controller.accountTypeSetAndHidden.value = true;

        controller.hideSearchListAnnualIncome.value = true;
        controller.hideSearchListFormOfBusiness.value = true;

        controller.hideSearchListPartnershipType.value =
            !controller.hideSearchListPartnershipType.value;
        controller.update();
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: width / 20.0,
          right: width / 20.0,
        ),
        child: IgnorePointer(
          ignoring: true,
          child: customTextField(
            readOnly: true,
            textEditingController: controller.partnerShipTypeController,
            title: "",
            fullTag: "Partnership Type",
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  controller.hideSearchListPartnershipType.value == false
                      ? BorderRadius.only(
                          topLeft: Radius.circular(width / 50),
                          topRight: Radius.circular(width / 50),
                        )
                      : BorderRadius.circular(width / 50),
              borderSide: BorderSide(
                color: appColors.black.withOpacity(0.35),
                width: 0.6,
              ),
            ),
            textColor: appColors.black,
            prefixIcon: Container(
              padding: EdgeInsets.all(width / 26),
              child: Image.asset(
                "assets/temp/annual_income.png",
                fit: BoxFit.contain,
                height: height / 90,
                width: height / 90,
              ),
            ),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: appColors.black.withOpacity(0.4),
              size: height / 14,
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
      ),
    );
  }

  Widget formOfBusiness() {
    return InkWell(
      onTap: () {
        controller.accountTypeSetAndHidden.value = true;
        controller.hideSearchListAnnualIncome.value = true;
        controller.hideSearchListBusinessType.value = true;
        controller.hideSearchListFormOfBusiness.value =
            !controller.hideSearchListFormOfBusiness.value;
        controller.update();
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: width / 20.0,
          right: width / 20.0,
        ),
        child: IgnorePointer(
          ignoring: true,
          child: customTextField(
            readOnly: true,
            textEditingController: controller.formOfBusinessController,
            title: "",
            fullTag: "Business Entity Type",
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  controller.hideSearchListFormOfBusiness.value == false
                      ? BorderRadius.only(
                          topLeft: Radius.circular(width / 50),
                          topRight: Radius.circular(width / 50),
                        )
                      : BorderRadius.circular(width / 50),
              borderSide: BorderSide(
                color: appColors.black.withOpacity(0.35),
                width: 0.6,
              ),
            ),
            textColor: appColors.black,
            prefixIcon: Container(
              padding: EdgeInsets.all(width / 26),
              child: Image.asset(
                "assets/temp/annual_income.png",
                fit: BoxFit.contain,
                height: height / 90,
                width: height / 90,
              ),
            ),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: appColors.black.withOpacity(0.4),
              size: height / 14,
            ),
            keyboardType: TextInputType.phone,
          ),
        ),
      ),
    );
  }

  final List list = [
    "assets/temp/briefcase.png",
    "assets/temp/building.png",
    "assets/temp/people.png",
    "assets/temp/rupee.png",
  ];
  final List listTitle = [
    "I'm a Salaried Professional",
    "I'm a Business Owner / Self Employed",
    "I'm an Agent",
    "I Have Other Sources of Income",
  ];
  final List listSubtitle = [
    "You receive regular salary from an employer",
    "You run your own business or are self-employed",
    "You work with some businesses.",
    "Investments, rental income, etc.",
  ];

  Widget item(path, index, title, subtitle) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: width,
      height: height / 5.2,
      padding:
          EdgeInsets.symmetric(vertical: width / 40, horizontal: width / 30),
      margin: EdgeInsets.only(bottom: height / 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          stops: const [-2, 3.0],
          colors: [
            Colors.purple,
            appColors.primaryColor,
          ],
        ),
        border: Border.all(
          width: 1,
          color: appColors.grey.withOpacity(0.4),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: appColors.primaryExtraLight.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(1000.0),
                ),
                padding: EdgeInsets.all(index == 2 ? height / 46 : height / 80),
                child: SizedBox(
                  height: index == 2 ? height / 12 : height / 10,
                  width: index == 2 ? height / 12 : height / 10,
                  child: Image.asset(
                    path,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(width: width / 30),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: appColors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: width / 32,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: width / 30),
              Icon(
                controller.accountTypeIndex == index
                    ? Icons.radio_button_on
                    : Icons.radio_button_off,
                size: height / 16,
                color: appColors.grey.withOpacity(0.5),
              )
            ],
          ),
        ],
      ),
    );
  }
}

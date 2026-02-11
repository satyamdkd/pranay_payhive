import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/shop_lincence/controller/shop_licence_controller.dart';
import 'package:payhive/utils/helper/form_validation.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';

import '../../pos/view/view_doc.dart';

class ShopLicencePage extends GetView<ShopLicenceController> {
  const ShopLicencePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appColors.primaryColor,
        body: body(context));
  }

  SafeArea body(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/splash_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              shopLicenceDetailText(),
              addShopLicence(context),
            ],
          ),
        ),
      ),
    );
  }

  Container addShopLicence(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.only(left: width / 20, right: width / 20),
      height: MediaQuery.sizeOf(context).height / 1.4,
      decoration: boxDecorationMainMobileWidget(),
      child: GetBuilder<ShopLicenceController>(
          init: controller,
          builder: (cxt) {
            return Form(
              key: controller.shopFormKey,
              child: Column(
                children: [
                  spacing(),
                  enterFullName(
                    controller.licence,
                    Icons.badge_outlined,
                    'Shop Licence Number',
                    (value) => FormValidation.name(controller.licence.text),
                    keyboardType: TextInputType.text,
                  ),
                  spacing(passedHeight: height / 30),
                  InkWell(
                    onTap: () {
                      controller.pickDocument();
                    },
                    child: IgnorePointer(
                      ignoring: true,
                      child: enterFullName(
                        controller.document,
                        Icons.document_scanner_rounded,
                        'Document',
                        onChange: (val) {},
                        (value) =>
                            FormValidation.name(controller.document.text),
                      ),
                    ),
                  ),
                  spacing(passedHeight: height / 30),
                  if (controller.file != null ||
                      controller.document.text.isNotEmpty)
                    SizedBox(height: height / 60),
                  if (controller.file != null ||
                      controller.document.text.isNotEmpty)
                    viewOrDelete(context),
                  spacer(),
                  spacing(passedHeight: height / 50),
                  !controller.isLoadingShopLicence.value
                      ? customButton(
                          title: "Submit",
                          context: context,
                          onTap: () {
                            controller.validateShopLicenceForm();
                          },
                        )
                      : Lottie.asset('assets/lottie/wave_loading.json',
                          width: width / 2, height: height / 3.5),
                  spacing(passedHeight: height / 8),
                ],
              ),
            );
          }),
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

  Widget shopLicenceDetailText() {
    return Expanded(
      child: Container(
        alignment: Alignment.bottomLeft,
        padding: EdgeInsets.only(left: width / 40, bottom: height / 40),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                margin: EdgeInsets.only(top: height / 20),
                child: Icon(
                  CupertinoIcons.back,
                  color: appColors.white,
                  size: height / 10,
                ),
              ),
            ),
            Text(
              "  Enter Your\n  Shop Licence Details",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: appColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration boxDecorationMainMobileWidget() {
    return BoxDecoration(
      image: const DecorationImage(
        image: AssetImage("assets/images/bg_drop_down.png"),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(height / 16),
        topLeft: Radius.circular(height / 16),
      ),
    );
  }

  SizedBox spacing({passedHeight}) =>
      SizedBox(height: passedHeight ?? height / 20);

  Spacer spacer() => const Spacer();

  InkWell enterFullName(
      textEditingController, icon, tag, String? Function(Object?)? validator,
      {onChange, TextInputType? keyboardType}) {
    return InkWell(
      onTap: () async {},
      child: customTextField(
        textEditingController: textEditingController,
        title: "",
        fullTag: tag,
        onChanged: onChange,
        fontSize: height / 26,
        prefixIcon: Container(
          padding: EdgeInsets.symmetric(
            vertical: height / 30,
            horizontal: width / 40,
          ),
          child: Icon(
            icon,
            color: appColors.black.withValues(alpha: 0.6),
          ),
        ),
        keyboardType: keyboardType ?? TextInputType.text,
      ),
    );
  }
}

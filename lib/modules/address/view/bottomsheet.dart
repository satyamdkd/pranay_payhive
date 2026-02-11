import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/address/controller/address_controller.dart';
import 'package:payhive/modules/address/view/location_pick.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';

import '../../pos/view/view_doc.dart';

class AddressBottomSheet extends StatelessWidget {
  AddressBottomSheet(
      {super.key,
      required this.address,
      required this.name,
      required this.phone});

  final String address;
  final String name;
  final String phone;

  final AddressController controller = Get.find<AddressController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 0.7, // Adjusted for better height
      minChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: appColors.backgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: GetBuilder(
                init: controller,
                builder: (ctx) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Form(
                      key: controller.addressFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Enter complete address",
                            style: theme.textTheme.headlineSmall?.copyWith(
                                color: appColors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: height / 20),
                          ),
                          spacing(passedHeight: height / 40),
                          Container(
                            decoration: BoxDecoration(
                              color: appColors.white,
                              borderRadius: BorderRadius.circular(height / 40),
                            ),
                            padding: EdgeInsets.all(height / 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Receiver details for this address",
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                          color:
                                              appColors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                          fontSize: height / 32),
                                ),
                                spacing(passedHeight: height / 100),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.phone_in_talk_rounded,
                                        color: appColors.textDark,
                                        size: height / 20),
                                    Row(
                                      children: [
                                        Text(
                                          " $name,",
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                            color: appColors.textDark,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.5,
                                            fontSize: height / 28,
                                          ),
                                        ),
                                        Text(
                                          " $phone",
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                            color: appColors.textDark,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                            fontSize: height / 26,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          spacing(passedHeight: height / 40),
                          Container(
                            decoration: BoxDecoration(
                              color: appColors.white,
                              borderRadius: BorderRadius.circular(height / 40),
                            ),
                            padding: EdgeInsets.all(height / 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tag this location for later",
                                  style:
                                      theme.textTheme.headlineSmall?.copyWith(
                                    color: appColors.black.withOpacity(0.6),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                    fontSize: height / 30,
                                  ),
                                ),
                                spacing(passedHeight: height / 80),
                                locationTagSelection(),
                                spacing(),
                                spacing(passedHeight: height / 40),
                                customTextField(
                                  textEditingController:
                                      TextEditingController(),
                                  title: "",
                                  fullTag: address,
                                  validator: (val) => null,
                                  fontSize: height / 26,
                                  maxLines: 3,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width / 30,
                                      vertical: width / 30),
                                  readOnly: true,
                                  suffixIcon: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: height / 30,
                                      horizontal: width / 30,
                                    ),
                                    child: customButton(
                                      passedHeight: height / 14,
                                      passedWidth: width / 5.8,
                                      title: "Change",
                                      context: context,
                                      onTap: () {
                                        Get.back();
                                        Get.back();
                                        Get.to(
                                          () => LocationPickerPage(
                                            name: name,
                                            phone: phone,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                spacing(passedHeight: height / 60),
                                Text(
                                  "Updated based on your exact map pin",
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                          color:
                                              appColors.black.withOpacity(0.6),
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                          fontSize: height / 30),
                                ),
                                spacing(passedHeight: height / 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width / 2.4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "State",
                                            style: theme.textTheme.headlineSmall
                                                ?.copyWith(
                                                    color: appColors.black
                                                        .withOpacity(0.6),
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 1,
                                                    fontSize: height / 30),
                                          ),
                                          customTextField(
                                            textEditingController:
                                                controller.state,
                                            title: "",
                                            fullTag: "State",
                                            fontSize: height / 26,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: width / 30,
                                                    vertical: width / 30),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: width / 2.4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "City",
                                            style: theme.textTheme.headlineSmall
                                                ?.copyWith(
                                                    color: appColors.black
                                                        .withOpacity(0.6),
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 1,
                                                    fontSize: height / 30),
                                          ),
                                          customTextField(
                                            textEditingController:
                                                controller.city,
                                            title: "",
                                            fullTag: "City",
                                            fontSize: height / 26,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: width / 30,
                                                    vertical: width / 30),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                spacing(passedHeight: height / 40),
                                customTextField(
                                  textEditingController: controller.pincode,
                                  title: "",
                                  keyboardType: TextInputType.number,
                                  fullTag: "Pincode",
                                  fontSize: height / 26,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width / 30,
                                      vertical: width / 30),
                                ),
                                spacing(passedHeight: height / 40),
                                customTextField(
                                  textEditingController:
                                      controller.completeAddress,
                                  title: "",
                                  fullTag: "Complete Address",
                                  fontSize: height / 26,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width / 30,
                                      vertical: width / 30),
                                ),
                                spacing(passedHeight: height / 40),
                                customTextField(
                                  textEditingController: controller.landmark,
                                  title: "",
                                  validator: (val) => null,
                                  fullTag: "Landmark (Optional)",
                                  fontSize: height / 26,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: width / 30,
                                      vertical: width / 30),
                                ),
                                spacing(passedHeight: height / 40),
                                InkWell(
                                  onTap: () {
                                    controller.pickDocument(context);
                                  },
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: customTextField(
                                      textEditingController:
                                          controller.document,
                                      title: "",
                                      readOnly: true,
                                      validator: (val) => null,
                                      fullTag: "Address proof",
                                      fontSize: height / 26,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: width / 30,
                                          vertical: width / 30),
                                    ),
                                  ),
                                ),
                                spacing(passedHeight: height / 40),
                                if (controller.doc != null ||
                                    controller.document.text.isNotEmpty)
                                  SizedBox(height: height / 60),
                                if (controller.doc != null ||
                                    controller.document.text.isNotEmpty)
                                  viewOrDelete(context),
                                SizedBox(height: height / 30),
                                spacing(passedHeight: height / 40),
                              ],
                            ),
                          ),
                          spacing(passedHeight: height / 20),
                          controller.isLoadingAddress.value
                              ? Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                    vertical: height / 30,
                                    horizontal: width / 30,
                                  ),
                                  child: CupertinoActivityIndicator(
                                    color: appColors.primaryLight,
                                    radius: height / 30,
                                  ),
                                )
                              : customButton(
                                  title: 'Confirm address',
                                  context: context,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: appColors.white,
                                    fontSize: height / 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  onTap: () {
                                    controller.validateAddressForm();
                                  }),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }

  Row viewOrDelete(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            controller.doc = null;
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
                file: controller.doc,
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

  locationTagSelection() {
    return Row(
      children: [
        locationTag(
          'Present',
          onTap: () {
            controller.locationTypeSelection.value = 1;
            controller.update();
          },
          Icons.location_on,
          appColors.primaryColor,
          selected: controller.locationTypeSelection.value == 1 ? true : false,
        ),
        SizedBox(
          width: width / 60,
        ),
        locationTag(
          'Permanent',
          onTap: () {
            controller.locationTypeSelection.value = 2;
            controller.update();
          },
          Icons.location_on,
          appColors.primaryColor,
          selected: controller.locationTypeSelection.value == 2 ? true : false,
        ),
      ],
    );
  }

  Widget locationTag(String text, IconData icon, Color color,
      {required bool selected, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height / 12,
        width: width / 3.5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.1) : appColors.white,
          border: Border.all(
              color: selected ? color : appColors.black.withOpacity(0.3),
              width: 1),
          borderRadius: BorderRadius.circular(height / 40),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? color : appColors.black.withOpacity(0.4),
              size: height / 20,
            ),
            SizedBox(width: width / 90),
            Text(
              text,
              style: theme.textTheme.headlineSmall?.copyWith(
                  color: selected ? color : appColors.black.withOpacity(0.4),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                  fontSize: height / 28),
            ),
          ],
        ),
      ),
    );
  }
}

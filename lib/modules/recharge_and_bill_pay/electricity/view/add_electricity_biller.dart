import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/recharge_and_bill_pay/electricity/controller/electricity_controller.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';
import 'package:flutter/services.dart';

class AddNewElectricityBill extends GetView<ElectricityController> {
  const AddNewElectricityBill(this.billerName, this.billerData, {super.key});

  final Map<String, dynamic> billerData;
  final String billerName;

  Container consentCard(double height) {
    return Container(
      decoration: BoxDecoration(
        color: appColors.primaryColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(height / 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: height / 120),
            child: Image.asset(
              'assets/icons/bbps_logo.png',
              height: height / 24,
            ),
          ),
          SizedBox(width: height / 60),
          Expanded(
            child: Text(
                'By proceeding further, you allow Payhive to store your bill details, fetch current and future bills, and send you reminders',
                style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w400, fontSize: height / 40)),
          ),
        ],
      ),
    );
  }

  dottedDigits(double h) {
    return IntrinsicWidth(
      child: Container(
        margin: EdgeInsets.all(h / 100),
        height: h * 0.056,
        decoration: BoxDecoration(
          color: appColors.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(h * 0.01),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: h * 0.014),
        child: Row(
          children: List.generate(
            12,
            (_) => Container(
              margin: EdgeInsets.symmetric(horizontal: h * 0.003),
              width: h * 0.01,
              height: h * 0.01,
              decoration: BoxDecoration(
                color: appColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.getParams(billerData);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: appColors.bgColorHome,
      bottomNavigationBar: poweredBySetu(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          appBar(),
          SliverToBoxAdapter(
            child: GetBuilder(
              init: controller,
              builder: (_) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [body(context)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding poweredBySetu() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Powered by  ',
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.primaryColor,
              letterSpacing: 1,
              fontWeight: FontWeight.w200,
              fontSize: height / 28,
            ),
          ),
          Image.asset(
            'assets/temp/settu_logo.png',
            height: height / 14,
          )
        ],
      ),
    );
  }

  body(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: appColors.primaryColor.withValues(alpha: 0.2),
          padding: EdgeInsets.symmetric(
              vertical: height / 50, horizontal: width / 20),
          width: width,
          child: Text(
            billerName,
            maxLines: 2,
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.primaryColor,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
              fontSize: height / 32,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(height / 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' ${controller.paramName[0]}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.textDark.withValues(alpha: 0.8),
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                  fontSize: height / 32,
                ),
              ),
              SizedBox(height: height / 80),
              customTextField(
                textEditingController: controller.subId,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(width / 50),
                  borderSide: BorderSide(
                    color: appColors.black.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                inputFormatter: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'[!@#$%^&*(),.?":{}|<>-]'))
                ],
                title: '',
                fullTag: '',
                keyboardType: TextInputType.text,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: appColors.primaryColor,
                  fontSize: height / 26,
                  letterSpacing: 1,
                ),
              ),
              if (controller.paramName.length > 1)
                SizedBox(height: height / 20),
              if (controller.paramName.length > 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' ${controller.paramName[1]}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.textDark.withValues(alpha: 0.8),
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        fontSize: height / 32,
                      ),
                    ),
                    SizedBox(height: height / 80),
                    customTextField(
                      textEditingController: controller.subIdSec,
                      maxLength: 10,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width / 50),
                        borderSide: BorderSide(
                          color: appColors.black.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      onChanged: (v) {
                        controller.update();
                      },
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      title: '',
                      fullTag: '',
                      keyboardType: TextInputType.phone,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: appColors.primaryColor,
                        fontSize: height / 26,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: height / 20),
              if (!controller.isMobileNumberAvailableInParams)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' Registered mobile number',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.textDark.withValues(alpha: 0.8),
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        fontSize: height / 32,
                      ),
                    ),
                    SizedBox(height: height / 80),
                    customTextField(
                      textEditingController: controller.mobileNumber,
                      maxLength: 10,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width / 50),
                        borderSide: BorderSide(
                          color: appColors.black.withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      onChanged: (v) {
                        controller.update();
                      },
                      inputFormatter: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      title: '',
                      fullTag: '',
                      keyboardType: TextInputType.phone,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: appColors.primaryColor,
                        fontSize: height / 26,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              if (controller.values.isNotEmpty) SizedBox(height: height / 20),
              if (controller.values.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' ${controller.values.keys.first}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.textDark.withValues(alpha: 0.8),
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        fontSize: height / 32,
                      ),
                    ),
                    SizedBox(height: height / 80),
                    InkWell(
                      onTap: () {
                        showBottomSheetSelector(
                          context: context,
                          items:
                              controller.values[controller.values.keys.first]!,
                          controller: controller.subIdThird,
                          title: controller.values.keys.first,
                          onSelected: (val) {},
                        );
                      },
                      child: IgnorePointer(
                        ignoring: true,
                        child: customTextField(
                          textEditingController: controller.subIdThird,
                          maxLength: 10,
                          readOnly: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(width / 50),
                            borderSide: BorderSide(
                              color: appColors.black.withValues(alpha: 0.1),
                              width: 1,
                            ),
                          ),
                          onChanged: (v) {},
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          title: '',
                          fullTag: '',
                          keyboardType: TextInputType.phone,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: appColors.primaryColor,
                            fontSize: height / 26,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: height / 6),
              consentCard(height),
              SizedBox(height: height / 36),
              if (controller.subId.text.isNotEmpty &&
                  (controller.paramName.length <= 1 ||
                      controller.subIdSec.text.isNotEmpty) &&
                  (controller.isMobileNumberAvailableInParams ||
                      controller.mobileNumber.text.length == 10) &&
                  (controller.values.isEmpty ||
                      controller.subIdThird.text.isNotEmpty))
                controller.loader.value
                    ? Center(
                        child: Lottie.asset(
                          'assets/lottie/wave_loading.json',
                          width: width,
                          height: height / 4,
                        ),
                      )
                    : customButton(
                        title: 'Confirm',
                        onTap: () async {
                          controller.logo = billerData['logo'];

                          controller.selectedBiller = billerName;

                          List customerParams = [];

                          customerParams.add({
                            "name": controller.paramName[0],
                            "value": controller.subId.text
                          });

                          if (controller.paramName.length > 1) {
                            customerParams.addIf(
                                controller.paramName.length > 1, {
                              "name": controller.paramName[1],
                              "value": controller.subIdSec.text
                            });
                          }

                          if (controller.values.isNotEmpty) {
                            customerParams.addIf(controller.values.isNotEmpty, {
                              "name": controller.values.keys.first,
                              "value": controller.subIdThird.text
                            });
                          }

                          if (controller.isMobileNumberAvailableInParams ==
                              true) {
                            controller.mobileNumber.text =
                                controller.subIdSec.text;
                          }

                          await controller.getElectricityBillFetchRequest(
                              billerId: billerData['id'],
                              customerParams: customerParams);
                        },
                        context: context,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: appColors.white,
                          fontSize: height / 24,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
            ],
          ),
        ),
      ],
    );
  }

  SliverAppBar appBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: appColors.primaryColor,
      expandedHeight: height / 4.6,
      floating: false,
      pinned: true,
      forceElevated: true,
      stretch: true,
      title: null,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: appColors.primaryColor),
            Image.asset(
              'assets/images/flare_two.png',
              fit: BoxFit.fitHeight,
            ),
            Container(
              margin: EdgeInsets.only(
                left: width / 30,
                bottom: width / 20,
                right: width / 30,
              ),
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  backButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector backButton() {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              Icon(
                Icons.arrow_back_ios_rounded,
                size: height / 18,
                color: appColors.primaryExtraLight,
              ),
              SizedBox(width: width / 80),
              Text(
                'Electricity',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w300,
                  fontSize: height / 20,
                ),
              ),
            ],
          ),
          SizedBox(width: width / 2.65),
          Image.asset(
            'assets/home/bbps_white_logo.png',
            height: height / 10,
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------------------------------

Future<void> showBottomSheetSelector({
  required BuildContext context,
  required List<String> items,
  required TextEditingController controller,
  String title = 'Select an option',
  ValueChanged<String>? onSelected,
}) async {
  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
    builder: (ctx) {
      final searchController = TextEditingController();
      return StatefulBuilder(
        builder: (ctx, setState) {
          List<String> filtered = items
              .where((v) =>
                  v.toLowerCase().contains(searchController.text.toLowerCase()))
              .toList();

          return Padding(
            padding: EdgeInsets.only(
                left: 18,
                right: 18,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 14),
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.11)),
                    ),
                  ),
                  onChanged: (val) => setState(() {}),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 260, // Fixed height for scrolling
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            "No match found",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) =>
                              Divider(height: 0, color: Colors.grey.shade200),
                          itemBuilder: (ctx, idx) {
                            final value = filtered[idx];
                            return ListTile(
                              title: Text(value,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontSize: 16)),
                              onTap: () {
                                controller.text = value;
                                onSelected?.call(value);
                                Navigator.of(ctx).pop();
                              },
                            );
                          },
                        ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          );
        },
      );
    },
  );
}

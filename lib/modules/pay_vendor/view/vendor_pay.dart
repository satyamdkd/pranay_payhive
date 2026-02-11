import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:payhive/modules/pay_vendor/controller/vendor_payment_controller.dart';
import 'package:payhive/modules/pay_vendor/model/beneficiary_list.dart';
import 'package:payhive/modules/pay_vendor/view/transfer_money.dart';
import 'package:payhive/utils/helper/text_capitalization.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';

class VendorPaymentScreen extends GetView<VendorPaymentController> {
  const VendorPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.bgColorHome,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          appBar(),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => GetBuilder(
                  init: controller,
                  builder: (ctx) {
                    return body(context);
                  }),
              childCount: 1,
            ),
          ),
        ],
      ),
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
        children: [
          Icon(
            Icons.arrow_back_ios_rounded,
            size: height / 18,
            color: appColors.primaryExtraLight,
          ),
          SizedBox(width: width / 80),
          Text(
            "Vendor payment",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.white,
              fontWeight: FontWeight.w200,
              fontSize: height / 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget body(BuildContext context) {
    return Container(
      color: appColors.bgColorHome,
      child: Padding(
        padding: EdgeInsets.all(height / 30),
        child: controller.beneficiaryList.isNotEmpty
            ? beneficiaryList(context)
            : SizedBox(
                height: height * 1.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No beneficiary found!\nPlease add one by clicking the button below.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: appColors.black.withValues(alpha: 0.45),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        fontSize: height / 28,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    InkWell(
                      onTap: controller.onTapAddBeneficiaryButton,
                      child: Container(
                        height: height / 10,
                        width: width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(height / 10),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.topRight,
                            stops: const [-1, 2.0],
                            colors: [
                              appColors.primaryLight,
                              appColors.primaryColor,
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle_outline_rounded,
                              color: appColors.white,
                              size: height / 24,
                            ),
                            SizedBox(width: width / 90),
                            Text(
                              "Add Beneficiary",
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: appColors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: height / 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Column beneficiaryList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height / 20),
        _buildSearchBar(),
        SizedBox(height: height / 20),
        _buildActionButtons(context),
        SizedBox(height: height / 10),
        Text(
          " Recipient List",
          style: theme.textTheme.labelMedium?.copyWith(
            color: appColors.black,
            fontWeight: FontWeight.bold,
            fontSize: height / 24,
          ),
        ),
        SizedBox(height: height / 30),
        SizedBox(
          height: height / 0.7,
          width: width,
          child: controller.isLoadingBeneficiaries.value
              ? Center(
                  child: Lottie.asset(
                    'assets/lottie/wave_loading.json',
                    width: width,
                    height: height / 5,
                  ),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      ...List.generate(
                        controller.beneficiaryList.length,
                        (ind) => _buildRecipientItem(
                            context, controller.beneficiaryList[ind]),
                      ),
                      SizedBox(height: height / 2),
                    ],
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width / 30),
        color: appColors.white,
      ),
      child: customTextField(
        textEditingController: controller.searchedText,
        border: false,
        prefixIcon: Container(
          padding: EdgeInsets.all(width / 26),
          child: Icon(
            CupertinoIcons.search,
            size: height / 18,
          ),
        ),
        suffixIcon: controller.searchedText.text.isNotEmpty
            ? InkWell(
                onTap: () {
                  controller.beneficiaryList.clear();
                  controller.searchedText.clear();
                  controller.beneficiaryList.addAll(controller.tempList);
                  controller.update();
                },
                child: Container(
                  padding: EdgeInsets.all(width / 26),
                  child: Icon(
                    CupertinoIcons.clear_circled,
                    color: appColors.red,
                    size: height / 18,
                  ),
                ),
              )
            : null,
        onChanged: (v) {
          controller.onSearchTextChanged(v);
        },
        fullTag: "Search beneficiary",
        title: "",
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _buildActionButtons(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: controller.onTapAddBeneficiaryButton,
          child: Container(
            height: height / 11,
            width: width / 2.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height / 40),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                stops: const [-1, 2.0],
                colors: [
                  appColors.primaryLight,
                  appColors.primaryColor,
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_circle_outline_rounded,
                  color: appColors.white,
                  size: height / 24,
                ),
                SizedBox(width: width / 90),
                Text(
                  "Add Beneficiary",
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: height / 32,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: width / 60),
        // SizedBox(
        //   height: height / 11,
        //   width: width / 2.5,
        //   child: OutlinedButton(
        //     style: OutlinedButton.styleFrom(
        //       foregroundColor: appColors.primaryLight,
        //       side: BorderSide(
        //         color: appColors.primaryLight.withValues(alpha: 0.25),
        //         width: 1,
        //       ),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(height / 40),
        //       ),
        //     ),
        //     onPressed: () {
        //       Get.back();
        //     },
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         Icon(
        //           Icons.favorite_border_rounded,
        //           color: appColors.primaryLight,
        //           size: height / 24,
        //         ),
        //         SizedBox(width: width / 90),
        //         Text(
        //           "Favorites",
        //           style: theme.textTheme.labelMedium?.copyWith(
        //             color: appColors.primaryLight,
        //             fontWeight: FontWeight.w600,
        //             fontSize: height / 32,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildRecipientItem(context, Item item) {
    return Container(
      margin: EdgeInsets.only(bottom: height / 30),
      padding:
          EdgeInsets.symmetric(horizontal: height / 50, vertical: height / 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height / 40),
        border: Border.all(
            color: appColors.primaryLight.withValues(alpha: 0.20), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/icons/add_beneficiary_doc.png',
            height: height / 22,
          ),
          SizedBox(
            width: width / 60,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                capitalizeFirstCharacter("${item.name}"),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: height / 30,
                ),
              ),
              Text(
                "A/C: ${item.accountnumber}",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.black.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: height / 32,
                ),
              ),
              Text(
                "IFSC Code : ${item.ifsc}",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.black.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: height / 32,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              customButton(
                passedHeight: height / 12,
                passedWidth: width / 5,
                title: "Transfer",
                borderRadius: BorderRadius.circular(height / 40.0),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: height / 36,
                ),
                context: context,
                onTap: () {
                  controller.amount.clear();
                  controller.payeeDetails = item;
                  Future.delayed(Duration.zero, () {
                    Navigator.of(context).push(
                      TransferMoney(myController: controller),
                    );
                  });
                },
              ),
              SizedBox(width: width / 60),
              SizedBox(
                height: height / 12,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: appColors.red,
                    side: BorderSide(color: appColors.red, width: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(height / 40),
                    ),
                  ),
                  onPressed: () {
                    controller.deleteBeneficiary(context, item.id);
                  },
                  child: Text(
                    "Delete",
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: appColors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: height / 36,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

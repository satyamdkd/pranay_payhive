import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/personal_details/controller/personal_detail_controller.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/textfield.dart';

class PersonalDetails extends GetView<PersonalDetailsController> {
  const PersonalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.primaryExtraLight,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
            "Personal details",
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
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg_drop_down.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(height / 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // GestureDetector(
            //   onTap: controller.onClicked,
            //   child: buildMainHeader(Icons.person, "Contact Details"),
            // ),
            // AnimatedContainer(
            //   duration: const Duration(milliseconds: 500),
            //   height: controller.maxHeight.value,
            //   decoration: BoxDecoration(
            //     color: appColors.primaryColor,
            //     borderRadius: BorderRadius.only(
            //       topRight: Radius.circular(height / 20),
            //       bottomRight: Radius.circular(height / 20),
            //     ),
            //   ),
            //   padding: EdgeInsets.only(left: width / 80),
            //   margin: EdgeInsets.only(left: width / 20),
            //   child: AnimatedContainer(
            //     duration: const Duration(milliseconds: 500),
            //     height: controller.maxHeight.value,
            //     decoration: BoxDecoration(
            //       color: appColors.white,
            //       borderRadius: BorderRadius.only(
            //         topRight: Radius.circular(height / 20),
            //         bottomRight: Radius.circular(height / 20),
            //       ),
            //     ),
            //   ),
            // ),
            // if(controller.maxHeight.value != 300.0)
            //   SizedBox(height: height / 16),
            // buildMainHeader(Icons.currency_rupee_rounded, "Income Source"),
            // SizedBox(height: height / 16),
            // buildMainHeader(Icons.document_scanner_rounded, "Documents"),
            // SizedBox(height: height / 16),
            // buildMainHeader(Icons.account_balance_rounded, "Bank Details"),
            // SizedBox(height: height / 16),
            // buildMainHeader(Icons.home_outlined, "Address"),

            /// ---------------------------------------------
            Text(
              'Name',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.primaryColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
                fontSize: height / 28,
              ),
            ),
            SizedBox(height: height / 60),
            customTextField(
                textEditingController: controller.name,
                title: '',
                readOnly: true),

            /// ---------------------------------------------

            /// ---------------------------------------------
            Text(
              'Phone',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.primaryColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
                fontSize: height / 28,
              ),
            ),
            SizedBox(height: height / 60),
            customTextField(
                textEditingController: controller.phone,
                title: '',
                readOnly: true),

            /// ---------------------------------------------

            /// ---------------------------------------------
            Text(
              'Email',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.primaryColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
                fontSize: height / 28,
              ),
            ),
            SizedBox(height: height / 60),
            customTextField(
                textEditingController: controller.email,
                title: '',
                readOnly: true),

            /// ---------------------------------------------

            if (controller.address.text.isNotEmpty)
              Text(
                'Address',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: height / 28,
                ),
              ),
            if (controller.address.text.isNotEmpty)
              SizedBox(height: height / 60),
            if (controller.address.text.isNotEmpty)
              customTextField(
                textEditingController: controller.address,
                title: '',
                contentPadding: EdgeInsets.symmetric(
                    horizontal: width / 30, vertical: width / 30),
                readOnly: true,
                maxLines: 3,
              ),

            /// ---------------------------------------------
            Text(
              'Account Type',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.primaryColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
                fontSize: height / 28,
              ),
            ),
            SizedBox(height: height / 60),
            customTextField(
                textEditingController: controller.accountType,
                title: '',
                readOnly: true),

            /// ---------------------------------------------

            /// ---------------------------------------------

            if (controller.businessType.text.isNotEmpty)
              Text(
                'Bussiness Type',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: height / 28,
                ),
              ),
            if (controller.businessType.text.isNotEmpty)
              SizedBox(height: height / 60),
            if (controller.businessType.text.isNotEmpty)
              customTextField(
                  textEditingController: controller.businessType,
                  title: '',
                  readOnly: true),

            /// ---------------------------------------------

            /// ---------------------------------------------
            if (controller.formOfBusiness.text.isNotEmpty)
              Text(
                'Form Bussiness',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: height / 28,
                ),
              ),

            if (controller.formOfBusiness.text.isNotEmpty)
              SizedBox(height: height / 60),

            if (controller.formOfBusiness.text.isNotEmpty)
              customTextField(
                  textEditingController: controller.formOfBusiness,
                  title: '',
                  readOnly: true),

            /// ---------------------------------------------

            /// ---------------------------------------------
            Text(
              'Turnover',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.primaryColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
                fontSize: height / 28,
              ),
            ),
            SizedBox(height: height / 60),
            customTextField(
                textEditingController: controller.turnover,
                title: '',
                readOnly: true),

            /// ---------------------------------------------

            /// ---------------------------------------------

            if (controller.gst.text.isNotEmpty)
              Text(
                'GST',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: height / 28,
                ),
              ),
            if (controller.gst.text.isNotEmpty) SizedBox(height: height / 60),

            if (controller.gst.text.isNotEmpty)
              customTextField(
                  textEditingController: controller.gst,
                  title: '',
                  readOnly: true),

            /// ---------------------------------------------

            /// ---------------------------------------------

            if (controller.pan.text.isNotEmpty)
              Text(
                'Pan',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: height / 28,
                ),
              ),
            if (controller.pan.text.isNotEmpty) SizedBox(height: height / 60),

            if (controller.pan.text.isNotEmpty)
              customTextField(
                  textEditingController: controller.pan,
                  title: '',
                  readOnly: true),

            /// ---------------------------------------------
            /// ---------------------------------------------
            Text(
              'Aadhar',
              style: theme.textTheme.labelMedium?.copyWith(
                color: appColors.primaryColor,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
                fontSize: height / 28,
              ),
            ),
            SizedBox(height: height / 60),
            customTextField(
                textEditingController: controller.aadhar,
                title: '',
                readOnly: true),

            /// ---------------------------------------------
            /// ---------------------------------------------

            if (controller.bank.text.isNotEmpty)
              Text(
                'Bank',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: height / 28,
                ),
              ),
            if (controller.bank.text.isNotEmpty) SizedBox(height: height / 60),

            if (controller.bank.text.isNotEmpty)
              customTextField(
                  textEditingController: controller.bank,
                  title: '',
                  readOnly: true),

            /// ---------------------------------------------
            /// ---------------------------------------------

            if (controller.ifsc.text.isNotEmpty)
              Text(
                'IFSC',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                  fontSize: height / 28,
                ),
              ),
            if (controller.ifsc.text.isNotEmpty) SizedBox(height: height / 60),

            if (controller.ifsc.text.isNotEmpty)
              customTextField(
                  textEditingController: controller.ifsc,
                  title: '',
                  readOnly: true),

            /// ---------------------------------------------

            // myWidget('Name', TextEditingController()),
            // myWidget('Name', TextEditingController()),
            // myWidget('Name', TextEditingController()),
            // myWidget('Name', TextEditingController()),
            // myWidget('Name', TextEditingController()),
            // myWidget('Name', TextEditingController()),
          ],
        ),
      ),
    );
  }

  Column myWidget(title, textController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: appColors.primaryColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            fontSize: height / 28,
          ),
        ),
        SizedBox(height: height / 60),
        customTextField(
          textEditingController: textController.text,
          title: '',
        ),
      ],
    );
  }

  Row buildMainHeader(icon, title) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(height / 40),
          decoration: BoxDecoration(
            color: appColors.primaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: height / 16,
            color: appColors.white,
          ),
        ),
        SizedBox(width: width / 60),
        Text(
          title,
          style: theme.textTheme.labelMedium?.copyWith(
            color: appColors.primaryColor,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            fontSize: height / 24,
          ),
        ),
      ],
    );
  }
}

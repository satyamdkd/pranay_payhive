import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/all_billers/controller/all_billers_controller.dart';
import 'package:payhive/utils/theme/apptheme.dart';

class AllBillersPage extends GetView<AllBillersController> {
  const AllBillersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: appColors.primaryColor,
        body: body(context));
  }

  body(context) {
    return Container();
  }
}

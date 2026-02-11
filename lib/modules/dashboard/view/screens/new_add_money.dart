import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/dashboard/controller/dashboard_controller.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:payhive/utils/widgets/textfield.dart';

class AddMoneyNew extends GetView<DashBoardController> {
  const AddMoneyNew({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.removeFocus();
      },
      child: Padding(
        padding: EdgeInsets.all(height / 30),
        child: GetBuilder(
            init: controller,
            builder: (ctx) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: _buildBalanceSection(),
                  ),
                  spacing(passedHeight: height / 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        /* ------------------ UTILITY COMMENTED ----------------------

                     Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose the category of payment',
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: appColors.textDark,
                                fontFamily: 'Sora',
                                fontSize: height / 32,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            spacing(passedHeight: height / 40),
                            Obx(
                              () => Row(
                                children: [
                                  Expanded(
                                    child: CategoryButton(
                                      icon: Icons.bolt,
                                      label: "Utilities",
                                      isSelected:
                                          controller.selectedCategory.value == 0,
                                      onTap: () =>
                                          controller.selectedCategory.value = 0,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CategoryButton(
                                      icon: Icons.person,
                                      label: "Non-Utilities",
                                      isSelected:
                                          controller.selectedCategory.value == 1,
                                      onTap: () =>
                                          controller.selectedCategory.value = 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            spacing(passedHeight: height / 50),
                            Text(
                              'Bank will not charge any additional charges for this transaction',
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: appColors.textDark,
                                fontSize: height / 38,
                                fontFamily: 'Sora',
                                letterSpacing: 0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: appColors.bgColorHome,
                        thickness: 2,
                      ),

                      ----------------------------------------------------------- */

                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Select the settlement type',
                                  style: theme.textTheme.labelLarge!.copyWith(
                                    color: appColors.textDark,
                                    fontSize: height / 32,
                                    letterSpacing: 0.0,
                                    fontFamily: 'Sora',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              spacing(passedHeight: height / 40),
                              Obx(
                                () => Row(
                                  children: [
                                    Expanded(
                                      child: CategoryButton(
                                        myPadding: EdgeInsets.symmetric(
                                            vertical: width / 30),
                                        icon: Icons.access_time,
                                        label: "Instant",
                                        isSelected: controller
                                                .selectedSettlement.value ==
                                            0,
                                        onTap: () => controller
                                            .selectedSettlement.value = 0,
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: CategoryButton(
                                    //     myPadding: EdgeInsets.symmetric(
                                    //         vertical: width / 50),
                                    //     icon: Icons.access_time,
                                    //     label: "Instant",
                                    //     isSelected: controller
                                    //             .selectedSettlement.value ==
                                    //         0,
                                    //     onTap: () => controller
                                    //         .selectedSettlement.value = 0,
                                    //   ),
                                    // ),
                                    // SizedBox(width: width / 30),
                                    // Expanded(
                                    //   child: CategoryButton(
                                    //     myPadding: EdgeInsets.symmetric(
                                    //         vertical: width / 50),
                                    //     icon: Icons.access_time,
                                    //     label: "T+1",
                                    //     isSelected: controller
                                    //             .selectedSettlement.value ==
                                    //         1,
                                    //     onTap: () => controller
                                    //         .selectedSettlement.value = 1,
                                    //   ),
                                    // ),
                                    // SizedBox(width: width / 30),
                                    // Expanded(
                                    //   child: CategoryButton(
                                    //     myPadding: EdgeInsets.symmetric(
                                    //         vertical: width / 50),
                                    //     icon: Icons.access_time,
                                    //     label: "T+5",
                                    //     isSelected: controller
                                    //             .selectedSettlement.value ==
                                    //         2,
                                    //     onTap: () => controller
                                    //         .selectedSettlement.value = 2,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                              spacing(passedHeight: height / 50),
                              Text(
                                'Amount will be added instantly',
                                style: theme.textTheme.labelLarge!.copyWith(
                                  color: appColors.textDark,
                                  fontSize: height / 38,
                                  letterSpacing: 0,
                                  fontFamily: 'Sora',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  spacing(passedHeight: height / 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '   Content will provide by client',
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: appColors.textDark,
                        fontSize: height / 38,
                        letterSpacing: 0,
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  spacing(passedHeight: height / 60),
                  controller.isLoadingPayment.value
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CupertinoActivityIndicator(
                              radius: height / 20,
                              color: appColors.primaryLight,
                            ),
                          ),
                        )
                      : customButton(
                          title: 'Add Money',
                          context: context,
                          onTap: () {
                            controller.validateAddMoney(context);
                          },
                        ),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Padding(
      padding: EdgeInsets.all(height / 30),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "₹ ",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: height / 10,
                ),
              ),
              SizedBox(
                width: width / 3,
                child: TextField(
                  controller: controller.addMoneyAmount,
                  focusNode: controller.focusNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'[!@#$%^&*(),.?":{}|<>-]'))
                  ],
                  keyboardType: TextInputType.number,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: appColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: height / 12,
                  ),
                ),
              ),
            ],
          ),
          Image.asset(
            "assets/images/large_line.png",
            width: width / 2.2,
          ),
          SizedBox(height: height / 30),
          Text(
            "Minimum amount ₹ 1 to Maximum amount ₹ 99,999",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.textDark.withValues(alpha: 0.6),
              fontWeight: FontWeight.w400,
              letterSpacing: 0,
              fontFamily: 'Sora',
              fontSize: height / 36,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? myPadding;

  const CategoryButton({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.myPadding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: myPadding ?? EdgeInsets.symmetric(vertical: height / 44),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    Color(0xFF9C27B0),
                    Color(0xFF6A1B9A),
                  ],
                )
              : const LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                  ],
                ),
          border: Border.all(
              color:
                  isSelected ? Colors.transparent : appColors.primaryExtraLight,
              width: 0.8),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: myPadding == null ? 20 : 16,
                color: isSelected ? Colors.white : Colors.deepPurple),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.deepPurple,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Sora',
                  fontSize: myPadding == null ? height / 32 : height / 36),
            ),
          ],
        ),
      ),
    );
  }
}

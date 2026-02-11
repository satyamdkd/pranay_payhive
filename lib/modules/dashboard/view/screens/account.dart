import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/dashboard/controller/dashboard_controller.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';

class AccountManage extends GetView<DashBoardController> {
  const AccountManage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      child: GetBuilder(
        init: controller,
        builder: (ctx) {
          return SingleChildScrollView(
            controller: controller.scrollController,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        expandedHeight: height / 1.6,
                        backgroundColor: appColors.primaryColor,
                        pinned: true,
                        floating: false,
                        snap: false,
                        elevation: 4,
                        title: Text(
                          controller.toolbarOpacity.value < 180.0
                              ? ''
                              : 'Your Profile',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: appColors.white,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.5,
                            fontSize: height / 22,
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          background: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: appColors.white,
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/splash_bg.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: controller.toolbarOpacity.value > 180.0
                                    ? const SizedBox()
                                    : Container(
                                        alignment: Alignment.center,
                                        margin:
                                            EdgeInsets.only(top: height / 16),
                                        child: CircleAvatar(
                                          radius: height / 7,
                                          foregroundImage: const NetworkImage(
                                              'https://gratisography.com/wp-content/uploads/2024/11/gratisography-augmented-reality-800x525.jpg'),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: height / 1.7,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Card(
                            child: Container(
                              height: height / 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: height / 30),
                          Card(
                            child: Container(
                              height: height / 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: height / 30),
                          Card(
                            child: Container(
                              height: height / 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: height / 30),
                          Card(
                            child: Container(
                              height: height / 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

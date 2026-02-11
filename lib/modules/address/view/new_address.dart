import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:payhive/modules/address/controller/address_controller.dart';
import 'package:payhive/modules/address/view/location_pick.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/button.dart';
import 'package:location/location.dart' as loc;
import 'package:payhive/utils/widgets/snackbar.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationSelectionPage extends GetView<AddressController> {
  const LocationSelectionPage(
      this.defaultAddress, this.name, this.phone, this.listOfAddress,
      {super.key});

  final List listOfAddress;
  final String defaultAddress;
  final String name;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: controller,
        builder: (ctx) {
          return Scaffold(
            backgroundColor: appColors.bgColorHome,
            body: controller.isDeleting.value
                ? Center(
                    child: CupertinoActivityIndicator(
                      color: appColors.primaryColor,
                      radius: height / 10,
                    ),
                  )
                : CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      appBar(),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => body(context),
                          childCount: 1,
                        ),
                      ),
                    ],
                  ),
          );
        });
  }

  Widget locationOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    context,
  }) {
    return GetBuilder(
        init: controller,
        builder: (ctx) {
          return Container(
            decoration: BoxDecoration(
              color: appColors.white,
              borderRadius: BorderRadius.circular(height / 40),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                if (defaultAddress != '') SizedBox(height: height / 20),
                if (defaultAddress != '')
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: width / 30),
                      Icon(icon, color: color),
                      SizedBox(width: width / 30),
                      SizedBox(
                        width: width / 1.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: color)),
                            Text(
                              subtitle,
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: width / 20),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                      SizedBox(width: width / 30),
                    ],
                  ),
                if (defaultAddress != '') SizedBox(height: height / 40),
                if (defaultAddress != '')
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width / 20),
                    child: Divider(
                      color: appColors.black.withOpacity(0.2),
                      thickness: 0.6,
                    ),
                  ),
                controller.isMapOpened.value
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          vertical: height / 30,
                          horizontal: width / 30,
                        ),
                        child: CupertinoActivityIndicator(
                          color: appColors.primaryLight,
                        ),
                      )
                    : Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(
                          vertical: height / 40,
                          horizontal: width / 20,
                        ),
                        child: customButton(
                          passedHeight: height / 11,
                          passedWidth: width / 3.4,
                          title: "Add Address",
                          context: context,
                          onTap: () async {
                            controller.isMapOpened.value = true;
                            controller.update();
                            AndroidGoogleMapsFlutter.useAndroidViewSurface =
                                true;

                            await Future.delayed(Duration.zero, () async {
                              await controller.handleLocationPermission();
                            });

                            if (loc.PermissionStatus.granted ==
                                await controller.location.requestPermission()) {
                              if (controller.currentLat != 0.0) {
                                controller.isMapOpened.value = false;
                                controller.update();
                                Get.to(
                                  () => LocationPickerPage(
                                    name: name,
                                    phone: phone,
                                  ),
                                  transition: Transition.rightToLeft,
                                  duration: const Duration(seconds: 1),
                                );
                              } else {
                                showSnackBar(
                                  message:
                                      "Please wait your location is being fetched.",
                                  title: "Location",
                                );
                              }
                            } else {
                              await openAppSettings();
                            }
                          },
                        ),
                      ),
                SizedBox(height: height / 100),
              ],
            ),
          );
        });
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
                bottom: width / 40,
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
            Icons.keyboard_arrow_down_outlined,
            size: height / 10,
            color: appColors.primaryExtraLight,
          ),
          SizedBox(width: width / 80),
          Text(
            "Select a location",
            style: theme.textTheme.labelMedium?.copyWith(
              color: appColors.white,
              fontWeight: FontWeight.w300,
              fontSize: height / 18,
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
        padding: EdgeInsets.all(height / 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            locationOption(
                icon: Icons.my_location_rounded,
                title: 'Currently selected address',
                subtitle: defaultAddress,
                color: appColors.primaryColor,
                context: context),
            if (defaultAddress != '') SizedBox(height: height / 20),
            if (defaultAddress != '') savedAddressDivider(),
            SizedBox(height: height / 20),
            ...List.generate(
              listOfAddress.length,
              (ind) => InkWell(
                onTap: () {
                  controller.addressId = listOfAddress[ind]['id'].toString();
                  controller.defaultAddress();
                },
                child: Column(
                  children: [
                    savedAddressCard(
                      addressType: "Home",
                      address: listOfAddress[ind]['address'],
                      context: context,
                      id: listOfAddress[ind]['id'],
                      isDefault: listOfAddress[ind]['default'],
                    ),
                    SizedBox(height: height / 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container savedAddressCard({addressType, address, context, id, isDefault}) {
    return Container(
      decoration: BoxDecoration(
        color: isDefault == 0
            ? appColors.white
            : appColors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(height / 40),
        border: Border.all(
          color: isDefault == 0 ? appColors.white : appColors.green,
          width: 0.25,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: height / 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: width / 30),
              Icon(
                  addressType == "Home"
                      ? Icons.home_rounded
                      : CupertinoIcons.building_2_fill,
                  color: appColors.primaryColor,
                  size: height / 18),
              SizedBox(width: width / 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: width / 1.5,
                    child: Text(
                      address ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: height / 28,
                      ),
                    ),
                  ),
                  SizedBox(height: height / 60),
                ],
              ),
              InkWell(
                onTap: () {
                  controller.addressId = id.toString();
                  controller.deleteAddress();
                },
                child: Icon(
                  CupertinoIcons.delete,
                  color: appColors.red,
                  size: height / 22,
                ),
              ),
              SizedBox(width: width / 30),
            ],
          ),
          SizedBox(height: height / 40),
        ],
      ),
    );
  }

  Row savedAddressDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: width / 6,
          child: Divider(
            color: appColors.black.withOpacity(0.35),
            thickness: 0.7,
          ),
        ),
        Text(
          "   SAVED ADDRESS   ",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: appColors.black.withOpacity(0.35),
            fontSize: height / 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
          width: width / 6,
          child: Divider(
            color: appColors.black.withOpacity(0.35),
            thickness: 0.7,
          ),
        ),
      ],
    );
  }
}

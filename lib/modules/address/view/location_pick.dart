import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:payhive/constants/urls.dart';
import 'package:payhive/modules/address/view/bottomsheet.dart';
import 'package:payhive/utils/screen_size.dart';
import 'package:payhive/utils/widgets/button.dart';
import '../../../utils/theme/apptheme.dart';
import '../controller/address_controller.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage(
      {super.key, required this.name, required this.phone});

  final String name;
  final String phone;

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final AddressController controller = Get.find<AddressController>();
  Map<String, LatLng> map = {};

  @override
  void initState() {
    super.initState();
    map['hi'] = LatLng(controller.currentLat, controller.currentLong);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (b, t) async {
        Get.back();
        Get.back();
      },
      child: Scaffold(
        backgroundColor: appColors.bgColorHome,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            MapLocationPicker(
              apiKey: URLs.googleAPIKEY,
              region: 'in',
              trafficEnabled: false,
              mapType: MapType.normal,
              buildingsEnabled: false,
              hideLocationButton: true,
              hideBottomCard: true,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                ),
                hintText: "Search",
              ),
              onNext: (GeocodingResult? result) {
                if (result != null) {
                  controller.landmark.text = result.formattedAddress!;
                  controller.address.text = result.formattedAddress!;
                }
              },
              onSuggestionSelected: (PlacesDetailsResponse? result) {
                controller.latitude.text =
                    result!.result.geometry!.location.lat.toString();
                controller.longitude.text =
                    result.result.geometry!.location.lng.toString();

                controller.currentLat = result.result.geometry!.location.lat;
                controller.currentLong = result.result.geometry!.location.lng;

                controller.landmark.text = result.result.formattedAddress!;
                controller.address.text = result.result.formattedAddress!;

                setState(() {});
              },
              onDecodeAddress: (result) async {
                controller.titleAddressToShow =
                    result!.addressComponents.first.shortName;
                controller.fullAddressToShow = result.formattedAddress!;

                controller.latitude.text =
                    result.geometry.location.lat.toString();
                controller.longitude.text =
                    result.geometry.location.lng.toString();

                setState(() {});
              },
              currentLatLng:
                  LatLng(controller.currentLat, controller.currentLong),
              location: Location(
                  lat: controller.currentLat, lng: controller.currentLong),
              hideBackButton: true,
              hideMapTypeButton: true,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: width / 3.1),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: appColors.primaryColor,
                            backgroundColor: Colors.white,
                            minimumSize: const Size(88, 30),
                            side: BorderSide(
                                width: 0.8, color: appColors.primaryColor),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(height / 40.0)),
                            ),
                          ),
                          onPressed: () async {
                            controller.currentLat =
                                controller.currentLatThatIsFixed!;
                            controller.currentLong =
                                controller.currentLongThatIsFixed!;

                            final newName = widget.name;
                            final newPhone = widget.phone;

                            Get.back();
                            Get.to(
                              () => LocationPickerPage(
                                name: newName,
                                phone: newPhone,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.my_location,
                                color: appColors.primaryColor,
                                size: height / 26,
                              ),
                              Text(
                                " Current location ",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                    color: appColors.primaryColor,
                                    fontWeight: FontWeight.w300,
                                    fontSize: height / 28),
                              ),
                            ],
                          ),
                        ),
                      ),
                      spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          Get.back();
                        },
                        child: Icon(
                          Icons.clear_rounded,
                          color: appColors.red,
                          size: height / 10,
                        ),
                      ),
                      SizedBox(
                        width: width / 40,
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(width / 30),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "YOUR CURRENTLY SELECTED ADDRESS",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: height / 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: appColors.primaryLight,
                                  size: height / 18,
                                ),
                                Text(controller.titleAddressToShow,
                                    style: TextStyle(
                                        fontSize: height / 18,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width / 17),
                          child: Text(
                            controller.fullAddressToShow,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.yellow[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "Please select your address precisely using the pin point location marker.",
                          ),
                        ),
                        customButton(
                          title: 'Add more address details',
                          context: context,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: appColors.white,
                            fontSize: height / 22,
                            fontWeight: FontWeight.w500,
                          ),
                          onTap: () {
                            controller
                                .parseAddress(controller.fullAddressToShow);

                            controller.update();
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => AddressBottomSheet(
                                address: controller.fullAddressToShow,
                                name: widget.name,
                                phone: widget.phone,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Spacer spacer() => const Spacer();
}

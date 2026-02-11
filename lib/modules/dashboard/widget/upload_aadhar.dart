import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:payhive/constants/colors.dart';
import 'package:payhive/services/network/network.dart';
import 'package:image_picker/image_picker.dart';
import 'package:payhive/utils/widgets/snackbar.dart';

import '../../../routes/pages.dart';
import '../../../services/di/di.dart';
import '../../../services/network/api_result.dart';
import '../../../utils/screen_size.dart';
import '../../../utils/theme/apptheme.dart';
import '../../auth/face_detections/face_detector_view.dart';
import '../controller/dashboard_controller.dart';

void showDocumentUploadDialog() {
  final dashController = Get.find<DashBoardController>();

  Get.dialog(
    PopScope(
      canPop: false,
      child: GetBuilder(
          init: dashController,
          builder: (ctx) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.orange),
                      child: Text(
                        "Your account is not yet active. Please complete your verification process to get started.",
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: height / 30,
                        ),
                      ),
                    ),

                    // const Text(
                    //   'Upload Document',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontFamily: 'Inter',
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),

                    const SizedBox(height: 12),

                    const Text(
                      'Complete your account set-up by uploading Aadhar/Pan card documents & Bank verification',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    /// Aadhaar
                    _UploadOptionTile(
                      icon: Icons.badge_outlined,
                      title: 'Upload Aadhaar',
                      subtitle: 'Front & back required',
                      isUploaded: dashController.isAadharUploaded.value,
                      onTap: () async {
                        // final File? file = await pickImage();
                        // if (file == null) return;
                        //
                        // showLoader();
                        //
                        // final result = await uploadDoc(
                        //   type: "aadhar",
                        //   document: file,
                        // );
                        // Get.back();
                        //
                        // await Future.delayed(const Duration(seconds: 1),
                        //     () async {
                        //   await dashController.dashboardApi();
                        //   dashController.update();
                        //
                        //   if (result is ApiSuccess) {
                        //     if (dashController.isPanUploaded.value &&
                        //         dashController.isAadharUploaded.value) {
                        //       Get.back();
                        //       Get.back();
                        //     }
                        //   } else {
                        //     Get.snackbar('Error', 'Upload failed');
                        //   }
                        // });

                        Get.toNamed(Routes.reverifyAadhaar);
                      },
                    ),

                    const SizedBox(height: 12),

                    /// PAN
                    _UploadOptionTile(
                      icon: Icons.credit_card_outlined,
                      title: 'Upload PAN',
                      subtitle: 'Clear photo required',
                      isUploaded: dashController.isPanUploaded.value,
                      onTap: () async {
                        final File? file = await pickImage();
                        if (file == null) return;

                        showLoader();

                        final result = await uploadDoc(
                          type: "pan",
                          document: file,
                        );
                        Get.back();

                        await Future.delayed(const Duration(seconds: 1),
                            () async {
                          await dashController.dashboardApi();

                          dashController.update();

                          if (result is ApiSuccess) {
                            if (dashController.isPanUploaded.value &&
                                dashController.isAadharUploaded.value) {
                              Get.back();
                              Get.back();
                            }
                          } else {
                            Get.snackbar('Error', 'Upload failed');
                          }
                        });
                      },
                    ),

                    /// Business Photo

                    if (dashController.accountType.value == 'agent' ||
                        dashController.accountType.value == 'business' ||
                        dashController.accountType.value == 'selfemployed')
                      const SizedBox(height: 12),

                    if (dashController.accountType.value == 'agent' ||
                        dashController.accountType.value == 'business' ||
                        dashController.accountType.value == 'selfemployed')
                      _UploadOptionTile(
                        icon: Icons.photo,
                        title: 'Business Photo',
                        subtitle: 'Take a photo of your business',
                        isUploaded:
                            dashController.isBusinessPhotoUploaded.value,
                        onTap: () async {
                          final File? file = await pickImage();
                          if (file == null) return;

                          showLoader();

                          final result = await uploadDoc(
                            type: "business",
                            document: file,
                          );
                          Get.back();

                          await Future.delayed(const Duration(seconds: 1),
                              () async {
                            await dashController.dashboardApi();
                            dashController.update();

                            if (result is ApiSuccess) {
                              if (dashController.isPanUploaded.value &&
                                  dashController.isAadharUploaded.value &&
                                  dashController
                                      .isBusinessPhotoUploaded.value) {
                                Get.back();
                              }
                            } else {
                              Get.snackbar('Error', 'Upload failed');
                            }
                          });
                        },
                      ),

                    const SizedBox(height: 12),
                    _UploadOptionTile(
                      icon: Icons.account_balance_outlined,
                      title: 'Add Bank',
                      subtitle: 'Verify your bank detail',
                      isUploaded: dashController.isBankUploaded.value,
                      onTap: () async {
                        ScaffoldMessenger.of(Get.context!).clearSnackBars();

                        Get.toNamed(Routes.bankDetail)!.then((v) async {
                          Get.back();
                          await dashController.dashboardApi();

                          dashController.update();
                        });
                      },
                    ),

                    if (dashController.isProfilePicApproved.value != 'approve')
                      const SizedBox(height: 12),
                    if (dashController.isProfilePicApproved.value != 'approve')
                      _UploadOptionTile(
                        icon: Icons.face,
                        title: 'Re-upload selfie',
                        subtitle:
                            'Your selfie was rejected by the admin. Please re-upload your selfie.',
                        isUploaded: dashController.isProfilePicApproved.value ==
                            'rejected',
                        onTap: () async {
                          isSelfieReUploading = true;
                          ScaffoldMessenger.of(Get.context!).clearSnackBars();

                          Get.to(const FaceDetectorView());
                        },
                      ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          }),
    ),
    barrierDismissible: false,
  );
}

class _UploadOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isUploaded;
  final VoidCallback onTap;

  const _UploadOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isUploaded,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: isUploaded ? () {} : onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (!isUploaded)
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Colors.grey,
              ),
            if (isUploaded)
              const Icon(
                CupertinoIcons.checkmark_seal,
                size: 22,
                color: Colors.green,
              ),
          ],
        ),
      ),
    );
  }
}

Future<ApiResults> uploadDoc({
  required String? type,
  required File? document,
}) async {
  dio.FormData formData = dio.FormData.fromMap({
    "type": type,
    "file": document != null
        ? await dio.MultipartFile.fromFile(
            document.path,
            filename: 'file.${document.path.split('.').last}',
          )
        : "",
  });

  return await Network().postDataWithFilesNew(
    endPoint: '/update-panaadhar',
    formData: formData,
  );
}

Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();

  final XFile? pickedFile = await Get.bottomSheet<XFile?>(
    SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () async {
              final file = await picker.pickImage(source: ImageSource.camera);
              Get.back(result: file);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () async {
              final file = await picker.pickImage(source: ImageSource.gallery);
              Get.back(result: file);
            },
          ),
        ],
      ),
    ),
    backgroundColor: Colors.white,
  );

  if (pickedFile == null) return null;
  return File(pickedFile.path);
}

void showLoader() {
  Get.dialog(
    const PopScope(
        canPop: false, child: Center(child: CircularProgressIndicator())),
    barrierDismissible: false,
  );
}

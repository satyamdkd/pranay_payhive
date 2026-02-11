import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:payhive/modules/list_pos_req/model/all_pos_request.dart';
import 'package:payhive/modules/list_pos_req/repo/list_pos_repo.dart';
import 'package:payhive/services/network/api_result.dart';
import 'package:payhive/utils/theme/apptheme.dart';
import 'package:payhive/utils/widgets/snackbar.dart';

class ListPosController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final tabs = const [
    Tab(text: 'Pending'),
    Tab(text: 'Approved'),
    Tab(text: 'Rejected'),
  ];

  ListPOSRepo repo = ListPOSRepo();

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      if (tabController.indexIsChanging == false) {
        update();
      }
    });
    getAllPosList();
  }

  AllPosRequest? allPosRequest;

  List<PosRequestItem> posReqList = [];
  List<PosRequestItem> pending = [];
  List<PosRequestItem> approved = [];
  List<PosRequestItem> rejected = [];

  RxBool loading = false.obs;
  getAllPosList() async {
    try {
      posReqList = [];
      pending = [];
      approved = [];
      rejected = [];
      loading.value = true;
      update();

      final response = await repo.getPosRequestList();

      if (response is ApiSuccess) {
        final data = response.data;
        allPosRequest = AllPosRequest.fromJson(data);

        if (data['status'] == 1) {
          if (response.data['data'] != null && response.data['data'] != []) {
            for (int i = 0; i < response.data['data'].length; i++) {
              posReqList.add(PosRequestItem.fromJson(response.data['data'][i]));

              if (response.data['data'][i]['status'] == 'pending') {
                pending.add(PosRequestItem.fromJson(response.data['data'][i]));
              }
              if (response.data['data'][i]['status'] == 'approve') {
                approved.add(PosRequestItem.fromJson(response.data['data'][i]));
              }
              if (response.data['data'][i]['status'] == 'reject') {
                rejected.add(PosRequestItem.fromJson(response.data['data'][i]));
              }
            }
          }
        } else {
          _showError(data['msg']);
        }
      } else if (response is ApiFailure) {}
    } catch (e) {
      debugPrint(e.toString());
      showSnackBar(message: 'Something went wrong.', title: 'PayLix');
    } finally {
      loading.value = false;
      update();
    }
  }

  TextEditingController selectDate = TextEditingController();

  File? file;
  String? selectedBank;
  String? bankID;
  String? tidToSendInApi;
  String? midToSendInApi;
  String? selectedCard;

  RxBool isLoading = false.obs;

  _showError(String message) {
    update();
    showSnackBar(
      message: message,
      title: "PayLix",
      color: appColors.red,
    );
  }
}

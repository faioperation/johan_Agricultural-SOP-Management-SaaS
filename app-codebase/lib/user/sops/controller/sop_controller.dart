import 'package:farm_check_support/app/token_service.dart';
import 'package:farm_check_support/core/services/network/network_client.dart';

import 'package:farm_check_support/user/sops/model/sop_detail_model.dart';
import 'package:farm_check_support/user/sops/model/sop_list_model.dart';
import 'package:farm_check_support/user/sops/model/sop_module_model.dart';
import 'package:farm_check_support/user/sops/repo/sop_repository.dart';
import 'package:get/get.dart';

class SopController extends GetxController {
  final SopRepository _repository;

  SopController(this._repository);

  var isLoadingModules = false.obs;
  var isLoadingSopList = false.obs;
  var isLoadingSopDetail = false.obs;


  var sopModules = <SopModule>[].obs;
  var sopList = <SopItem>[].obs;
  var sopDetail = Rxn<SopDetailData>();


  @override
  void onInit() {
    super.onInit();
    if (TokenService.accessToken != null) {
      fetchSopModules();
    }
  }

  Future<void> fetchSopModules() async {
    isLoadingModules.value = true;
    try {
      NetworkResponse response = await _repository.getSopModules();
      if (response.isSuccess && response.responseData != null) {
        SopModuleResponse moduleResponse = SopModuleResponse.fromJson(response.responseData);
        sopModules.value = moduleResponse.data ?? [];
      }
    } catch (e) {
      print('Error fetching SOP modules: $e');
    } finally {
      isLoadingModules.value = false;
    }
  }

  Future<void> fetchSopList(String module) async {
    isLoadingSopList.value = true;
    sopList.clear();
    try {
      NetworkResponse response = await _repository.getSopList(module);
      if (response.isSuccess && response.responseData != null) {
        SopListResponse listResponse = SopListResponse.fromJson(response.responseData);
        sopList.value = listResponse.data ?? [];
      }
    } catch (e) {
      print('Error fetching SOP list: $e');
    } finally {
      isLoadingSopList.value = false;
    }
  }

  Future<void> fetchSopDetail(String id) async {
    isLoadingSopDetail.value = true;
    sopDetail.value = null;
    try {
      NetworkResponse response = await _repository.getSopDetail(id);
      if (response.isSuccess && response.responseData != null) {
        SopDetailResponse detailResponse =
            SopDetailResponse.fromJson(response.responseData);
        sopDetail.value = detailResponse.data;
      }
    } catch (e) {
      print('Error fetching SOP detail: $e');
    } finally {
      isLoadingSopDetail.value = false;
    }
  }


}

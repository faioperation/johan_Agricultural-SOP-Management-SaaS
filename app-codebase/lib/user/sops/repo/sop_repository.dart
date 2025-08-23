import 'package:farm_check_support/app/urls.dart';
import 'package:farm_check_support/core/services/network/network_client.dart';

class SopRepository {
  final NetworkClient _client;

  SopRepository(this._client);

  Future<NetworkResponse> getSopModules() {
    return _client.getRequest(ApiUrls.employeeSops);
  }

  Future<NetworkResponse> getSopList(String module) {
    return _client.getRequest(ApiUrls.employeeSopList(module));
  }

  Future<NetworkResponse> getSopDetail(String id) {
    return _client.getRequest(ApiUrls.employeeSopDetail(id));
  }


}

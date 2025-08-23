import 'package:farm_check_support/app/urls.dart';
import 'package:farm_check_support/core/services/network/network_client.dart';

class AuthRepository {
  final NetworkClient _client;

  AuthRepository(this._client);

  Future<NetworkResponse> login({
    required String email,
    required String password,
  }) async {
    // Try standard login first
    var response = await _client.postRequest(
      ApiUrls.login,
      body: {
        "email": email,
        "password": password,
      },
    );

    // If it fails, try employee login
    if (!response.isSuccess) {
      response = await _client.postRequest(
        ApiUrls.employeeLogin,
        body: {
          "email": email,
          "password": password,
        },
      );
    }

    return response;
  }

  Future<NetworkResponse> forgotPassword({required String email}) {
    return _client.postRequest(
      ApiUrls.forgotPassword,
      body: {"email": email},
    );
  }

  Future<NetworkResponse> verifyForgotOtp({
    required String email,
    required String otp,
  }) {
    return _client.postRequest(
      ApiUrls.verifyForgotOtp,
      body: {
        "email": email,
        "otp": otp,
      },
    );
  }

  Future<NetworkResponse> resetPassword({
    required String password,
  }) {
    return _client.postRequest(
      ApiUrls.resetPassword,
      body: {
        "newPassword": password,
      },
    );
  }
}

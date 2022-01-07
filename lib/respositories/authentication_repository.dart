import 'package:vtms_frontend/models/current_user.dart';
import 'package:vtms_frontend/services/http_service.dart';

class AuthenticationReposiry {
  HttpService httpService = HttpService();

  Future<CurrentUser> login(String username, String password) async {
    var response = await httpService.postResponse(url: 'users/login', body: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      return CurrentUser.fromJson(response.data);
    } else {
      throw Exception('Failed to login');
    }
  }
}

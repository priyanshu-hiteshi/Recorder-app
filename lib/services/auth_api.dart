import 'package:chatapp/helper/end_points.dart';
import 'package:chatapp/services/auth_service.dart';

class AuthAPI {
  static Future<void> fetchUser() async {
    final response = await ApiService.getRequest(
      endPoint: EndPoints.users,
      headers: {
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjI2LCJlbWFpbCI6Imxva2VuODIwMDJAZ21haWwuY29tIiwibmFtZSI6Imxva2VuZHJhIiwiaWF0IjoxNzM0MDA1MjEyLCJleHAiOjE3MzQ2MTAwMTJ9.6iYlwOg6DgLHtecmEESirdw-u22m7xD1OnraPNg8_oQ"
      },
    );

    print(response);
  }
}

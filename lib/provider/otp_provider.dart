import 'package:flutter/material.dart';

class OtpProvider extends ChangeNotifier {
  static int get otpLength => 6;
  final List<TextEditingController> otpControllers =
      List.generate(otpLength, (_) => TextEditingController());
  final List<FocusNode> focusNodes =
      List.generate(otpLength, (_) => FocusNode());

  String get otp => otpControllers.map((controller) => controller.text).join();

  void onOtpChanged(int index, String value, BuildContext context) {
    if (value.isNotEmpty && index < focusNodes.length - 1) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    } else if (index == focusNodes.length - 1) {
      FocusScope.of(context).unfocus();
    }
    notifyListeners();
  }

  void verifyOtp(BuildContext context) {
    if (otp.length == otpLength && otp.isNotEmpty) {
      print("OTP entered: $otp");
      //  ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("here is yout  $otp")),
      //   );
      // Add verification logic here
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 4-digit OTP")),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}

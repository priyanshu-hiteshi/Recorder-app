import 'package:chatapp/screens/otp/otp-components/otp_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/otp_provider.dart';
import './otp-components/otp_widget.dart';
import '../auth/background.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpProvider(),
      child: Scaffold(
        body: BackgroundWidget(
          child: Consumer<OtpProvider>(
            builder: (context, otpProvider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "OTP Screen",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 80),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(OtpProvider.otpLength, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: OtpBox(
                          controller: otpProvider.otpControllers[index],
                          focusNode: otpProvider.focusNodes[index],
                          onChanged: (value) =>
                              otpProvider.onOtpChanged(index, value, context),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () => otpProvider.verifyOtp(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Verify",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(otpProvider.otp),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

//   Widget _buildOtpBox(TextEditingController controller, FocusNode currentNode,
//       FocusNode? nextNode) {
//     return SizedBox(
//       width: 50,
//       child: TextField(
//         controller: controller,
//         focusNode: currentNode,
//         maxLength: 1,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: Colors.white),
//         decoration: const InputDecoration(
//           counterText: "",
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.blue),
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//           ),
//         ),
//         onChanged: (value) {
//           if (value.isNotEmpty) {
//             if (nextNode != null) {
//               FocusScope.of(context).requestFocus(nextNode);
//             } else {
//               FocusScope.of(context).unfocus();
//             }
//           }
//         },
//       ),
//     );
//   }
// }

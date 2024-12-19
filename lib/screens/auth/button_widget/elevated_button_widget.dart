// import 'package:flutter/material.dart';

// class ElevatedButtonWidget extends StatelessWidget {
//   final void Function() onPressed;
//   final String buttonName;
//   final Color backgroundColor;

//   const ElevatedButtonWidget({
//     super.key,
//     required this.onPressed,
//     required this.buttonName,
//     this.backgroundColor = const Color(0xFF2575FC),
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: backgroundColor,
//         foregroundColor: const Color.fromARGB(255, 244, 245, 246),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.0),
//         ),
//         padding: const EdgeInsets.symmetric(vertical: 16.0),
//       ),
//       child: Text(
//         buttonName,
//         style: TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final void Function() onPressed;
  final String buttonName;
  final List<Color> gradientColors;

  const ElevatedButtonWidget({
    super.key,
    required this.onPressed,
    required this.buttonName,
    this.gradientColors = const [
      Color(0xFF2575FC),
      Color(0xFF6A11CB)
    ], // Default gradient colors
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Color(0xFF2575FC))
        
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // Make the button background transparent
          shadowColor: Colors
              .transparent, // Remove the shadow to avoid breaking the gradient
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
        ),
        child: Text(
          buttonName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors
                .white, // Ensure the text color contrasts with the gradient
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/all_audios_model.dart';
import '../provider/recorder_provider.dart';

class AnimatedGradientButton extends StatefulWidget {
  final AllAudio recording;

  const AnimatedGradientButton({
    Key? key,
    required this.recording,
  }) : super(key: key);

  @override
  _AnimatedGradientButtonState createState() => _AnimatedGradientButtonState();
}

class _AnimatedGradientButtonState extends State<AnimatedGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: false); // Infinite animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recorderProvider = Provider.of<RecorderProvider>(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GestureDetector(
          onTap: () async {
            // Call the generateRecordingData function
            await recorderProvider.generateRecordingData(
                context, widget.recording);
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: const [
                  Colors.blue,
                  Colors.purple,
                  Colors.red,
                  Colors.orange,
                  Colors.blue,
                ],
                stops: [0.0, 0.25, 0.5, 0.75, 1.0],
                transform: GradientRotation(_controller.value * 6.28),
              ),
              border: Border.all(
                width: 2,
                color: Colors.transparent, // Makes the inner area look clean
              ),
            ),
            child: Center(
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.pinkAccent, Colors.orangeAccent],
                  ),
                ),
                child: Image.asset(
                  'assets/animations/speech-synthesis.png',
                  height: 5,
                  width: 5,
                ),
              ),
            ),
            
          ),
        );
      },
    );
  }
}

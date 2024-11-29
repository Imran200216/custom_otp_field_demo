import 'package:custom_otp_field_demo/widgets/custom_otp_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    // Initialize 6 controllers and focus nodes for OTP input fields.
    for (int i = 0; i < 6; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
  }

  @override
  void dispose() {
    // Dispose of controllers and focus nodes when done
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _getLastOtpFieldValue() {
    String lastValue = _controllers.last.text;
    print("Last OTP Field Value: $lastValue");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Otp demo",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  6,
                  (index) {
                    return RawKeyboardListener(
                      focusNode: FocusNode(),
                      // Separate focus node for listening to key events
                      onKey: (RawKeyEvent event) {
                        // Check if backspace is pressed
                        if (event is RawKeyDownEvent &&
                            event.logicalKey == LogicalKeyboardKey.backspace) {
                          if (_controllers[index].text.isEmpty && index > 0) {
                            // Move to the previous field and delete its content
                            _focusNodes[index - 1].requestFocus();
                            _controllers[index - 1].clear();
                          }
                        }
                      },
                      child: CustomOtpField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        previousFocusNode:
                            index > 0 ? _focusNodes[index - 1] : null,
                        onChanged: (value) {
                          // Move to the next field when text is entered and it's not the last field
                          if (value.isNotEmpty && index < 5) {
                            _focusNodes[index + 1].requestFocus();
                          }
                          // Call _getLastOtpFieldValue whenever there's a change
                          _getLastOtpFieldValue();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

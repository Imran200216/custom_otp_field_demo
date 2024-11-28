import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomOtpField extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? previousFocusNode;

  const CustomOtpField({
    super.key,
    required this.onChanged,
    required this.controller,
    required this.focusNode,
    this.previousFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 40,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
        onSubmitted: (_) {
          if (controller.text.isNotEmpty) {
            focusNode.nextFocus();
          }
        },
        onEditingComplete: () {
          if (controller.text.isEmpty && previousFocusNode != null) {
            previousFocusNode!.requestFocus();
          }
        },
      ),
    );
  }
}

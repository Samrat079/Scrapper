import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:scrapper/Services/AppUserServices/AppUserServices01.dart';
import 'package:scrapper/theme/theme_extensions.dart';

import '../../../Custome/CenterColumn/CenterColumn04.dart';

class AddOtp01 extends StatefulWidget {
  final PageController controller;

  const AddOtp01({super.key, required this.controller});

  @override
  State<AddOtp01> createState() => _AddOtp01State();
}

class _AddOtp01State extends State<AddOtp01> {
  final PinInputController otpController = PinInputController();

  bool isLoading = false;
  String? errorText;

  void clear() {
    otpController.clear();
    setState(() => errorText = null);
  }

  Future<void> submitHandler(String otp) async {
    setState(() {
      isLoading = true;
      errorText = null;
    });

    /// Same validation logic as before
    if (otp.length != 6) {
      setError("Please enter a valid 6-digit OTP");
      return;
    }

    try {
      await AppUserServices01().verifyOtp(otp);

      widget.controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    } on FirebaseAuthException catch (e) {
      setError(e.message ?? "Verification failed");
    } catch (_) {
      setError("Something went wrong");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void setError(String message) {
    otpController.triggerError();
    setState(() => errorText = message);
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CenterColumn04(
      centerVertically: true,
      padding: context.paddingXL,
      children: [
        Image.asset('assets/Illustrations/otp01.png', height: 256),

        context.gapMD,

        const Text(
          'Please add otp',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        context.gapXL,

        /// 🔑 PIN FIELD (replaces FormBuilderField)
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialPinField(
              length: 6,
              pinController: otpController,
              onChanged: (_) {
                if (errorText != null) {
                  setState(() => errorText = null);
                }
              },
              onCompleted: submitHandler,
              theme: const MaterialPinTheme(cellSize: Size(40, 46)),
            ),

            context.gapSM,

            if (errorText != null)
              Text(
                errorText!,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
          ],
        ),

        context.gapMD,

        if (isLoading)
          Column(
            children: [
              const LinearProgressIndicator(),
              context.gapSM,
              const Text('Please wait', textAlign: TextAlign.center),
              context.gapMD,
            ],
          ),

        ElevatedButton(
          onPressed: isLoading ? null : () => submitHandler(otpController.text),
          child: const Text('Submit'),
        ),

        context.gapMD,

        ElevatedButton(
          onPressed: clear,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.colorScheme.surfaceContainerHigh,
            foregroundColor: context.colorScheme.onSurface,
          ),
          child: const Text('Clear'),
        ),
      ],
    );
  }
}

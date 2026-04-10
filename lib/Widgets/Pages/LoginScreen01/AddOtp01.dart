import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:scrapper/Services/Auth/AuthServices.dart';

import '../../Custome/CardColumn01/CardColumn01.dart';

class AddOtp01 extends StatefulWidget {
  const AddOtp01({super.key});

  @override
  State<AddOtp01> createState() => _AddOtp01State();
}

class _AddOtp01State extends State<AddOtp01> {
  final _otpController = GlobalKey<FormBuilderState>();

  void clear() => _otpController.currentState!.reset();

  void submitHandler() async {
    if (_otpController.currentState?.saveAndValidate() ?? false) {
      final otp = _otpController.currentState?.fields['Otp']?.value;

      try {
        await AuthServices().verifyOtp(otp);
        Navigator.pushReplacementNamed(context, '/profile');
      } on FirebaseAuthException catch (e) {
        _otpController.currentState?.fields['Otp']?.invalidate(
          e.message.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _otpController,
      child: CardColumn01(
        children: [
          Text(
            'Please add otp',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 32),

          FormBuilderTextField(
            name: 'Otp',
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Otp',
              hintText: '232323',
              prefixIcon: Icon(Icons.message_outlined),
              border: OutlineInputBorder(),
              errorMaxLines: 3,
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.numeric(),
              FormBuilderValidators.maxLength(6),
            ]),
          ),

          SizedBox(height: 32),

          ElevatedButton(
            onPressed: submitHandler,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: Text('Submit'),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: clear,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surfaceContainerHigh,
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}

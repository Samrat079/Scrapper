import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:scrapper/Services/AppUserServices/AppUserService02.dart';
import 'package:scrapper/theme/theme_extensions.dart';

import '../../../Custome/CenterColumn/CenterColumn04.dart';

class AddNumber01 extends StatefulWidget {
  final PageController _controller;

  const AddNumber01({super.key, required PageController controller})
    : _controller = controller;

  @override
  State<AddNumber01> createState() => _AddNumber01State();
}

class _AddNumber01State extends State<AddNumber01> {
  final _addNumberKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;

  void clear() {
    _addNumberKey.currentState!.reset();
    widget._controller.previousPage(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  Future<void> submitHandler() async {
    if (!(_addNumberKey.currentState?.saveAndValidate() ?? false)) return;

    final number = _addNumberKey.currentState?.fields['Phone']?.value;

    setState(() => isLoading = true);

    final appUser = context.read<AppUserServices02>();

    try {
      await appUser.sendOtp(number);

      widget._controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } on FirebaseAuthException catch (e) {
      _addNumberKey.currentState?.fields['Phone']?.invalidate(
        e.message ?? 'Invalid number',
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _addNumberKey,
      child: CenterColumn04(
        centerVertically: true,
        padding: context.paddingXL,
        children: [
          Image.asset('assets/Illustrations/login02.png', height: 256),
          context.gapMD,

          const Text(
            'Verify Phone number',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          context.gapXL,

          FormBuilderField(
            name: 'Phone',
            validator: FormBuilderValidators.phoneNumber(),
            builder: (field) {
              return IntlPhoneField(
                onEditingComplete: submitHandler,
                onChanged: (phone) => field.didChange(phone.completeNumber),
                initialCountryCode: 'IN',
                decoration: InputDecoration(
                  labelText: 'Phone',
                  hintText: '888-444-6464',
                  errorText: field.errorText,
                  errorMaxLines: 2,
                  filled: true,
                  fillColor: context.colorScheme.surfaceContainer,
                ),
              );
            },
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
            onPressed: isLoading ? null : submitHandler,
            child: const Text('Submit'),
          ),

          context.gapMD,

          ElevatedButton(
            onPressed: clear,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.surfaceContainerHigh,
              foregroundColor: context.colorScheme.onSurface,
            ),
            child: const Text('Previous'),
          ),
        ],
      ),
    );
  }
}

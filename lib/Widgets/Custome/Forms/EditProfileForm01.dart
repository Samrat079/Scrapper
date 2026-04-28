import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:scrapper/Models/AppUser/AppUser01.dart';
import 'package:scrapper/Services/AppUserServices/AppUserServices01.dart';
import 'package:scrapper/theme/theme_extensions.dart';

class EditProfileForm01 extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final Function() onCancel;

  const EditProfileForm01({super.key, required this.onSubmit, required this.onCancel});

  @override
  State<EditProfileForm01> createState() => _EditProfileForm01State();
}

class _EditProfileForm01State extends State<EditProfileForm01> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = false;
  final AppUser01 currUser = AppUserServices01().current;

  void submitHandler() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => isLoading = true);
      final currState = _formKey.currentState!.value;
      await widget.onSubmit(currState);

      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// Add more profile editing fields in future

          /// Display Name
          FormBuilderTextField(
            name: 'displayName',
            validator: FormBuilderValidators.username(allowSpace: true),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            initialValue: currUser.customer01?.displayName,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.person_outline,
                color: context.colorScheme.primary,
              ),
              labelText: 'Full Name',
              filled: true,
              fillColor: context.colorScheme.surfaceContainer,
              enabledBorder: OutlineInputBorder(
                borderRadius: context.radiusMD,
                borderSide: BorderSide(color: context.colorScheme.outline),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: context.radiusMD,
                borderSide: BorderSide(color: context.colorScheme.outline),
              ),
            ),
          ),

          context.gapLG,

          /// Submit
          ElevatedButton(
            onPressed: isLoading ? null : submitHandler,
            child: const Text('Save Changes'),
          ),
          context.gapMD,
          ElevatedButton(
            onPressed: widget.onCancel,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.colorScheme.surfaceContainerHigh,
              foregroundColor: context.colorScheme.onSurface,
            ),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}

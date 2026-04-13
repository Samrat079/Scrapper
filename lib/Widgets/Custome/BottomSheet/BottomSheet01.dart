import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:scrapper/Services/CustomerServices/Customer01Services.dart';
import 'package:scrapper/Widgets/Custome/CenterColumn/CenterColumb03.dart';

import '../../../Models/Address/Address01.dart';

class BottomSheet01 extends StatefulWidget {
  const BottomSheet01({super.key});

  @override
  State<BottomSheet01> createState() => _BottomSheet01State();
}

class _BottomSheet01State extends State<BottomSheet01> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();
    final customer = Customer01Services().currCustomer;

    void submitHandler() async {
      if (_formKey.currentState?.saveAndValidate() ?? false) {
        final data = _formKey.currentState!.value;

        final address = Address01(
          name: data['name'],
          phoneNumber: data['phoneNumber'],
          houseNumber: data['house'],
          locality: data['locality'],
          isDefault: false,
        );

        Navigator.of(context).pop(address);
      }
    }

    return FormBuilder(
      key: _formKey,
      child: CenterColumb03(
        children: [
          /// Location details
          FormBuilderTextField(
            name: 'locality',
            validator: FormBuilderValidators.required(),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.my_location_outlined),
              labelText: 'Area/Locality',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          FormBuilderTextField(
            name: 'house',
            validator: FormBuilderValidators.required(),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.home_outlined),
              labelText: 'House no./Building',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          /// Contact details
          Text('Add contact details'),
          FormBuilderTextField(
            name: 'name',
            validator: FormBuilderValidators.required(),
            initialValue: customer.displayName,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline),
              labelText: 'name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          FormBuilderTextField(
            name: 'phoneNumber',
            validator: FormBuilderValidators.phoneNumber(),
            initialValue: customer.phoneNumber,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined),
              labelText: 'phone',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          /// Submit button
          ElevatedButton(
            onPressed: submitHandler,
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}

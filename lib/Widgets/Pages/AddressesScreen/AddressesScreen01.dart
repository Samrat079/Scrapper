import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/Models/Customer/Address/Address01.dart';
import 'package:scrapper/Models/Customer/Customer01.dart';
import 'package:scrapper/Services/AddressServices/Address01Services.dart';
import 'package:scrapper/Widgets/Custome/CenterColumn/ScrollColumn01.dart';
import 'package:scrapper/Widgets/Custome/BottomSheet/BottomSheet01.dart';

import 'Widget/AddressTile01.dart';

class AddressesScreen01 extends StatelessWidget {
  final Customer01 customer;

  const AddressesScreen01({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    final addService = Address01Services(customer.uid);
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: addService.getRealTime(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;

          return ScrollColumn01(
            children: [
              /// List of addresses
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  return AddressTile01(
                    doc: docs[index],
                    addService: addService,
                  );
                },
              ),

              /// Add more
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () => showModalBottomSheet<Address01>(
                  useSafeArea: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => BottomSheet01(),
                ).then((address) => addService.add(address!)),

                label: Text('Add address'),
                icon: Icon(Icons.add_outlined),
              ),
            ],
          );
        },
      ),
    );
  }
}

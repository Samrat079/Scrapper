import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/Models/Customer/Address/Address01.dart';
import 'package:scrapper/Models/Customer/Customer01.dart';
import 'package:scrapper/Services/AddressServices/Address01Services.dart';
import 'package:scrapper/Services/CustomerServices/Customer01Services.dart';
import 'package:scrapper/Widgets/Custome/CenterColumn/ScrollColumn01.dart';
import 'package:scrapper/Widgets/Custome/FutureBuilder01/FutureBuilder01.dart';
import 'package:scrapper/Widgets/Pages/AddressesScreen01/Widget/AddressTile01.dart';
import 'package:scrapper/Widgets/Pages/AddressesScreen01/Widget/BottomSheet01.dart';

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
                  return AddressTile01(doc: docs[index], addService: addService);
                },
              ),

              /// Add more
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () => showModalBottomSheet(
                  useSafeArea: true,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => BottomSheet01(customer: customer),
                ),
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

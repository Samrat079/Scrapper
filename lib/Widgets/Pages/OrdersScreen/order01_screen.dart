import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrapper/Models/Orders/Order01.dart';
import 'package:scrapper/Services/OrderServices/Order01Service.dart';

class Order01Screen extends StatelessWidget {
  const Order01Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot<Order01>>(
        stream: Order01Service().getAllByStatus(Order01Status.requested),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              return ListTile(
                title: Text(data.price.toString()),
                subtitle: Text(data.address.place.displayName.toString()),
                trailing: IconButton(
                  onPressed: () => Order01Service().statusById(
                    data.uid!,
                    Order01Status.cancelled,
                  ),
                  icon: Icon(Icons.cancel_outlined),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

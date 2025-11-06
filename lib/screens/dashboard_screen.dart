import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/item.dart';

class DashboardScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Dashboard')),
      body: StreamBuilder<List<Item>>(
        stream: firestoreService.getItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading items'));
          }
          final items = snapshot.data ?? [];
          final totalValue =
              items.fold(0.0, (sum, item) => sum + item.price * item.quantity);
          final outOfStock = items.where((item) => item.quantity == 0).toList();
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Items: ${items.length}', style: TextStyle(fontSize: 18)),
                Text('Total Inventory Value: \$${totalValue.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),
                const Text('Out of Stock Items:', style: TextStyle(fontSize: 16)),
                ...outOfStock.map((item) => Text(item.name)),
              ],
            ),
          );
        },
      ),
    );
  }
}

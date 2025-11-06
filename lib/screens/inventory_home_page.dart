import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/item.dart';
import 'add_edit_item_screen.dart';

class InventoryHomePage extends StatefulWidget {
  const InventoryHomePage({super.key});

  @override
  _InventoryHomePageState createState() => _InventoryHomePageState();
}

class _InventoryHomePageState extends State<InventoryHomePage> {
  final FirestoreService firestoreService = FirestoreService();

  String searchQuery = '';
  String? selectedCategory;
  bool showLowStock = false;
  Set<String> selectedItems = {}; // For bulk operations

  List<String> categories = ['Electronics', 'Clothing', 'Food', 'Other']; // Example

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Home Page'),
        actions: [
          if (selectedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                for (var id in selectedItems) {
                  await firestoreService.deleteItem(id);
                }
                setState(() {
                  selectedItems.clear();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selected items deleted')),
                );
              },
            )
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() {
                searchQuery = value;
              }),
            ),
          ),
          // Category filter and Low Stock toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                // Category dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    hint: const Text('Filter by category'),
                    items: categories
                        .map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() {
                      selectedCategory = value;
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                // Low stock toggle
                Column(
                  children: [
                    const Text('Low Stock'),
                    Switch(
                      value: showLowStock,
                      onChanged: (value) => setState(() {
                        showLowStock = value;
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          // Item list
          Expanded(
            child: StreamBuilder<List<Item>>(
              stream: firestoreService.getItemsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading items'));
                }
                List<Item> items = snapshot.data ?? [];

                // Apply search & filters
                items = items.where((item) {
                  final matchesSearch = item.name
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase());
                  final matchesCategory =
                      selectedCategory == null || item.category == selectedCategory;
                  final matchesLowStock =
                      !showLowStock || item.quantity < 5; // low stock < 5
                  return matchesSearch && matchesCategory && matchesLowStock;
                }).toList();

                if (items.isEmpty) {
                  return const Center(child: Text('No products found'));
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = selectedItems.contains(item.id);
                    return ListTile(
                      leading: Checkbox(
                        value: isSelected,
                        onChanged: (selected) {
                          setState(() {
                            if (selected == true) {
                              selectedItems.add(item.id!);
                            } else {
                              selectedItems.remove(item.id!);
                            }
                          });
                        },
                      ),
                      title: Text(item.name),
                      subtitle: Text(
                          'Category: ${item.category} | Qty: ${item.quantity} | \$${item.price}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditItemScreen(item: item),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditItemScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

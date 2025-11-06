import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';

class AddEditItemScreen extends StatefulWidget {
  final Item? item;

  AddEditItemScreen({this.item});

  @override
  _AddEditItemScreenState createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService firestoreService = FirestoreService();

  late TextEditingController nameController;
  late TextEditingController quantityController;
  late TextEditingController priceController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item?.name ?? '');
    quantityController =
        TextEditingController(text: widget.item?.quantity.toString() ?? '');
    priceController =
        TextEditingController(text: widget.item?.price.toString() ?? '');
    categoryController =
        TextEditingController(text: widget.item?.category ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.item != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Item' : 'Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter name' : null,
              ),
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter quantity' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter price' : null,
              ),
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter category' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(isEditing ? 'Update' : 'Add'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newItem = Item(
                      id: widget.item?.id,
                      name: nameController.text,
                      quantity: int.parse(quantityController.text),
                      price: double.parse(priceController.text),
                      category: categoryController.text,
                      createdAt: DateTime.now(),
                    );
                    if (isEditing) {
                      await firestoreService.updateItem(newItem);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${newItem.name} updated')),
                      );
                    } else {
                      await firestoreService.addItem(newItem);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${newItem.name} added')),
                      );
                    }
                    Navigator.pop(context);
                  }
                },
              ),
              if (isEditing)
                TextButton(
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  onPressed: () async {
                    await firestoreService.deleteItem(widget.item!.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${widget.item!.name} deleted')),
                    );
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

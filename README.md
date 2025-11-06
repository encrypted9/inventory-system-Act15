# act15

A new Flutter project.

Inventory Management App – Flutter & Firebase
## Getting Started

This project is a starting point for a Flutter application.

This is a fully functional Inventory Management App built with Flutter and Firebase Firestore. The app allows users to Create, Read, Update, and Delete (CRUD) inventory items, with all data synchronized in real-time to the cloud.

Core Features
Add, Edit, Delete, and View Inventory Items in real-time.
Search & Filter inventory items by name and category.
Real-time updates using Firestore streams.
User-friendly UI for managing inventory efficiently.
Enhanced Features Implemented
1) Advanced Search & Filtering
A search bar to filter items by name in real-time.
Dropdown (or filter chips) to filter items by category or stock status (e.g., Low Stock).
2) Data Insights Dashboard
A separate screen displaying key inventory statistics:
Total number of unique items
Total inventory value (sum of quantity × price)
List of out-of-stock items


A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

In th terminal cd to the file Act15 
Type "Fluttter pub get get"
Then "Flutter run"
Open with your desired connected device

Home Screen
When you open the app, you’ll see the Inventory List displaying all items stored in Firebase Firestore in real-time.
Each item shows:
Name
Quantity
Price
Category
You can:
Tap the + Floating Action Button (FAB) to add a new item.
Tap an item to edit or delete it.

The search bar and category dropdown help you quickly find items.
Search Bar: Type part of an item’s name to filter the list instantly.
Example: typing “pen” shows all items with “pen” in their name.
Category Filter: Use the dropdown menu at the top to filter items by category (e.g., “Electronics”, “Groceries”, etc.).
Low Stock Filter: Items with low quantity (e.g., less than 5) are highlighted or can be filtered under “Low Stock”.


Tap the Dashboard icon in the AppBar (or use the navigation button) to open the Insights Dashboard.
This screen shows real-time analytics based on Firestore data:
Total Unique Items = Count of all distinct inventory items.
Total Inventory Value = Sum of (price × quantity) for all items.
Out-of-Stock Items = A list of items where quantity = 0.

All Firestore operations (add, update, delete) are reflected instantly in both the Inventory List and Dashboard.
Firestore is used as the primary database, ensuring real-time sync across devices.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

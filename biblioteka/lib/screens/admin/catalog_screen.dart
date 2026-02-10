import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CatalogScreen extends StatelessWidget {
  static const routeName = "/CatalogScreen";
  const CatalogScreen({super.key});

  Future<void> _deleteBook(BuildContext context, String docId) async {
    await FirebaseFirestore.instance.collection('books').doc(docId).delete();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Book deleted")),
      );
    }
  }

  void _openAddBookDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const _AddBookDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booksRef = FirebaseFirestore.instance.collection('books');

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catalog (Admin)"),
        actions: [
          IconButton(
            onPressed: () => _openAddBookDialog(context),
            icon: const Icon(Icons.add),
            tooltip: "Add book",
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: booksRef.orderBy("title").snapshots(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text("No books yet"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();

              final title = (data["title"] ?? "Untitled").toString();
              final author = (data["author"] ?? "-").toString();
              final price = (data["price"] ?? 0).toString();
              final quantity = (data["quantity"] ?? 0).toString();

              return ListTile(
                title: Text(title),
                subtitle: Text("Author: $author • Price: $price RSD • Qty: $quantity"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Delete book"),
                        content: const Text("Are you sure you want to delete this book?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    );

                    if (ok == true) {
                      await _deleteBook(context, doc.id);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AddBookDialog extends StatefulWidget {
  const _AddBookDialog();

  @override
  State<_AddBookDialog> createState() => _AddBookDialogState();
}

class _AddBookDialogState extends State<_AddBookDialog> {
  final titleCtrl = TextEditingController();
  final authorCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  final qtyCtrl = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    titleCtrl.dispose();
    authorCtrl.dispose();
    priceCtrl.dispose();
    categoryCtrl.dispose();
    descCtrl.dispose();
    imageCtrl.dispose();
    qtyCtrl.dispose();
    super.dispose();
  }

  Future<void> _addBook() async {
    final title = titleCtrl.text.trim();
    if (title.isEmpty) return;

    setState(() => loading = true);

    try {
      await FirebaseFirestore.instance.collection('books').add({
        "title": title,
        "author": authorCtrl.text.trim(),
        "price": double.tryParse(priceCtrl.text.trim()) ?? 0,
        "category": categoryCtrl.text.trim(),
        "description": descCtrl.text.trim(),
        "imageUrl": imageCtrl.text.trim(),
        "quantity": int.tryParse(qtyCtrl.text.trim()) ?? 0,
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Book added ✅")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Add failed: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add new book"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Title")),
            TextField(controller: authorCtrl, decoration: const InputDecoration(labelText: "Author")),
            TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: "Price (number)"), keyboardType: TextInputType.number),
            TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: "Category")),
            TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: "Quantity (int)"), keyboardType: TextInputType.number),
            TextField(controller: imageCtrl, decoration: const InputDecoration(labelText: "Image URL")),
            TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: "Description")),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: loading ? null : () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: loading ? null : _addBook,
          child: loading
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text("Add"),
        ),
      ],
    );
  }
}

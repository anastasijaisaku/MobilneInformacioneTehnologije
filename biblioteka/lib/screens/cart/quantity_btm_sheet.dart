import 'package:flutter/material.dart';

class QuantityBottomSheetWidget extends StatefulWidget {
  const QuantityBottomSheetWidget({
    super.key,
    required this.initialQty,
    this.maxQty = 99,
  });

  final int initialQty;
  final int maxQty;

  @override
  State<QuantityBottomSheetWidget> createState() =>
      _QuantityBottomSheetWidgetState();
}

class _QuantityBottomSheetWidgetState extends State<QuantityBottomSheetWidget> {
  late int qty;

  @override
  void initState() {
    super.initState();
    qty = widget.initialQty <= 0 ? 1 : widget.initialQty;
  }

  void _inc() {
    if (qty >= widget.maxQty) return;
    setState(() => qty++);
  }

  void _dec() {
    if (qty <= 1) return;
    setState(() => qty--);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Select quantity",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _dec,
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                const SizedBox(width: 10),
                Text(
                  "$qty",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: _inc,
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, 0); // remove item
                    },
                    child: const Text("Remove"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, qty); // return selected qty
                    },
                    child: const Text("Done"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

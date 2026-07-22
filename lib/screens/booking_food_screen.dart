import 'package:flutter/material.dart';
import '../controllers/booking_controller.dart';
import 'checkout_screen.dart';

class BookingFoodScreen extends StatefulWidget {
  final BookingController controller;

  const BookingFoodScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _BookingFoodScreenState createState() => _BookingFoodScreenState();
}

class _BookingFoodScreenState extends State<BookingFoodScreen> {
  // Giống data food_combo_screen nhưng là clone riêng để quản lý state giỏ hàng
  final List<Map<String, dynamic>> foods = [
    {'name': 'Combo Bắp Nước', 'desc': '1 Bắp lớn + 1 Nước ngọt lớn', 'price': 85000, 'qty': 0, 'image': 'https://images.unsplash.com/photo-1585647347384-2593bc35786b?w=500'},
    {'name': 'Combo 2 Người', 'desc': '1 Bắp lớn + 2 Nước ngọt lớn', 'price': 105000, 'qty': 0, 'image': 'https://images.unsplash.com/photo-1572177215152-32f247303126?w=500'},
    {'name': 'Snack Thập Cẩm', 'desc': '1 Snack khoai tây + 1 Nước ngọt', 'price': 55000, 'qty': 0, 'image': 'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=500'},
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Chọn bắp nước', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(food['image'], width: 80, height: 80, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(food['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Text(food['desc'], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              const SizedBox(height: 8),
                              Text('${food['price']} đ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              color: food['qty'] > 0 ? Colors.red : Colors.grey,
                              onPressed: () {
                                if (food['qty'] > 0) {
                                  setState(() => food['qty']--);
                                  widget.controller.updateFoodCart(foods);
                                }
                              },
                            ),
                            Text('${food['qty']}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              color: Colors.red,
                              onPressed: () {
                                setState(() => food['qty']++);
                                widget.controller.updateFoodCart(foods);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Tổng thanh toán', style: TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.controller.totalAmount} đ',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckoutScreen(controller: widget.controller),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Tiếp tục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

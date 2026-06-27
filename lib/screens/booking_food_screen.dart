import 'package:flutter/material.dart';
import '../controllers/booking_controller.dart';
import '../models/food_model.dart';
import 'checkout_screen.dart';

class BookingFoodScreen extends StatefulWidget {
  final BookingController controller;

  const BookingFoodScreen({super.key, required this.controller});

  @override
  State<BookingFoodScreen> createState() => _BookingFoodScreenState();
}

class _BookingFoodScreenState extends State<BookingFoodScreen> {
  final List<FoodItem> foods = FoodItem.getDefaultFoods();

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

  void _syncToController() {
    widget.controller.updateFoodCart(foods);
  }

  String _formatCurrency(int amount) {
    final str = amount.toString();
    final result = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        result.write('.');
      }
      result.write(str[i]);
    }
    return result.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0D2B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
          ).createShader(bounds),
          child: const Text(
            'Chọn bắp nước',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      final food = foods[index];
                      return _buildFoodCard(food, index);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A4E),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Tổng thanh toán',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${_formatCurrency(widget.controller.totalAmount)}đ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Color(0xFFFF9800),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CheckoutScreen(controller: widget.controller),
                                  ),
                                );
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                child: Text(
                                  'Tiếp tục',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodCard(FoodItem food, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1E50), Color(0xFF2A2A5E)],
          ),
          border: Border.all(
            color: food.qty > 0 ? const Color(0xFFFF9800).withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  food.image,
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A5E),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.fastfood, color: Colors.white24, size: 30),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food.description,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_formatCurrency(food.price)}đ',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9800), fontSize: 15),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 20),
                      color: food.qty > 0 ? const Color(0xFFFF5722) : Colors.white24,
                      onPressed: () {
                        if (food.qty > 0) {
                          setState(() => food.qty--);
                          _syncToController();
                        }
                      },
                    ),
                    Text(
                      '${food.qty}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 20),
                      color: const Color(0xFFFF9800),
                      onPressed: () {
                        setState(() => food.qty++);
                        _syncToController();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

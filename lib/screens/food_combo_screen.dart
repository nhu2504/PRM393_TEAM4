import 'package:flutter/material.dart';
import '../models/food_model.dart';

class FoodComboScreen extends StatefulWidget {
  const FoodComboScreen({super.key});

  @override
  State<FoodComboScreen> createState() => _FoodComboScreenState();
}

class _FoodComboScreenState extends State<FoodComboScreen> {
  final List<FoodItem> combos = FoodItem.getDefaultFoods();

  int get totalPrice => combos.fold(0, (sum, item) => sum + item.price * item.qty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D2B),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF9800).withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.fastfood_rounded, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                        ).createShader(bounds),
                        child: const Text(
                          'Bắp Nước',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Chọn combo yêu thích của bạn',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                    itemCount: combos.length,
                    itemBuilder: (context, index) {
                      return _buildComboCard(combos[index], index);
                    },
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A4E),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                    border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        offset: const Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Tổng cộng',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_formatCurrency(totalPrice)}đ',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: Color(0xFFFF9800),
                            ),
                          ),
                        ],
                      ),
                      AnimatedOpacity(
                        opacity: totalPrice > 0 ? 1.0 : 0.4,
                        duration: const Duration(milliseconds: 200),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF9800), Color(0xFFFF5722)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: totalPrice > 0
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFFFF9800).withValues(alpha: 0.4),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: totalPrice > 0
                                  ? () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text(
                                            'Vui lòng chọn phim và suất chiếu trước khi mua bắp nước!',
                                          ),
                                          backgroundColor: const Color(0xFF6C63FF),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                      );
                                    }
                                  : null,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Đặt ngay',
                                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 6),
                                    Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComboCard(FoodItem food, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
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
          boxShadow: [
            BoxShadow(
              color: food.qty > 0 ? const Color(0xFFFF9800).withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    food.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A5E),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.fastfood, color: Colors.white24, size: 32),
                    ),
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
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      food.description,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_formatCurrency(food.price)}đ',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFFF9800),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  children: [
                    _buildCountButton(
                      icon: Icons.remove,
                      color: food.qty > 0 ? const Color(0xFFFF5722) : Colors.white24,
                      onTap: () {
                        if (food.qty > 0) {
                          setState(() => food.qty--);
                        }
                      },
                    ),
                    SizedBox(
                      width: 30,
                      child: Center(
                        child: Text(
                          '${food.qty}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    _buildCountButton(
                      icon: Icons.add,
                      color: const Color(0xFFFF9800),
                      onTap: () {
                        setState(() => food.qty++);
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

  Widget _buildCountButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
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
}

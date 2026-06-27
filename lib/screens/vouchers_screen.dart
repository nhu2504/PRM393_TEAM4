import 'package:flutter/material.dart';
import '../models/voucher_model.dart';

class VouchersScreen extends StatefulWidget {
  const VouchersScreen({super.key});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> with TickerProviderStateMixin {
  final List<Voucher> _vouchers = Voucher.getMockVouchers();
  final TextEditingController _codeController = TextEditingController();
  Voucher? _lastAppliedVoucher;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animController.forward();
  }

  @override
  void dispose() {
    _codeController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _applyCode() {
    final code = _codeController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    Voucher? voucher;
    for (final item in _vouchers) {
      if (item.code == code && !item.isUsed) {
        voucher = item;
        break;
      }
    }

    if (voucher != null) {
      setState(() => _lastAppliedVoucher = voucher);
      _codeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('Áp dụng thành công: ${voucher.title}'),
            ],
          ),
          backgroundColor: const Color(0xFF4ECDC4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('Mã không hợp lệ hoặc đã sử dụng!'),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _useVoucher(Voucher voucher) {
    setState(() => _lastAppliedVoucher = voucher);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.local_offer, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text('Đã chọn: ${voucher.title} — Giảm ${_formatPrice(voucher.discountValue)}')),
          ],
        ),
        backgroundColor: const Color(0xFF6C63FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatPrice(int price) {
    if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return '$priceđ';
  }

  IconData _getVoucherIcon(String iconType) {
    switch (iconType) {
      case 'percent':
        return Icons.percent_rounded;
      case 'ticket':
        return Icons.confirmation_num_rounded;
      case 'gift':
        return Icons.card_giftcard_rounded;
      case 'star':
        return Icons.star_rounded;
      default:
        return Icons.local_offer_rounded;
    }
  }

  List<Color> _getVoucherGradient(String iconType) {
    switch (iconType) {
      case 'percent':
        return [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)];
      case 'ticket':
        return [const Color(0xFF6C63FF), const Color(0xFF4834DF)];
      case 'gift':
        return [const Color(0xFF4ECDC4), const Color(0xFF44B09E)];
      case 'star':
        return [const Color(0xFFFFB74D), const Color(0xFFFF9800)];
      default:
        return [const Color(0xFFFF6B6B), const Color(0xFFEE5A24)];
    }
  }

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
                          gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)]),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.local_offer_rounded, color: Colors.white, size: 26),
                      ),
                      const SizedBox(width: 14),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFFB74D)],
                        ).createShader(bounds),
                        child: const Text(
                          'Khuyến Mãi',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Icon(Icons.confirmation_number_outlined, color: Colors.white.withValues(alpha: 0.4)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _codeController,
                            style: const TextStyle(color: Colors.white, fontSize: 15),
                            decoration: InputDecoration(
                              hintText: 'Nhập mã khuyến mãi...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            textCapitalization: TextCapitalization.characters,
                            onSubmitted: (_) => _applyCode(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: _applyCode,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Áp dụng',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    itemCount: _vouchers.length,
                    itemBuilder: (context, index) => _buildVoucherCard(_vouchers[index], index),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherCard(Voucher voucher, int index) {
    final gradientColors = _getVoucherGradient(voucher.iconType);
    final isSelected = _lastAppliedVoucher?.id == voucher.id;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 120)),
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
            color: isSelected ? gradientColors[0].withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.06),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _useVoucher(voucher),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: gradientColors),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(_getVoucherIcon(voucher.iconType), color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voucher.title,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          voucher.description,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _infoChip('HSD: ${voucher.expiryDate}', gradientColors[0]),
                            _infoChip(voucher.code, Colors.white54),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      gradient: isSelected ? LinearGradient(colors: gradientColors) : null,
                      color: isSelected ? null : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected ? null : Border.all(color: gradientColors[0].withValues(alpha: 0.5)),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _useVoucher(voucher),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          child: Text(
                            isSelected ? '✓ Đã chọn' : 'Dùng ngay',
                            style: TextStyle(
                              color: isSelected ? Colors.white : gradientColors[0],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

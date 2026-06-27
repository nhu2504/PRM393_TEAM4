import 'package:flutter/material.dart';
import '../controllers/booking_controller.dart';
import '../models/voucher_model.dart';
import 'payment_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final BookingController controller;

  const CheckoutScreen({super.key, required this.controller});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final List<Voucher> _availableVouchers = Voucher.getMockVouchers();
  bool _showVoucherPicker = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
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
            colors: [Color(0xFFFF6B6B), Color(0xFFFFB74D)],
          ).createShader(bounds),
          child: const Text(
            'Thanh Toán',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 22),
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thông tin phim
                _buildMovieInfoCard(),
                const SizedBox(height: 16),

                // Voucher / Mã giảm giá
                _buildVoucherSection(),
                const SizedBox(height: 16),

                // Tóm tắt đơn hàng
                _buildOrderSummaryCard(),
                const SizedBox(height: 16),

                // Phương thức thanh toán
                _buildPaymentMethodCard(),
                const SizedBox(height: 30),

                // Nút thanh toán
                _buildCheckoutButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMovieInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E50), Color(0xFF2A2A5E)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.controller.movie.image,
              width: 80,
              height: 115,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 80, height: 115,
                color: const Color(0xFF2A2A5E),
                child: const Icon(Icons.movie, color: Colors.white24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.controller.movie.title,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.location_on_rounded, widget.controller.cinemaName, const Color(0xFF4ECDC4)),
                const SizedBox(height: 4),
                _buildInfoRow(
                  Icons.access_time_filled_rounded,
                  '${widget.controller.showTime} | ${widget.controller.showDate}',
                  const Color(0xFFFFB74D),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Ghế: ${widget.controller.selectedSeats.map((s) => s.id).join(', ')}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF6C63FF)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.7)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildVoucherSection() {
    final applied = widget.controller.appliedVoucher;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E50), Color(0xFF2A2A5E)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          // Header voucher
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                setState(() => _showVoucherPicker = !_showVoucherPicker);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.local_offer_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mã giảm giá',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          if (applied != null)
                            Text(
                              '${applied.title} (-${_formatCurrency(applied.discountValue)}đ)',
                              style: const TextStyle(color: Color(0xFF4ECDC4), fontSize: 12, fontWeight: FontWeight.w500),
                            )
                          else
                            Text(
                              'Chọn hoặc nhập mã giảm giá',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                    if (applied != null)
                      GestureDetector(
                        onTap: () {
                          widget.controller.removeVoucher();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.redAccent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.close, color: Colors.redAccent, size: 16),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Icon(
                      _showVoucherPicker ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.white38,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Voucher picker
          if (_showVoucherPicker)
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.06))),
              ),
              child: Column(
                children: _availableVouchers.map((v) {
                  final isApplied = applied?.id == v.id;
                  final canApply = (widget.controller.seatTotal + widget.controller.foodTotal) >= v.minOrderValue;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: canApply
                          ? () {
                              if (isApplied) {
                                widget.controller.removeVoucher();
                              } else {
                                widget.controller.applyVoucher(v);
                              }
                              setState(() => _showVoucherPicker = false);
                            }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            Icon(
                              isApplied ? Icons.check_circle : Icons.radio_button_unchecked,
                              color: isApplied
                                  ? const Color(0xFF4ECDC4)
                                  : canApply
                                      ? Colors.white38
                                      : Colors.white12,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    v.title,
                                    style: TextStyle(
                                      color: canApply ? Colors.white : Colors.white24,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  if (!canApply)
                                    Text(
                                      'Đơn tối thiểu: ${_formatCurrency(v.minOrderValue)}đ',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              '-${_formatCurrency(v.discountValue)}đ',
                              style: TextStyle(
                                color: canApply ? const Color(0xFFFF6B6B) : Colors.white24,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E50), Color(0xFF2A2A5E)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tóm tắt đơn hàng', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 14),
          _buildPriceRow(
            'Ghế (${widget.controller.selectedSeats.length})',
            '${_formatCurrency(widget.controller.seatTotal)}đ',
          ),
          if (widget.controller.selectedFoods.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              'Bắp nước',
              '${_formatCurrency(widget.controller.foodTotal)}đ',
            ),
          ],
          if (widget.controller.discountAmount > 0) ...[
            const SizedBox(height: 8),
            _buildPriceRow(
              'Giảm giá (${widget.controller.appliedVoucher?.code ?? ''})',
              '-${_formatCurrency(widget.controller.discountAmount)}đ',
              valueColor: const Color(0xFF4ECDC4),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                colors: [Colors.transparent, Colors.white.withValues(alpha: 0.15), Colors.transparent],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tổng tiền', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFFF6B6B), Color(0xFFFFB74D)],
                ).createShader(bounds),
                child: Text(
                  '${_formatCurrency(widget.controller.totalAmount)}đ',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w600, color: valueColor ?? Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildPaymentMethodCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E1E50), Color(0xFF2A2A5E)],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phương thức thanh toán',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 14),
          _buildPaymentOption(Icons.account_balance_wallet_rounded, 'Ví MoMo', const Color(0xFFE91E8C)),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.04), margin: const EdgeInsets.symmetric(vertical: 2)),
          _buildPaymentOption(Icons.credit_card_rounded, 'Thẻ ATM/Visa', const Color(0xFF6C63FF)),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.04), margin: const EdgeInsets.symmetric(vertical: 2)),
          _buildPaymentOption(Icons.qr_code_rounded, 'QR Pay (VNPay)', const Color(0xFF4ECDC4)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(IconData icon, String title, Color color) {
    final isSelected = widget.controller.selectedPaymentMethod == title;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          widget.controller.changePaymentMethod(title);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: isSelected ? 0.2 : 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: isSelected ? color : Colors.white38, size: 22),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: isSelected ? Colors.white : Colors.white54,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              const Spacer(),
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: isSelected ? color : Colors.white24,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckoutButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          final ticket = widget.controller.checkout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => PaymentSuccessScreen(ticket: ticket)),
            (route) => route.isFirst,
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B6B).withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(
                'XÁC NHẬN THANH TOÁN',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Voucher {
  final String id;
  final String code;
  final String title;
  final String description;
  final int discountValue; // số tiền giảm (VND)
  final int minOrderValue; // đơn tối thiểu để áp dụng
  final String expiryDate; // HSD dạng "dd/MM/yyyy"
  final String iconType; // 'percent', 'ticket', 'gift', 'star'
  bool isUsed;

  Voucher({
    required this.id,
    required this.code,
    required this.title,
    this.description = '',
    required this.discountValue,
    this.minOrderValue = 0,
    required this.expiryDate,
    this.iconType = 'percent',
    this.isUsed = false,
  });

  /// Danh sách voucher mock
  static List<Voucher> getMockVouchers() {
    return [
      Voucher(
        id: 'v1',
        code: 'GIAM20K',
        title: 'Giảm 20K cho vé 2D',
        description: 'Áp dụng cho tất cả phim 2D, đơn tối thiểu 100K',
        discountValue: 20000,
        minOrderValue: 100000,
        expiryDate: '15/08/2026',
        iconType: 'percent',
      ),
      Voucher(
        id: 'v2',
        code: 'COMBO50',
        title: 'Giảm 50K Combo Bắp Nước',
        description: 'Áp dụng khi mua combo bắp nước kèm vé',
        discountValue: 50000,
        minOrderValue: 150000,
        expiryDate: '30/07/2026',
        iconType: 'gift',
      ),
      Voucher(
        id: 'v3',
        code: 'NEWUSER',
        title: 'Giảm 30K cho khách mới',
        description: 'Dành cho khách hàng đăng ký lần đầu',
        discountValue: 30000,
        minOrderValue: 90000,
        expiryDate: '31/12/2026',
        iconType: 'star',
      ),
      Voucher(
        id: 'v4',
        code: 'VIP100',
        title: 'Giảm 100K ghế VIP',
        description: 'Chỉ áp dụng cho ghế VIP, đơn tối thiểu 200K',
        discountValue: 100000,
        minOrderValue: 200000,
        expiryDate: '20/09/2026',
        iconType: 'ticket',
      ),
    ];
  }
}

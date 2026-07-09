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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'discountValue': discountValue,
      'minOrderValue': minOrderValue,
      'expiryDate': expiryDate,
      'iconType': iconType,
      'isUsed': isUsed ? 1 : 0,
    };
  }

  factory Voucher.fromMap(Map<String, dynamic> map) {
    return Voucher(
      id: map['id'] ?? '',
      code: map['code'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      discountValue: map['discountValue'] ?? 0,
      minOrderValue: map['minOrderValue'] ?? 0,
      expiryDate: map['expiryDate'] ?? '',
      iconType: map['iconType'] ?? 'percent',
      isUsed: map['isUsed'] == 1,
    );
  }

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
      Voucher(
        id: 'v5',
        code: 'HSSV50',
        title: 'Giảm 50% cho HSSV (Tối đa 50K)',
        description: 'Dành cho Học sinh, Sinh viên. Có kiểm tra thẻ.',
        discountValue: 50000,
        minOrderValue: 0,
        expiryDate: '01/06/2027',
        iconType: 'star',
      ),
      Voucher(
        id: 'v6',
        code: 'HALLOWEEN',
        title: 'Giảm 40K Phim Kinh Dị',
        description: 'Áp dụng cho các suất chiếu sau 22:00',
        discountValue: 40000,
        minOrderValue: 120000,
        expiryDate: '31/10/2026',
        iconType: 'gift',
      ),
      Voucher(
        id: 'v7',
        code: 'WEEKEND15',
        title: 'Giảm 15K cuối tuần',
        description: 'Áp dụng cho mọi đơn đặt vé trong cuối tuần',
        discountValue: 15000,
        minOrderValue: 80000,
        expiryDate: '31/12/2026',
        iconType: 'percent',
      ),
      Voucher(
        id: 'v8',
        code: 'CINEMA25',
        title: 'Giảm 25K cho đặt vé sớm',
        description: 'Ưu đãi cho khách đặt vé trước 24 giờ',
        discountValue: 25000,
        minOrderValue: 95000,
        expiryDate: '30/11/2026',
        iconType: 'ticket',
      ),
    ];
  }
}

class FoodItem {
  final String id;
  final String name;
  final String description;
  final int price;
  final String image;
  int qty;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    this.qty = 0,
  });

  /// Clone với qty mới (dùng khi cần bản sao cho giỏ hàng)
  FoodItem copyWith({int? qty}) {
    return FoodItem(
      id: id,
      name: name,
      description: description,
      price: price,
      image: image,
      qty: qty ?? this.qty,
    );
  }

  /// Thành Map để lưu vào Ticket
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'qty': qty,
    };
  }

  /// Danh sách combo mặc định
  static List<FoodItem> getDefaultFoods() {
    return [
      FoodItem(
        id: 'f1',
        name: 'Combo Bắp Nước Siêu To',
        description: '1 Bắp lớn + 1 Nước ngọt lớn',
        price: 85000,
        image: 'https://images.unsplash.com/photo-1585647347384-2593bc35786b?w=500',
      ),
      FoodItem(
        id: 'f2',
        name: 'Combo 2 Người',
        description: '1 Bắp lớn + 2 Nước ngọt lớn',
        price: 105000,
        image: 'https://images.unsplash.com/photo-1572177215152-32f247303126?w=500',
      ),
      FoodItem(
        id: 'f3',
        name: 'Snack Thập Cẩm',
        description: '1 Snack khoai tây + 1 Nước ngọt',
        price: 55000,
        image: 'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=500',
      ),
      FoodItem(
        id: 'f4',
        name: 'Nước Suối Tinh Khiết',
        description: '1 Chai nước suối 500ml',
        price: 20000,
        image: 'https://images.unsplash.com/photo-1616118132534-381148898bb4?w=500',
      ),
    ];
  }
}

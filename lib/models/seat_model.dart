class Seat {
  final String id;
  final String row;
  final int number;
  final String type; // 'standard', 'vip'
  final int price;
  bool isBooked;

  Seat({
    required this.id,
    required this.row,
    required this.number,
    this.type = 'standard',
    required this.price,
    this.isBooked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'row': row,
      'number': number,
      'type': type,
      'price': price,
      'isBooked': isBooked ? 1 : 0,
    };
  }

  factory Seat.fromMap(Map<String, dynamic> map) {
    return Seat(
      id: map['id'],
      row: map['row'],
      number: map['number'],
      type: map['type'] ?? 'standard',
      price: map['price'] ?? 0,
      isBooked: map['isBooked'] == 1 || map['isBooked'] == true,
    );
  }
}

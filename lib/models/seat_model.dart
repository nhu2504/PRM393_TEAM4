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
}

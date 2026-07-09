class RoomModel {
  final String id;
  final String cinemaId;
  final String name;
  final String type; // '2D', '3D', 'IMAX', 'Gold Class'

  RoomModel({
    required this.id,
    required this.cinemaId,
    required this.name,
    this.type = '2D',
  });

  factory RoomModel.fromMap(Map<String, dynamic> map) {
    return RoomModel(
      id: map['id'].toString(),
      cinemaId: map['cinemaId'].toString(),
      name: map['name'] ?? '',
      type: map['type'] ?? '2D',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cinemaId': cinemaId,
      'name': name,
      'type': type,
    };
  }
}

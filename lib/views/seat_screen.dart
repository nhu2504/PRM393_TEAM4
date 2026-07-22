import 'package:flutter/material.dart';
import 'order_confirmation_screen.dart';

class SeatScreen extends StatefulWidget {
  const SeatScreen({super.key});

  @override
  State<SeatScreen> createState() => _SeatScreenState();
}

class _SeatScreenState extends State<SeatScreen> {
  // --- MOCK DATA & TRẠNG THÁI ---

  // 1. Danh sách rạp & trạng thái rạp đang chọn
  final List<String> _cinemas = [
    'Beta Cinemas Mỹ Đình',
    'CGV Vincom Center',
    'Lotte Cinema Tây Hồ'
  ];
  String _selectedCinema = 'Beta Cinemas Mỹ Đình';

  // 2. Danh sách giờ chiếu & trạng thái giờ đang chọn
  final List<String> _showtimes = ['09:30', '12:00', '14:15', '18:30', '20:45'];
  String _selectedTime = '14:15';

  // 3. Trạng thái ghế ngồi
  final int _ticketPrice = 85000;
  final List<int> _bookedSeats = [3, 7, 12, 15]; // Các ghế đã có người mua
  List<int> _selectedSeats = []; // Các ghế mình đang click chọn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Thêm chức năng back
          },
        ),
        title: const Text(
          'Chọn rạp & ghế',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // PHẦN 1: CHỌN RẠP PHIM (Dropdown)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: _buildCinemaDropdown(),
          ),

          // PHẦN 2: CHỌN SUẤT CHIẾU (List cuộn ngang)
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20),
            child: SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _showtimes.length,
                itemBuilder: (context, index) {
                  return _buildTimeChip(_showtimes[index]);
                },
              ),
            ),
          ),

          // Đường kẻ phân cách
          Divider(thickness: 8, color: Colors.grey[100]),

          // PHẦN 3: SƠ ĐỒ GHẾ NGỒI
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Màn hình (Arc)
                  _buildScreenCurve(),
                  const SizedBox(height: 30),

                  // Lưới ghế
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildSeatGrid(),
                  ),

                  // Chú thích
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildLegendItem(Colors.grey[200]!, 'Trống', Colors.black54),
                        _buildLegendItem(Colors.red[600]!, 'Đang chọn', Colors.white),
                        _buildLegendItem(Colors.grey[600]!, 'Đã bán', Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // PHẦN 4: THANH TOÁN (Tính tiền thực tế)
          _buildBottomBar(),
        ],
      ),
    );
  }

  // ========================================================
  // CÁC WIDGET THÀNH PHẦN
  // ========================================================

  // 1. Nút Dropdown chọn rạp
  Widget _buildCinemaDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCinema,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.red),
          items: _cinemas.map((String cinema) {
            return DropdownMenuItem<String>(
              value: cinema,
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey, size: 20),
                  const SizedBox(width: 10),
                  Text(cinema, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCinema = newValue;
                _selectedSeats.clear(); // Đổi rạp thì reset lại ghế
              });
            }
          },
        ),
      ),
    );
  }

  // 2. Nút chọn giờ chiếu
  Widget _buildTimeChip(String time) {
    bool isSelected = _selectedTime == time;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTime = time;
          _selectedSeats.clear(); // Đổi giờ chiếu thì reset lại ghế
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red[600] : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.red[600]! : Colors.grey[300]!,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  // 3. Đường cong màn hình chiếu
  Widget _buildScreenCurve() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[300]!, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: const Border(top: BorderSide(color: Colors.grey, width: 3)),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      alignment: Alignment.topCenter,
      child: const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Text(
          'MÀN HÌNH',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 2),
        ),
      ),
    );
  }

  // 4. Lưới ghế ngồi (Có tính năng click)
  Widget _buildSeatGrid() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // Nằm trong SingleChildScrollView nên tắt cuộn
      shrinkWrap: true,
      itemCount: 30, // 5 hàng, 6 cột
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        int rowIndex = index ~/ 6;
        int colIndex = (index % 6) + 1;
        String seatName = '${String.fromCharCode(65 + rowIndex)}$colIndex';

        bool isBooked = _bookedSeats.contains(index);
        bool isSelected = _selectedSeats.contains(index);

        Color seatColor = Colors.grey[200]!;
        Color textColor = Colors.black54;

        if (isBooked) {
          seatColor = Colors.grey[600]!;
          textColor = Colors.white;
        } else if (isSelected) {
          seatColor = Colors.red[600]!;
          textColor = Colors.white;
        }

        return GestureDetector(
          onTap: () {
            if (isBooked) return; // Ghế đã bán thì không cho bấm

            setState(() {
              if (isSelected) {
                _selectedSeats.remove(index); // Đang chọn -> Bỏ chọn
              } else {
                if (_selectedSeats.length < 6) { // Giới hạn mua 6 vé 1 lần
                  _selectedSeats.add(index);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chỉ được chọn tối đa 6 ghế!')),
                  );
                }
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: seatColor,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              seatName,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
            ),
          ),
        );
      },
    );
  }

  // 5. Chú thích màu sắc ghế
  Widget _buildLegendItem(Color color, String label, Color textColor) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // 6. Thanh toán cuối màn hình
  Widget _buildBottomBar() {
    int totalAmount = _selectedSeats.length * _ticketPrice;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedSeats.isEmpty ? 'Chưa chọn ghế' : '${_selectedSeats.length} ghế đã chọn',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  // Format số tiền có dấu chấm (VD: 170.000 đ)
                  '${totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                ),
              ],
            ),
            ElevatedButton(
              // Chỉ cho phép bấm khi đã chọn ít nhất 1 ghế
              onPressed: _selectedSeats.isEmpty ? null : () {
                // Chuyển danh sách index ghế sang tên ghế (A1, B2...)
                List<String> seatNames = _selectedSeats.map((index) {
                  int rowIndex = index ~/ 6;
                  int colIndex = (index % 6) + 1;
                  return '${String.fromCharCode(65 + rowIndex)}$colIndex';
                }).toList();

                // Chuyển sang màn hình Xác nhận đơn hàng với dữ liệu thực tế
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderConfirmationScreen(
                      cinemaName: _selectedCinema,
                      showtime: '$_selectedTime - Thứ 6, 24/05', // Mock thêm ngày
                      selectedSeats: seatNames,
                      totalAmount: _selectedSeats.length * _ticketPrice,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Tiếp tục',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
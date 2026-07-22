import 'package:flutter/material.dart';
import 'widgets/search_bar_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () => Navigator.pop(context),
    );
  }
}

class _SearchScreenState extends State<SearchScreen> {
  final List<String> categories = [
    'Tất cả', 'Hành động', 'Hài', 'Kinh dị', 'Tình cảm', 'Hoạt hình', 'Viễn tưởng'
  ];
  final List<String> statusFilters = ['Đang chiếu', 'Sắp chiếu'];

  String selectedCategory = 'Tất cả';
  String selectedStatus = 'Đang chiếu';
  double maxPrice = 150000;
  String searchQuery = ''; // Biến lưu giá trị tìm kiếm khi nhập

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const _CloseButton(),
        title: const Text(
          'Tìm kiếm phim',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Đổi padding bọc ngoài thành chỉ áp dụng vertical và right,
        // vì phía bên trái đã có sẵn padding 16 của SearchBarWidget rồi.
        padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Khu vực Tìm kiếm & Nút mở Bộ lọc
            Row(
              children: [
                Expanded(
                  child: SearchBarWidget(
                    // Truyền hàm onChanged theo đúng yêu cầu bắt buộc từ widget của bạn
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                // Nút mở bộ lọc (Filter) đặt sát cạnh thanh SearchBar của bạn
                GestureDetector(
                  onTap: () => _showFilterBottomSheet(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Vì phần Column cha bị lệch padding trái (do SearchBar tự có padding),
            // ta bọc các thành phần bên dưới vào Padding để căn đều 16px hai bên.
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Các từ khóa tìm kiếm phổ biến
                  const Text(
                    'Tìm kiếm phổ biến',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildSuggestionChip('Avengers: Endgame'),
                      _buildSuggestionChip('Lật Mặt'),
                      _buildSuggestionChip('Conjuring'),
                      _buildSuggestionChip('Titanic'),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // 3. Danh sách kết quả gợi ý / tìm thấy
                  const Text(
                    'Kết quả gợi ý',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) => _buildMovieSearchCard(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.grey[800], fontSize: 13),
      ),
    );
  }

  Widget _buildMovieSearchCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.grey),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tên Phim Thử Nghiệm',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hành động, Viễn tưởng',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    const Text('4.8', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Text('2D | T16', style: TextStyle(color: Colors.red[400], fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Sheet hiển thị Bộ lọc nâng cao (Trạng thái, Thể loại, Giá vé)
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Bộ lọc nâng cao',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Lọc Trạng thái
                  const Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Row(
                    children: statusFilters.map((status) {
                      final isSelected = selectedStatus == status;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedStatus = status),
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.red : Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 13),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Lọc Thể loại
                  const Text('Thể loại', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((cat) {
                      final isSelected = selectedCategory == cat;
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedCategory = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.red : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isSelected ? Colors.red : Colors.grey.shade300),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 13),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Lọc Khoảng giá vé (Slider)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Giá vé tối đa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('${maxPrice.toInt()}đ', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Slider(
                    value: maxPrice,
                    min: 50000,
                    max: 200000,
                    divisions: 6,
                    activeColor: Colors.red,
                    inactiveColor: Colors.grey[300],
                    onChanged: (value) => setModalState(() => maxPrice = value),
                  ),
                  const SizedBox(height: 24),

                  // Các nút hành động xử lý bộ lọc
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setModalState(() {
                              selectedCategory = 'Tất cả';
                              selectedStatus = 'Đang chiếu';
                              maxPrice = 150000;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Thiết lập lại', style: TextStyle(color: Colors.red)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text('Áp dụng', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
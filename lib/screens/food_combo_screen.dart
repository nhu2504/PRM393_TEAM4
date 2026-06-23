import 'package:flutter/material.dart';

class FoodComboScreen extends StatefulWidget {
  const FoodComboScreen({Key? key}) : super(key: key);

  @override
  _FoodComboScreenState createState() => _FoodComboScreenState();
}

class _FoodComboScreenState extends State<FoodComboScreen> {
  final List<Map<String, dynamic>> combos = [
    {
      'name': 'Combo Bắp Nước Siêu To',
      'desc': '1 Bắp lớn + 1 Nước ngọt lớn',
      'price': 85000,
      'qty': 0,
      'image': 'https://images.unsplash.com/photo-1585647347384-2593bc35786b?w=500'
    },
    {
      'name': 'Combo 2 Người',
      'desc': '1 Bắp lớn + 2 Nước ngọt lớn',
      'price': 105000,
      'qty': 0,
      'image': 'https://images.unsplash.com/photo-1572177215152-32f247303126?w=500'
    },
    {
      'name': 'Snack Thập Cẩm',
      'desc': '1 Snack khoai tây + 1 Nước ngọt',
      'price': 55000,
      'qty': 0,
      'image': 'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=500'
    },
    {
      'name': 'Nước Suối tinh khiết',
      'desc': '1 Chai nước suối 500ml',
      'price': 20000,
      'qty': 0,
      'image': 'https://images.unsplash.com/photo-1616118132534-381148898bb4?w=500'
    },
  ];

  int get totalPrice => combos.fold(0, (sum, item) => sum + (item['price'] as int) * (item['qty'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.orangeAccent, Colors.deepOrangeAccent]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.fastfood_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.orangeAccent, Colors.deepOrange],
              ).createShader(bounds),
              child: const Text(
                'Chọn Đồ Ăn',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: combos.length,
              itemBuilder: (context, index) {
                final combo = combos[index];
                return Card(
                  elevation: 4,
                  shadowColor: Colors.black12,
                  margin: const EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Colors.white, Color(0xFFFFFDF8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            combo['image'],
                            width: 85,
                            height: 85,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 85,
                              height: 85,
                              color: Colors.orange[50],
                              child: const Icon(Icons.fastfood, color: Colors.orange, size: 40),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(combo['name'],
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: Colors.black87)),
                              const SizedBox(height: 6),
                              Text(combo['desc'],
                                  style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 10),
                              Text('${combo['price']} đ',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.deepOrange)),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.orangeAccent.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 22),
                                color: combo['qty'] > 0 ? Colors.deepOrange : Colors.grey[400],
                                onPressed: () {
                                  if (combo['qty'] > 0) {
                                    setState(() {
                                      combo['qty']--;
                                    });
                                  }
                                },
                              ),
                              Text('${combo['qty']}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              IconButton(
                                icon: const Icon(Icons.add, size: 22),
                                color: Colors.deepOrange,
                                onPressed: () {
                                  setState(() {
                                    combo['qty']++;
                                  });
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Tổng thanh toán', style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text('$totalPrice đ',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 26, color: Colors.redAccent)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: totalPrice > 0 ? () {} : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                      backgroundColor: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: totalPrice > 0 ? 8 : 0,
                      shadowColor: Colors.deepOrangeAccent.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Tiếp tục', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

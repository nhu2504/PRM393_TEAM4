import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Thanh chấm sao có thể bấm chọn.
///
/// Tương thích ngược: vẫn gọi được `const StarRating()` như cũ.
/// Muốn lấy giá trị người dùng chọn thì truyền [onRatingChanged].
///
///   StarRating(onRatingChanged: (value) => _movieRating = value)
///
/// ⚠️ Nếu file StarRating cũ của bạn đã có sẵn `onRatingChanged`/`onChanged`
/// thì bỏ file này đi và dùng đúng tên tham số của bạn trong 3 chỗ gọi ở
/// rate_experience_screen.dart.
class StarRating extends StatefulWidget {
  final int initialRating;
  final int starCount;
  final double size;
  final Color? color;
  final ValueChanged<int>? onRatingChanged;

  const StarRating({
    super.key,
    this.initialRating = 0,
    this.starCount = 5,
    this.size = 34,
    this.color,
    this.onRatingChanged,
  });

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  late int _rating = widget.initialRating;

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.color ?? AppColors.primaryPink;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (index) {
        final filled = index < _rating;
        return GestureDetector(
          onTap: () {
            setState(() => _rating = index + 1);
            widget.onRatingChanged?.call(_rating);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_border_rounded,
              size: widget.size,
              color: filled ? activeColor : Colors.grey.shade300,
            ),
          ),
        );
      }),
    );
  }
}

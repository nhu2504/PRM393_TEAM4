import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/star_rating.dart';
import '../models/movie_model.dart';
import '../models/review_model.dart';
import '../controllers/review_controller.dart';
import '../controllers/account_controller.dart';

class RateExperienceScreen extends StatefulWidget {
  /// Phim + rạp cần đánh giá — truyền từ 1 vé.
  final Movie movie;
  final String cinemaName;

  const RateExperienceScreen({
    super.key,
    required this.movie,
    required this.cinemaName,
  });

  @override
  State<RateExperienceScreen> createState() => _RateExperienceScreenState();
}

class _RateExperienceScreenState extends State<RateExperienceScreen> {
  int _movieRating = 0;
  int _cinemaRating = 0;
  int _foodRating = 0;
  String _photoPath = '';
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _today() {
    final n = DateTime.now();
    return '${n.day.toString().padLeft(2, '0')}/'
        '${n.month.toString().padLeft(2, '0')}/${n.year}';
  }

  Future<void> _send() async {
    // Bắt buộc chấm rạp hoặc đồ ăn để phân loại đúng vào tab "Trải nghiệm".
    if (_cinemaRating == 0 && _foodRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hãy chấm sao cho Cinema hoặc Drink & Food nhé!')),
      );
      return;
    }

    final userId = context.read<AccountController>().user?.id ?? 'guest';

    final review = ReviewModel(
      id: 'REV_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      movieId: widget.movie.id,
      ratingMovie: _movieRating.toDouble(),
      ratingCinema: _cinemaRating.toDouble(),
      ratingFood: _foodRating.toDouble(),
      comment: _commentController.text.trim(),
      imagePath: _photoPath,
      date: _today(),
    );

    await ReviewController.instance.addReview(review);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cảm ơn bạn đã đánh giá trải nghiệm!')),
    );
    Navigator.pop(context, review);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text(
                        'X',
                        style: TextStyle(fontSize: 24, color: AppColors.primaryPink),
                      ),
                    ),
                    const SizedBox(width: 35),
                    const Text(
                      'Rate Your Experience ⭐',
                      style: TextStyle(fontSize: 18, color: AppColors.primaryPink),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                // Tên rạp cho người dùng biết đang đánh giá buổi xem nào
                Text(
                  '${widget.cinemaName}',
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),

                const SizedBox(height: 20),

                Text(
                  widget.movie.title,
                  style: const TextStyle(fontSize: 26, color: AppColors.primaryPink),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: StarRating(onRatingChanged: (v) => _movieRating = v),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Cinema',
                  style: TextStyle(fontSize: 26, color: AppColors.primaryPink),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: StarRating(onRatingChanged: (v) => _cinemaRating = v),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Drink & Food',
                  style: TextStyle(fontSize: 26, color: AppColors.primaryPink),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: StarRating(onRatingChanged: (v) => _foodRating = v),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Load a photo',
                  style: TextStyle(fontSize: 26, color: AppColors.primaryPink),
                ),

                const SizedBox(height: 15),

                GestureDetector(
                  onTap: () {
                    // TODO: dùng image_picker để chọn ảnh thật:
                    //   final f = await ImagePicker().pickImage(source: ImageSource.gallery);
                    //   if (f != null) setState(() => _photoPath = f.path);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('upload')),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xffffedf5),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.lightPink, width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 35,
                          color: AppColors.primaryPink,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _photoPath.isEmpty ? 'Tap to upload photo' : 'Đã chọn 1 ảnh',
                          style: const TextStyle(color: AppColors.primaryPink, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                const Text(
                  'Write comment',
                  style: TextStyle(fontSize: 26, color: AppColors.primaryPink),
                ),

                const SizedBox(height: 5),

                TextField(
                  controller: _commentController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    filled: true,
                    fillColor: const Color(0xffffedf5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: CustomButton(
                    text: 'Send',
                    width: 130,
                    onPressed: _send,
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

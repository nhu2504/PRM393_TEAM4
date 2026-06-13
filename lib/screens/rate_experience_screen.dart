import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/star_rating.dart';

class RateExperienceScreen extends StatelessWidget {
  const RateExperienceScreen({super.key});

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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'X',
                        style: TextStyle(
                          fontSize: 24,
                          color: AppColors.primaryPink,
                        ),
                      ),
                    ),

                    const SizedBox(width: 35),

                    const Text(
                      'Rate Your Experience ⭐',
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.primaryPink,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 70),

                const Text(
                  'Movie',
                  style: TextStyle(
                    fontSize: 26,
                    color: AppColors.primaryPink,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 55),
                  child: StarRating(),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Cinema',
                  style: TextStyle(
                    fontSize: 26,
                    color: AppColors.primaryPink,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 55),
                  child: StarRating(),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Drink & Food',
                  style: TextStyle(
                    fontSize: 26,
                    color: AppColors.primaryPink,
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(left: 55),
                  child: StarRating(),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Load a photo',
                  style: TextStyle(
                    fontSize: 26,
                    color: AppColors.primaryPink,
                  ),
                ),

                const SizedBox(height: 15),

                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('upload'),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: 95,
                    decoration: BoxDecoration(
                      color: const Color(0xffffedf5),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: AppColors.lightPink,
                        width: 1,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 35,
                          color: AppColors.primaryPink,
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Tap to upload photo',
                          style: TextStyle(
                            color: AppColors.primaryPink,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                const Text(
                  'Write comment',
                  style: TextStyle(
                    fontSize: 26,
                    color: AppColors.primaryPink,
                  ),
                ),

                const SizedBox(height: 5),

                TextField(
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
                    onPressed: () {},
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
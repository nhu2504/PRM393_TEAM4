import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  const StarRating({super.key});

  @override
  State<StarRating> createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int selectedStar = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        int starNumber = index + 1;

        return IconButton(
          onPressed: () {
            setState(() {
              selectedStar = starNumber;
            });
          },
          icon: Icon(
            starNumber <= selectedStar
                ? Icons.star
                : Icons.star_border,
            color: Colors.amber,
            size: 30,
          ),
        );
      }),
    );
  }
}
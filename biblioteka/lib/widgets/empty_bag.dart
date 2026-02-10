import 'package:flutter/material.dart';
import 'package:biblioteka/consts/app.colors.dart';
import 'package:biblioteka/widgets/subtitle_text.dart';
import 'package:biblioteka/widgets/title_text.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.buttonAction,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback buttonAction; 

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath,
          width: double.infinity,
          height: size.height * 0.20,
        ),
        const SizedBox(height: 20),

        TitelesTextWidget(label: title),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SubtitleTextWidget(
              label: subtitle,
              textAlign: TextAlign.center,
            ),
          ),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.darkPrimary,
          ),
          onPressed: buttonAction, 
          child: Text(
            buttonText,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

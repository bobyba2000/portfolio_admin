import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FeedbackItemWidget extends StatelessWidget {
  final FeedbackItemModel feedback;
  const FeedbackItemWidget({Key? key, required this.feedback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VideoPlayerController _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        feedback.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: feedback.isActive ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Text(
                        feedback.isActive ? 'Active' : 'Inactive',
                        style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 12),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  feedback.videoLink,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  feedback.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black, fontSize: 12),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FeedbackItemModel {
  String content;
  String videoLink;
  String title;
  String subTitle;
  bool isActive;
  FeedbackItemModel(
    this.videoLink,
    this.title,
    this.content,
    this.subTitle,
    this.isActive,
  );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'video': videoLink,
      'content': content,
      'subTitle': subTitle,
      'isActive': isActive,
    };
  }
}

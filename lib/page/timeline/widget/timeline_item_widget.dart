import 'package:flutter/material.dart';

class TimelineItemWidget extends StatelessWidget {
  final TimelineItemModel timeline;
  const TimelineItemWidget({Key? key, required this.timeline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              image: DecorationImage(
                image: NetworkImage(timeline.imageLink),
                fit: BoxFit.cover,
              ),
            ),
            height: 200,
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
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
                        timeline.title,
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
                        color: timeline.isActive ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Text(
                        timeline.isActive ? 'Active' : 'Inactive',
                        style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black, fontSize: 12),
                      ),
                    )
                  ],
                ),
                Text(
                  timeline.year,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  timeline.content,
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

class TimelineItemModel {
  String content;
  String imageLink;
  String title;
  String year;
  bool isActive;
  TimelineItemModel(this.imageLink, this.title, this.content, this.isActive, this.year);

  int get numYear {
    return int.tryParse(year) ?? 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'image': imageLink,
      'title': title,
      'content': content,
      'isActive': isActive,
    };
  }
}

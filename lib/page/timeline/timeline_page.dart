import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:portfolio/common_widgets/custom_grid_widget.dart';
import 'package:portfolio/page/timeline/page/timeline_detail_page.dart';
import 'package:portfolio/page/timeline/widget/timeline_item_widget.dart';

class TimelinePage extends StatefulWidget {
  const TimelinePage({Key? key}) : super(key: key);

  @override
  State<TimelinePage> createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  List<dynamic> listTimelines = [];
  List<Widget> children = [];
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'TIMELINE',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Spacer(),
            ],
          ),
          const SizedBox(height: 36),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomGridWidget(
                    children: listTimelines
                        .asMap()
                        .entries
                        .map(
                          (e) => InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: TimelineDetailPage(
                                    listTimeline: listTimelines,
                                    timeline: TimelineItemModel(
                                      e.value['image'],
                                      e.value['title'],
                                      e.value['content'],
                                      e.value['isActive'] ?? true,
                                      e.value['year'],
                                    ),
                                    index: e.key,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                ),
                              );
                              getData();
                            },
                            child: TimelineItemWidget(
                              timeline: TimelineItemModel(
                                e.value['image'],
                                e.value['title'],
                                e.value['content'],
                                e.value['isActive'] ?? true,
                                e.value['year'],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: InkWell(
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          padding: const EdgeInsets.all(8),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ),
        onTap: () async {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: TimelineDetailPage(listTimeline: listTimelines),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          );
          getData();
        },
      ),
    );
  }

  Future<void> getData() async {
    EasyLoading.show(dismissOnTap: false);
    try {
      Map<String, dynamic> timeline = (await FirebaseFirestore.instance.collection('user_info').get()).docs.first.get('timeline');
      listTimelines = timeline['items'];
      setState(() {});
    } catch (e) {
      // ToastUtils.showToast(msg: e.toString(), isError: true);
    }
    EasyLoading.dismiss();
  }
}

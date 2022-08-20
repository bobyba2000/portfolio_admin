import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:portfolio/common_widgets/custom_grid_widget.dart';
import 'package:portfolio/common_widgets/text_field_widget.dart';
import 'package:portfolio/page/blog/page/blog_detail_page.dart';
import 'package:portfolio/page/blog/widget/blog_item_widget.dart';

import '../../helper/toast_utils.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({Key? key}) : super(key: key);

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  List<dynamic> listBlogs = [];
  List<Widget> children = [];
  final TextEditingController _generalController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
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
          const Text(
            'BLOGS',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 36),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'INTRODUCTION',
                          style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        TextFieldWidget(
                          controller: _generalController,
                          label: 'General Detail',
                          maxLines: 2,
                        ),
                        const SizedBox(height: 16),
                        TextFieldWidget(
                          controller: _linkController,
                          label: 'Link',
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomGridWidget(
                    children: listBlogs
                        .asMap()
                        .entries
                        .map(
                          (e) => InkWell(
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: BlogDetailPage(
                                    listBlog: listBlogs,
                                    blog: BlogItemModel(
                                      e.value['datePost'],
                                      e.value['image'],
                                      e.value['title'],
                                      e.value['link'],
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
                            child: BlogItemWidget(
                              blog: BlogItemModel(
                                e.value['datePost'],
                                e.value['image'],
                                e.value['title'],
                                e.value['link'],
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
              content: BlogDetailPage(listBlog: listBlogs),
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
      Map<String, dynamic> content = (await FirebaseFirestore.instance.collection('user_info').get()).docs.first.get('content');
      listBlogs = content['posts'];
      _generalController.text = content['introduce'];
      _linkController.text = content['link'];
      setState(() {});
    } catch (e) {
      ToastUtils.showToast(msg: e.toString(), isError: true);
    }
    EasyLoading.dismiss();
  }
}

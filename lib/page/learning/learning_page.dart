import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:portfolio/common_widgets/base_button.dart';
import 'package:portfolio/common_widgets/custom_grid_widget.dart';
import 'package:portfolio/common_widgets/network_image_widget.dart';
import 'package:portfolio/common_widgets/text_field_widget.dart';
import 'package:portfolio/page/learning/page/learning_detail_page.dart';
import 'package:portfolio/page/learning/widget/learning_item_widget.dart';

import '../../helper/storage_service.dart';
import '../../helper/toast_utils.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({Key? key}) : super(key: key);

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  List<dynamic> listLearnings = [];
  List<Widget> children = [];
  final TextEditingController _generalController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final form = GlobalKey<FormState>();
  Uint8List bytes = Uint8List(0);
  String? url;
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
            children: [
              const Text(
                'LEARNINGS',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              BaseButton(
                text: 'SAVE',
                onClick: () {
                  if (form.currentState!.validate()) {
                    updateData();
                  }
                },
                textStyle: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                backgroundColor: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 36),
          Form(
            key: form,
            child: Expanded(
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
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['png'],
                                  );
                                  if (result != null) {
                                    bytes = result.files.first.bytes ?? Uint8List(0);
                                    setState(() {});
                                  }
                                },
                                child: NetworkImageWidget(
                                  url: url,
                                  bytes: bytes,
                                  width: 120,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomGridWidget(
                      children: listLearnings
                          .asMap()
                          .entries
                          .map(
                            (e) => InkWell(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: LearningDetailPage(
                                      listLearning: listLearnings,
                                      learning: LearningItemModel(
                                        e.value['image'],
                                        e.value['title'],
                                        e.value['link'],
                                        e.value['content'] ?? '',
                                        e.value['isActive'] ?? true,
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
                              child: LearningItemWidget(
                                learning: LearningItemModel(
                                  e.value['image'],
                                  e.value['title'],
                                  e.value['link'],
                                  e.value['content'] ?? '',
                                  e.value['isActive'] ?? true,
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
              content: LearningDetailPage(listLearning: listLearnings),
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
      Map<String, dynamic> content = (await FirebaseFirestore.instance.collection('user_info').get()).docs.first.get('learning');
      listLearnings = content['posts'];
      _generalController.text = content['introduce'];
      _linkController.text = content['link'];
      url = content['image_background'];
      setState(() {});
    } catch (e) {
      // ToastUtils.showToast(msg: e.toString(), isError: true);
    }
    EasyLoading.dismiss();
  }

  Future<void> updateData() async {
    EasyLoading.show(dismissOnTap: false);
    try {
      CollectionReference userInfo = FirebaseFirestore.instance.collection('user_info');
      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({'learning.introduce': _generalController.text});
      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({'learning.link': _linkController.text});
      if (bytes.isNotEmpty) {
        url = await Storage.uploadFile(bytes, 'learnings') ?? '';
      }
      if (url != null) {
        await userInfo.doc('KFcwyediaY33ojA7FdCt').update({'learning.image_background': url});
      }
      ToastUtils.showToast(msg: 'Update successfully.');
      EasyLoading.dismiss();
    } catch (e) {
      ToastUtils.showToast(msg: 'Update failed.', isError: true);
      EasyLoading.dismiss();
    }
  }
}

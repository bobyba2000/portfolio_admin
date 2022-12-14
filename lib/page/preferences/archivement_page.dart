import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:portfolio/common_widgets/custom_grid_widget.dart';
import 'package:portfolio/common_widgets/text_field_widget.dart';

import '../../common_widgets/base_button.dart';
import '../../helper/toast_utils.dart';
import 'page/archivement_detail_page.dart';
import 'widget/archivement_item_widget.dart';

class ArchivementPage extends StatefulWidget {
  const ArchivementPage({Key? key}) : super(key: key);

  @override
  State<ArchivementPage> createState() => _ArchivementPageState();
}

class _ArchivementPageState extends State<ArchivementPage> {
  List<dynamic> listArchivements = [];
  List<Widget> children = [];
  final TextEditingController _generalController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final form = GlobalKey<FormState>();
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
                'ARCHIVEMENTS',
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
                      children: listArchivements
                          .asMap()
                          .entries
                          .map(
                            (e) => InkWell(
                              onTap: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: ArchivementDetailPage(
                                      listArchivement: listArchivements,
                                      archivement: ArchivementItemModel(
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
                              child: ArchivementItemWidget(
                                archivement: ArchivementItemModel(
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
              content: ArchivementDetailPage(listArchivement: listArchivements),
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
      Map<String, dynamic> content = (await FirebaseFirestore.instance.collection('user_info').get()).docs.first.get('recent_work');
      listArchivements = content['posts'];
      _generalController.text = content['introduce'];
      _linkController.text = content['link'];
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
      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({'recent_work.introduce': _generalController.text});
      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({'recent_work.link': _linkController.text});
      ToastUtils.showToast(msg: 'Update successfully.');
      EasyLoading.dismiss();
    } catch (e) {
      ToastUtils.showToast(msg: 'Update failed.', isError: true);
      EasyLoading.dismiss();
    }
  }
}

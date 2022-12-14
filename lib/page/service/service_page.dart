import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:portfolio/helper/storage_service.dart';
import 'package:portfolio/helper/toast_utils.dart';
import 'package:portfolio/page/service/service_detail_page.dart';
import 'package:portfolio/page/service/service_item.dart';

import '../../common_widgets/base_button.dart';
import '../../common_widgets/text_field_widget.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  final form = GlobalKey<FormState>();
  List<TextEditingController> listDetail = [];
  final TextEditingController _generalController = TextEditingController();
  List<dynamic> listServices = [];
  List<Uint8List> listImages = <Uint8List>[];
  List<Widget> children = [];
  bool isDetail = false;
  List<String> listHtml = [];
  int index = -1;

  @override
  Widget build(BuildContext context) {
    if (isDetail) {
      return ServiceDetailPage(
        onBack: () {
          setState(() {
            isDetail = false;
          });
        },
        id: index,
        onSave: (value) {
          listHtml[index] = value;
          isDetail = false;
          updateData();
        },
        value: listHtml[index],
        title: listServices[index]['title'],
      );
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'SERVICES',
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'YOUR SERVICES\'DETAIL',
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          TextFieldWidget(
                            controller: _generalController,
                            label: 'General Detail',
                            maxLines: 3,
                          ),
                          ...children,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getData() async {
    EasyLoading.show();
    try {
      Map<String, dynamic> userInfo = (await FirebaseFirestore.instance.collection('user_info').get()).docs.first.get('service');
      listServices = userInfo['list'];
      listDetail = listServices
          .map(
            (e) => TextEditingController(text: e['info']),
          )
          .toList();
      listHtml = listServices.map<String>((e) => e['html']?.toString() ?? '').toList();
      listImages = listServices.map((e) => Uint8List(0)).toList();
      children = listServices
          .asMap()
          .entries
          .map(
            (e) => ServiceItemWidget(
              value: e.value,
              controller: listDetail[e.key],
              onChangeImage: (bytes) {
                listImages[e.key] = bytes;
              },
              onClick: () {
                setState(() {
                  index = e.key;
                  isDetail = true;
                });
              },
            ),
          )
          .toList();
      _generalController.text = userInfo['introduce'];
      setState(() {});
    } catch (e) {
      // ToastUtils.showToast(msg: e.toString(), isError: true);
    }
    EasyLoading.dismiss();
  }

  Future<void> updateData() async {
    EasyLoading.show();
    try {
      CollectionReference userInfo = FirebaseFirestore.instance.collection('user_info');

      for (var i = 0; i < listServices.length; i++) {
        if (listImages[i].isNotEmpty) {
          listServices[i]['image'] = await Storage.uploadFile(listImages[i], 'services') ?? listServices[i]['image'];
        }
      }

      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({
        'service': {
          'introduce': _generalController.text,
          'list': listServices.asMap().entries.map(
                (e) => {
                  'info': listDetail[e.key].text,
                  'icon': e.value['icon'],
                  'title': e.value['title'],
                  'image': e.value['image'] ?? '',
                  'html': listHtml[e.key],
                },
              )
        }
      });
      ToastUtils.showToast(msg: 'Update successfully.');
      EasyLoading.dismiss();
      getData();
    } catch (e) {
      ToastUtils.showToast(msg: 'Update failed.', isError: true);
      EasyLoading.dismiss();
    }
  }
}

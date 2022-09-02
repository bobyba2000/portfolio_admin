import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:portfolio/helper/toast_utils.dart';

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
  List<Widget> children = [];
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
      children = listServices
          .asMap()
          .entries
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextFieldWidget(controller: listDetail[e.key], label: e.value['title'] + ' Detail'),
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
      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({
        'service': {
          'introduce': _generalController.text,
          'list': listServices.asMap().entries.map(
                (e) => {
                  'info': listDetail[e.key].text,
                  'icon': e.value['icon'],
                  'title': e.value['title'],
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

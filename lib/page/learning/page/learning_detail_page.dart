import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:portfolio/common_widgets/base_button.dart';
import 'package:portfolio/common_widgets/network_image_widget.dart';
import 'package:portfolio/common_widgets/text_field_widget.dart';
import 'package:portfolio/helper/storage_service.dart';
import 'package:portfolio/helper/toast_utils.dart';
import 'package:portfolio/validator/base_validator.dart';

import '../widget/learning_item_widget.dart';

class LearningDetailPage extends StatefulWidget {
  final LearningItemModel? learning;
  final List<dynamic> listLearning;
  final int? index;
  const LearningDetailPage({
    Key? key,
    this.learning,
    required this.listLearning,
    this.index,
  }) : super(key: key);

  @override
  State<LearningDetailPage> createState() => _LearningDetailPageState();
}

class _LearningDetailPageState extends State<LearningDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late LearningItemModel learning;
  Uint8List bytes = Uint8List(0);
  final form = GlobalKey<FormState>();

  @override
  void initState() {
    learning = widget.learning ??
        LearningItemModel(
          '',
          '',
          '',
          '',
          true,
        );
    _titleController.text = learning.title;
    _linkController.text = learning.link;
    _contentController.text = learning.content ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.learning == null ? 'New Learning' : 'Update Learning',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          Form(
            key: form,
            child: Row(
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
                    url: learning.imageLink,
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
                        controller: _titleController,
                        label: 'Title',
                        validator: BaseValidator.requiredValidate,
                      ),
                      const SizedBox(height: 16),
                      TextFieldWidget(
                        controller: _contentController,
                        label: 'Content Link',
                        validator: BaseValidator.requiredValidate,
                      ),
                      const SizedBox(height: 16),
                      TextFieldWidget(
                        controller: _linkController,
                        label: 'Link',
                        validator: BaseValidator.requiredValidate,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Visibility(
                visible: widget.learning != null,
                child: BaseButton(
                  text: learning.isActive ? 'Deactivate' : 'Activate',
                  onClick: () {
                    setLearningState();
                    uploadToFirestore();
                  },
                  backgroundColor: learning.isActive ? Colors.red : Colors.green,
                ),
              ),
              const Spacer(),
              BaseButton(
                text: 'Cancel',
                onClick: () {
                  Navigator.pop(context);
                },
                backgroundColor: Colors.transparent,
                border: Border.all(),
              ),
              const SizedBox(width: 8),
              BaseButton(
                text: ' Save ',
                onClick: () async {
                  if (form.currentState!.validate()) {
                    EasyLoading.show(dismissOnTap: false);
                    if (bytes.isNotEmpty) {
                      learning.imageLink = await Storage.uploadFile(bytes, 'learnings') ?? '';
                    }
                    learning.link = _linkController.text;
                    learning.title = _titleController.text;
                    learning.content = _contentController.text;
                    if (widget.learning == null) {
                      createLearning();
                    } else {
                      updateLearning();
                    }
                    uploadToFirestore();
                  }
                },
                backgroundColor: Colors.black,
                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                border: Border.all(),
              )
            ],
          )
        ],
      ),
    );
  }

  void setLearningState() {
    learning.isActive = !learning.isActive;
    widget.listLearning[widget.index!] = learning.toJson();
  }

  void createLearning() {
    widget.listLearning.add(learning.toJson());
  }

  void updateLearning() {
    widget.listLearning[widget.index!] = learning.toJson();
  }

  Future<void> uploadToFirestore() async {
    try {
      EasyLoading.show(dismissOnTap: false);
      CollectionReference userInfo = FirebaseFirestore.instance.collection('user_info');
      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({'learning.posts': widget.listLearning});
      EasyLoading.dismiss();
      ToastUtils.showToast(msg: 'Successfully');
      Navigator.pop(context);
      return;
    } catch (e) {
      EasyLoading.dismiss();
      ToastUtils.showToast(msg: 'Error. Please try again.', isError: true);
    }
  }
}

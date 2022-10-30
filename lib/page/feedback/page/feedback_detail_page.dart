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
import 'package:portfolio/page/feedback/widget/feedback_item_widget.dart';
import 'package:portfolio/validator/base_validator.dart';

class FeedbackDetailPage extends StatefulWidget {
  final FeedbackItemModel? feedback;
  final List<dynamic> listFeedback;
  final int? index;
  const FeedbackDetailPage({
    Key? key,
    this.feedback,
    required this.listFeedback,
    this.index,
  }) : super(key: key);

  @override
  State<FeedbackDetailPage> createState() => _FeedbackDetailPageState();
}

class _FeedbackDetailPageState extends State<FeedbackDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();
  late FeedbackItemModel feedback;
  final form = GlobalKey<FormState>();

  @override
  void initState() {
    feedback = widget.feedback ??
        FeedbackItemModel(
          '',
          '',
          '',
          true,
        );
    _titleController.text = feedback.title;
    _contentController.text = feedback.content;
    _videoLinkController.text = feedback.videoLink;
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
              widget.feedback == null ? 'New Feedback' : 'Update Feedback',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 12),
          Form(
            key: form,
            child: Row(
              children: [
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
                        label: 'Content',
                        maxLines: 6,
                        validator: BaseValidator.requiredValidate,
                      ),
                      const SizedBox(height: 16),
                      TextFieldWidget(
                        controller: _videoLinkController,
                        label: 'Video Link',
                        maxLines: 1,
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
                visible: widget.feedback != null,
                child: BaseButton(
                  text: feedback.isActive ? 'Deactivate' : 'Activate',
                  onClick: () {
                    setFeedbackState();
                    uploadToFirestore();
                  },
                  backgroundColor: feedback.isActive ? Colors.red : Colors.green,
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
                    feedback.title = _titleController.text;
                    feedback.content = _contentController.text;
                    feedback.videoLink = _videoLinkController.text;
                    if (widget.feedback == null) {
                      createFeedback();
                    } else {
                      updateFeedback();
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

  void setFeedbackState() {
    feedback.isActive = !feedback.isActive;
    widget.listFeedback[widget.index!] = feedback.toJson();
  }

  void createFeedback() {
    widget.listFeedback.add(feedback.toJson());
  }

  void updateFeedback() {
    widget.listFeedback[widget.index!] = feedback.toJson();
  }

  Future<void> uploadToFirestore() async {
    try {
      EasyLoading.show(dismissOnTap: false);
      CollectionReference userInfo = FirebaseFirestore.instance.collection('user_info');
      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({'feedback.items': widget.listFeedback});
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

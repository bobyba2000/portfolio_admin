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
import 'package:portfolio/page/timeline/widget/timeline_item_widget.dart';
import 'package:portfolio/validator/base_validator.dart';

class TimelineDetailPage extends StatefulWidget {
  final TimelineItemModel? timeline;
  final List<dynamic> listTimeline;
  final int? index;
  const TimelineDetailPage({
    Key? key,
    this.timeline,
    required this.listTimeline,
    this.index,
  }) : super(key: key);

  @override
  State<TimelineDetailPage> createState() => _TimelineDetailPageState();
}

class _TimelineDetailPageState extends State<TimelineDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  late TimelineItemModel timeline;
  Uint8List bytes = Uint8List(0);
  final form = GlobalKey<FormState>();

  @override
  void initState() {
    timeline = widget.timeline ??
        TimelineItemModel(
          '',
          '',
          '',
          true,
          '',
        );
    _titleController.text = timeline.title;
    _contentController.text = timeline.content;
    _yearController.text = timeline.year;
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
              widget.timeline == null ? 'New Timeline' : 'Update Timeline',
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
                    url: timeline.imageLink,
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
                        controller: _yearController,
                        label: 'Year',
                        validator: BaseValidator.requiredValidate,
                      ),
                      const SizedBox(height: 16),
                      TextFieldWidget(
                        controller: _contentController,
                        label: 'Content',
                        maxLines: 3,
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
                visible: widget.timeline != null,
                child: BaseButton(
                  text: timeline.isActive ? 'Deactivate' : 'Activate',
                  onClick: () {
                    setTimelineState();
                    uploadToFirestore();
                  },
                  backgroundColor: timeline.isActive ? Colors.red : Colors.green,
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
                      timeline.imageLink = await Storage.uploadFile(bytes, 'timelines') ?? '';
                    }
                    timeline.year = _yearController.text;
                    timeline.title = _titleController.text;
                    timeline.content = _contentController.text;
                    if (widget.timeline == null) {
                      createTimeline();
                    } else {
                      updateTimeline();
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

  void setTimelineState() {
    timeline.isActive = !timeline.isActive;
    widget.listTimeline[widget.index!] = timeline.toJson();
  }

  void createTimeline() {
    widget.listTimeline.add(timeline.toJson());
  }

  void updateTimeline() {
    widget.listTimeline[widget.index!] = timeline.toJson();
  }

  Future<void> uploadToFirestore() async {
    try {
      EasyLoading.show(dismissOnTap: false);
      CollectionReference userInfo = FirebaseFirestore.instance.collection('user_info');
      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({'timeline.items': widget.listTimeline});
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

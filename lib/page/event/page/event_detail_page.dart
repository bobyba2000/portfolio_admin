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
import 'package:portfolio/page/event/widget/event_item_widget.dart';
import 'package:portfolio/validator/base_validator.dart';

class EventDetailPage extends StatefulWidget {
  final EventItemModel? event;
  final List<dynamic> listEvent;
  final int? index;
  const EventDetailPage({
    Key? key,
    this.event,
    required this.listEvent,
    this.index,
  }) : super(key: key);

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _registerLinkController = TextEditingController();
  late EventItemModel event;
  Uint8List bytes = Uint8List(0);
  final form = GlobalKey<FormState>();

  @override
  void initState() {
    event = widget.event ??
        EventItemModel(
          '',
          '',
          '',
          true,
          '',
          "",
        );
    _titleController.text = event.title;
    _contentController.text = event.content;
    _dateController.text = event.date;
    _registerLinkController.text = event.registerLink;
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
              widget.event == null ? 'New Event' : 'Update Event',
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
                    url: event.imageLink,
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
                        label: 'Writer',
                        validator: BaseValidator.requiredValidate,
                      ),
                      const SizedBox(height: 16),
                      TextFieldWidget(
                        controller: _dateController,
                        label: 'Date',
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
                        controller: _registerLinkController,
                        label: 'Register Link',
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
                visible: widget.event != null,
                child: BaseButton(
                  text: event.isActive ? 'Deactivate' : 'Activate',
                  onClick: () {
                    setEventState();
                    uploadToFirestore();
                  },
                  backgroundColor: event.isActive ? Colors.red : Colors.green,
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
                      event.imageLink = await Storage.uploadFile(bytes, 'events') ?? '';
                    }
                    event.date = _dateController.text;
                    event.title = _titleController.text;
                    event.content = _contentController.text;
                    event.registerLink = _registerLinkController.text;
                    if (widget.event == null) {
                      createEvent();
                    } else {
                      updateEvent();
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

  void setEventState() {
    event.isActive = !event.isActive;
    widget.listEvent[widget.index!] = event.toJson();
  }

  void createEvent() {
    widget.listEvent.add(event.toJson());
  }

  void updateEvent() {
    widget.listEvent[widget.index!] = event.toJson();
  }

  Future<void> uploadToFirestore() async {
    try {
      EasyLoading.show(dismissOnTap: false);
      CollectionReference userInfo = FirebaseFirestore.instance.collection('user_info');
      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({'event.items': widget.listEvent});
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

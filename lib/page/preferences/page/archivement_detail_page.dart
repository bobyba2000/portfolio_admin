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
import 'package:intl/intl.dart';
import 'package:portfolio/validator/base_validator.dart';

import '../widget/archivement_item_widget.dart';

class ArchivementDetailPage extends StatefulWidget {
  final ArchivementItemModel? archivement;
  final List<dynamic> listArchivement;
  final int? index;
  const ArchivementDetailPage({
    Key? key,
    this.archivement,
    required this.listArchivement,
    this.index,
  }) : super(key: key);

  @override
  State<ArchivementDetailPage> createState() => _ArchivementDetailPageState();
}

class _ArchivementDetailPageState extends State<ArchivementDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  late ArchivementItemModel archivement;
  Uint8List bytes = Uint8List(0);
  final form = GlobalKey<FormState>();

  @override
  void initState() {
    archivement = widget.archivement ?? ArchivementItemModel('', '', '');
    _titleController.text = archivement.title;
    _linkController.text = archivement.link;
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
              widget.archivement == null ? 'New Archivement' : 'Update Archivement',
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
                    url: archivement.imageLink,
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
                visible: widget.archivement != null,
                child: BaseButton(
                  text: 'Delete',
                  onClick: () {
                    widget.listArchivement.removeAt(widget.index!);
                    uploadToFirestore();
                  },
                  backgroundColor: Colors.red,
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
                      archivement.imageLink = await Storage.uploadFile(bytes, 'archivements') ?? '';
                    }
                    archivement.link = _linkController.text;
                    archivement.title = _titleController.text;
                    if (widget.archivement == null) {
                      createArchivement();
                    } else {
                      updateArchivement();
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

  void createArchivement() {
    widget.listArchivement.add(archivement.toJson());
  }

  void updateArchivement() {
    widget.listArchivement[widget.index!] = archivement.toJson();
  }

  Future<void> uploadToFirestore() async {
    try {
      CollectionReference userInfo = FirebaseFirestore.instance.collection('user_info');
      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({'recent_work.posts': widget.listArchivement});
      EasyLoading.dismiss();
      Navigator.pop(context);
      ToastUtils.showToast(msg: 'Successfully');
    } catch (e) {
      EasyLoading.dismiss();
      ToastUtils.showToast(msg: 'Error. Please try again.', isError: true);
    }
  }
}

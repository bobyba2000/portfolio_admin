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
import 'package:portfolio/page/blog/widget/blog_item_widget.dart';
import 'package:intl/intl.dart';
import 'package:portfolio/validator/base_validator.dart';

class BlogDetailPage extends StatefulWidget {
  final BlogItemModel? blog;
  final List<dynamic> listBlog;
  final int? index;
  const BlogDetailPage({
    Key? key,
    this.blog,
    required this.listBlog,
    this.index,
  }) : super(key: key);

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  late BlogItemModel blog;
  Uint8List bytes = Uint8List(0);
  final form = GlobalKey<FormState>();

  @override
  void initState() {
    blog = widget.blog ??
        BlogItemModel(
          DateFormat('MMMM dd, yyyy').format(DateTime.now()),
          '',
          '',
          '',
        );
    _titleController.text = blog.title;
    _linkController.text = blog.link;
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
              widget.blog == null ? 'New Blog' : 'Update Blog',
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
                    url: blog.imageLink,
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
                visible: widget.blog != null,
                child: BaseButton(
                  text: 'Delete',
                  onClick: () {
                    widget.listBlog.removeAt(widget.index!);
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
                      blog.imageLink = await Storage.uploadFile(bytes, 'blogs') ?? '';
                    }
                    blog.link = _linkController.text;
                    blog.title = _titleController.text;
                    if (widget.blog == null) {
                      createBlog();
                    } else {
                      updateBlog();
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

  void createBlog() {
    widget.listBlog.add(blog.toJson());
  }

  void updateBlog() {
    widget.listBlog[widget.index!] = blog.toJson();
  }

  Future<void> uploadToFirestore() async {
    try {
      CollectionReference userInfo = FirebaseFirestore.instance.collection('user_info');
      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({'content.posts': widget.listBlog});
      EasyLoading.dismiss();
      Navigator.pop(context);
      ToastUtils.showToast(msg: 'Successfully');
    } catch (e) {
      EasyLoading.dismiss();
      ToastUtils.showToast(msg: 'Error. Please try again.', isError: true);
    }
  }
}

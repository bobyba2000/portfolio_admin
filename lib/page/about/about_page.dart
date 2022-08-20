import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:portfolio/common_widgets/base_button.dart';
import 'package:portfolio/common_widgets/text_field_widget.dart';
import 'package:portfolio/helper/storage_service.dart';
import 'package:portfolio/helper/toast_utils.dart';
import 'package:portfolio/validator/base_validator.dart';

import '../../common_widgets/network_image_widget.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String photoUrl = '';
  Uint8List? photoBytes;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _shortIntroduction = TextEditingController();
  final TextEditingController _detailController = TextEditingController();

  final TextEditingController _facebookController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _youtubeController = TextEditingController();
  final TextEditingController _tiktokController = TextEditingController();

  final TextEditingController _youtubeLinkController = TextEditingController();

  final form = GlobalKey<FormState>();
  List skillInfo = [];
  List<TextEditingController> skillNumber = [];
  List<Widget> skillChildren = [];

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
                'ABOUT',
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
                            'INTRODUCE ABOUT YOURSELF',
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildImageWidget(),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFieldWidget(
                                            controller: _nameController,
                                            label: 'Name',
                                            validator: BaseValidator.requiredValidate,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: TextFieldWidget(
                                            controller: _jobController,
                                            label: 'Job Title',
                                            validator: BaseValidator.requiredValidate,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFieldWidget(
                                            controller: _emailController,
                                            label: 'Email',
                                            validator: BaseValidator.requiredValidate,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: TextFieldWidget(
                                            controller: _phoneController,
                                            label: 'Phone Number',
                                            validator: BaseValidator.requiredValidate,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    TextFieldWidget(
                                      controller: _locationController,
                                      label: 'Location',
                                      maxLines: 1,
                                      validator: BaseValidator.requiredValidate,
                                    ),
                                    const SizedBox(height: 20),
                                    TextFieldWidget(
                                      controller: _youtubeLinkController,
                                      label: 'Youtube Video',
                                      maxLines: 1,
                                      validator: BaseValidator.requiredValidate,
                                    ),
                                    const SizedBox(height: 20),
                                    TextFieldWidget(
                                      controller: _shortIntroduction,
                                      label: 'Short Introduce',
                                      maxLines: 2,
                                      validator: BaseValidator.requiredValidate,
                                    ),
                                    const SizedBox(height: 20),
                                    TextFieldWidget(
                                      controller: _detailController,
                                      label: 'Detail Introduce',
                                      maxLines: 3,
                                      validator: BaseValidator.requiredValidate,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
                            'LINK TO YOUR SOCIAL MEDIA',
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldWidget(
                                  controller: _facebookController,
                                  label: 'Facebook Url',
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: TextFieldWidget(
                                  controller: _youtubeController,
                                  label: 'Youtube Url',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextFieldWidget(
                                  controller: _instagramController,
                                  label: 'Instagram Url',
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: TextFieldWidget(
                                  controller: _tiktokController,
                                  label: 'Tiktok Url',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
                            'SKILLS',
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Numbers only',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                          ...skillChildren
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

  Widget buildImageWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Avatar',
          style: TextStyle(
            color: Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['png'],
            );
            if (result != null) {
              photoBytes = result.files.first.bytes;
              setState(() {});
            }
          },
          child: SizedBox(
            height: 120,
            width: 120,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(60)),
              child: photoBytes != null
                  ? Image.memory(
                      photoBytes!,
                      fit: BoxFit.cover,
                    )
                  : NetworkImageWidget(url: photoUrl),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> getData() async {
    EasyLoading.show(dismissOnTap: false);
    Map<String, dynamic> userInfo = (await FirebaseFirestore.instance.collection('user_info').get()).docs.first.get('about');

    _nameController.text = userInfo['name'];
    _emailController.text = userInfo['email'];
    _phoneController.text = userInfo['phone'];
    _jobController.text = userInfo['job'];
    _shortIntroduction.text = userInfo['introduce_short'];
    _detailController.text = userInfo['introduce_detail'];
    _facebookController.text = userInfo['facebook'];
    _instagramController.text = userInfo['instagram'];
    _tiktokController.text = userInfo['tiktok'];
    _youtubeController.text = userInfo['youtube'];
    _locationController.text = userInfo['location'] ?? '';
    _youtubeLinkController.text = userInfo['youtube_video'] ?? '';
    photoUrl = userInfo['avatar'];

    skillInfo = (await FirebaseFirestore.instance.collection('user_info').get()).docs.first.get('skills');
    skillNumber = skillInfo
        .map(
          (e) => TextEditingController(text: e['value']),
        )
        .toList();

    skillChildren = skillInfo
        .asMap()
        .entries
        .map(
          (e) => Padding(
            padding: const EdgeInsets.only(top: 20),
            child: TextFieldWidget(
              controller: skillNumber[e.key],
              label: e.value['title'] + ' Number',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        )
        .toList();
    setState(() {});
    EasyLoading.dismiss();
  }

  Future<void> updateData() async {
    EasyLoading.show(dismissOnTap: false);
    try {
      CollectionReference userInfo = FirebaseFirestore.instance.collection('user_info');
      if (photoBytes != null) {
        photoUrl = await Storage.uploadFile(photoBytes!, 'user_image') ?? photoUrl;
      }
      await userInfo.doc('KFcwyediaY33ojA7FdCt').update(
        {
          'about': {
            'avatar': photoUrl,
            'email': _emailController.text,
            'facebook': _facebookController.text,
            'instagram': _instagramController.text,
            'introduce_detail': _detailController.text,
            'introduce_short': _shortIntroduction.text,
            'job': _jobController.text,
            'phone': _phoneController.text,
            'name': _nameController.text,
            'tiktok': _tiktokController.text,
            'youtube': _youtubeController.text,
            'location': _locationController.text,
            'youtube_video': _youtubeLinkController.text,
          },
        },
      );

      await userInfo.doc('KFcwyediaY33ojA7FdCt').update({
        'skills': skillInfo.asMap().entries.map(
              (e) => {
                'value': skillNumber[e.key].text,
                'icon': e.value['icon'],
                'title': e.value['title'],
              },
            )
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

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:portfolio/common_widgets/network_image_widget.dart';
import 'package:portfolio/common_widgets/text_field_widget.dart';

class ServiceItemWidget extends StatefulWidget {
  final Map<String, dynamic> value;
  final TextEditingController controller;
  final Function(Uint8List) onChangeImage;
  const ServiceItemWidget({
    Key? key,
    required this.value,
    required this.controller,
    required this.onChangeImage,
  }) : super(key: key);

  @override
  State<ServiceItemWidget> createState() => _ServiceItemWidgetState();
}

class _ServiceItemWidgetState extends State<ServiceItemWidget> {
  Uint8List bytes = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['png'],
              );
              if (result != null) {
                bytes = result.files.first.bytes!;
                widget.onChangeImage.call(bytes);
                setState(() {});
              }
            },
            child: SizedBox(
              height: 60,
              width: 60,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(60)),
                child: bytes.isNotEmpty
                    ? Image.memory(
                        bytes,
                        fit: BoxFit.cover,
                      )
                    : NetworkImageWidget(url: widget.value['image']),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: TextFieldWidget(controller: widget.controller, label: widget.value['title'] + ' Detail'),
          ),
        ],
      ),
    );
  }
}

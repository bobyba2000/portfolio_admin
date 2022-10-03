import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class ServiceDetailPage extends StatefulWidget {
  final Function() onBack;
  final int id;
  final Function(String) onSave;
  final String value;
  final String title;
  const ServiceDetailPage({
    Key? key,
    required this.onBack,
    required this.id,
    required this.onSave,
    required this.value,
    required this.title,
  }) : super(key: key);

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  HtmlEditorController controller = HtmlEditorController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: widget.onBack,
        ),
        centerTitle: false,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          InkWell(
            onTap: () async {
              widget.onSave.call(await controller.getText());
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(8),
              child: Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: HtmlEditor(
          controller: controller, //required
          htmlEditorOptions: HtmlEditorOptions(
            hint: "Your text here...",
            initialText: widget.value,
          ),

          otherOptions: OtherOptions(
            height: 600,
          ),

          htmlToolbarOptions: const HtmlToolbarOptions(
            toolbarPosition: ToolbarPosition.aboveEditor, //by default
            toolbarType: ToolbarType.nativeScrollable, //by default
            initiallyExpanded: true,
          ),
        ),
      ),
    );
  }
}

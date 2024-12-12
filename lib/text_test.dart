import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:test_video/special_text/dollar_text.dart';
import 'package:test_video/special_text/emoji_text.dart';
import 'package:test_video/text_edit_extension.dart';

import 'my_special_text_span_builder.dart';

class TextTest extends StatefulWidget {
  const TextTest({super.key});

  @override
  State<TextTest> createState() => _TextTestState();
}

class _TextTestState extends State<TextTest>
    with SingleTickerProviderStateMixin {
  late TextEditingController _controller;

  final MySpecialTextSpanBuilder _mySpecialTextSpanBuilder =
      MySpecialTextSpanBuilder();
  final GlobalKey<ExtendedTextFieldState> _key =
      GlobalKey<ExtendedTextFieldState>();

  @override
  void initState() {
    _controller = TextEditingController();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('text'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                child: ExtendedTextField(
              key: _key,
              controller: _controller,
              specialTextSpanBuilder:
                  MySpecialTextSpanBuilder(showAtBackground: true),
            )),
            GestureDetector(
              child: Text('@--'),
              onTap: () {
                _controller.insertText("@liudongju");
              },
            )
          ],
        ),
      ),
    );
  }
}

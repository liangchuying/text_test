import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/material.dart';
import 'package:test_video/special_text/at_text.dart';
import 'package:test_video/test_special_text_span_builder.dart';
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

    _controller.addListener(() {
      _mySpecialTextSpanBuilder.selection = _controller.selection;
    });

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
        padding: const EdgeInsets.symmetric(horizontal: 15),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: ExtendedTextField(
                  maxLines: 5,
                  key: _key,
                  controller: _controller,
                  specialTextSpanBuilder: _mySpecialTextSpanBuilder,
                  // specialTextSpanBuilder: TestSpecialTextSpanBuilder(),
                )),
                GestureDetector(
                  child: const Text('@--'),
                  onTap: () {
                    int start = _controller.selection.isValid
                        ? _controller.selection.start
                        : 0;

                    AtText atText = AtText(
                        const TextStyle(), null,
                        text: 'liudongju\t',
                        start: start,
                        end: start);
                    atText.appendContent('liudongju\t');
                    try {
                      _mySpecialTextSpanBuilder.insertSpecialText(atText);
                      _controller.insertText("@liudongju\t");
                    }catch (e) {
                      e.toString();
                    }

                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:extended_text_field/extended_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/painting/text_style.dart';
import 'package:test_video/special_text/at_text.dart';

class MySpecialTextSpanBuilder extends SpecialTextSpanBuilder {
  MySpecialTextSpanBuilder({this.showAtBackground = false, controller});

  /// whether show background for @somebody
  final bool showAtBackground;

  TextEditingController? controller;

  String _lastText = "";

  TextSelection? selection;

  // 上一次的光标位置
  TextSelection? _lastSelection;

  final List _currentLineList = [];

  @override
  SpecialText? createSpecialText(String flag,
      {TextStyle? textStyle,
      SpecialTextGestureTapCallback? onTap,
      required int index}) {
    // TODO: implement createSpecialText
    throw UnimplementedError();
  }

  @override
  TextSpan build(String data,
      {TextStyle? textStyle, SpecialTextGestureTapCallback? onTap}) {
    final List<InlineSpan> inlineList = <InlineSpan>[];
    String textStack = '';

    // 如果没有特殊字符直接输出
    if (data.isEmpty) {
      _currentLineList.clear();
      return TextSpan(text: data, style: textStyle);
    }

    if (data.isNotEmpty && _currentLineList.isNotEmpty) {
      // 确定特殊文本是否有变动
      if (data.length != _lastText.length) {
        int differenceUnit = data.length - _lastText.length;
        if (selection!.start != _lastSelection!.start) {
          updateSpecialTextLocations(
              _lastSelection!, selection!, differenceUnit);
        }
      }

      for (int i = 0; i < data.length; i++) {
        final String char = data[i];
        textStack += char;
        if (isSpecialAtFlag(char)) {
          AtText? customSpan = isSpecialLineList(i);
          if (customSpan != null) {
            if (textStack.isNotEmpty) {
              inlineList.add(
                  TextSpan(text: textStack.substring(0, textStack.length - 1)));
              textStack = "";
            }
            inlineList.add(customSpan.finishText());
            // 跳过特殊文本累加
            i += customSpan.text.length;
          }
        } else {
          // 判断结尾没有特殊字符
          if (i == data.length - 1 && textStack.isNotEmpty) {
            inlineList.add(TextSpan(text: textStack));
          }
        }
      }
    } else {
      inlineList.add(TextSpan(text: data));
    }

    _lastText = data;

    if (selection != null) {
      _lastSelection = selection;
    }
    return TextSpan(children: inlineList, style: textStyle);
  }

  // 判断字符光标上最后一个字符是不是特殊字符
  @override
  bool isStart(String value, String startFlag) {
    return value.endsWith(startFlag);
  }

  /// 插入指定组件
  void insertSpecialText(AtText span) {
    // 第一次赋值的处理
    if (_lastSelection == null) {
      _currentLineList.add(span);
    } else {
      if (_currentLineList.isNotEmpty) {
        for (var i = 0; i < _currentLineList.length; i++) {
          var customSpan = _currentLineList[i];
          if (span.start! > customSpan.start) {
            _currentLineList.insert(i, span);
            break;
          }
        }
      } else {
        _currentLineList.add(span);
      }
    }
  }

  /// get InlineSpan
  List<InlineSpan> getCurrentInlineSpan() {
    List<InlineSpan> inlineList = <InlineSpan>[];

    for (int i = 0; i < _currentLineList.length; i++) {
      AtText inlineSpan = _currentLineList[i];
      inlineList.insert(0, inlineSpan.finishText());
    }

    return inlineList;
  }

  // 获取当前 AtText 数据
  List getCurrentAtSpecial() {
      return _currentLineList.whereType<AtText>().toList();
  }

  /// 根据删除的位置去删除特殊文本
  void deleteSpecialText(
      TextSelection? oldSelection, TextSelection? newSelection) {
    for (var i = 0; i < _currentLineList.length; i++) {
      var customSpan = _currentLineList[i];
      if (customSpan.start == newSelection?.start &&
          customSpan.end == oldSelection?.start) {
        _currentLineList.removeAt(i);
        // 做删除的回调, 自定义处理
        break;
      }
    }
  }

  // 更新特殊文本的位置
  void updateSpecialTextLocations(
      TextSelection oldSelection, TextSelection newSelection, int index) {
    if (_currentLineList.isNotEmpty) {
      // 整数 + ，负数 -
      int newUnit = newSelection.start - oldSelection.start;

      for (int i = 0; i < _currentLineList.length; i++) {
        var currentSpan = _currentLineList[i];
        // 新增文本操作
        if (newSelection.start > oldSelection.start) {
          // 谁在newSelection 前面输入的位置不改变反之
          if (currentSpan.start > oldSelection.start) {
            currentSpan.start += newUnit;
            currentSpan.end += newUnit;
          }
        } else {
          // 删除文本操作
          if (currentSpan.end > oldSelection.start &&
              currentSpan.start >= oldSelection.start) {
            currentSpan.start += newUnit;
            currentSpan.end += newUnit;
          }
          if (currentSpan.end <= oldSelection.start &&
              currentSpan.start == newSelection.start) {
            _currentLineList.remove(currentSpan);
            // 执行删除回调给自定义at 删除回调
          }
        }
      }
    }
  }

  /// 是不是特殊字符
  bool isSpecialAtFlag(String value) {
    return value.endsWith(AtText.flag);
  }

  // 是否是特殊字符
  AtText? isSpecialLineList(int index) {
    if (_currentLineList.isEmpty) return null;
    for (int i = 0; i < _currentLineList.length; i++) {
      var currentSpan = _currentLineList[i];
      if (currentSpan.start == index) {
        return currentSpan;
      }
    }

    return null;
  }
}

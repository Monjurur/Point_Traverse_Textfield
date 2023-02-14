

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestPage extends StatefulWidget {
  final String? label;
  var validator;
  final bool? readOnly;
  InputBorder? border;
  InputBorder? enabledBorder;
  InputBorder? focusedBorder;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextEditingController controller;
  final bool enterPress;
  final Color?  borderColor;

  TestPage(
      {Key? key,
      required this.controller,
      this.readOnly,
      this.validator,
      this.enabledBorder,
      this.focusedBorder,
      this.border,
      this.label,
      this.focusNode,
      this.nextFocus,
      this.enterPress = true,this.borderColor})
      : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  //final TextEditingController controller = TextEditingController();
  /*FocusNode focusNode = FocusNode();
  FocusNode textFocusNode = FocusNode();*/
  String value = '0.00';
  var data;

  @override
  void initState() {
    widget.controller.text = '0.00';
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }



  handleNumberInputKey(RawKeyEvent key) {
    try {
      if (key.runtimeType.toString() == 'RawKeyDownEvent') {
        RawKeyEventDataAndroid data = key.data as RawKeyEventDataAndroid;
     /*   if(defaultTargetPlatform == TargetPlatform.iOS){
          RawKeyEventDataIos data = key.data as RawKeyEventDataIos;
          return data;
        }else if(defaultTargetPlatform == TargetPlatform.windows){
          RawKeyEventDataWindows data = key.data as RawKeyEventDataWindows;
          return data;
        }else if(defaultTargetPlatform == TargetPlatform.android){
        RawKeyEventDataAndroid data = key.data as RawKeyEventDataAndroid;
        return data;
        }*/
        String _keyCode;
        _keyCode = data.keyCode.toString();
        value = widget.controller.text;
        if (_keyCode == '67') {
          value = value.substring(0, widget.controller.text.length - 1);
          value = value.replaceAll('.', '');
          if ((int.parse(value).toString()).length > 2) {
            value = value.substring(0, value.length - 2) +
                '.' +
                value.substring(value.length - 2);
          } else {
            if (int.parse(value) > 9) {
              value = '0.' + int.parse(value).toString();
            } else {
              value = '0.0' + int.parse(value).toString();
            }
          }
        }
        if (7 <= int.parse(_keyCode) && int.parse(_keyCode) <= 16) {
          value += key.logicalKey.keyLabel;
          value = value.replaceAll('.', '');
          value = value.substring(0, value.length - 2) +
              '.' +
              value.substring(value.length - 2);
          if (int.parse(value.split('.')[0]) > 0) {
            value = int.parse(value.split('.')[0]).toString() +
                '.' +
                value.split('.')[1];
          } else {
            value = '0.' + value.split('.')[1];
          }
        }
        setState(() {
          widget.controller.text = value;
          print(widget.controller.text);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MaterialApp(
        home: SafeArea(
          bottom: false,
          child: Scaffold(
            body: Column(
              children: [
                RawKeyboardListener(
                  focusNode: widget.focusNode ?? FocusNode(),
                  onKey: handleNumberInputKey,
                  child: TextFormField(
                    controller: widget.controller,
                    decoration:  InputDecoration(    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: widget.borderColor??Colors.blueAccent) )),
                    textInputAction: widget.enterPress == true ? TextInputAction.done : null,
                    onFieldSubmitted: (value) async {
                      if (widget.enterPress == true) {
                        FocusScope.of(context).unfocus();
                        FocusScope.of(context).requestFocus(widget.nextFocus);
                      }
                    },
                    onChanged: ((val) {
                      setState(() {
                        widget.controller.text = value;
                        widget.controller.selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: widget.controller.text.length));
                      });
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

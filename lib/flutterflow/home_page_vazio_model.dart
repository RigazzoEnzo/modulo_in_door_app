/*
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
*/


import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'home_page_vazio_widget.dart' show HomePageVazioWidget;
import 'package:flutter/material.dart';

class HomePageVazioModel extends FlutterFlowModel<HomePageVazioWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}

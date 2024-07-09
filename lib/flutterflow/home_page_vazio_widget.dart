/*
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
*/

import 'package:modulo_in_door_app/flutterflow/new_box_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:flutter/material.dart';

import 'home_page_vazio_model.dart';
export 'home_page_vazio_model.dart';

class HomePageVazioWidget extends StatefulWidget {
  const HomePageVazioWidget({super.key});

  @override
  State<HomePageVazioWidget> createState() => _HomePageVazioWidgetState();
}

class _HomePageVazioWidgetState extends State<HomePageVazioWidget> {
  late HomePageVazioModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageVazioModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print("Go to NewBox");
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewBoxWidget()));
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 8,
          child: Icon(
            Icons.add,
            color: FlutterFlowTheme.of(context).info,
            size: 24,
          ),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Nome do App',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22,
                  letterSpacing: 0,
                ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 4,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: AlignmentDirectional(0, -1),
            child: Container(
              width: 340,
              height: 600,
              decoration: BoxDecoration(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 3,
                          child: Container(
                            width: 286,
                            height: 136,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).accent1,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Nenhuma caixa adicionada ainda.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.boxOpen,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  size: 64,
                                ),
                              ].divide(SizedBox(height: 12)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

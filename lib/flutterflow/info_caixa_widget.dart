/*
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
*/

//import 'package:modulo_in_door_app/route/route.dart' as route;import 'dart:async';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'cultivo.dart' as mod;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

import 'info_caixa_model.dart';
export 'info_caixa_model.dart';

class InfoCaixaWidget extends StatefulWidget {
  const InfoCaixaWidget({super.key});

  @override
  State<InfoCaixaWidget> createState() => _InfoCaixaWidgetState();
}

class _InfoCaixaWidgetState extends State<InfoCaixaWidget> {
  late InfoCaixaModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String temperatura = "";
  String ip = mod.modulo.ip;
  bool click = true, click2 = true;


  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InfoCaixaModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  asyncFunc() async { // VERIFICAR SE REALMENTE PRECISA DISSO
    // Async func to handle Futures easier; or use Future.then
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("xxxx");
  }

  // Função para ativar a iluminação, envia um URL para o 
  // microcontrolador
  callAPI1() async {
    var client = http.Client();
    // print(ip);
    if (ip != '100.100.100.100') {
      try {
        var response = await client.get(
          Uri.parse('$ip' 'cm?cmnd=Power1%20TOGGLE'),
        );
        //await client.get(Uri.parse('192.168.18.82/cm?cmnd=Power1%20On'));
        var decodedResponse = jsonDecode(response.body);
        // ignore: avoid_print
        print(decodedResponse);
        if (decodedResponse.toString() == '{POWER1: ON}') {
          //
          click = true;
        } else {
          //
          click = false;
        }
      } finally {
        client.close();
      }
    } else {
      mensagem_ip();
    }
  }

  callAPI2() async {
    var client = http.Client();
    if (ip != '100.100.100.100') {
      try {
        var response = await client.get(
          Uri.parse('$ip' 'cm?cmnd=Power2%20TOGGLE'),
        );
        var decodedResponse = jsonDecode(response.body);
        // ignore: avoid_print
        print(decodedResponse);
        if (decodedResponse.toString() == '{POWER2: ON}') {
          //
          click2 = true;
        } else {
          //
          click2 = false;
        }
      } finally {
        client.close();
      }
    } else {
      mensagem_ip();
    }
  }
  
  callAPITemp() async {
    var client = http.Client();
    if (ip != '100.100.100.100') {
      try {
        var response = await client.get(
          Uri.parse('$ip' 'cm?cmnd=Status%208'),
        );
        var decodedResponse = jsonDecode(response.body);
        // ignore: avoid_print
        //print(decodedResponse);
        temperatura =
            decodedResponse['StatusSNS']['ANALOG']['Temperature1'].toString();
      } finally {
        client.close();
      }
    } else
      print(temperatura);
    //   mensagem_ip();
  }

  void mensagem_ip() {
    showDialog(
      context: context,
      builder: (alertContext) => AlertDialog(
        title: const Text("Atenção"),
        content: const Text(
            """Insira o IP correto do equipamento na opção do menu principal configurações"""),
        actions: [
          TextButton(
            child: const Text("Sair"),
            onPressed: () => Navigator.pop(alertContext),
          ),
        ],
      ),
    );
  }
    // Método para enviar o link HTTP via web
  void sendLink() async {
    var client = http.Client();
    if (ip != '100.100.100.100') {
      try {
        var response1 = await client.get(
          Uri.parse('$ip' 'cm?cmnd=Power1'),
        );
        var decodedResponse1 = jsonDecode(response1.body);
        // ignore: avoid_print
        // print(decodedResponse1);
        //print(decodedResponse['Status']['PowerOnState'].toString());

        if (decodedResponse1.toString() == '{POWER1: ON}') {
          //
          click = true;
        } else {
          //
          click = false;
        }
        var response2 = await client.get(
          Uri.parse('$ip' 'cm?cmnd=Power2'),
        );
        var decodedResponse2 = jsonDecode(response2.body);
        if (decodedResponse2.toString() == '{POWER2: ON}') {
          //
          click2 = true;
        } else {
          //
          click2 = false;
        }

        if (response2.statusCode == 200) {
          // Se a solicitação foi bem-sucedida, toque um toque de notificação
          //  FlutterRingtonePlayer.play(
          //    android: AndroidSounds.notification,
          //    ios: IosSounds.glass,
          //    looping: false,
          //  );
        } else {
          print('Erro ao enviar link: status $response2.statusCode');
        }
      } finally {
        client.close();
      }
    } else {
      //mensagem_ip();
    }
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    callAPITemp();
    // Agende a tarefa de enviar o link a cada minuto
    Timer.periodic(const Duration(minutes: 1), (timer) {
      sendLink();
      print(timer);
    });
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () async {
              print("Go back page");
              Navigator.pop(context);
              //context.pop();
            },
          ),
          title: Text(
            'Cultivo',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22,
                  letterSpacing: 0,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 4,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0, -1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: const BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Material(
                          color: Colors.transparent,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Container(
                            width: 340,
                            height: 124,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(5),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    mod.modulo.cultivo.nome, // NOME DO CULTIVO
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      decoration: const BoxDecoration(),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Material(
                                              color: Colors.transparent,
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                              child: Container(
                                                width: 140,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                  ),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                5, 0, 5, 0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Align(
                                                          alignment:
                                                              const AlignmentDirectional(
                                                                  0, 0),
                                                          child: Icon(
                                                            Icons.thermostat,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText,
                                                            size: 35,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 100,
                                                          child:
                                                              VerticalDivider(
                                                            thickness: 1,
                                                            color: Color(
                                                                0xCC5A5858),
                                                          ),
                                                        ),
                                                        Text(
                                                          '$temperatura ºC', // AONDE FICARÁ A TEMPERATURA
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Readex Pro',
                                                                fontSize: 24,
                                                                letterSpacing:
                                                                    0,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Material(
                                                color: Colors.transparent,
                                                elevation: 2,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                                child: Container(
                                                  width: 120,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryBackground,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3),
                                                    border: Border.all(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .secondaryText,
                                                    ),
                                                  ),
                                                  child: Align(
                                                    alignment:
                                                        const AlignmentDirectional(
                                                            0, 0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  5, 0, 5, 0),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Align(
                                                            alignment:
                                                                const AlignmentDirectional(
                                                                    0, 0),
                                                            child: Icon(
                                                              Icons.water_drop,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText,
                                                              size: 35,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 100,
                                                            child:
                                                                VerticalDivider(
                                                              thickness: 1,
                                                              color: Color(
                                                                  0xCC5A5858),
                                                            ),
                                                          ),
                                                          Text(
                                                            'Medio', // AONDE FICA ALTURA DA ÁGUA
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Readex Pro',
                                                                  fontSize: 24,
                                                                  letterSpacing:
                                                                      0,
                                                                ),
                                                          ),
                                                        ]
                                                            .divide(const SizedBox(
                                                                width: 3))
                                                            .around(const SizedBox(
                                                                width: 3)),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ].divide(const SizedBox(width: 8)),
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
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Container(
                          width: 250,
                          height: 250,
                          child: Stack(
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: Container(
                                  width: 230,
                                  height: 230,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: Image.asset( // IMAGEM DO CULTIVO
                                        mod.modulo.cultivo.imagem,
                                      ).image,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(0, 0),
                                child: CircularPercentIndicator(
                                  percent: 0.8,
                                  radius: 125,
                                  lineWidth: 12,
                                  animation: true,
                                  animateFromLastPercent: true,
                                  progressColor:
                                      Theme.of(context).primaryColor,
                                  backgroundColor:
                                      FlutterFlowTheme.of(context).accent4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Material(
                            color: Colors.transparent,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              width: 101,
                              height: 70,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: FlutterFlowIconButton(
                                borderColor:
                                    Theme.of(context).primaryColor,
                                borderRadius: 20,
                                borderWidth: 1,
                                buttonSize: 40,
                                fillColor: Theme.of(context).primaryColorLight,
                                icon: FaIcon(
                                  FontAwesomeIcons.fan,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 40,
                                ),
                                onPressed: () {
                                  print('IconFan pressed ...');
                                  callAPI2();
                                  setState(() {
                                    //print(click);
                                  });
                                },
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              width: 101,
                              height: 70,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: FlutterFlowIconButton(
                                borderColor:
                                    Theme.of(context).primaryColor,
                                borderRadius: 20,
                                borderWidth: 1,
                                buttonSize: 40,
                                fillColor: Theme.of(context).primaryColorLight,
                                icon: Icon(
                                  Icons.lightbulb_sharp,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 40,
                                ),
                                onPressed: () {
                                  print('IconLight pressed ...');
                                  callAPI1();
                                  setState(() {
                                    //print(click);
                                  });

                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

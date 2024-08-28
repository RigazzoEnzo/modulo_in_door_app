import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> list = <String>[
  '-Selecionar-',
  'Alface',
  'Tomate',
  'Rúcula',
  'Manjericão'
]; //lista drobox

class home_page extends StatefulWidget {
  const home_page({super.key});

  @override
  State<home_page> createState() => _home_pageState();
}

// ignore: camel_case_types
class _home_pageState extends State<home_page> {
  bool click = true, click2 = true;
  String temperatura = "";
  //String ip = 'http://192.168.207.22/';
  String ip = '100.100.100.100';
  String cultura = "Sem cultivo no Momento";
  int cor1 = 0, cor2 = 0, cor3 = 0, cor4 = 0;

  asyncFunc() async {
    // Async func to handle Futures easier; or use Future.then
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("xxxx");
  }

// Set
//prefs.setString('apiTokenIP', tokenIP);

// Get
//String token = prefs.getString('apiTokenIP');

// Remove
//prefs.remove('apiTokenIP');

// PopupMenuButton<String>(
//   onSelected: (value) {
//     print(value);
//   },
//   itemBuilder: (BuildContext context) {
//     return [
//       PopupMenuItem<String>(
//         value: 'item1',
//         child: Text('Item 1'),
//       ),
//       PopupMenuItem<String>(
//         value: 'item2',
//         child: Text('Item 2'),
//       ),
//     ];
//   },
// ),

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
            """Insira o IP do equipamento na opção do menu principal configurações"""),
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

  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Osiris PlantBox'),
      ),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.cyan,
            ),
            child: Text('Configure'),
          ),
          ListTile(
              leading: const Icon(Icons.account_tree_outlined),
              title: const Text("IP"),
              subtitle: const Text("Defina o ip do OSIBOX"),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // debugPrint('toquei no drawer');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Entrar com valor do IP"),
                      content: TextField(
                        onChanged: (String value) {
                          ip = 'http://$value/';
                        },
                      ),
                      actions: <Widget>[
                        ElevatedButton.icon(
                          onPressed: () {
                            callAPITemp(); //atualiza a temperatura
                            Navigator.of(context).pop();
                            Navigator.pop(context);
                            setState(() {
                              //print(click);
                            });
                          },
                          icon: const Icon(Icons.check_box),
                          label: const Text("Salvar"),
                        ),
                        // FlatButton(
                        //   child: Text("OK"),
                        //   onPressed: () {
                        //     Navigator.of(context).pop();
                        //   },
                        // ),
                      ],
                    );
                  },
                );
              }),
          ListTile(
              leading: const Icon(Icons.ac_unit_rounded),
              title: const Text("Escolha o Cultivo"),
              subtitle: const Text(""),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // debugPrint('toquei no drawer');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Escolha o Cultivo escolhido"),
                      // content: TextField(
                      //   onChanged: (String value) {
                      //     ip = 'http://$value/';
                      //   },
                      // ),
                      actions: <Widget>[
                        //Container(
                        Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                                child: DropdownButtonFormField<String>(
                                  value: dropdownValue,
                                  icon: const Icon(Icons.arrow_downward),
                                  elevation: 06,
                                  style:
                                      const TextStyle(color: Colors.deepPurple),
                                  // underline: Container(
                                  //   height: 4,
                                  //   color: Colors.deepPurpleAccent,
                                  // ),
                                  onChanged: (String? value) {
                                    // This is called when the user selects an item.
                                    setState(() {
                                      dropdownValue = value!;
                                      cultura = value;
                                      if (cultura != '-Selecionar-')
                                        cor1 = 100;
                                      else {
                                        cor1 = 0;
                                        cor2 = 0;
                                        cor3 = 0;
                                        cor4 = 0;
                                      }
                                    });
                                  },
                                  items: list.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                              // ],
                              //),
                              //),

                              ElevatedButton.icon(
                                onPressed: () {
                                  callAPITemp(); //atualiza a temperatura
                                  Navigator.of(context).pop();
                                  Navigator.pop(context);
                                  //print(cultura);
                                  setState(() {
                                    //print(click);
                                  });
                                },
                                icon: const Icon(Icons.check_box),
                                label: const Text("Salvar"),
                              ),
                              // FlatButton(
                              //   child: Text("OK"),
                              //   onPressed: () {
                              //     Navigator.of(context).pop();
                              //   },
                              // ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              })
        ],
      )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 100,
              child: Card(
                elevation: 20,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(70, 20, 0, 0),
                      child: ListTile(
                        title: Text("$cultura",
                            style: const TextStyle(fontWeight: FontWeight.w500)),
                        //subtitle: Text('$temperatura C'),
                        leading: const Icon(
                          Icons.ac_unit,
                          size: 40,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 420,
              child: Card(
                elevation: 20,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(60, 10, 10, 60),
                      child: ListTile(
                        title: const Text("Colher",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        //subtitle: Text('$temperatura C'),
                        leading: Icon(
                          Icons.compost,
                          size: 140,
                          color: Colors.amber[cor4],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(70, 10, 10, 45),
                      child: ListTile(
                        title: const Text("   Adulta",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        //subtitle: Text('$temperatura C'),
                        leading: Icon(
                          Icons.compost,
                          size: 120,
                          color: Colors.amber[cor3],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(85, 10, 10, 20),
                      child: ListTile(
                        title: const Text("      Jovem",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        //subtitle: Text('$temperatura C'),
                        leading: Icon(
                          Icons.compost,
                          size: 90,
                          color: Colors.amber[cor2],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(100, 10, 10, 0),
                      child: ListTile(
                        title: const Text("        Semente",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        //subtitle: Text('$temperatura C'),
                        leading: Icon(
                          Icons.compost,
                          size: 60,
                          color: Colors.amber[cor1],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: Card(
                elevation: 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton.icon(
                      onPressed: () {
                        callAPI1();
                        setState(() {
                          //print(click);
                        });
                      },
                      //OnPressed Logic
                      icon: Icon((click == false)
                          ? Icons.lightbulb
                          : Icons.lightbulb_outlined),
                      label: const Text("Iluminação"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        callAPI2();
                        setState(() {
                          //print(click);
                        });
                      },
                      icon: Icon((click2 == false)
                          ? Icons.wind_power_rounded
                          : Icons.wind_power_outlined),
                      label: const Text("Aerador"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              child: Card(
                elevation: 20,
                child: Column(
                  children: [
                    // ListTile(
                    //   title: const Text('Sensor de Luz',
                    //       style: TextStyle(fontWeight: FontWeight.w500)),
                    //   //subtitle: Text('$luz'),
                    //   leading: Icon(
                    //     Icons.lightbulb_outline,
                    //     color: Colors.blue[500],
                    //   ),
                    // ),
                    // const Divider(),
                    ListTile(
                      title: Text("Sensor de Temperatura: $temperatura C",
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      //subtitle: Text('$temperatura C'),
                      leading: Icon(
                        Icons.thermostat,
                        color: Colors.blue[500],
                      ),
                      onTap: () {
                        print(temperatura);
                        callAPITemp();
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
// MVC
// /lib
//     /models
//         user.dart
//         product.dart
//     /views
//         /widgets
//             home.dart
//             product_list.dart
//         /styles
//             main.dart
//         /layouts
//             main.dart
//     /controllers
//         home.dart
//         product.dart
//     /services
//         api.dart
//         authentication.dart
//     /shared
//         config.dart
//         strings.dart
//         images
//             logo.png
//             background.png

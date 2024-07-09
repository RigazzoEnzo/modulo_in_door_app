class Cultivo {
  final String nome;
  final String imagem;
  final String horasLuz;
  
  Cultivo(this.nome, this.imagem, this.horasLuz);

}

class Modulo {
  late String ip;
  late DateTime inicioCultivo;
  late Cultivo cultivo;

  Modulo();

  void setModulo(String ip, Cultivo cultivo) {
    this.ip = ip;
    this.cultivo = cultivo;
    inicioCultivo = DateTime.now();
    print("Criei um modulo com  o ip: ${this.ip}. \n");
  }

  void uptIp (String ip) {
    this.ip = ip;
  }

}

Cultivo nenhum = Cultivo("", "", ""); 
Cultivo tomateCereja = Cultivo("Tomate Cereja", "https://revistacampoenegocios.com.br/wp-content/uploads/2020/05/shutterstock_120016855.jpg", "05:00 - 14:00");


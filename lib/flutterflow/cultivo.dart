class Cultivo {
  final String nome;
  final String imagem;
  final int horasLuz;
  
  Cultivo(this.nome, this.imagem, this.horasLuz);

}

class Modulo {
  late String ip;
  late DateTime inicioCultivo;
  late Cultivo cultivo;
  late String inicioCiclo;
  late String duracao;

  Cultivo nenhum = Cultivo("Sem Cultivo", "", 0); 
  Cultivo tomateCereja = Cultivo("Tomate Cereja", "images/tomateCereja.jpg", 5);

  Modulo() {
    ip = "100.100.100.100";
    inicioCiclo = "00:00";
    cultivo = nenhum;
  }

  void setModulo(String inicioCiclo, Cultivo cultivo, String duracao) {
    this.inicioCiclo = inicioCiclo;
    this.cultivo = cultivo;
    this.duracao = duracao;
    inicioCultivo = DateTime.now();
    print("Inicio setado para: ${this.inicioCiclo}. \n");
  }

  void uptIp (String ip) {
    this.ip = ip;
  }


  Cultivo retornaCultivo (String cult) {
    switch (cult) {
      case "Tomate Cereja":
        return tomateCereja;
      default:
        return nenhum;
    }
  }   
}


// Cria uma nova instância de Modulo
Modulo modulo = Modulo();

// Configura o módulo usando a instância criada
//modulo.setModulo(textController!.text, mod.tomateCereja);


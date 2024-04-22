import 'package:flutter/material.dart';

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Afazeres'),
          leading: Container(
            margin: const EdgeInsets.all(10.0),
            width: 160, // Definindo a largura do contêiner
            height: 80, // Definindo a altura do contêiner
            child: Image.network(
                'https://estude-unicv.com/img/logo-share.jpg'), // Usando Image.network para carregar uma imagem da internet
          ),
        ),
        backgroundColor: Color.fromARGB(
            255, 208, 208, 186), // Definindo a cor de fundo como verde
        body: const _ListaAfazeres(),
      ),
    );
  }
}

class _ListaAfazeres extends StatefulWidget {
  const _ListaAfazeres({Key? key}) : super(key: key);

  @override
  State<_ListaAfazeres> createState() => _ListaAfazeresState();
}

class _ListaAfazeresState extends State<_ListaAfazeres> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController controlador = TextEditingController();
  final TextEditingController controladorEdicao = TextEditingController();
  bool editando = false;
  int indiceEditando = -1;

  void adicionarTarefa() {
    if (controlador.text.isEmpty) {
      return;
    }
    setState(() {
      if (editando) {
        _tarefas[indiceEditando].descricao = controladorEdicao.text;
        _tarefas[indiceEditando].status = false; // Atualizando o status
        controladorEdicao.clear();
        indiceEditando = -1;
        editando = false;
      } else {
        _tarefas.add(Tarefa(descricao: controlador.text, status: false));
        controlador.clear();
      }
    });
  }

  void editarTarefa(int index) {
    setState(() {
      controladorEdicao.text = _tarefas[index].descricao;
      editando = true;
      indiceEditando = index;
    });
  }

  void atualizarTarefa() {
    if (controladorEdicao.text.isEmpty) {
      return;
    }
    setState(() {
      _tarefas[indiceEditando].descricao = controladorEdicao.text;
      controladorEdicao.clear();
      editando = false;
    });
  }

  void excluirTarefa(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Tarefa'),
          content: const Text('Deseja mesmo excluir?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _tarefas.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _tarefas.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(_tarefas[index].descricao),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              editarTarefa(index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              excluirTarefa(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: editando ? controladorEdicao : controlador,
                  decoration: const InputDecoration(
                    hintText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 200,
                height: 60,
                child: ElevatedButton(
                  onPressed: editando ? atualizarTarefa : adicionarTarefa,
                  child: Text(editando ? 'Atualizar' : 'Adicionar Tarefa'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Tarefa {
  String descricao;
  bool status;

  Tarefa({required this.descricao, required this.status});
}

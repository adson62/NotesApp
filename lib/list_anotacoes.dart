import 'package:app_anotacoes/app_controller.dart';
import 'package:app_anotacoes/models/anotacao.dart';
import 'package:flutter/material.dart';

import 'principal.dart';

class AnotacaoList extends StatefulWidget {
  const AnotacaoList({Key? key}) : super(key: key);

  @override
  _AnotacaoListState createState() => _AnotacaoListState();
}

class _AnotacaoListState extends State<AnotacaoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const LateralPage(),
      appBar: AppBar(title: const Text('Ver Anotações'), actions: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.search,
            semanticLabel: 'Pesquisar',
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/search_anotacao');
          },
        ),
      ]),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: AnimatedBuilder(
          animation: CrudNotes.instance,
          builder: (context, child) => Padding(
            padding: const EdgeInsets.all(12.0),
            child: CrudNotes.instance.created
                ? GetNotes()
                : const ZeroNotesSaved(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.popAndPushNamed(context, '/tipo_anotacao'),
        tooltip: 'Adicionar Anotação',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class GetNotes extends StatefulWidget {
  GetNotes({Key? key}) : super(key: key);

  @override
  _GetNotesState createState() => _GetNotesState();
}

class _GetNotesState extends State<GetNotes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: CrudNotes.instance.getNote(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          return AnimatedBuilder(
            animation: CrudNotes.instance,
            builder: (context, child) => ListView(
                children: List.generate(
              snapshot.data!.length,
              (i) => ListTile(
                title: Text('${snapshot.data![i]['titulo']}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                    )),
                subtitle: Text(
                  '${snapshot.data![i]['texto']}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    // decoration: snapshot.data![i]['done']
                    //     ? TextDecoration.lineThrough
                    //     : TextDecoration.none
                  ),
                ),
                trailing: IconButton(
                    iconSize: 30,
                    icon: snapshot.data![i]['done'] == 0
                        ? Icon(
                            Icons.check_box_outline_blank,
                            color: Colors.teal,
                            semanticLabel: 'Marcar como Concluído',
                          )
                        : Icon(
                            Icons.check_box,
                            color: Colors.teal,
                            semanticLabel: 'Concluído',
                          ),
                    onPressed: () {
                      snapshot.data![i]['done'] == 0
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.teal,
                                  content: Text(
                                    'Concluído! "${snapshot.data![i]['titulo']}"',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            )
                          : ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                  content: Text(
                                    'Não concluído! "${snapshot.data![i]['titulo']}"',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            );
                      AppController.instance.checkBox(snapshot.data![i]);
                    }),
                onTap: () => Navigator.of(context).popAndPushNamed(
                    '/detail_anotacao',
                    arguments: snapshot.data![i]),
              ),
            )),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class ZeroNotesSaved extends StatelessWidget {
  const ZeroNotesSaved({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
      Text(
        'Não há anotações, adicione uma clicando em "+"',
        style: TextStyle(fontSize: 20),
      ),
    ]);
  }
}

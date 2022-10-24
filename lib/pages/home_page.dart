import '../widget/change_button.dart';
import 'package:flutter/material.dart';
import 'package:notas_diarias/models/annotation.dart';
import '../helpers/annotation_helper.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];

  _exibirTelaCadastro({Anotacao? anotacao}) {
    String textoSalvarAtualizar = "";
    String textoTituloSalvarAtualizar = "";
    if (anotacao == null) {
      //salvando
      _tituloController.text = "";
      _descricaoController.text = "";
      textoSalvarAtualizar = "Salvar";
      textoTituloSalvarAtualizar = "Adicionar anotação";
    } else {
      //atualizar
      _tituloController.text = anotacao.titulo!;
      _descricaoController.text = anotacao.descricao!;
      textoSalvarAtualizar = "Atualizar";
      textoTituloSalvarAtualizar = "Atualizar anotação";
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Adicionar anotação",
              style: TextStyle(color: Theme.of(context).iconTheme.color),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: _tituloController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: "Título",
                      labelStyle:
                          TextStyle(color: Theme.of(context).iconTheme.color),
                      hintText: "Digite título...",
                      hintStyle:
                          TextStyle(color: Theme.of(context).iconTheme.color),
                    ),
                  ),
                  TextField(
                    controller: _descricaoController,
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: "Descrição",
                        hintText: "Digite descrição..."),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color?>(
                        Theme.of(context).iconTheme.color)),
              ),
              TextButton(
                onPressed: () {
                  _salvarAtualizarAnotacao();
                  Navigator.pop(context);
                },
                child: Text(
                  "$textoSalvarAtualizar",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color?>(
                        Theme.of(context).iconTheme.color)),
              ),
            ],
          );
        });
  }

  _recuperarAnotacoes() async {
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();

    List<Anotacao> listaTemporaria = [];
    for (var item in anotacoesRecuperadas) {
      Anotacao anotacao = Anotacao.fromMap(item);
      listaTemporaria.add(anotacao);
    }

    setState(() {
      _anotacoes = listaTemporaria;
    });
    listaTemporaria = [];
  }

  _salvarAtualizarAnotacao({Anotacao? anotacaoSelecionada}) async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    if (anotacaoSelecionada == null) {
      //salvar
      Anotacao anotacao =
          Anotacao(titulo, descricao, DateTime.now().toString());
      int? resultado = await _db.salvarAnotacao(anotacao);
    } else {
      //atualizar
      anotacaoSelecionada.titulo = titulo;
      anotacaoSelecionada.descricao = descricao;
      anotacaoSelecionada.data = DateTime.now().toString();
      int resultado = await _db.atualizarAnotacao(anotacaoSelecionada);
    }

    _tituloController.clear();
    _descricaoController.clear();

    _recuperarAnotacoes();
  }

  _formatarData(String data) {
    initializeDateFormatting("pt_BR");

    //Year -> y month-> M Day -> d
    // Hour -> H minute -> m second -> s
    //var formatador = DateFormat("d/MMMM/y H:m:s");
    var formatador = DateFormat.yMd("pt_BR");

    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);

    return dataFormatada;
  }

  _removerAnotacao(int id) async {
    await _db.removerAnotacao(id);

    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Theme.of(context).iconTheme.color,
        actions: [
          ChangeThemeButtonWidget(),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
          foregroundColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).iconTheme.color,
          child: Icon(Icons.add_outlined),
          onPressed: () {
            return _exibirTelaCadastro();
          }),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _anotacoes.length,
                  itemBuilder: (context, index) {
                    final anotacao = _anotacoes[index];

                    return Card(
                      child: ListTile(
                        title: Text(anotacao.titulo ?? ""),
                        subtitle: Text(
                            "${_formatarData(anotacao.data ?? "")} - ${anotacao.descricao}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _exibirTelaCadastro(anotacao: anotacao);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _removerAnotacao(anotacao.id ?? 0);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}

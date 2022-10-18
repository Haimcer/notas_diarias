import 'package:flutter/material.dart';
import 'package:notas_diarias/models/annotation.dart';
import '../helpers/annotation_helper.dart';

class exibirTela extends StatelessWidget {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();

  _salvarAnotacao() async {
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    int? resultado = await _db.salvarAnotacao(anotacao);
  }

  @override
  Widget build(BuildContext context) {
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
                labelStyle: TextStyle(color: Theme.of(context).iconTheme.color),
                hintText: "Digite título...",
                hintStyle: TextStyle(color: Theme.of(context).iconTheme.color),
              ),
            ),
            TextField(
              controller: _descricaoController,
              autofocus: true,
              decoration: InputDecoration(
                  labelText: "Descrição", hintText: "Digite descrição..."),
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
            Navigator.pop(context);
          },
          child: Text(
            "Salvar",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color?>(
                  Theme.of(context).iconTheme.color)),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:notas_diarias/models/annotation.dart';

class AnotacaoHelper {
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  late Database _db;
  static final String nomeTabela = "anotacao";

  factory AnotacaoHelper() {
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal() {}

  get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql =
        "CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME )";
    await db.execute(sql);
  }

  inicializarDB() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados =
        join(caminhoBancoDados, "banco_minhas_anotacoes.db");

    var db =
        await openDatabase(localBancoDados, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int?> salvarAnotacao(Anotacao anotacao) async {
    var bancoDados = await db;

    int resultado = await bancoDados.insert(nomeTabela, anotacao.toMap());
    return resultado;
  }
}

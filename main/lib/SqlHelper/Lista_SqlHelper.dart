import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class ListaSQLHelper {
  static Future<void> criarTabelas(sql.Database db) async {
    await db.execute(""" 
      CREATE TABLE listas( 
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        nome TEXT, 
        cor TEXT
      ) 
    """);

    await db.execute(""" 
      CREATE TABLE itens(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        listaId INTEGER,
        nome TEXT,
        marcado INTEGER,
        quantidade INTEGER,
        FOREIGN KEY (listaId) REFERENCES listas (id) ON DELETE CASCADE
      ) 
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'listas.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await criarTabelas(database);
      },
    );
  }

  static Future<int> createLista(String nome, int cor) async {
    final db = await ListaSQLHelper.db();
    final dados = {'nome': nome, 'cor': cor};
    final id = await db.insert('listas', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<int> createItem(int listaId, String nome, bool marcado, int quantidade) async {
    final db = await ListaSQLHelper.db();
    final dados = {'listaId': listaId, 'nome': nome, 'marcado': marcado ? 1 : 0, 'quantidade': quantidade,};
    final id = await db.insert('itens', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getListas() async {
    final db = await ListaSQLHelper.db();
    return db.query('listas', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getUmaLista(int id) async {
    final db = await ListaSQLHelper.db();
    return db.query('listas', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getItens(int listaId) async {
    final db = await ListaSQLHelper.db();
    return db.query('itens', where: "listaId = ?", whereArgs: [listaId]);
  }

  static Future<int> updateItem(int id,int quantidade, String nome, bool marcado) async {
    final db = await ListaSQLHelper.db();
    final dados = {
      'nome' : nome,
      'marcado' : marcado,
      'quantidade' : quantidade
    };
    final result = await db.update('itens', dados, where: "id = ?" , whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await ListaSQLHelper.db();
    try {
      await db.delete('itens', where: "id= ?", whereArgs: [id]);
    } catch(err){
      debugPrint("Erro ao apagar o item: $err");
    }
  }

  static Future<void> deleteLista(int id) async {
    final db = await ListaSQLHelper.db();
    try{
      db.delete('listas', where: 'id = ?', whereArgs: [id]);
    } catch(err){
      debugPrint("Erro ao apagar a lista: $err");
    }
  }
}

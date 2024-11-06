import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;

class UsuarioSQLHelper {
  static Future<void> criarTabelas(sql.Database db) async {
    await db.execute("""
      CREATE TABLE usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            email TEXT UNIQUE,
            senha TEXT,
            foto TEXT
          )
    """);
      //TODO: categorias preferidas
    // // Criação da tabela de categorias
    // await db.execute("""
    //   CREATE TABLE categorias (
    //         id INTEGER PRIMARY KEY AUTOINCREMENT,
    //         nome TEXT
    //       )
    // """);
    //
    // // Criação da tabela de preferências (relação muitos-para-muitos entre usuários e categorias)
    // await db.execute("""
    //       CREATE TABLE preferencias_usuarios (
    //         usuario_id INTEGER,
    //         categoria_id INTEGER,
    //         FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE,
    //         FOREIGN KEY (categoria_id) REFERENCES categorias (id) ON DELETE CASCADE,
    //         PRIMARY KEY (usuario_id, categoria_id)
    //       )
    //     """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'usuarios.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await criarTabelas(database);
      },
    );
  }

  static Future<int> createUsuario(String nome, String email, String senha, String foto) async {
    final db = await UsuarioSQLHelper.db();
    final dados = {'nome': nome, 'email': email,'senha': senha, 'foto': foto};
    final id = await db.insert('usuarios', dados,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }
}

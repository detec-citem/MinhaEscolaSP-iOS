//
//  UsuarioDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 13/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class UsuarioDao {
    //MARK: Constants
    struct CamposServidor {
        static let codigoResponsavel = "CodigoResponsavel"
        static let codigoUsuario = "IdUsuario"
        static let digitoRa = "DigitoRA"
        static let escolaCentralizada = "EscolaCentralizada"
        static let email = "Email"
        static let nome = "Nome"
        static let perfis = "Perfis"
        static let ra = "NumeroRA"
        static let telefoneResponsavel = "TelefoneResponsavel"
        static let token = "Token"
        static let ufRa = "UfRA"
    }
    
    enum Perfil: Int16 {
        case aluno = 6
        case responsavel = 7
    }
    
    //MARK: Methods
    static func usuarioLogado() -> Usuario? {
        return CoreDataManager.sharedInstance.getData(tabela: Tabelas.usuario, unique: true)?.first as? Usuario
    }
    
    static func salvarUsuario(json: [String:Any], perfil: Perfil, user: String, senha: String) -> Usuario {
        if let codigoUsuario = json[CamposServidor.codigoUsuario] as? UInt32 {
            if let usuarioLogado = CoreDataManager.sharedInstance.getData(tabela: Tabelas.usuario, predicate: NSPredicate(format: "codigoUsuario == %d", codigoUsuario), unique: true)?.first as? Usuario {
                if let token = json[CamposServidor.token] as? String {
                    usuarioLogado.perfil = perfil.rawValue
                    usuarioLogado.token = token
                    if perfil == .aluno {
                        usuarioLogado.estudante = true
                    }
                }
                return usuarioLogado
            }
            let usuario: Usuario = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.usuario)
            usuario.codigoUsuario = codigoUsuario
            usuario.usuario = user
            usuario.senha = senha
            usuario.perfil = perfil.rawValue
            if perfil == .aluno {
                usuario.estudante = true
            }
            if let digitoRa = json[CamposServidor.digitoRa] as? String {
                usuario.digitoRa = digitoRa
            }
            if let escolaCentralizada = json[CamposServidor.escolaCentralizada] as? Bool {
                usuario.escolaCentralizada = escolaCentralizada
            }
            if let nome = json[CamposServidor.nome] as? String {
                usuario.nome = nome
            }
            if let numeroRa = json[CamposServidor.ra] as? String {
                usuario.numeroRa = numeroRa
            }
            if let token = json[CamposServidor.token] as? String {
                usuario.token = token
            }
            if let ufRa = json[CamposServidor.ufRa] as? String {
                usuario.ufRa = ufRa
            }
            return usuario
        }
        return Usuario()
    }
}

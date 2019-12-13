//
//  EscolaDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 15/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class EscolaDao {
    //MARK: Constants
    fileprivate struct CamposServidor {
        static let codigoEscola = "CodigoEscola"
        static let emailEscola = "EmailEscola"
        static let enderecoUnidade = "EnderecoUnidade"
        static let nomeDiretor = "NomeDiretor"
        static let nomeEscola = "NomeEscola"
    }
    
    //MARK: Methods
    static func salvarEscola(json: [String:Any], aluno: Aluno) -> Escola {
        if let codigoEscola = json[CamposServidor.codigoEscola] as? UInt32, let nomeEscola = json[CamposServidor.nomeEscola] as? String {
            if let escola = CoreDataManager.sharedInstance.getData(tabela: Tabelas.escola, predicate: NSPredicate(format: "codigo == %d AND aluno.codigoAluno = %d", codigoEscola, aluno.codigoAluno), unique: true)?.first as? Escola {
                escola.nome = nomeEscola
                escola.aluno = aluno
                if let diretor = json[CamposServidor.nomeDiretor] as? String {
                    escola.diretor = diretor
                }
                if let emailEscola = json[CamposServidor.emailEscola] as? String {
                    escola.email = emailEscola
                }
                if let enderecoUnidade = json[CamposServidor.enderecoUnidade] as? String {escola.enderecoUnidade = enderecoUnidade.replacingOccurrences(of: "(RUA )+", with: "RUA ", options: .regularExpression)
                }
                return escola
            }
            let escola: Escola = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.escola)
            escola.codigo = codigoEscola
            escola.nome = nomeEscola
            escola.aluno = aluno
            if let diretor = json[CamposServidor.nomeDiretor] as? String {
                escola.diretor = diretor
            }
            if let emailEscola = json[CamposServidor.emailEscola] as? String {
                escola.email = emailEscola
            }
            if let enderecoUnidade = json[CamposServidor.enderecoUnidade] as? String {escola.enderecoUnidade = enderecoUnidade.replacingOccurrences(of: "(RUA )+", with: "RUA ", options: .regularExpression)
            }
            return escola
        }
        return Escola()
    }
}

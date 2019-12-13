//
//  ContatoDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 15/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class ContatoDao {
    //MARK: Constants
    fileprivate struct CamposServidor {
        static let codigoDdd = "CodigoDDD"
        static let codigoFoneTelefone = "CodigoFoneTelefone"
        static let codigoResponsavel = "CodigoResponsavel"
        static let codigoTipoTelefone = "CodigoTipoTelefone"
        static let complemento = "Complemento"
        static let telefoneAluno = "TelefoneAluno"
        static let telefoneResponsavel = "TelefoneResponsavel"
        static let validacaoSms = "ValidacaoSMS"
    }
    
    struct Contants {
        static let operacaoAlterar: UInt16 = 2
        static let operacaoDeletar: UInt16 = 3
    }
    
    //MARK: Methods
    static func salvarContato(codigoDdd: UInt16, complemento: String?, telefone: String, tipoTelefone: UInt16, responsavel: Bool, aluno: Aluno? = nil, usuario: Usuario? = nil) -> Contato {
        let contato: Contato = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.contato)
        contato.codigoDdd = codigoDdd
        contato.complemento = complemento
        contato.telefone = telefone
        contato.codigoTipoTelefone = tipoTelefone
        if responsavel, let aluno = aluno {
            contato.aluno = aluno
        }
        else if let usuario = usuario {
            contato.usuario = usuario
        }
        return contato
    }
    
    static func salvarContato(json: [String:Any], responsavel: Bool, aluno: Aluno? = nil, usuario: Usuario? = nil) {
        if let codigoDdd = json[CamposServidor.codigoDdd] as? String, let codigoFoneTelefone = json[CamposServidor.codigoFoneTelefone] as? UInt32, let codigoTipoTelefone = json[CamposServidor.codigoTipoTelefone] as? UInt16, let validacaoSms = json[CamposServidor.validacaoSms] as? UInt8 {
            if let contato = CoreDataManager.sharedInstance.getData(tabela: Tabelas.contato, predicate: NSPredicate(format: "codigo == %d", codigoFoneTelefone), unique: true)?.first as? Contato {
                contato.codigoDdd = UInt16(codigoDdd)!
                contato.codigoTipoTelefone = codigoTipoTelefone
                contato.validacaoSms = validacaoSms != .zero
                if let complemento = json[CamposServidor.complemento] as? String {
                    contato.complemento = complemento
                }
                if !responsavel {
                    if let aluno = aluno {
                        contato.aluno = aluno
                    }
                    if let telefone = json[CamposServidor.telefoneAluno] as? String {
                        contato.telefone = telefone
                    }
                }
                else {
                    if let usuario = usuario {
                        contato.usuario = usuario
                    }
                    if let codigoResponsavel = json[CamposServidor.codigoResponsavel] as? UInt32 {
                        contato.codigoResponsavel = codigoResponsavel
                    }
                    if let telefone = json[CamposServidor.telefoneResponsavel] as? String {
                        contato.telefone = telefone
                    }
                }
            }
            let contato: Contato = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.contato)
            contato.codigo = codigoFoneTelefone
            contato.codigoDdd = UInt16(codigoDdd)!
            contato.codigoTipoTelefone = codigoTipoTelefone
            contato.validacaoSms = validacaoSms != .zero
            if let complemento = json[CamposServidor.complemento] as? String {
                contato.complemento = complemento
            }
            if !responsavel {
                if let aluno = aluno {
                    contato.aluno = aluno
                }
                if let telefone = json[CamposServidor.telefoneAluno] as? String {
                    contato.telefone = telefone
                }
            }
            else {
                if let usuario = usuario {
                    contato.usuario = usuario
                }
                if let codigoResponsavel = json[CamposServidor.codigoResponsavel] as? UInt32 {
                    contato.codigoResponsavel = codigoResponsavel
                }
                if let telefone = json[CamposServidor.telefoneResponsavel] as? String {
                    contato.telefone = telefone
                }
            }
        }
    }
}

//
//  TurmaDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 15/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class TurmaDao {
    //MARK: Constants
    struct CamposServidor {
        static let anoLetivo = "AnoLetivo"
        static let codigoMatriculaAluno = "CodigoMatriculaAluno"
        static let codigoTipoEnsino = "CodigoTipoEnsino"
        static let codigoTurma = "CodigoTurma"
        static let dataFimMatricula = "DtFimMatricula"
        static let dataInicioMatricula = "DtInicioMatricula"
        static let nomeEscola = "NomeEscola"
        static let nomeTurma = "NomeTurma"
        static let tipoEnsino = "TipoEnsino"
        static let situacaoAprovacao = "SituacaoAprovacao"
        static let situacaoMatricula = "SituacaoMatricula"
    }
    
    //MARK: Methods
    static func buscarTurmaComNome(nome: String) -> Turma? {
        return CoreDataManager.sharedInstance.getData(tabela: Tabelas.turma, predicate: NSPredicate(format: "nomeTurma == %@", nome), unique: true)?.first as? Turma
    }
    
    static func buscarTurmaAtiva(aluno: Aluno) -> Turma? {
        let hoje = Date()
        let hojeSemTempo = Date().semTempo as NSDate
        return CoreDataManager.sharedInstance.getData(tabela: Tabelas.turma, predicate: NSPredicate(format: "anoLetivo == %d AND situacaoMatricula == %@ AND aluno.codigoAluno == %d AND dataInicioMatricula <= %@ AND dataFimMatricula >= %@ AND (codigoTipoEnsino == %d OR codigoTipoEnsino == %d)", Calendar.current.component(.year, from: hoje), "Ativo", aluno.codigoAluno, hojeSemTempo, hojeSemTempo, TipoEnsino.fundamental.rawValue, TipoEnsino.medio.rawValue), unique: true)?.first as? Turma
    }
    
    //MARK: Methods
    static func salvarTurma(json: [String:Any], responsavel: Bool, aluno: Aluno) {
        if let anoLetivo = json[CamposServidor.anoLetivo] as? UInt16, let codigoMatriculaAluno = json[CamposServidor.codigoMatriculaAluno] as? UInt64, let codigoTipoEnsino = json[CamposServidor.codigoTipoEnsino] as? UInt16, let codigoTurma = json[CamposServidor.codigoTurma] as? UInt32, let dataFimMatriculaString = json[CamposServidor.dataFimMatricula] as? String, let dataInicioMatriculaString = json[CamposServidor.dataInicioMatricula] as? String, let nomeEscola = json[CamposServidor.nomeEscola] as? String, let nomeTurma = json[CamposServidor.nomeTurma] as? String, let tipoEnsino = json[CamposServidor.tipoEnsino] as? String, let dataFimMatricula = DateFormatter.isoDateFormatter.date(from: dataFimMatriculaString), let dataInicioMatricula = DateFormatter.isoDateFormatter.date(from: dataInicioMatriculaString) {
            if let turma = CoreDataManager.sharedInstance.getData(tabela: Tabelas.turma, predicate: NSPredicate(format: "codigoTurma == %d", codigoTurma), unique: true)?.first as? Turma {
                turma.anoLetivo = anoLetivo
                turma.codigoMatriculaAluno = codigoMatriculaAluno
                turma.codigoTipoEnsino = codigoTipoEnsino
                turma.dataFimMatricula = dataFimMatricula
                turma.dataInicioMatricula = dataInicioMatricula
                turma.nomeEscola = nomeEscola
                turma.nomeTurma = nomeTurma
                turma.tipoEnsino = tipoEnsino
                turma.aluno = aluno
                if let situacaoAprovacao = json[CamposServidor.situacaoAprovacao] as? String {
                    turma.situacaoAprovacao = situacaoAprovacao
                }
                if let situacaoMatricula = json[CamposServidor.situacaoMatricula] as? String {
                    turma.situacaoMatricula = situacaoMatricula
                }
                return
            }
            let turma: Turma = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.turma)
            turma.anoLetivo = anoLetivo
            turma.codigoMatriculaAluno = codigoMatriculaAluno
            turma.codigoTipoEnsino = codigoTipoEnsino
            turma.codigoTurma = codigoTurma
            turma.dataFimMatricula = dataFimMatricula
            turma.dataInicioMatricula = dataInicioMatricula
            turma.nomeEscola = nomeEscola
            turma.nomeTurma = nomeTurma
            turma.tipoEnsino = tipoEnsino
            turma.aluno = aluno
            if let situacaoAprovacao = json[CamposServidor.situacaoAprovacao] as? String {
                turma.situacaoAprovacao = situacaoAprovacao
            }
            if let situacaoMatricula = json[CamposServidor.situacaoMatricula] as? String {
                turma.situacaoMatricula = situacaoMatricula
            }
        }
    }
}

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
        static let codigoTurma = "CodigoTurma"
    }
    
    //MARK: Methods
    static func buscarTurmaAtiva(aluno: Aluno) -> Turma? {
        let hoje = Date()
        let hojeSemTempo = Date().semTempo as NSDate
        return CoreDataManager.sharedInstance.getData(tabela: Tabelas.turma, predicate: NSPredicate(format: "anoLetivo == %d AND situacaoMatricula == %@ AND aluno.codigoAluno == %d AND dataInicioMatricula <= %@ AND dataFimMatricula >= %@ AND (codigoTipoEnsino == %d OR codigoTipoEnsino == %d)", Calendar.current.component(.year, from: hoje), "Ativo", aluno.codigoAluno, hojeSemTempo, hojeSemTempo, TipoEnsino.fundamental.rawValue, TipoEnsino.medio.rawValue), unique: true)?.first as? Turma
    }
}

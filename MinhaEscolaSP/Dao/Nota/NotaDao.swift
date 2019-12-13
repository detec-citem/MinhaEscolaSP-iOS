//
//  NotaDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 23/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class NotaDao {
    //MARK: Constants
    fileprivate struct CamposServidor {
        static let codigoDisciplina = "CodigoDisciplina"
        static let composicaoNota = "ComposicaoNota"
        static let nomeDisciplina = "NomeDisciplina"
        static let nota = "Nota"
    }
    
    //MARK: Methods
    static func salvarNota(bimestre: UInt16, json: [String:Any], aluno: Aluno) -> Nota {
        if let codigoDisciplina = json[CamposServidor.codigoDisciplina] as? UInt16, let composicoesNota = json[CamposServidor.composicaoNota] as? [[String:Any]], let nomeDisciplina = json[CamposServidor.nomeDisciplina] as? String, let nota = json[CamposServidor.nota] as? Float {
            if let notaModel = CoreDataManager.sharedInstance.getData(tabela: Tabelas.nota, predicate: NSPredicate(format: "codigoDisciplina == %d AND bimestre == %d AND aluno == %@", codigoDisciplina, bimestre, aluno), unique: true)?.first as? Nota {
                notaModel.nota = nota
                for composicaoNotaJson in composicoesNota {
                    ComposicaoNotaDao.salvarComposicaoNota(json: composicaoNotaJson, nota: notaModel)
                }
                return notaModel
            }
            let notaModel: Nota = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.nota)
            notaModel.bimestre = bimestre
            notaModel.codigoDisciplina = codigoDisciplina
            notaModel.nomeDisciplina = nomeDisciplina
            notaModel.nota = nota
            notaModel.aluno = aluno
            for composicaoNotaJson in composicoesNota {
                ComposicaoNotaDao.salvarComposicaoNota(json: composicaoNotaJson, nota: notaModel)
            }
            return notaModel
        }
        return Nota()
    }
}

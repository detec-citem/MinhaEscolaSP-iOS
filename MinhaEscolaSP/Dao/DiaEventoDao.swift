//
//  DiaEventoDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 19/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class DiaEventoDao {
    //MARK: Constants
    struct CamposServidor {
        static let bimestre = "Bimestre"
        static let descricaoEvento = "DescricaoEvento"
        static let dia = "Dia"
        static let diasEventos = "DiasEventos"
        static let disciplina = "Disciplina"
        static let letivo = "Letivo"
        static let mes = "Mes"
        static let nomeEvento = "NomeEvento"
    }
    
    //MARK: Methods
    static func salvarDiaLetivo(mes: UInt16, bimestre: Bimestre, turma: Turma, json: [String:Any]) -> DiaEvento {
        if let dia = json[CamposServidor.dia] as? UInt16, let descricaoEvento = json[CamposServidor.descricaoEvento] as? String, let letivo = json[CamposServidor.letivo] as? Bool, let nomeEvento = json[CamposServidor.nomeEvento] as? String {
            var predicate: NSPredicate!
            let numeroBimestre = bimestre.numeroBimestre
            let codigoTurma = turma.codigoTurma
            var predicateString = "dia == %d AND mes == %d AND bimestre.numeroBimestre == %d AND turma.codigoTurma == %d AND nomeEvento == %@ AND descricaoEvento == %@"
            if let disciplinaString = json[CamposServidor.disciplina] as? String {
                predicateString += " AND disciplina == %@"
                predicate = NSPredicate(format: predicateString, dia, mes, numeroBimestre, codigoTurma, disciplinaString, nomeEvento, descricaoEvento)
            }
            else {
                predicate = NSPredicate(format: predicateString, dia, mes, numeroBimestre, codigoTurma, nomeEvento, descricaoEvento)
            }
            if let diaEvento = CoreDataManager.sharedInstance.getData(tabela: Tabelas.diaEvento, predicate: predicate, unique: true)?.first as? DiaEvento {
                diaEvento.letivo = letivo
                return diaEvento
            }
            let diaEvento: DiaEvento = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.diaEvento)
            diaEvento.descricaoEvento = descricaoEvento
            diaEvento.dia = dia
            diaEvento.letivo = letivo
            diaEvento.mes = mes
            diaEvento.nomeEvento = nomeEvento
            diaEvento.bimestre = bimestre
            diaEvento.turma = turma
            if let disciplina = json[CamposServidor.disciplina] as? String {
                diaEvento.disciplina = disciplina
            }
            return diaEvento
        }
        return DiaEvento()
    }
}

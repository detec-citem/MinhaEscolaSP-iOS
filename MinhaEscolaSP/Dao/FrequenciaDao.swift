//
//  FrequenciaDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 25/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class FrequenciaDao: NSObject {
    //MARK: Constants
    struct CamposServidor {
        static let ausenciasCompensadas = "AusenciasCompensadas"
        static let codigoDisciplina = "CodigoDisciplina"
        static let faltas = "Faltas"
        static let nomeDisciplina = "NomeDisciplina"
        static let porcentagemFaltas = "PorcentagemFaltas"
    }
    
    static func salvarFrequencia(bimestre: UInt16, json: [String:Any], aluno: Aluno) -> Frequencia {
        if let ausenciasCompensadas = json[CamposServidor.ausenciasCompensadas] as? Int16, let codigoDisciplina = json[CamposServidor.codigoDisciplina] as? UInt16, let faltas = json[CamposServidor.faltas] as? Int16, let porcentagemFaltas = json[CamposServidor.porcentagemFaltas] as? Double, let nomeDisciplina = json[CamposServidor.nomeDisciplina] as? String {
            if let frequencia = CoreDataManager.sharedInstance.getData(tabela: Tabelas.frequencia, predicate: NSPredicate(format: "codigoDisciplina == %d AND bimestre == %d AND aluno.codigoAluno == %d", codigoDisciplina, bimestre, aluno.codigoAluno), unique: true)?.first as? Frequencia {
                frequencia.ausenciasCompensadas = ausenciasCompensadas
                frequencia.faltas = faltas
                frequencia.porcentagemFaltas = Float(porcentagemFaltas)
                return frequencia
            }
            let frequencia = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.frequencia) as! Frequencia
            frequencia.ausenciasCompensadas = ausenciasCompensadas
            frequencia.bimestre = bimestre
            frequencia.codigoDisciplina = codigoDisciplina
            frequencia.faltas = faltas
            frequencia.porcentagemFaltas = Float(porcentagemFaltas)
            frequencia.nomeDisciplina = nomeDisciplina
            frequencia.aluno = aluno
            return frequencia
        }
        return Frequencia()
    }
}

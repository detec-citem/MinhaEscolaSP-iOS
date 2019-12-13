//
//  HorarioAulaDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 22/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class HorarioAulaDao {
    //MARK: Constants
    struct CamposServidor {
        static let codigoAluno = "CodigoAluno"
        static let codigoMateria = "CodigoMateria"
        static let dataHoraFim = "DataHoraFim"
        static let dataHoraInicio = "DataHoraInicio"
        static let diaSemana = "DiaSemana"
        static let nomeMateriaAbreviado = "NomeMateriaAbreviado"
        static let nomeProfessor = "NomeProfessor"
        static let nomeTurma = "NomeTurma"
    }
    
    //MARK: Methods
    static func salvarHorarioAula(json: [String:Any], aluno: Aluno, turma: Turma) -> HorarioAula {
        if let codigoMateria = json[CamposServidor.codigoMateria] as? UInt16, let dataHoraFim = json[CamposServidor.dataHoraFim] as? String, let dataHoraInicio = json[CamposServidor.dataHoraInicio] as? String, let diaSemana = json[CamposServidor.diaSemana] as? String, let nomeMateriaAbreviado = json[CamposServidor.nomeMateriaAbreviado] as? String, let nomeProfessor = json[CamposServidor.nomeProfessor] as? String {
            if let horarioAula = CoreDataManager.sharedInstance.getData(tabela: Tabelas.horarioAula, predicate: NSPredicate(format: "codigoMateria == %d AND diaSemana == %d AND dataHoraInicio == %@ AND dataHoraFim == %@ AND aluno == %@ AND turma == %@", codigoMateria, diaSemana, dataHoraInicio, dataHoraFim, aluno, turma), unique: true)?.first as? HorarioAula {
                horarioAula.nomeMateriaAbreviado = nomeMateriaAbreviado
                horarioAula.nomeMateriaCompleto = formatarNomeMateria(codigoMateria: codigoMateria)
                horarioAula.nomeProfessor = nomeProfessor
                return horarioAula
            }
            let horarioAula: HorarioAula = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.horarioAula)
            horarioAula.codigoMateria = codigoMateria
            horarioAula.dataHoraFim = dataHoraFim
            horarioAula.dataHoraInicio = dataHoraInicio
            horarioAula.diaSemana = diaSemana
            horarioAula.nomeMateriaAbreviado = nomeMateriaAbreviado
            horarioAula.nomeMateriaCompleto = formatarNomeMateria(codigoMateria: codigoMateria)
            horarioAula.nomeProfessor = nomeProfessor
            horarioAula.aluno = aluno
            horarioAula.turma = turma
            
            return horarioAula
        }
        return HorarioAula()
    }
    
    fileprivate static func formatarNomeMateria(codigoMateria: UInt16) -> String {
        if codigoMateria == 1000 {
            return "Matemática, Língua Portuguesa e Ciências"
        }
        if codigoMateria == 1100 || codigoMateria == 1118 || codigoMateria == 1131 {
            return "Língua Portuguesa"
        }
        if codigoMateria == 1111 || codigoMateria == 1119 || codigoMateria == 1132 {
            return "Língua Portuguesa e Literatura"
        }
        if codigoMateria == 1130 {
            return "Sala de Leitura"
        }
        if codigoMateria == 1200 || codigoMateria == 1201 || codigoMateria == 1202 {
            return "Língua Estrangeira: Espanhol"
        }
        if codigoMateria == 1300 {
            return "Língua Estrangeira: Francês"
        }
        if codigoMateria == 1400 || codigoMateria == 1401 || codigoMateria == 1407 || codigoMateria == 1408 {
            return "Língua Estrangeira: Inglês"
        }
        if codigoMateria == 1500 {
            return "Língua Estrangeira: Alemão"
        }
        if codigoMateria == 1800 {
            return "Educação Artística"
        }
        if codigoMateria == 1800 {
            return "Educação Artística"
        }
        if codigoMateria == 1813 || codigoMateria == 1814 || codigoMateria == 1816 {
            return "Artes"
        }
        if codigoMateria == 1900 || codigoMateria == 1903 || codigoMateria == 1908 {
            return "Educação Física"
        }
        if codigoMateria == 1905 {
            return "Atividades Currículares Desportivas"
        }
        if codigoMateria == 2000 {
            return "Língua Estrangeira: Mandarim"
        }
        if codigoMateria == 2100 || codigoMateria == 2105 || codigoMateria == 2112 {
            return "Geografia"
        }
        if codigoMateria == 2200 || codigoMateria == 2008 {
            return "História"
        }
        else if codigoMateria == 2300 || codigoMateria == 2306 || codigoMateria == 2309 {
            return "Sociologia"
        }
        if codigoMateria == 2308 {
            return "Sociologia do Trabalho"
        }
        if codigoMateria == 2400 || codigoMateria == 2413 || codigoMateria == 2426 {
            return "Biologia"
        }
        if codigoMateria == 2500 || codigoMateria == 2504 {
            return "Ciências Físicas e Biológicas"
        }
        if codigoMateria == 2600 || codigoMateria == 2605 || codigoMateria == 2607 {
            return "Física"
        }
        if codigoMateria == 2700 || codigoMateria == 2707 || codigoMateria == 2713 || codigoMateria == 7235 {
            return "Matemática"
        }
        if codigoMateria == 2800 || codigoMateria == 2812 || codigoMateria == 2831 || codigoMateria == 2832 {
            return "Química"
        }
        if codigoMateria == 3100 || codigoMateria == 3105 || codigoMateria == 3107 || codigoMateria == 3108 {
            return "Filosofia"
        }
        if codigoMateria == 3200 {
            return "Estudos Sociais"
        }
        if codigoMateria == 5100 {
            return "Organização Social e Política do Brasil"
        }
        if codigoMateria == 6900 {
            return "Língua Estrangeira: Japônees"
        }
        if codigoMateria == 7000 {
            return "Língua Estrangeira: Italiano"
        }
        if codigoMateria == 7240 {
            return "Ciências da Natureza"
        }
        if codigoMateria == 7245 {
            return "Ciências da Natureza"
        }
        if codigoMateria >= 8001 && codigoMateria <= 8015 {
            return "Atletismo"
        }
        if codigoMateria >= 8016 && codigoMateria <= 8025 {
            return "Basquete"
        }
        if (codigoMateria >= 8026 && codigoMateria <= 8035) || (codigoMateria == 8218) {
            return "Capoeira"
        }
        if codigoMateria >= 8036 && codigoMateria <= 8050 {

            return "Damas"
        }
        if codigoMateria >= 8051 && codigoMateria <= 8060 {
            return "Futsal"
        }
        if codigoMateria >= 8061 && codigoMateria <= 8075 {
            return "Ginástica Artística"
        }
        if codigoMateria >= 8076 && codigoMateria <= 8093 {
            return "Ginástica Geral"
        }
        if codigoMateria >= 8091 && codigoMateria <= 8105 {
            return "Ginástica Rítmica"
        }
        if codigoMateria >= 8106 && codigoMateria <= 8115 {
            return "Handebol"
        }
        if (codigoMateria >= 8116 && codigoMateria <= 8125) || (codigoMateria >= 8222 && codigoMateria <= 8225) {
            return "Judo"
        }
        if codigoMateria >= 8126 && codigoMateria <= 8140 {
            return "Tênis de Mesa"
        }
        if codigoMateria >= 8141 && codigoMateria <= 8150 {
            return "Voleibol"
        }
        if codigoMateria >= 8141 && codigoMateria <= 8150 {
            return "Voleibol"
        }
        if codigoMateria >= 8151 && codigoMateria <= 8165 {
            return "Xadrez"
        }
        if codigoMateria >= 8166 && codigoMateria <= 8177 {
            return "Badmington"
        }
        if codigoMateria >= 8178 && codigoMateria <= 8189 {
            return "Natação"
        }
        if codigoMateria >= 8190 && codigoMateria <= 8197 {
            return "Rugby"
        }
        if codigoMateria >= 8198 && codigoMateria <= 8205 {
            return "Volei de Praia"
        }
        if codigoMateria >= 8206 && codigoMateria <= 8217 {
            return "Karatê"
        }
        return ""
    }
}

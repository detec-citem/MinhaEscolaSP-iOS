//
//  InteresseRematriculaDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 05/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class InteresseRematriculaDao {
    //MARK: Constants
    fileprivate struct CamposServidor {
        static let aceitoTermoResponsabilidade = "AceitoTermoResponsabilidade"
        static let anoLetivo = "AnoLetivo"
        static let anoLetivoRematricula = "AnoLetivo"
        static let codigoInteresseRematricula = "CodigoInteresseRematricula"
        static let codigoOpcaoNoturna = "CodigoOpcaoNoturna"
        static let interesseContinuidade = "InteresseContinuidade"
        static let interesseEspanhol = "InteresseEspanhol"
        static let interesseNovotec = "InteresseNovotec"
        static let interesseTurnoIntegral = "InteresseTurnoIntegral"
        static let interesseTurnoNoturno = "InteresseTurnoNoturno"
        static let eixoEnsinoProfissionalUm = "EixoEnsinoProfissionalUm"
        static let eixoEnsinoProfissionalDois = "EixoEnsinoProfissionalDois"
        static let eixoEnsinoProfissionalTres = "EixoEnsinoProfissionalTres"
    }
    
    struct Constants {
        static let separadorCursosTecnicos = ","
    }
    
    //MARK: Methods
    static func criarInteresseRematricula(aluno: Aluno) -> InteresseRematricula {
        let interesseRematricula: InteresseRematricula = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.interesseRematricula)
        interesseRematricula.aluno = aluno
        interesseRematricula.cursoTecnico = ""
        return interesseRematricula
    }
    
    static func interesseRematriculaDoAluno(codigoAluno: UInt32) -> InteresseRematricula? {
        return CoreDataManager.sharedInstance.getData(tabela: Tabelas.interesseRematricula, predicate: NSPredicate(format: "aluno.codigoAluno == %d", codigoAluno), unique: true)?.first as? InteresseRematricula
    }
    
    static func salvarInteresseRematricula(json: [String:Any], aluno: Aluno) {
        if let aceitoTermoResponsabilidade = json[CamposServidor.aceitoTermoResponsabilidade] as? Bool, let anoLetivo = json[CamposServidor.anoLetivo] as? UInt16, let anoLetivoRematricula = json[CamposServidor.anoLetivoRematricula] as? UInt16, let codigoInteresseRematricula = json[CamposServidor.codigoInteresseRematricula] as? UInt32, let codigoOpcaoNoturna = json[CamposServidor.codigoOpcaoNoturna] as? UInt16, let eixoEnsinoProfissionalUm = json[CamposServidor.eixoEnsinoProfissionalUm] as? Int, let eixoEnsinoProfissionalDois = json[CamposServidor.eixoEnsinoProfissionalDois] as? Int, let eixoEnsinoProfissionalTres = json[CamposServidor.eixoEnsinoProfissionalTres] as? Int, let interesseContinuidade = json[CamposServidor.interesseContinuidade] as? Bool, let interesseEspanhol = json[CamposServidor.interesseEspanhol] as? Bool, let interesseNovotec = json[CamposServidor.interesseNovotec] as? Bool, let interesseTurnoIntegral = json[CamposServidor.interesseTurnoIntegral] as? Bool, let interesseTurnoNoturno = json[CamposServidor.interesseTurnoNoturno] as? Bool {
            var cursosTecnicos = [String]()
            if eixoEnsinoProfissionalUm != .zero {
                cursosTecnicos.append(CursosTecnicos.cursosTecnicos[eixoEnsinoProfissionalUm - 1])
            }
            if eixoEnsinoProfissionalDois != .zero {
                cursosTecnicos.append(CursosTecnicos.cursosTecnicos[eixoEnsinoProfissionalDois - 1])
            }
            if eixoEnsinoProfissionalTres != .zero {
                cursosTecnicos.append(CursosTecnicos.cursosTecnicos[eixoEnsinoProfissionalTres - 1])
            }
            let cursosTecnicosString = cursosTecnicos.joined(separator: Constants.separadorCursosTecnicos)
            if let interesseRematricula = CoreDataManager.sharedInstance.getData(tabela: Tabelas.interesseRematricula, predicate: NSPredicate(format: "codigoInteresseRematricula == %d", codigoInteresseRematricula), unique: true)?.first as? InteresseRematricula {
                interesseRematricula.aceitoTermoResponsabilidade = aceitoTermoResponsabilidade
                interesseRematricula.anoLetivo = anoLetivo
                interesseRematricula.anoLetivoRematricula = anoLetivoRematricula
                interesseRematricula.codigoOpcaoNoturno = codigoOpcaoNoturna
                interesseRematricula.cursoTecnico = cursosTecnicosString
                interesseRematricula.interesseContinuidade = interesseContinuidade
                interesseRematricula.interesseEspanhol = interesseEspanhol
                interesseRematricula.interesseNovotec = interesseNovotec
                interesseRematricula.interesseTurnoIntegral = interesseTurnoIntegral
                interesseRematricula.interesseTurnoNoturno = interesseTurnoNoturno
                interesseRematricula.aluno = aluno
            }
            let interesseRematricula: InteresseRematricula = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.interesseRematricula)
            interesseRematricula.aceitoTermoResponsabilidade = aceitoTermoResponsabilidade
            interesseRematricula.anoLetivo = anoLetivo
            interesseRematricula.anoLetivoRematricula = anoLetivoRematricula
            interesseRematricula.codigoInteresseRematricula = codigoInteresseRematricula
            interesseRematricula.codigoOpcaoNoturno = codigoOpcaoNoturna
            interesseRematricula.cursoTecnico = cursosTecnicosString
            interesseRematricula.interesseContinuidade = interesseContinuidade
            interesseRematricula.interesseEspanhol = interesseEspanhol
            interesseRematricula.interesseNovotec = interesseNovotec
            interesseRematricula.interesseTurnoIntegral = interesseTurnoIntegral
            interesseRematricula.interesseTurnoNoturno = interesseTurnoNoturno
            interesseRematricula.aluno = aluno
        }
    }
}

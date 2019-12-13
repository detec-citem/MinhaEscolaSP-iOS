//
//  BimestreDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 20/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class BimestreDao {
    //MARK: Constants
    struct CamposServidor {
        static let bimestre = "Bimestre"
        static let dataFim = "DataFim"
        static let dataInicio = "DataInicio"
        static let calendario = "calendario"
    }
    
    //MARK: Methods
    static func bimestreAtual() -> Bimestre? {
        var hoje = Date()
        if !Requests.Configuracoes.servidorHabilitado || LoginRequest.usuarioLogado.usuarioMock(), let data = Calendar.current.date(bySetting: .year, value: 2018, of: hoje) {
            hoje = data
        }
        hoje = hoje.semTempo
        return CoreDataManager.sharedInstance.getData(tabela: Tabelas.bimestre, predicate: NSPredicate(format: "dataInicio <= %@ AND dataFim >= %@", argumentArray: [hoje, hoje]), unique: true)?.first as? Bimestre
    }
    
    static func buscarBimestres() -> [Bimestre]? {
        return CoreDataManager.sharedInstance.getData(tabela: Tabelas.bimestre, sortBy: "numeroBimestre") as? [Bimestre]
    }
    
    static func salvarBimestre(json: [String:Any]) -> Bimestre {
        if let numeroBimestreString = json[CamposServidor.bimestre] as? String, let dataFimString = json[CamposServidor.dataFim] as? String, let dataInicioString = json[CamposServidor.dataInicio] as? String, let numeroBimestre = UInt16(numeroBimestreString), let dataFim = DateFormatter.defaultDateFormatter.date(from: dataFimString), let dataInicio = DateFormatter.defaultDateFormatter.date(from: dataInicioString) {
            if let bimestre = CoreDataManager.sharedInstance.getData(tabela: Tabelas.bimestre, predicate: NSPredicate(format: "numeroBimestre == %d", numeroBimestre), unique: true)?.first as? Bimestre {
                bimestre.dataFim = dataFim
                bimestre.dataInicio = dataInicio
                return bimestre
            }
            let bimestre: Bimestre = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.bimestre)
            bimestre.numeroBimestre = numeroBimestre
            bimestre.dataFim = dataFim
            bimestre.dataInicio = dataInicio
            return bimestre
        }
        return Bimestre()
    }
}

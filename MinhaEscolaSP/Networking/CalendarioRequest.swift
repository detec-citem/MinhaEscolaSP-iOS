//
//  CalendarioRequest.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 19/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class CalendarioRequest {
    //MARK: Constants
    fileprivate struct Constants {
        static let calendarioApi = "SedApi/Api/CalendarioEscolar/EventosCalendario?codigoTurma="
        static let calendarioMock = "calendario"
    }
    
    //MARK: Methods
    static func buscarCalendario(turma: Turma, completion: @escaping ([DiaEvento]?, Bool, String?) -> Void) {
        if !Requests.Configuracoes.servidorHabilitado || LoginRequest.usuarioLogado.usuarioMock(), let json = Requests.getLocalJsonData(name: Constants.calendarioMock) as? [[String:Any]] {
            processarCalendario(turma: turma, json: json, completion: completion)
        }
        else if let url = URL(string: Requests.Configuracoes.urlServidor + Constants.calendarioApi + String(turma.codigoTurma)) {
            Requests.requestData(request: URLRequest(url: url), httpMethod: .get) { (data, error) in
                if error != nil {
                    completion(nil, false, error)
                }
                else if let data = data as? Data, let json = Requests.parseJson(data: data) as? [[String:Any]] {
                    processarCalendario(turma: turma, json: json, completion: completion)
                }
            }
        }
    }
    
    fileprivate static func processarCalendario(turma: Turma, json: [[String:Any]], completion: @escaping ([DiaEvento]?, Bool, String?) -> Void) {
        DispatchQueue.main.async {
            var diasEvento = [DiaEvento]()
            for bimestreJson in json {
                let bimestre = BimestreDao.salvarBimestre(json: bimestreJson)
                if let calendarioJson = bimestreJson[BimestreDao.CamposServidor.calendario] as? [[String:Any]] {
                    for mesJson in calendarioJson {
                        if let mes = mesJson[DiaEventoDao.CamposServidor.mes] as? UInt16, let diasEventoJson = mesJson[DiaEventoDao.CamposServidor.diasEventos] as? [[String:Any]] {
                            for diaEventoJson in diasEventoJson {
                                let diaEvento = DiaEventoDao.salvarDiaLetivo(mes: mes, bimestre: bimestre, turma: turma, json: diaEventoJson)
                                diasEvento.append(diaEvento)
                            }
                        }
                    }
                }
            }
            CoreDataManager.sharedInstance.saveContext()
            completion(diasEvento, true, nil)
        }
    }
}

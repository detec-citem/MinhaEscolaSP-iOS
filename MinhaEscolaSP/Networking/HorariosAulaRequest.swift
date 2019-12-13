//
//  HorariosAulaRequest.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 22/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class HorariosAulaRequest {
    //MARK: Constants
    fileprivate struct Constants {
        static let aulas = "Aulas"
        static let horariosAulaApi = "SedApi/Api/HorarioAula?turma="
        static let horariosAulaMock = "horarios_aula"
    }
    
    //MARK: Methods
    static func pegarHorariosAula(aluno: Aluno, turma: Turma, completion: @escaping (([HorarioAula]?, Bool, String?) -> Void)) {
        if !Requests.Configuracoes.servidorHabilitado || LoginRequest.usuarioLogado.usuarioMock(), let json = Requests.getLocalJsonData(name: Constants.horariosAulaMock) as? [String:Any] {
            salvarHorariosAula(json: json, aluno: aluno, completion: completion)
        }
        else if let url = URL(string: Requests.Configuracoes.urlServidor + Constants.horariosAulaApi + String(turma.codigoTurma)) {
            Requests.requestData(request: URLRequest(url: url), httpMethod: .get) { (data, error) in
                if error != nil {
                    completion(nil, false, error)
                }
                else if let data = data as? Data, let json = Requests.parseJson(data: data) as? [String:Any] {
                    salvarHorariosAula(json: json, aluno: aluno, completion: completion)
                }
            }
        }
    }
    
    fileprivate static func salvarHorariosAula(json: [String:Any], aluno: Aluno, completion: @escaping ([HorarioAula]?, Bool, String?) -> Void) {
        if let horariosAulaJson = json[Constants.aulas] as? [[String:Any]] {
            DispatchQueue.main.async {
                var horariosAula = [HorarioAula]()
                horariosAula.reserveCapacity(horariosAulaJson.count)
                for horarioAulaJson in horariosAulaJson {
                    if let nomeTurma = horarioAulaJson[HorarioAulaDao.CamposServidor.nomeTurma] as? String, let turma = TurmaDao.buscarTurmaComNome(nome: nomeTurma) {
                        let horarioAula = HorarioAulaDao.salvarHorarioAula(json: horarioAulaJson, aluno: aluno, turma: turma)
                        horariosAula.append(horarioAula)
                    }
                }
                CoreDataManager.sharedInstance.saveContext()
                completion(horariosAula, true, nil)
            }
        }
    }
}

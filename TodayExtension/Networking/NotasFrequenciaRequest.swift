//
//  NotasRequest.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 23/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class NotasFrequenciaRequest {
    //MARK: Constants
    fileprivate struct Constants {
        static let bimestre = "Bimestre"
        static let codigoAluno = "CodigoAluno"
        static let notas = "Notas"
        static let notasFrequenciasApi = "/SedApi/Api/Boletim/GerarAlunoTurma"
        static let notasFrequenciasMock = "notas_frequencias"
    }
    
    //MARK: Methods
    static func buscarNotas(aluno: Aluno, turma: Turma, completion: @escaping ([Nota]?,Bool,String?) -> Void) {
        if !Requests.Configuracoes.servidorHabilitado || LoginRequest.usuarioLogado.usuarioMock(), let json = Requests.getLocalJsonData(name: Constants.notasFrequenciasMock) as? [[String:Any]] {
            salvarNotas(aluno: aluno, notasJson: json, completion: completion)
        }
        else if let url = URL(string: Requests.Configuracoes.urlServidor + Constants.notasFrequenciasApi) {
            var request = URLRequest(url: url)
            var json: [String:Any] = [TurmaDao.CamposServidor.anoLetivo:turma.anoLetivo,TurmaDao.CamposServidor.codigoTurma:turma.codigoTurma]
            if !LoginRequest.usuarioLogado.estudante {
                json[Constants.codigoAluno] = aluno.codigoAluno
            }
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json)
                Requests.requestData(request: request, httpMethod: .post) { (data, erro) in
                    if erro != nil {
                        completion(nil, false, erro)
                    }
                    else if let data = data as? Data, let json = Requests.parseJson(data: data) as? [[String:Any]] {
                        salvarNotas(aluno: aluno, notasJson: json, completion: completion)
                    }
                }
            }
            catch {
                completion(nil, false, error.localizedDescription)
            }
        }
    }
    
    fileprivate static func salvarNotas(aluno: Aluno, notasJson: [[String:Any]], completion: @escaping ([Nota]?,Bool,String?) -> Void) {
        DispatchQueue.main.async {
            var notas = [Nota]()
            for json in notasJson {
                if let bimestre = json[Constants.bimestre] as? UInt16, let notasJson = json[Constants.notas] as? [[String:Any]] {
                    for notaJson in notasJson {
                        let nota = NotaDao.salvarNota(bimestre: bimestre, json: notaJson, aluno: aluno)
                        notas.append(nota)
                    }
                }
            }
            CoreDataManager.sharedInstance.saveContext()
            completion(notas, true, nil)
        }
    }
}

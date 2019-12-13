//
//  AlimentacaoRequest.swift
//  MinhaEscolaSP
//
//  Created by infra on 21/03/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class AlimentacaoRequest {
    //MARK: Constants
    fileprivate struct Constants {
        static let codigoTurma = "CodigoTurma"
        static let enviarAvaliacaoAlimentacaoApi = "/SedApi/Api/AlimentacaoEscolar/Salvar"
        static let podeResponder = "PodeResponder"
        static let podeResponderApi = "/SedApi/Api/AlimentacaoEscolar/PodeResponder"
        static let questao1 = "Questao1"
        static let questao2 = "Questao2"
        static let questao3 = "Questao3"
        static let questao4 = "Questao4"
        static let questao5 = "Questao5"
    }
    
    //MARK: Methods
    static func enviarAvaliacao(codigoTurma: UInt32, questao1: UInt8, questao2: UInt8, questao3: [UInt8], questao4: [UInt8], questao5: [UInt8], completion: @escaping (Bool, String?) -> Void) {
        if !Requests.Configuracoes.servidorHabilitado || LoginRequest.usuarioLogado.usuarioMock() {
            completion(true, nil)
        }
        else {
            let json: [String:Any] = [Constants.codigoTurma:codigoTurma,Constants.questao1:[questao1],Constants.questao2:[questao2],Constants.questao3:questao3,Constants.questao4:questao4,Constants.questao5:questao5]
            var request = URLRequest(url: URL(string: Requests.Configuracoes.urlServidor + Constants.enviarAvaliacaoAlimentacaoApi)!)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json)
                Requests.requestData(request: request, httpMethod: .post) { (data, erro) in
                    if let erro = erro {
                        completion(false, erro)
                    }
                    else {
                        completion(true, nil)
                    }
                }
            }
            catch {
                completion(false, error.localizedDescription)
            }
        }
    }
    
    static func podeResponder(completion: @escaping (Bool?, Bool, String?) -> Void) {
        if !Requests.Configuracoes.servidorHabilitado || LoginRequest.usuarioLogado.usuarioMock() {
            completion(true, true, nil)
        }
        else {
            Requests.requestData(request: URLRequest(url: URL(string: Requests.Configuracoes.urlServidor + Constants.podeResponderApi)!), httpMethod: .get) { (data, erro) in
                if let erro = erro {
                    completion(nil, false, erro)
                }
                else if let data = data as? Data, let json = Requests.parseJson(data: data) as? [String:Any] {
                    if let podeResponder = json[Constants.podeResponder] as? Bool {
                        completion(podeResponder, true, nil)
                    }
                    else {
                        completion(nil, false, "Algo de errado aconteceu")
                    }
                }
            }
        }
    }
}

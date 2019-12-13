//
//  CarteirinhaRequest.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 17/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class CarteirinhaRequest: NSObject {
    //MARK: Constants
    fileprivate struct Constants {
        static let carteirinhaAlunoApi = "SedApi/Api/CarteirinhaAluno"
        static let carteirinhaMock = "carteirinha"
        static let carteirinhaNaoAprovada = "Carteirinha não aprovada."
        static let parametroCodigoAluno = "CodigoAluno"
    }
    
    //MARK: Methods
    static func pegarCarteirinha(aluno: Aluno?, completion: @escaping ((Carteirinha?, Bool, String?) -> Void)) {
        if !Requests.Configuracoes.servidorHabilitado || LoginRequest.usuarioLogado.usuarioMock(), let json = Requests.getLocalJsonData(name: Constants.carteirinhaMock) as? [String:Any] {
            processarCarteirinha(json: json, completion: completion)
        }
        else if let url = URL(string: Requests.Configuracoes.urlServidor + Constants.carteirinhaAlunoApi) {
            var request = URLRequest(url: url)
            if !LoginRequest.usuarioLogado.estudante, let aluno = aluno {
                let json = [Constants.parametroCodigoAluno:aluno.codigoAluno]
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: json)
                }
                catch {
                    completion(nil, false, error.localizedDescription)
                }
            }
            Requests.requestData(request: request, httpMethod: .post) { (data, error) in
                if error != nil {
                    if error == Constants.carteirinhaNaoAprovada {
                        completion(nil, true, nil)
                    }
                    else {
                        completion(nil, false, error)
                    }
                }
                else if let data = data as? Data, let json = Requests.parseJson(data: data) as? [String : Any] {
                    processarCarteirinha(json: json, completion: completion)
                }
            }
        }
    }
    
    fileprivate static func processarCarteirinha(json: [String:Any], completion: @escaping (Carteirinha?, Bool, String?) -> Void) {
        DispatchQueue.main.async {
            let carteirinha = CarteirinhaDao.salvarCarteirinha(json: json, aluno: LoginRequest.usuarioLogado.aluno)
            CoreDataManager.sharedInstance.saveContext()
            completion(carteirinha, true, nil)
        }
    }
}

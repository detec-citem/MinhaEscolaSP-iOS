//
//  EnviarFotoRequest.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 07/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation
import UIKit

final class EnviarFotoRequest {
    //MARK: Constants
    fileprivate struct Constants {
        static let enviarFotoApi = "/FotoDoAluno/Api/Photo"
        static let parametroFoto = "Foto"
    }
    
    //MARK: Methods
    static func enviarFoto(foto: UIImage, completion: @escaping (Bool, String?) -> Void) {
        if !Requests.Configuracoes.servidorHabilitado || LoginRequest.usuarioLogado.usuarioMock() {
            completion(true, "Foto enviada para aprovação!")
        }
        else if let url = URL(string: Requests.Configuracoes.urlServidor + Constants.enviarFotoApi) {
            var request = URLRequest(url: url)
            let fotoBytes = foto.jpegData(compressionQuality: 1)
            let fotoBytesArray = [UInt8](fotoBytes!)
            let json = [Constants.parametroFoto:fotoBytesArray]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: json)
            }
            catch {
                completion(false, error.localizedDescription)
                return
            }
            Requests.requestData(request: request, httpMethod: .post, completion: { (data, erro) in
                if erro != nil {
                    completion(false, erro)
                }
                else if let data = data as? Data, let respostaString = String(data: data, encoding: .utf8), let respostaCodigo = Int(respostaString) {
                    if respostaCodigo == .zero {
                        completion(true, "Foto enviada para aprovação!")
                    }
                    else if respostaCodigo == -2 {
                        completion(false, "Não encontrou a foto, ou a foto passa de 1MB")
                    }
                    else if respostaCodigo == -3 {
                        completion(false, "O detector facial não detectou uma face na foto")
                    }
                    else if respostaCodigo == -4 {
                        completion(false, "Erro desconhecido durante a detecção facial")
                    }
                    else if respostaCodigo == -5 {
                        completion(false, "Sessão expirada. Faça login novamente")
                    }
                    else if respostaCodigo == -6 {
                        completion(false, "O detector facial não detectou uma face na foto")
                    }
                    else if respostaCodigo == -1 || respostaCodigo == -7 || respostaCodigo == -8 {
                        completion(false, "Ocorreu um erro ao enviar a foto. Tente novamente em alguns minutos!")
                    }
                }
            })
        }
    }
}

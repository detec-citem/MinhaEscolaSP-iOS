//
//  BoletimRequest.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 18/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class BoletimRequest {
    //MARK: Constants
    fileprivate struct Constants {
        static let boletimApi = "Boletim/GerarBoletimUnificadoExterno"
        static let igual = "="
        static let parametroAnoLetivo = "nrAnoLetivo"
        static let parametroDataNascimento = "dtNascimento"
        static let parametroDigitoRa = "nrDigRa"
        static let parametroNumeroRa = "nrRa"
        static let parametroUfRa = "dsUfRa"
        static let separadorParametro = "&"
        static let tamanhoRa = 12
        static let zero = "0"
    }
    
    //MARK: Methods
    static func gerarBoletim(ano: UInt16, aluno: Aluno, completion: @escaping ((String?, Bool, String?) -> Void)) {
        if let boletimUrl = URL(string: Requests.Configuracoes.urlServidor + Constants.boletimApi) {
            var ra: String!
            let numeroRa = aluno.numeroRa
            if numeroRa.count > Constants.tamanhoRa {
                let indice = numeroRa.index(numeroRa.endIndex, offsetBy: -Constants.tamanhoRa)
                ra = String(numeroRa.suffix(from: indice))
            }
            else if numeroRa.count < Constants.tamanhoRa {
                let numeroDeZeros = Constants.tamanhoRa - numeroRa.count
                var zeros = ""
                for _ in 1...numeroDeZeros {
                    zeros += Constants.zero
                }
                ra = zeros + numeroRa
            }
            else {
                ra = numeroRa
            }
            var parametros = Constants.parametroNumeroRa + Constants.igual + ra + Constants.separadorParametro + Constants.parametroDigitoRa + Constants.igual + aluno.digitoRa + Constants.separadorParametro + Constants.parametroUfRa + Constants.igual + aluno.ufRa
            if let dataNascimento = aluno.dataNascimento {
                let dataNascimentoString = DateFormatter.defaultDateFormatter.string(from: dataNascimento)
                parametros += (Constants.separadorParametro + Constants.parametroDataNascimento + Constants.igual + dataNascimentoString)
            }
            parametros += (Constants.separadorParametro + Constants.parametroAnoLetivo + Constants.igual + String(ano))
            var request = URLRequest(url: boletimUrl)
            request.httpBody = parametros.data(using: .utf8)
            Requests.requestData(json: false, request: request, httpMethod: .post) { (data, erro) in
                if erro != nil {
                    completion(nil, false, erro)
                }
                else if let data = data as? Data, let boletimHtml = String(data: data, encoding: .utf8) {
                    completion(boletimHtml, true, nil)
                }
            }
        }
    }
}

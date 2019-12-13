//
//  CarteirinhaDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 17/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class CarteirinhaDao {
    //MARK: Constants
    fileprivate struct CamposServidor {
        static let apelido = "Apelido"
        static let codigoAlunoCriptografado = "CodigoAlunoCriptografado"
        static let foto = "Foto"
        static let qrCode = "QrCode"
        static let rg = "Rg"
        static let validade = "Validade"
    }
    
    //MARK: Methods
    static func salvarCarteirinha(json: [String:Any], aluno: Aluno) -> Carteirinha {
        if let apelido = json[CamposServidor.apelido] as? String, let codigoAlunoCriptografado = json[CamposServidor.codigoAlunoCriptografado] as? String, let foto = json[CamposServidor.foto] as? String, let qrCode = json[CamposServidor.qrCode] as? String, let rg = json[CamposServidor.rg] as? String, let validade = json[CamposServidor.validade] as? String {
            if !rg.isEmpty {
                aluno.rg = rg
            }
            if let carteirinha = aluno.carteirinha {
                carteirinha.apelido = apelido
                carteirinha.codigoAlunoCriptografado = codigoAlunoCriptografado
                carteirinha.foto = foto
                carteirinha.qrCode = qrCode
                if let validadeDate = DateFormatter.mesAno.date(from: validade) {
                    carteirinha.validade = validadeDate
                }
                return carteirinha
            }
            let carteirinha: Carteirinha = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.carteirinha)
            carteirinha.apelido = apelido
            carteirinha.codigoAlunoCriptografado = codigoAlunoCriptografado
            carteirinha.foto = foto
            carteirinha.qrCode = qrCode
            carteirinha.aluno = aluno
            if let validadeDate = DateFormatter.mesAno.date(from: validade) {
                carteirinha.validade = validadeDate
            }
            return carteirinha
        }
        return Carteirinha()
    }
}

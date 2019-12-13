//
//  TelefoneCellDelegate.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 08/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

protocol TelefoneCellDelegate: class {
    func deletarTelefone(indice: Int, responsavel: Bool)
    func editarTelefone(indice: Int, responsavel: Bool)
}

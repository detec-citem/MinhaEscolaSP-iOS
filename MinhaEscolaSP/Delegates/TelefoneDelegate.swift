//
//  TelefoneDelegate.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 13/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

protocol TelefoneDelegate: class {
    func adicionouTelefone(contato: Contato, responsavel: Bool)
    func editouTelefone(contato: Contato, responsavel: Bool)
}

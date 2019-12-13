//
//  ContatoEscolaDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 15/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class ContatoEscolaDao {
    //MARK: Constants
    struct CamposServidor {
        static let contatoEscola = "ContatoEscola"
        static let telefoneUnidade = "TelefoneUnidade"
    }
    
    //MARK: Methods
    static func salvarContato(telefone: String, escolaAluno: Escola) {
        let predicate = NSPredicate(format: "telefone == %@ AND escolaAluno == %@", telefone, escolaAluno)
        if CoreDataManager.sharedInstance.getCount(tabela: Tabelas.contatoEscola, predicate: predicate) == .zero {
            let contatoAluno: ContatoEscola = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.contatoEscola)
            contatoAluno.telefone = telefone
            contatoAluno.escolaAluno = escolaAluno
        }
    }
}

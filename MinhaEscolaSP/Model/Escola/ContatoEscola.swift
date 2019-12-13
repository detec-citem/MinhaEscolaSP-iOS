//
//  ContatoEscola.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 15/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(ContatoEscola)

final class ContatoEscola: NSManagedObject {
    @NSManaged var telefone: String
    @NSManaged var escolaAluno: Escola
}

//
//  Escola.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 09/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(Escola)

final class Escola: NSManagedObject {
    @NSManaged var codigo: UInt32
    @NSManaged var diretor: String?
    @NSManaged var email: String?
    @NSManaged var enderecoUnidade: String?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var nome: String
    @NSManaged var aluno: Aluno
    @NSManaged var contatos: NSSet
}

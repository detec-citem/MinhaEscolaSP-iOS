//
//  Carteirinha.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 09/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(Carteirinha)

final class Carteirinha: NSManagedObject {
    @NSManaged var apelido: String
    @NSManaged var codigoAlunoCriptografado: String
    @NSManaged var foto: String
    @NSManaged var qrCode: String
    @NSManaged var validade: Date
    @NSManaged var aluno: Aluno
}

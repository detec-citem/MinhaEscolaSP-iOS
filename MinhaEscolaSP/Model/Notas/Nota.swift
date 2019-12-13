//
//  Nota.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 23/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(Nota)

final class Nota: NSManagedObject {
    @NSManaged var bimestre: UInt16
    @NSManaged var codigoDisciplina: UInt16
    @NSManaged var nota: Float
    @NSManaged var nomeDisciplina: String
    @NSManaged var aluno: Aluno
    @NSManaged var composicoesNota: NSSet
    var expandida: Bool!
    var composicoesNotaArray: [ComposicaoNota]!
}

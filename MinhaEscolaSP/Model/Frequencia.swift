//
//  Frequencia.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 23/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(Frequencia)

final class Frequencia: NSManagedObject {
    @NSManaged var bimestre: UInt16
    @NSManaged var codigoDisciplina: UInt16
    @NSManaged var ausenciasCompensadas: Int16
    @NSManaged var faltas: Int16
    @NSManaged var porcentagemFaltas: Float
    @NSManaged var nomeDisciplina: String
    @NSManaged var aluno: Aluno
}

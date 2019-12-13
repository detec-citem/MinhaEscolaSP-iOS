//
//  HorarioAula.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 09/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(HorarioAula)

final class HorarioAula: NSManagedObject {
    @NSManaged var codigoMateria: UInt16
    @NSManaged var dataHoraFim: String
    @NSManaged var dataHoraInicio: String
    @NSManaged var diaSemana: String
    @NSManaged var nomeMateriaAbreviado: String
    @NSManaged var nomeMateriaCompleto: String
    @NSManaged var nomeProfessor: String
    @NSManaged var aluno: Aluno
    @NSManaged var turma: Turma
    var nomeImagem: String!
}

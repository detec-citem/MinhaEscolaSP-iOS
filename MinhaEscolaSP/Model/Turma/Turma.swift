//
//  Turma.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 09/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(Turma)

final class Turma: NSManagedObject {
    //MARK: Constants
    fileprivate struct Constants {
        static let nonoAno = "9º ANO"
    }
    
    //MARK: Variables
    @NSManaged var anoLetivo: UInt16
    @NSManaged var codigoMatriculaAluno: UInt64
    @NSManaged var codigoTipoEnsino: UInt16
    @NSManaged var codigoTurma: UInt32
    @NSManaged var dataFimMatricula: Date
    @NSManaged var dataInicioMatricula: Date
    @NSManaged var nomeTurma: String
    @NSManaged var nomeEscola: String
    @NSManaged var situacaoAprovacao: String
    @NSManaged var situacaoMatricula: String
    @NSManaged var tipoEnsino: String
    @NSManaged var aluno: Aluno
    @NSManaged var horariosAula: NSSet
    @NSManaged var diasEvento: NSSet
    
    //MARK: Methods
    func ensinoMedio() -> Bool {
        return codigoTipoEnsino == TipoEnsino.medio.rawValue
    }
    
    func nonoAno() -> Bool {
        return nomeTurma.contains(Constants.nonoAno)
    }
}

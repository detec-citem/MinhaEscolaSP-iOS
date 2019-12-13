//
//  DiaEvento.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 19/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(DiaEvento)

final class DiaEvento: NSManagedObject {
    //MARK: Variables
    @NSManaged var descricaoEvento: String
    @NSManaged var dia: UInt16
    @NSManaged var disciplina: String
    @NSManaged var letivo: Bool
    @NSManaged var mes: UInt16
    @NSManaged var nomeEvento: String
    @NSManaged var bimestre: Bimestre
    @NSManaged var turma: Turma
}

extension DiaEvento {
    //MARK: Constants
    fileprivate struct Constants {
        static let avaliacao = "Avaliação"
        static let atividade = "Atividade"
        static let trabalho = "Trabalho"
        static let outros = "Outros"
    }
    
    //MARK: Methods
    func avaliacao() -> Bool {
        return nomeEvento == Constants.avaliacao || nomeEvento == Constants.atividade || nomeEvento == Constants.trabalho || nomeEvento == Constants.outros
    }
}

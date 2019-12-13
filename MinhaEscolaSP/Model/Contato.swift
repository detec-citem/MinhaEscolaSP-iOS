//
//  ContatoAluno.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 15/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(Contato)

final class Contato: NSManagedObject {
    @NSManaged var codigo: UInt32
    @NSManaged var codigoDdd: UInt16
    @NSManaged var codigoResponsavel: UInt32
    @NSManaged var codigoTipoTelefone: UInt16
    @NSManaged var complemento: String?
    @NSManaged var operacao: UInt16
    @NSManaged var telefone: String
    @NSManaged var validacaoSms: Bool
    @NSManaged var aluno: Aluno
    @NSManaged var usuario: Usuario
}

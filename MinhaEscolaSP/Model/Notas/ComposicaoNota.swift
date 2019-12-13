//
//  ComposicaoNota.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 23/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(ComposicaoNota)

final class ComposicaoNota: NSManagedObject {
    @NSManaged var descricaoAtividade: String
    @NSManaged var numeroNota: Float
    @NSManaged var nota: Nota
}

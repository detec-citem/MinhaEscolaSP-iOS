//
//  Bimestre.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 20/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(Bimestre)

final class Bimestre: NSManagedObject {
    @NSManaged var numeroBimestre: UInt16
    @NSManaged var dataInicio: Date
    @NSManaged var dataFim: Date
    @NSManaged var diasEvento: NSSet
}

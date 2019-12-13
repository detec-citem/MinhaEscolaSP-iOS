//
//  ImagemTurma.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 09/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(ImagemTurma)

final class ImagemTurma: NSManagedObject {
    @NSManaged var codigoMateria: UInt16
    @NSManaged var nomeImagem: String
}

//
//  InteresseRematricula.swift
//  
//
//  Created by Victor Bozelli Alvarez on 05/08/19.
//
//

import CoreData

@objc(InteresseRematricula)

final class InteresseRematricula: NSManagedObject {
    @NSManaged var anoLetivo: UInt16
    @NSManaged var anoLetivoRematricula: UInt16
    @NSManaged var aceitoTermoResponsabilidade: Bool
    @NSManaged var codigoInteresseRematricula: UInt32
    @NSManaged var codigoOpcaoNoturno: UInt16
    @NSManaged var cursoTecnico: String
    @NSManaged var interesseContinuidade: Bool
    @NSManaged var interesseNovotec: Bool
    @NSManaged var interesseTurnoIntegral: Bool
    @NSManaged var interesseEspanhol: Bool
    @NSManaged var interesseTurnoNoturno: Bool
    @NSManaged var aluno: Aluno
}

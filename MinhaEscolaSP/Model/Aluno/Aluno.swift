//
//  Aluno.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 09/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(Aluno)

final class Aluno: NSManagedObject {
    //MARK: Constants
    fileprivate struct Contants {
        static let maiorIdade = 18
    }
    
    //MARK: Variables
    @NSManaged var bairroEndereco: String
    @NSManaged var cep: String
    @NSManaged var cidadeEndereco: String
    @NSManaged var codigoAluno: UInt32
    @NSManaged var complementoEndereco: String?
    @NSManaged var cpf: String?
    @NSManaged var dataNascimento: Date?
    @NSManaged var digitoRa: String
    @NSManaged var digitoRg: String?
    @NSManaged var email: String?
    @NSManaged var endereco: String?
    @NSManaged var idade: UInt16
    @NSManaged var latitude: Double
    @NSManaged var latitudeIndicativo: Double
    @NSManaged var localizacaoDiferenciada: UInt16
    @NSManaged var longitude: Double
    @NSManaged var longitudeIndicativo: Double
    @NSManaged var municipioNascimento: String?
    @NSManaged var nacionalidade: String?
    @NSManaged var nome: String
    @NSManaged var nomeMae: String?
    @NSManaged var nomePai: String?
    @NSManaged var numeroEndereco: UInt32
    @NSManaged var numeroRa: String
    @NSManaged var respondeRematricula: Bool
    @NSManaged var rg: String?
    @NSManaged var tipoLogradouro: UInt16
    @NSManaged var ufEndereco: String
    @NSManaged var ufNascimento: String
    @NSManaged var ufRa: String
    @NSManaged var carteirinha: Carteirinha?
    @NSManaged var interesseRematricula: InteresseRematricula?
    @NSManaged var usuario: Usuario
    @NSManaged var contatos: NSSet
    @NSManaged var escolas: NSSet
    @NSManaged var frequencias: NSSet
    @NSManaged var horariosAula: NSSet
    @NSManaged var matriculas: NSSet
    @NSManaged var notas: NSSet
    
    //MARK: Methods
    func maiorDeIdade() -> Bool {
        return idade >= Contants.maiorIdade
    }
}

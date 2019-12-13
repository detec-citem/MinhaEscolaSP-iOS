//
//  AlunoDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 16/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class AlunoDao {
    //MARK: Constants
    struct CamposServidor {
        static let bairro = "Bairro"
        static let cidade = "Cidade"
        static let codigoAluno = "CodigoAluno"
        static let complemento = "Complemento"
        static let contatoAluno = "ContatoAluno"
        static let cpf = "NumeroCpf"
        static let dataNascimento = "DataNascimento"
        static let digitoRa = "DigitoRA"
        static let digitoRg = "DigitoRg"
        static let emailAluno = "EmailAluno"
        static let enderecoAluno = "EnderecoAluno"
        static let id = "Id"
        static let idade = "Idade"
        static let interesseRematricula = "InteresseRematricula"
        static let latitude = "Latitude"
        static let longitude = "Longitude"
        static let latitudeIndicativo = "LatitudeIndicativo"
        static let longitudeIndicativo = "LongitudeIndicativo"
        static let localizacaoDiferenciada = "LocalizacaoDiferenciada"
        static let municipioNascimento = "MunicipioNascimento"
        static let nacionalidade = "Nacionalidade"
        static let nome = "Nome"
        static let nomeAluno = "NomeAluno"
        static let nomeDaMae = "NomeDaMae"
        static let nomeDoPai = "NomeDoPai"
        static let numeroDoCEP = "NumeroDoCEP"
        static let numeroEndereco = "NumeroEndereco"
        static let ra = "NumeroRA"
        static let rg = "NumeroRg"
        static let respondeRematricula = "RespondeRematricula"
        static let tipoLogradouro = "TipoLogradouro"
        static let ufEstado = "UfEstado"
        static let ufNascimento = "UfNascimento"
        static let ufRa = "UfRA"
    }
    
    //MARK: Methods
    static func buscarAlunos() -> [Aluno]? {
        return CoreDataManager.sharedInstance.getData(tabela: Tabelas.aluno, sortBy: "nome") as? [Aluno]
    }
    
    static func buscarAlunoComCodigo(codigo: UInt32) -> Aluno? {
        return CoreDataManager.sharedInstance.getData(tabela: Tabelas.aluno, predicate: NSPredicate(format: "codigoAluno == %d", codigo), unique: true)?.first as? Aluno
    }
    
    static func salvarAluno(json: [String:Any], responsavel: Bool) -> Aluno {
        if let bairro = json[CamposServidor.bairro] as? String, let cidadeEndereco = json[CamposServidor.cidade] as? String, let dataNascimento = json[CamposServidor.dataNascimento] as? String, let digitoRa = json[CamposServidor.digitoRa] as? String, let endereco = json[CamposServidor.enderecoAluno] as? String, let idade = json[CamposServidor.idade] as? UInt16, let localizacaoDiferenciada = json[CamposServidor.localizacaoDiferenciada] as? UInt16, let nacionalidade = json[CamposServidor.nacionalidade] as? String, let numeroDoCep = json[CamposServidor.numeroDoCEP] as? String, let numeroEndereco = json[CamposServidor.numeroEndereco] as? String, let numeroRa = json[CamposServidor.ra] as? String, let respondeRematricula = json[CamposServidor.respondeRematricula] as? Bool, let tipoLogradouro = json[CamposServidor.tipoLogradouro] as? String, let ufEstado = json[CamposServidor.ufEstado] as? String, let ufNascimento = json[CamposServidor.ufNascimento] as? String, let ufRa = json[CamposServidor.ufRa] as? String {
            var codigoAluno: UInt32 = 0
            if responsavel, let codigoAlunoJson = json[CamposServidor.codigoAluno] as? UInt32 {
                codigoAluno = codigoAlunoJson
            }
            else if let codigoAlunoJson = json[CamposServidor.id] as? UInt32 {
                codigoAluno = codigoAlunoJson
            }
            if let aluno = buscarAlunoComCodigo(codigo: codigoAluno) {
                aluno.bairroEndereco = bairro
                aluno.cep = numeroDoCep
                aluno.cidadeEndereco = cidadeEndereco
                aluno.digitoRa = digitoRa
                aluno.endereco = endereco
                aluno.idade = idade
                aluno.localizacaoDiferenciada = localizacaoDiferenciada
                aluno.nacionalidade = nacionalidade
                aluno.numeroRa = numeroRa
                aluno.respondeRematricula = respondeRematricula
                aluno.tipoLogradouro = UInt16(tipoLogradouro)!
                aluno.ufEndereco = ufEstado
                aluno.ufNascimento = ufNascimento
                aluno.ufRa = ufRa
                if let complemento = json[CamposServidor.complemento] as? String {
                    aluno.complementoEndereco = complemento
                }
                if let cpf = json[CamposServidor.cpf] as? String {
                    aluno.cpf = cpf
                }
                if let dataNascimentoDate = DateFormatter.defaultDateFormatter.date(from: dataNascimento) {
                    aluno.dataNascimento = dataNascimentoDate
                }
                if let digitoRg = json[CamposServidor.digitoRg] as? String {
                    aluno.digitoRg = digitoRg
                }
                if let email = json[CamposServidor.emailAluno] as? String {
                    aluno.email = email
                }
                if let latitude = json[CamposServidor.latitude] as? String, let latitudeDouble = Double(latitude) {
                    aluno.latitude = latitudeDouble
                }
                if let latitudeIndicativo = json[CamposServidor.latitudeIndicativo] as? String, let latitudeIndicativoDouble = Double(latitudeIndicativo) {
                    aluno.latitudeIndicativo = latitudeIndicativoDouble
                }
                if let longitude = json[CamposServidor.longitude] as? String, let longitudeDouble = Double(longitude) {
                    aluno.longitude = longitudeDouble
                }
                if let longitudeIndicativo = json[CamposServidor.longitudeIndicativo] as? String, let longitudeIndicativoDouble = Double(longitudeIndicativo) {
                    aluno.longitudeIndicativo = longitudeIndicativoDouble
                }
                if let municipioNascimento = json[CamposServidor.municipioNascimento] as? String {
                    aluno.municipioNascimento = municipioNascimento
                }
                if let nomeDaMae = json[CamposServidor.nomeDaMae] as? String {
                    aluno.nomeMae = nomeDaMae
                }
                if let nomeDoPai = json[CamposServidor.nomeDoPai] as? String {
                    aluno.nomePai = nomeDoPai
                }
                if let numeroEnderecoInt = UInt32(numeroEndereco) {
                    aluno.numeroEndereco = numeroEnderecoInt
                }
                if let rg = json[CamposServidor.rg] as? String {
                    aluno.rg = rg
                }
                if responsavel, let nomeAluno = json[CamposServidor.nomeAluno] as? String {
                    aluno.nome = nomeAluno
                }
                if !responsavel, let nome = json[CamposServidor.nome] as? String {
                    aluno.nome = nome
                }
                return aluno
            }
            let aluno: Aluno = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.aluno)
            aluno.bairroEndereco = bairro
            aluno.cep = numeroDoCep
            aluno.cidadeEndereco = cidadeEndereco
            aluno.codigoAluno = codigoAluno
            aluno.digitoRa = digitoRa
            aluno.endereco = endereco
            aluno.idade = idade
            aluno.localizacaoDiferenciada = localizacaoDiferenciada
            aluno.nacionalidade = nacionalidade
            aluno.numeroRa = numeroRa
            aluno.respondeRematricula = respondeRematricula
            aluno.tipoLogradouro = UInt16(tipoLogradouro)!
            aluno.ufEndereco = ufEstado
            aluno.ufNascimento = ufNascimento
            aluno.ufRa = ufRa
            if let complemento = json[CamposServidor.complemento] as? String {
                aluno.complementoEndereco = complemento
            }
            if let cpf = json[CamposServidor.cpf] as? String {
                aluno.cpf = cpf
            }
            if let dataNascimentoDate = DateFormatter.defaultDateFormatter.date(from: dataNascimento) {
                aluno.dataNascimento = dataNascimentoDate
            }
            if let digitoRg = json[CamposServidor.digitoRg] as? String {
                aluno.digitoRg = digitoRg
            }
            if let email = json[CamposServidor.emailAluno] as? String {
                aluno.email = email
            }
            if let latitude = json[CamposServidor.latitude] as? String, let latitudeDouble = Double(latitude) {
                aluno.latitude = latitudeDouble
            }
            if let latitudeIndicativo = json[CamposServidor.latitudeIndicativo] as? String, let latitudeIndicativoDouble = Double(latitudeIndicativo) {
                aluno.latitudeIndicativo = latitudeIndicativoDouble
            }
            if let longitude = json[CamposServidor.longitude] as? String, let longitudeDouble = Double(longitude) {
                aluno.longitude = longitudeDouble
            }
            if let longitudeIndicativo = json[CamposServidor.longitudeIndicativo] as? String, let longitudeIndicativoDouble = Double(longitudeIndicativo) {
                aluno.longitudeIndicativo = longitudeIndicativoDouble
            }
            if let municipioNascimento = json[CamposServidor.municipioNascimento] as? String {
                aluno.municipioNascimento = municipioNascimento
            }
            if let nomeDaMae = json[CamposServidor.nomeDaMae] as? String {
                aluno.nomeMae = nomeDaMae
            }
            if let nomeDoPai = json[CamposServidor.nomeDoPai] as? String {
                aluno.nomePai = nomeDoPai
            }
            if let numeroEnderecoInt = UInt32(numeroEndereco) {
                aluno.numeroEndereco = numeroEnderecoInt
            }
            if let rg = json[CamposServidor.rg] as? String {
                aluno.rg = rg
            }
            if responsavel, let nomeAluno = json[CamposServidor.nomeAluno] as? String {
                aluno.nome = nomeAluno
            }
            if !responsavel, let nome = json[CamposServidor.nome] as? String {
                aluno.nome = nome
            }
            return aluno
        }
        return Aluno()
    }
}

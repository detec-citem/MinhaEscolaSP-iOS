//
//  BuscarAlunosRequest.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 06/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreLocation
import Foundation

final class BuscarAlunosRequest {
    //MARK: Constants
    fileprivate struct Constants {
        static let ativo = "Ativo"
        static let buscarAlunosApi = "SedApi/Api/Usuario"
        static let buscarAlunosMock = "alunos"
        static let campoAlunos = "Alunos"
        static let campoContatoAluno = "ContatoAluno"
        static let campoEscolas = "Escolas"
        static let campoTurmas = "Turmas"
        static let encerrada = "Encerrada"
    }
    
    //MARK: Methods
    static func buscarAlunos(completion: @escaping ([Aluno]?, Bool, String?) -> Void) {
        if !Requests.Configuracoes.servidorHabilitado || LoginRequest.usuarioLogado.usuarioMock(), let json = Requests.getLocalJsonData(name: Constants.buscarAlunosMock) as? [String:Any] {
            processarAlunos(json: json, completion: completion)
        }
        else if let url = URL(string: Requests.Configuracoes.urlServidor + Constants.buscarAlunosApi) {
            Requests.requestData(request: URLRequest(url: url), httpMethod: .get) { (data, error) in
                if error != nil {
                    completion(nil, false, error)
                }
                else if let data = data as? Data, let json = Requests.parseJson(data: data) as? [String:Any] {
                    processarAlunos(json: json, completion: completion)
                }
            }
        }
    }
    
    fileprivate static func processarAlunos(json: [String:Any], completion: @escaping ([Aluno]?, Bool, String?) -> Void) {
        DispatchQueue.main.async {
            if let codigoResponsavel = json[UsuarioDao.CamposServidor.codigoResponsavel] as? UInt32 {
                LoginRequest.usuarioLogado.codigoUsuario = codigoResponsavel
            }
            if let email = json[UsuarioDao.CamposServidor.email] as? String {
                LoginRequest.usuarioLogado.email = email
            }
            if let telefonesResponsavel = json[UsuarioDao.CamposServidor.telefoneResponsavel] as? [[String:Any]] {
                for telefoneResponsavel in telefonesResponsavel {
                    ContatoDao.salvarContato(json: telefoneResponsavel, responsavel: true, usuario: LoginRequest.usuarioLogado)
                }
            }
            var alunosDict = [UInt32:Aluno]()
            if let alunosJson = json[Constants.campoAlunos] as? [[String:Any]] {
                alunosDict.reserveCapacity(alunosJson.count)
                for alunoJson in alunosJson {
                    let aluno = AlunoDao.salvarAluno(json: alunoJson, responsavel: true)
                    alunosDict[aluno.codigoAluno] = aluno
                    if let interessesRematricula = alunoJson[AlunoDao.CamposServidor.interesseRematricula] as? [[String:Any]], let interesseRematricula = interessesRematricula.first {
                        InteresseRematriculaDao.salvarInteresseRematricula(json: interesseRematricula, aluno: aluno)
                    }
                    if let contatosAluno = alunoJson[Constants.campoContatoAluno] as? [[String:Any]] {
                        for contatoAluno in contatosAluno {
                            ContatoDao.salvarContato(json: contatoAluno, responsavel: false, aluno: aluno)
                        }
                    }
                    if let turmas = alunoJson[Constants.campoTurmas] as? [[String:Any]] {
                        for turma in turmas {
                            TurmaDao.salvarTurma(json: turma, responsavel: true, aluno: aluno)
                        }
                    }
                }
            }
            let dispatchGroup = DispatchGroup()
            if let escolasJson = json[Constants.campoEscolas] as? [[String:Any]] {
                for escolaJson in escolasJson {
                    if let codigoAluno = escolaJson[AlunoDao.CamposServidor.codigoAluno] as? UInt32, let aluno = alunosDict[codigoAluno] {
                        let escola = EscolaDao.salvarEscola(json: escolaJson, aluno: aluno)
                        if let telefonesUnidade = escolaJson[ContatoEscolaDao.CamposServidor.telefoneUnidade] as? [[String:String]] {
                            for telefoneUnidade in telefonesUnidade {
                                if let telefone = telefoneUnidade[ContatoEscolaDao.CamposServidor.contatoEscola] {
                                    ContatoEscolaDao.salvarContato(telefone: telefone, escolaAluno: escola)
                                }
                            }
                        }
                        if let enderecoUnidade = escola.enderecoUnidade {
                            dispatchGroup.enter()
                            CLGeocoder().geocodeAddressString(enderecoUnidade, completionHandler: { (placemarks, error) in
                                if let localizacao = placemarks?.first?.location?.coordinate {
                                    escola.latitude = localizacao.latitude
                                    escola.longitude = localizacao.longitude
                                }
                                dispatchGroup.leave()
                            })
                        }
                    }
                }
            }
            dispatchGroup.notify(queue: .main, execute: {
                CoreDataManager.sharedInstance.saveContext()
                let alunos = [Aluno](alunosDict.values)
                completion(alunos, true, nil)
            })
        }
    }
}

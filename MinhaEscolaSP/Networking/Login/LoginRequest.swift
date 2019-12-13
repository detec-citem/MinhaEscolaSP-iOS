//
//  LoginRequest.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 13/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreLocation
import Foundation

final class LoginRequest: NSObject {
    //MARK: Constants
    fileprivate struct Constants {
        static let appMinhaEscolaSP = "App Minha Escola SP"
        static let ativo = "Ativo"
        static let campoContatoAluno = "ContatoAluno"
        static let campoEscolas = "Escolas"
        static let campoTurmas = "Turmas"
        static let encerrada = "Encerrada"
        static let loginApi = "SedApi/Api/Login"
        static let loginAlunoMock = "login_aluno"
        static let loginResponsavelMock = "login_responsavel"
        static let parametroAluno = "aluno"
        static let parametroRefLogin = "RefLogin"
        static let parametroSenha = "senha"
        static let parametroToken = "&token="
        static let parametroUsuario = "user"
        static let rg = "rg"
        static let selecionarPerfilApi = "SedApi/Api/Login/SelecionarPerfil?perfilSelecionado="
    }
    
    //MARK: Variables
    static var usuarioLogado: Usuario!
    
    //MARK: Methods
    static func fazerLogin(login: String, password: String, perfil: UsuarioDao.Perfil, completion: @escaping ((String?, Bool, String?) -> Void)) {
        if !Requests.Configuracoes.servidorHabilitado || (perfil == .aluno && password == Requests.Configuracoes.LoginTesteApple.Aluno.senha && login == Requests.Configuracoes.LoginTesteApple.Aluno.ra + Requests.Configuracoes.LoginTesteApple.Aluno.digitoRa + Requests.Configuracoes.LoginTesteApple.Aluno.uf) || (perfil == .responsavel && ((password == Requests.Configuracoes.LoginTesteApple.ResponsavelRg.senha && login == Constants.rg + Requests.Configuracoes.LoginTesteApple.ResponsavelRg.rg + Requests.Configuracoes.LoginTesteApple.ResponsavelRg.digitoRg + Requests.Configuracoes.LoginTesteApple.ResponsavelRg.uf) || (password == Requests.Configuracoes.LoginTesteApple.ResponsavelRne.senha && login == Requests.Configuracoes.LoginTesteApple.ResponsavelRne.rne))) {
            if perfil == .aluno, let jsonLogin = Requests.getLocalJsonData(name: Constants.loginAlunoMock) as? [String:Any] {
                processarLoginAluno(login: login, password: password, perfil: perfil, json: jsonLogin, completion: completion)
            }
            else if perfil == .responsavel, let jsonLogin = Requests.getLocalJsonData(name: Constants.loginResponsavelMock) as? [String:Any] {
                processarLoginResponsavel(login: login, password: password, perfil: perfil, json: jsonLogin, completion: completion)
            }
        }
        else if let url = URL(string: Requests.Configuracoes.urlServidor + Constants.loginApi) {
            var params: [String:Any] = [Constants.parametroRefLogin:Constants.appMinhaEscolaSP,Constants.parametroUsuario:login,Constants.parametroSenha:password]
            if perfil == .aluno {
                params[Constants.parametroAluno] = true
            }
            var request = URLRequest(url: url)
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params)
                Requests.requestData(request: request, httpMethod: .post, completion: { data, error in
                    if error == nil, let data = data as? Data, let jsonLogin = Requests.parseJson(data: data) as? [String:Any] {
                        if let token = jsonLogin[UsuarioDao.CamposServidor.token] as? String {
                            usuarioLogado?.token = token
                            if perfil == .aluno {
                                processarLoginAluno(login: login, password: password, token: token, perfil: perfil, json: jsonLogin, completion: completion)
                            }
                            else {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                    if let url = URL(string: Requests.Configuracoes.urlServidor + Constants.selecionarPerfilApi + String(perfil.rawValue) + Constants.parametroToken + token) {
                                        Requests.requestData(request: URLRequest(url: url), httpMethod: .get, completion: { data, erro in
                                            if data != nil {
                                                processarLoginResponsavel(login: login, password: password, perfil: perfil, json: jsonLogin, completion: completion)
                                            }
                                            else {
                                                completion(token, false, erro)
                                            }
                                        })
                                    }
                                })
                            }
                        }
                        else {
                            completion(nil, false, error)
                        }
                    }
                    else {
                        completion(nil, false, error)
                    }
                })
            }
            catch {
                completion(nil, false, error.localizedDescription)
            }
        }
    }
    
    fileprivate static func processarLoginAluno(login: String, password: String, token: String? = nil, perfil: UsuarioDao.Perfil, json:[String:Any], completion: @escaping (String?, Bool, String?) -> Void) {
        DispatchQueue.main.async {
            let aluno = AlunoDao.salvarAluno(json: json, responsavel: false)
            let usuario = UsuarioDao.salvarUsuario(json: json, perfil: perfil, user: login, senha: password)
            usuario.aluno = aluno
            usuarioLogado = usuario
            if let interessesRematricula = json[AlunoDao.CamposServidor.interesseRematricula] as? [[String:Any]], let interesseRematricula = interessesRematricula.first {
                InteresseRematriculaDao.salvarInteresseRematricula(json: interesseRematricula, aluno: aluno)
            }
            if let contatosAluno = json[Constants.campoContatoAluno] as? [[String:Any]] {
                for contatoAluno in contatosAluno {
                    ContatoDao.salvarContato(json: contatoAluno, responsavel: false, aluno: aluno)
                }
            }
            if let turmas = json[Constants.campoTurmas] as? [[String:Any]] {
                for turma in turmas {
                    TurmaDao.salvarTurma(json: turma, responsavel: false, aluno: aluno)
                }
            }
            let dispatchGroup = DispatchGroup()
            if let escolas = json[Constants.campoEscolas] as? [[String:Any]] {
                for escola in escolas {
                    let escolaAluno = EscolaDao.salvarEscola(json: escola, aluno: aluno)
                    if let telefonesUnidade = escola[ContatoEscolaDao.CamposServidor.telefoneUnidade] as? [[String:String]] {
                        for telefoneUnidade in telefonesUnidade {
                            if let telefone = telefoneUnidade[ContatoEscolaDao.CamposServidor.contatoEscola] {
                                ContatoEscolaDao.salvarContato(telefone: telefone, escolaAluno: escolaAluno)
                            }
                        }
                    }
                    if let enderecoUnidade = escolaAluno.enderecoUnidade {
                        dispatchGroup.enter()
                        CLGeocoder().geocodeAddressString(enderecoUnidade, completionHandler: { (placemarks, error) in
                            if let localizacao = placemarks?.first?.location?.coordinate {
                                escolaAluno.latitude = localizacao.latitude
                                escolaAluno.longitude = localizacao.longitude
                            }
                            dispatchGroup.leave()
                        })
                    }
                }
            }
            dispatchGroup.notify(queue: .main, execute: {
                CoreDataManager.sharedInstance.saveContext()
                completion(token, true, nil)
            })
        }
    }
    
    fileprivate static func processarLoginResponsavel(login: String, password: String, token: String? = nil, perfil: UsuarioDao.Perfil, json: [String:Any], completion: @escaping (String?, Bool, String?) -> Void) {
        usuarioLogado = UsuarioDao.salvarUsuario(json: json, perfil: perfil, user: login, senha: password)
        BuscarAlunosRequest.buscarAlunos(completion: { (_, sucesso, erro) in
            if sucesso {
                completion(token, true, nil)
            }
            else {
                completion(nil, false, erro)
            }
        })
    }
}

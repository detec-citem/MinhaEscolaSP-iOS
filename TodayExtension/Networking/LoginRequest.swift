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
        static let loginApi = "SedApi/Api/Login"
        static let loginAlunoMock = "login_aluno"
        static let parametroAluno = "aluno"
        static let parametroRefLogin = "RefLogin"
        static let parametroSenha = "senha"
        static let parametroToken = "&token="
        static let parametroUsuario = "user"
    }
    
    //MARK: Variables
    static var usuarioLogado: Usuario!
    
    //MARK: Methods
    static func fazerLogin(login: String, password: String, perfil: UsuarioDao.Perfil, completion: @escaping ((String?, Bool, String?) -> Void)) {
        if !Requests.Configuracoes.servidorHabilitado || (perfil == .aluno && password == Requests.Configuracoes.LoginTesteApple.Aluno.senha && login == Requests.Configuracoes.LoginTesteApple.Aluno.ra + Requests.Configuracoes.LoginTesteApple.Aluno.digitoRa + Requests.Configuracoes.LoginTesteApple.Aluno.uf) {
            if perfil == .aluno, let jsonLogin = Requests.getLocalJsonData(name: Constants.loginAlunoMock) as? [String:Any] {
                processarLoginAluno(login: login, password: password, perfil: perfil, json: jsonLogin, completion: completion)
            }
        }
        else if let url = URL(string: Requests.Configuracoes.urlServidor + Constants.loginApi) {
            let params: [String:Any] = [Constants.parametroAluno:true,Constants.parametroRefLogin:Constants.appMinhaEscolaSP,Constants.parametroUsuario:login, Constants.parametroSenha:password]
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
            CoreDataManager.sharedInstance.saveContext()
            completion(token, true, nil)
        }
    }
}

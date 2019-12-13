//
//  Requests.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 13/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Reachability

final class Requests {
    //MARK: Constants
    fileprivate struct Constants {
        static let campoErro = "Erro"
        static let campoMensagem = "Message"
        static let jsonFileExtension = "json"
        static let timeoutInterval: TimeInterval = 120
    }
    
    fileprivate struct HttpHeaderFieldsKey {
        static let acceptEncoding = "Accept-Encoding"
        static let authorization = "Authorization"
        static let contentType = "Content-Type"
    }
    
    fileprivate struct HttpHeaderFieldsValue {
        static let acceptEncoding = "gzip"
        static let contentTypeFormData = "application/x-www-form-urlencoded; charset=UTF-8"
        static let contentTypeJson = "application/json"
    }
    
    fileprivate struct HttpStatusCode {
        static let error = 201
        static let forbiddenAccess1 = 400
        static let forbiddenAccess2 = 401
        static let internalServerError = 500
        static let notFound = 404
        static let sucess1 = 200
        static let sucess2 = 202
        static let sucess3 = 300
    }
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    struct Configuracoes {
        fileprivate struct UrlsServidor {
            static let producao = "https://sed.educacao.sp.gov.br/"
            static let homologacao = "https://homologacaosed.educacao.sp.gov.br/"
        }
        
        static var servidorHabilitado: Bool = true
        
        struct LoginTeste {
            struct Aluno {
                //Aline
                //static let ra = "104351122"
                //static let digitoRa = "2"
                //static let senha = "01022001"
                //static let uf = "sp"

                //Beatriz
                static let ra = "108640106"
                static let digitoRa = "2"
                static let senha = "12345678"
                static let uf = "sp"
            }
            
            struct Responsável {
                //Iolanda
                static let rg = "26529906"
                static let digitoRg = "8"
                static let senha = "12345678"
                static let uf = "sp"
            }
        }
        
        struct LoginTesteApple {
            struct Aluno {
                static let ra = "000000000"
                static let digitoRa = "0"
                static let senha = "12345678"
                static let uf = "sp"
            }
            
            struct ResponsavelRg {
                static let rg = "00000000"
                static let digitoRg = "0"
                static let senha = "12345678"
                static let uf = "sp"
            }
            
            struct ResponsavelRne {
                static let rne = "000000000"
                static let senha = "12345678"
            }
        }
        
        #if DEBUG
            static let urlServidor: String = UrlsServidor.homologacao
            static let producaoHabilitado: Bool = false
        #else
            static let urlServidor: String = UrlsServidor.producao
            static let producaoHabilitado: Bool = true
        #endif
    }
    
    //MARK: Methods
    static func conectadoInternet() -> Bool {
        if Reachability.forInternetConnection().isReachable() {
            return true
        }
        return false
    }
    
    static func getLocalJsonData(name: String) -> Any? {
        if let path = Bundle.main.path(forResource: name, ofType: Constants.jsonFileExtension) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                return json
            }
            catch {
            }
        }
        return nil
    }
    
    static func parseJson(data: Data) -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: data)
        }
        catch {
        }
        return nil
    }
    
    static func requestData(json: Bool = true, request: URLRequest, httpMethod: HttpMethod, completion: ((Any?, String?) -> Void)?) {
        var request = request
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = Constants.timeoutInterval
        request.httpMethod = httpMethod.rawValue
        request.setValue(HttpHeaderFieldsValue.acceptEncoding, forHTTPHeaderField: HttpHeaderFieldsKey.acceptEncoding)
        if json {
            request.setValue(HttpHeaderFieldsValue.contentTypeJson, forHTTPHeaderField: HttpHeaderFieldsKey.contentType)
        }
        else {
            request.setValue(HttpHeaderFieldsValue.contentTypeFormData, forHTTPHeaderField: HttpHeaderFieldsKey.contentType)
        }
        if let token = LoginRequest.usuarioLogado?.token {
            request.setValue(token, forHTTPHeaderField: HttpHeaderFieldsKey.authorization)
        }
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse, error == nil {
                switch response.statusCode {
                case HttpStatusCode.sucess1, HttpStatusCode.sucess2 ..< HttpStatusCode.sucess3:
                    completion?(data, nil)
                case HttpStatusCode.error:
                    if let data = data {
                        if let json = parseJson(data: data) as? [String:Any] {
                            if let errorMessage = json[Constants.campoErro] as? String {
                                completion?(nil, errorMessage)
                            }
                            else if let errorMessage = json[Constants.campoMensagem] as? String {
                                completion?(nil, errorMessage)
                            }
                        }
                        else if let errorMessage = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\"", with: "") {
                            completion?(nil, errorMessage)
                        }
                    }
                case HttpStatusCode.forbiddenAccess1:
                    if let data = data, let json = parseJson(data: data) as? [String:Any], let erro = json[Constants.campoErro] as? String {
                        completion?(nil, erro)
                    }
                    else if let usuarioLogado = LoginRequest.usuarioLogado {
                        LoginRequest.fazerLogin(login: usuarioLogado.usuario, password: usuarioLogado.senha, perfil: UsuarioDao.Perfil(rawValue: usuarioLogado.perfil)!, completion: { _, sucess, _ in
                            if sucess {
                                requestData(request: request, httpMethod: httpMethod, completion: completion)
                            }
                            else {
                                completion?(nil, Localizable.algoDeErradoAconteceu.localized)
                            }
                        })
                    }
                    else {
                        completion?(nil, Localizable.algoDeErradoAconteceu.localized)
                    }
                case HttpStatusCode.forbiddenAccess2:
                    completion?(nil, "Acesso negado. Tente novamente.")
                case HttpStatusCode.notFound:
                    completion?(nil, "Não encontrado. Tente novamente.")
                case let x where x >= HttpStatusCode.internalServerError:
                    completion?(nil, "Erro do servidor. Tente novamente.")
                default:
                    completion?(nil, Localizable.algoDeErradoAconteceu.localized)
                }
            }
            else if error?._code == NSURLErrorTimedOut {
                completion?(nil, "Timeout de requisição. Conecte-se a uma internet mais rápida e tente novamente.")
            }
            else {
                completion?(nil, "Sem resposta do servidor. Tente novamente.")
            }
        }.resume()
    }
}

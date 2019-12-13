//
//  EnviarInformacoes.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 14/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class EnviarInformacoes {
    //MARK: Constants
    fileprivate struct Constants {
        static let campoCodigo = "Codigo"
        static let enviarInformacoesApi = "SedApi/Api/FichaAluno/Alunos"
        static let extensaoJpeg = ".jpg"
        static let extensaoPdf = ".pdf"
        static let operacaoAlterar = 2
        static let operacaoInserir = 1
        static let operacaoDeletar = 3
        static let parametroAceiteTermoResponsabilidade = "inFl_AceiteTermoResponsabilidade"
        static let parametroAnoLetivo = "inAnoletivo"
        static let parametroAnoLetivoRematricula = "inAnoletivoRematricula"
        static let parametroBairro = "inBairro"
        static let parametroBinarioArquivo = "inBinarioArquivo"
        static let parametroCep = "inCep"
        static let parametroCidade = "inCidade"
        static let parametroCodigoAluno = "inCodigoAluno"
        static let parametroCodigoInteresseRematricula = "inCodigoInteresseRematricula"
        static let parametroCodigoLocalizacaoDiferenciada = "inCodigoLocalizacaoDiferenciada"
        static let parametroCodigoMatriculaOrigem = "inCodigoMatriculaOrigem"
        static let parametroCodigoMunicipioDNE = "inCodigoMunicipioDNE"
        static let parametroCodigoObservacaoOpcaoNoturno = "inCodigoObservacaoOpcaoNoturno"
        static let parametroCodigoOperacao = "inCodigoOperacao"
        static let parametroCodigoResponsavel = "inCodigoResponsavel"
        static let parametroCodigoSistemaInteresseRematricula = "inCodigoSistemaInteresseRematricula"
        static let parametroCodigoTelefoneAluno = "inCodigoTelefoneAluno"
        static let parametroCodigoTelefoneResponsavel = "inCodigoTelefoneResponsavel"
        static let parametroCodigoVerificador = "inCodigoVerificador"
        static let parametroComplemento = "inComplemento"
        static let parametroContatoAluno = "enContatoAluno"
        static let parametroContatoResponsavelAluno = "enContatoResponsavelAluno"
        static let parametroDdd = "inDDD"
        static let parametroEixoEnsinoProfissionalUm = "inEixoEnsinoProfissionalUm"
        static let parametroEixoEnsinoProfissionalDois = "inEixoEnsinoProfissionalDois"
        static let parametroEixoEnsinoProfissionalTres = "inEixoEnsinoProfissionalTres"
        static let parametroEmail = "inEmail"
        static let parametroEnviaSms = "inEnviaSMS"
        static let parametroEmailResponsavel = "inEmailResponsavel"
        static let parametroEnderecoAluno = "enEnderecoAluno"
        static let parametroInteresseContinuidade = "inFl_InteresseContinuidade"
        static let parametroInteresseEspanhol = "inFl_InteresseEspanhol"
        static let parametroInteresseNoturno = "inFl_InteresseTurnoNoturno"
        static let parametroInteresseNovoTec = "inFl_InteresseNovoTec"
        static let parametroInteresseRematricula = "enInteresseRematricula"
        static let parametroInteresseTurnoIntegral = "inFl_InteresseTurnoIntegral"
        static let parametroLatitude = "inLatitude"
        static let parametroLatitudeIndi = "inLatitudeIndi"
        static let parametroListaTelefonesAluno = "lstTelefoneAluno"
        static let parametroListaTelefonesResponsavelAluno = "lstTelefoneResponsavelAluno"
        static let parametroLogradouro = "inLogradouro"
        static let parametroLongitude = "inLongitude"
        static let parametroLongitudeIndi = "inLongitudeIndi"
        static let parametroNomeExtensaoAruqivo = "inNomeExtensaoArquivo"
        static let parametroNumero = "inNumero"
        static let parametroResponsavelAluno = "enResponsavelAluno"
        static let parametroTipoTelefone = "inTipoTelefone"
        static let parametroUf = "inUF"
        static let parametroZonaLogradouro = "inZonaLogradouro"
    }
    
    //MARK: Methods
    static func enviarInformacoes(comprovanteImagem: Bool, editouEmailAluno: Bool, editouEmailResponsavel: Bool, editouEndereco: Bool, editouInteresseRematricula: Bool, editouTelefonesAluno: Bool, editouTelefonesResponsavel: Bool, emailResponsavelNecessario: Bool, comprovante: Data?, aluno: Aluno, interesseRematricula: InteresseRematricula?, turmaAtiva: Turma, telefonesAdicionadosAluno: [Contato], telefonesAlteradosAluno: [Contato], telefonesAdicionadosResponsavel: [Contato], telefonesAlteradosResponsavel: [Contato], completion: @escaping (Bool, String?, UInt32?) -> Void) {
        var codigoInteresseRematricula: UInt32 = 0
        if let interesseRematricula = interesseRematricula {
            codigoInteresseRematricula = interesseRematricula.codigoInteresseRematricula
        }
        if !Requests.Configuracoes.servidorHabilitado || LoginRequest.usuarioLogado.usuarioMock() {
            sucessoEnvioInformacoes(editouTelefonesAluno: editouTelefonesAluno, editouTelefonesResponsavel: editouTelefonesResponsavel, codigoInteresseRematricula: codigoInteresseRematricula, telefonesAlteradosAluno: telefonesAlteradosAluno, telefonesAlteradosResponsavel: telefonesAlteradosResponsavel, completion: completion)
        }
        else {
            var parametros = [String:Any]()
            if editouEmailAluno, let email = aluno.email {
                parametros[Constants.parametroContatoAluno] = [Constants.parametroCodigoAluno:aluno.codigoAluno,Constants.parametroEmail:email]
            }
            else {
                parametros[Constants.parametroContatoAluno] = [:]
            }
            if editouInteresseRematricula, let interesseRematricula = interesseRematricula {
                let anoLetivo = turmaAtiva.anoLetivo
                let cursosTecnicos = interesseRematricula.cursoTecnico.components(separatedBy: InteresseRematriculaDao.Constants.separadorCursosTecnicos)
                var parametrosInteresseRematricula: [String:Any] = [Constants.parametroCodigoResponsavel:0,Constants.parametroCodigoSistemaInteresseRematricula:2,Constants.parametroCodigoInteresseRematricula:interesseRematricula.codigoInteresseRematricula,Constants.parametroCodigoAluno:aluno.codigoAluno,Constants.parametroCodigoObservacaoOpcaoNoturno:interesseRematricula.codigoOpcaoNoturno,Constants.parametroAnoLetivo:anoLetivo,Constants.parametroAnoLetivoRematricula:anoLetivo+1,Constants.parametroAceiteTermoResponsabilidade:interesseRematricula.aceitoTermoResponsabilidade,Constants.parametroInteresseContinuidade:interesseRematricula.interesseContinuidade,Constants.parametroInteresseEspanhol:interesseRematricula.interesseEspanhol,Constants.parametroInteresseNoturno:interesseRematricula.interesseTurnoNoturno,Constants.parametroInteresseNovoTec:interesseRematricula.interesseNovotec,Constants.parametroInteresseTurnoIntegral:interesseRematricula.interesseTurnoIntegral,Constants.parametroCodigoMatriculaOrigem:turmaAtiva.codigoMatriculaAluno]
                if let primeiroCursoTecnico = cursosTecnicos.first, let eixoEnsinoProfissionalUm = CursosTecnicos.cursosTecnicos.firstIndex(of: primeiroCursoTecnico) {
                    parametrosInteresseRematricula[Constants.parametroEixoEnsinoProfissionalUm] = eixoEnsinoProfissionalUm
                }
                else {
                    parametrosInteresseRematricula[Constants.parametroEixoEnsinoProfissionalUm] = 0
                }
                if cursosTecnicos.count > 1, let eixoEnsinoProfissionalDois = CursosTecnicos.cursosTecnicos.firstIndex(of: cursosTecnicos[1]) {
                    parametrosInteresseRematricula[Constants.parametroEixoEnsinoProfissionalDois] = eixoEnsinoProfissionalDois
                }
                else {
                    parametrosInteresseRematricula[Constants.parametroEixoEnsinoProfissionalDois] = 0
                }
                if cursosTecnicos.count > 2, let eixoEnsinoProfissionalTres = CursosTecnicos.cursosTecnicos.firstIndex(of: cursosTecnicos[2]) {
                    parametrosInteresseRematricula[Constants.parametroEixoEnsinoProfissionalTres] = eixoEnsinoProfissionalTres
                }
                else {
                    parametrosInteresseRematricula[Constants.parametroEixoEnsinoProfissionalTres] = 0
                }
                parametros[Constants.parametroInteresseRematricula] = parametrosInteresseRematricula
            }
            else {
                parametros[Constants.parametroInteresseRematricula] = [:]
            }
            if editouTelefonesAluno {
                var telefonesAluno = [[String:Any]]()
                for telefoneAdicionadoAluno in telefonesAdicionadosAluno {
                    if telefoneAdicionadoAluno.operacao != ContatoDao.Contants.operacaoDeletar {
                        telefonesAluno.append([Constants.parametroCodigoVerificador:0,Constants.parametroComplemento:telefoneAdicionadoAluno.complemento,Constants.parametroCodigoOperacao:Constants.operacaoInserir,Constants.parametroCodigoAluno:aluno.codigoAluno,Constants.parametroCodigoTelefoneAluno:telefoneAdicionadoAluno.codigo,Constants.parametroTipoTelefone:telefoneAdicionadoAluno.codigoTipoTelefone,Constants.parametroDdd:String(telefoneAdicionadoAluno.codigoDdd),Constants.parametroNumero:telefoneAdicionadoAluno.telefone])
                    }
                }
                for telefoneAlteradoAluno in telefonesAlteradosAluno {
                    var codigoOperacao: Int!
                    var parametrosTelefone: [String:Any] = [Constants.parametroCodigoVerificador:0,Constants.parametroComplemento:telefoneAlteradoAluno.complemento,Constants.parametroCodigoAluno:aluno.codigoAluno,Constants.parametroCodigoTelefoneAluno:telefoneAlteradoAluno.codigo,Constants.parametroTipoTelefone:telefoneAlteradoAluno.codigoTipoTelefone,Constants.parametroDdd:String(telefoneAlteradoAluno.codigoDdd),Constants.parametroNumero:telefoneAlteradoAluno.telefone]
                    if telefoneAlteradoAluno.operacao == ContatoDao.Contants.operacaoDeletar {
                        codigoOperacao = Constants.operacaoDeletar
                    }
                    else if telefoneAlteradoAluno.operacao == ContatoDao.Contants.operacaoAlterar  {
                        codigoOperacao = Constants.operacaoAlterar
                    }
                    parametrosTelefone[Constants.parametroCodigoOperacao] = codigoOperacao
                    telefonesAluno.append(parametrosTelefone)
                }
                parametros[Constants.parametroListaTelefonesAluno] = telefonesAluno
            }
            else {
                parametros[Constants.parametroListaTelefonesAluno] = [[:]]
            }
            if editouEmailResponsavel || editouTelefonesResponsavel, let usuarioLogado = LoginRequest.usuarioLogado {
                let codigoResponsavel = LoginRequest.usuarioLogado!.codigoUsuario
                var parametrosResponsavel: [String:Any] = [Constants.parametroCodigoResponsavel:codigoResponsavel]
                if editouEmailResponsavel, let email = usuarioLogado.email {
                    let codigoOperacao: Int!
                    if emailResponsavelNecessario {
                        codigoOperacao = Constants.operacaoInserir
                    }
                    else {
                        codigoOperacao =  Constants.operacaoAlterar
                    }
                    parametrosResponsavel[Constants.parametroContatoResponsavelAluno] = [Constants.parametroCodigoResponsavel:codigoResponsavel,Constants.parametroEmailResponsavel:email,Constants.parametroCodigoOperacao:codigoOperacao!]
                }
                else {
                    parametrosResponsavel[Constants.parametroContatoResponsavelAluno] = [:]
                }
                if editouTelefonesResponsavel {
                    var telefonesResponsavel = [[String:Any]]()
                    for telefoneAdicionadoResponsavel in telefonesAdicionadosResponsavel {
                        if telefoneAdicionadoResponsavel.operacao != ContatoDao.Contants.operacaoDeletar {
                            telefonesResponsavel.append([Constants.parametroCodigoVerificador:0,Constants.parametroComplemento:telefoneAdicionadoResponsavel.complemento,Constants.parametroEnviaSms:telefoneAdicionadoResponsavel.validacaoSms,Constants.parametroCodigoOperacao:Constants.operacaoInserir,Constants.parametroCodigoResponsavel:codigoResponsavel,Constants.parametroCodigoTelefoneResponsavel:telefoneAdicionadoResponsavel.codigo,Constants.parametroTipoTelefone:telefoneAdicionadoResponsavel.codigoTipoTelefone,Constants.parametroDdd:String(telefoneAdicionadoResponsavel.codigoDdd),Constants.parametroNumero:telefoneAdicionadoResponsavel.telefone])
                        }
                    }
                    for telefoneAlteradoResponsavel in telefonesAlteradosResponsavel {
                        var codigoOperacao: Int!
                        var parametrosTelefone: [String:Any] = [Constants.parametroCodigoVerificador:0,Constants.parametroComplemento:telefoneAlteradoResponsavel.complemento,Constants.parametroEnviaSms:telefoneAlteradoResponsavel.validacaoSms,Constants.parametroCodigoResponsavel:codigoResponsavel,Constants.parametroCodigoTelefoneResponsavel:telefoneAlteradoResponsavel.codigo,Constants.parametroTipoTelefone:telefoneAlteradoResponsavel.codigoTipoTelefone,Constants.parametroDdd:String(telefoneAlteradoResponsavel.codigoDdd),Constants.parametroNumero:telefoneAlteradoResponsavel.telefone]
                        if telefoneAlteradoResponsavel.operacao == ContatoDao.Contants.operacaoDeletar {
                            codigoOperacao = Constants.operacaoDeletar
                        }
                        else if telefoneAlteradoResponsavel.operacao == ContatoDao.Contants.operacaoAlterar  {
                            codigoOperacao = Constants.operacaoAlterar
                        }
                        parametrosTelefone[Constants.parametroCodigoOperacao] = codigoOperacao
                        telefonesResponsavel.append(parametrosTelefone)
                    }
                    parametrosResponsavel[Constants.parametroListaTelefonesResponsavelAluno] = telefonesResponsavel
                }
                else {
                    parametrosResponsavel[Constants.parametroListaTelefonesResponsavelAluno] = [[:]]
                }
                parametros[Constants.parametroResponsavelAluno] = parametrosResponsavel
            }
            else {
                parametros[Constants.parametroResponsavelAluno] = [Constants.parametroCodigoResponsavel:0,Constants.parametroContatoResponsavelAluno:[:],Constants.parametroListaTelefonesResponsavelAluno:[[:]]]
            }
            if editouEndereco {
                let latitude = String(aluno.latitude)
                let longitude = String(aluno.longitude)
                var parametrosEnderecoAluno: [String:Any] = [Constants.parametroCodigoAluno:aluno.codigoAluno,Constants.parametroNumero:String(aluno.numeroEndereco),Constants.parametroBairro:aluno.bairroEndereco,Constants.parametroCidade:aluno.cidadeEndereco,Constants.parametroUf:aluno.ufEndereco,Constants.parametroCep:aluno.cep.replacingOccurrences(of: "-", with: ""),Constants.parametroCodigoMunicipioDNE:Municipios.municipiosDict[aluno.cidadeEndereco.uppercased().folding(options: .diacriticInsensitive, locale: .current)]!,Constants.parametroLatitude:latitude,Constants.parametroLatitudeIndi:latitude,Constants.parametroLongitude:longitude,Constants.parametroLongitudeIndi:longitude,Constants.parametroZonaLogradouro:String(aluno.tipoLogradouro),Constants.parametroCodigoLocalizacaoDiferenciada:aluno.localizacaoDiferenciada]
                if let complemento = aluno.complementoEndereco {
                    parametrosEnderecoAluno[Constants.parametroComplemento] = complemento
                }
                if let endereco = aluno.endereco {
                    parametrosEnderecoAluno[Constants.parametroLogradouro] = endereco
                }
                if let comprovante = comprovante {
                    var extensaoArquivo: String!
                    if comprovanteImagem {
                        extensaoArquivo = Constants.extensaoJpeg
                    }
                    else {
                        extensaoArquivo = Constants.extensaoPdf
                    }
                    parametrosEnderecoAluno[Constants.parametroNomeExtensaoAruqivo] = extensaoArquivo!
                    parametrosEnderecoAluno[Constants.parametroBinarioArquivo] = comprovante.base64EncodedString()
                }
                parametros[Constants.parametroEnderecoAluno] = parametrosEnderecoAluno
            }
            else {
                parametros[Constants.parametroEnderecoAluno] = [:]
            }
            if let url = URL(string: Requests.Configuracoes.urlServidor + Constants.enviarInformacoesApi) {
                var request = URLRequest(url: url)
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parametros)
                }
                catch {
                    completion(false, error.localizedDescription, nil)
                }
                Requests.requestData(request: request, httpMethod: .post, completion: { (data,erro) in
                    DispatchQueue.main.async {
                        if let erro = erro {
                            completion(false, erro, nil)
                        }
                        else if let data = data as? Data, let json = Requests.parseJson(data: data) as? [String:Any], let codigoInteresseRematriculaString = json[Constants.campoCodigo] as? String, let codigoInteresseRematricula = UInt32(codigoInteresseRematriculaString) {
                            sucessoEnvioInformacoes(editouTelefonesAluno: editouTelefonesAluno, editouTelefonesResponsavel: editouTelefonesResponsavel, codigoInteresseRematricula: codigoInteresseRematricula, telefonesAlteradosAluno: telefonesAlteradosAluno, telefonesAlteradosResponsavel: telefonesAlteradosResponsavel, completion: completion)
                        }
                    }
                })
            }
        }
    }
    
    fileprivate static func sucessoEnvioInformacoes(editouTelefonesAluno: Bool, editouTelefonesResponsavel: Bool, codigoInteresseRematricula: UInt32, telefonesAlteradosAluno: [Contato], telefonesAlteradosResponsavel: [Contato], completion: (Bool, String?, UInt32?) -> Void) {
        if editouTelefonesAluno {
            for telefoneAlteradoAluno in telefonesAlteradosAluno {
                if telefoneAlteradoAluno.operacao == ContatoDao.Contants.operacaoDeletar {
                    CoreDataManager.sharedInstance.deleteObject(object: telefoneAlteradoAluno)
                }
                else {
                    telefoneAlteradoAluno.operacao = .zero
                }
            }
        }
        if editouTelefonesResponsavel {
            for telefoneAlteradoResponsavel in telefonesAlteradosResponsavel {
                if telefoneAlteradoResponsavel.operacao == ContatoDao.Contants.operacaoDeletar {
                    CoreDataManager.sharedInstance.deleteObject(object: telefoneAlteradoResponsavel)
                }
                else {
                    telefoneAlteradoResponsavel.operacao = .zero
                }
            }
        }
        CoreDataManager.sharedInstance.saveContext()
        completion(true, nil, codigoInteresseRematricula)
    }
}

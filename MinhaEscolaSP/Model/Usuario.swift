//
//  Usuario.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 09/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData

@objc(Usuario)

final class Usuario: NSManagedObject {
    //MARK: Constants
    fileprivate struct Constants {
        static let rg = "rg"
    }
    
    //MARK: Variables
    @NSManaged var codigoUsuario: UInt32
    @NSManaged var digitoRa: String
    @NSManaged var email: String?
    @NSManaged var escolaCentralizada: Bool
    @NSManaged var estudante: Bool
    @NSManaged var nome: String
    @NSManaged var numeroRa: String
    @NSManaged var perfil: Int16
    @NSManaged var senha: String
    @NSManaged var token: String
    @NSManaged var ufRa: String
    @NSManaged var usuario: String
    @NSManaged var aluno: Aluno
    @NSManaged var contatos: NSSet
    
    //MARK: Methods
    func usuarioMock() -> Bool {
        return (perfil == UsuarioDao.Perfil.aluno.rawValue && senha == Requests.Configuracoes.LoginTesteApple.Aluno.senha && usuario == Requests.Configuracoes.LoginTesteApple.Aluno.ra + Requests.Configuracoes.LoginTesteApple.Aluno.digitoRa + Requests.Configuracoes.LoginTesteApple.Aluno.uf) || (perfil == UsuarioDao.Perfil.responsavel.rawValue && ((senha == Requests.Configuracoes.LoginTesteApple.ResponsavelRg.senha && usuario == Constants.rg + Requests.Configuracoes.LoginTesteApple.ResponsavelRg.rg + Requests.Configuracoes.LoginTesteApple.ResponsavelRg.digitoRg + Requests.Configuracoes.LoginTesteApple.ResponsavelRg.uf) || (usuario == Requests.Configuracoes.LoginTesteApple.ResponsavelRne.rne && senha == Requests.Configuracoes.LoginTesteApple.ResponsavelRne.senha)))
    }
}

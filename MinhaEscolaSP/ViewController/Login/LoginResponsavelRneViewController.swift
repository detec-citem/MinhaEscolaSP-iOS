//
//  LoginResponsavelRneViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 16/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import MBProgressHUD
import UIKit

final class LoginResponsavelRneViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let menuNavigationController = "MenuNavigationController"
        static let senhaResponsavelSegue = "SenhaResponsavelSegue"
    }
    
    //MARK: Outlets
    @IBOutlet weak var entrarButton: UIButton!
    @IBOutlet weak var rneTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        entrarButton.layer.borderColor = UIColor.white.cgColor
        if !Requests.Configuracoes.servidorHabilitado {
            rneTextField.text = Requests.Configuracoes.LoginTesteApple.ResponsavelRne.rne
            senhaTextField.text = Requests.Configuracoes.LoginTesteApple.ResponsavelRne.senha
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.senhaResponsavelSegue, let senhaViewController = segue.destination as? SenhaViewController {
            senhaViewController.aluno = false
        }
    }
    
    //MARK: Actions
    @IBAction func login() {
        if rneTextField.text?.count == .zero {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.digiteRne.localized, style: .alert, target: self)
        }
        else if senhaTextField.text?.count == .zero {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.digiteSenha.localized, style: .alert, target: self)
        }
        else if !Requests.Configuracoes.servidorHabilitado || Requests.conectadoInternet() || (rneTextField.text == Requests.Configuracoes.LoginTesteApple.ResponsavelRne.rne && senhaTextField.text == Requests.Configuracoes.LoginTesteApple.ResponsavelRne.senha) {
            let progressHud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
            progressHud.label.text = Localizable.carregando.localized
            progressHud.detailsLabel.text = Localizable.fazendoLogin.localized
            LoginRequest.fazerLogin(login: rneTextField.text!, password: senhaTextField.text!, perfil: .responsavel) { (_, sucesso, erro) in
                DispatchQueue.main.async {
                    progressHud.hide(animated: true)
                }
                if sucesso {
                    DispatchQueue.main.async {
                        let menuNavigationController = self.storyboard!.instantiateViewController(withIdentifier: Constants.menuNavigationController) as! UINavigationController
                        self.present(menuNavigationController, animated: true)
                    }
                }
                else {
                    UIAlertController.createAlert(title: Localizable.atencao.localized, message: erro, style: .alert, target: self)
                }
            }
        }
        else {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.internetLogin.localized, style: .alert, target: self)
        }
    }
    
    @IBAction func sobreRne() {
        UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.naoCadastrado.localized, style: .alert, target: self)
    }
    
    @IBAction func sobreSenha() {
        UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.primeiraSenhaResponavel.localized, style: .alert, target: self)
    }
}

//MARK: UITextFieldDelegate
extension LoginResponsavelRneViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

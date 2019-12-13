//
//  LoginResponsavelRgViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 16/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import MBProgressHUD
import UIKit

final class LoginResponsavelRgViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let tamanhoDigito = 2
        static let tamanhoRg = 15
        static let menuNavigationController = "MenuNavigationController"
        static let rg = "rg"
        static let senhaResponsavelSegue = "SenhaResponsavelSegue"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var entrarButton: UIButton!
    @IBOutlet fileprivate weak var estadoLabel: UILabel!
    @IBOutlet fileprivate weak var estadosComboBox: UIView!
    @IBOutlet fileprivate weak var rg1TextField: UITextField!
    @IBOutlet fileprivate weak var rg2TextField: UITextField!
    @IBOutlet fileprivate weak var senhaTextField: UITextField!
    
    //MARK: Variables
    fileprivate var estadoSelecionado = "sp"
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let branco = UIColor.white.cgColor
        entrarButton.layer.borderColor = branco
        estadosComboBox.layer.borderColor = branco
        if !Requests.Configuracoes.servidorHabilitado {
            let estado = Requests.Configuracoes.LoginTesteApple.ResponsavelRg.uf
            estadoSelecionado = estado.localizedLowercase
            estadoLabel.text = estado
            rg1TextField.text = Requests.Configuracoes.LoginTesteApple.ResponsavelRg.rg
            rg2TextField.text = Requests.Configuracoes.LoginTesteApple.ResponsavelRg.digitoRg
            senhaTextField.text = Requests.Configuracoes.LoginTesteApple.ResponsavelRg.senha
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.senhaResponsavelSegue, let senhaViewController = segue.destination as? SenhaViewController {
            senhaViewController.aluno = false
        }
    }
    
    //MARK: Actions
    @IBAction func entrar() {
        if rg1TextField.text?.count == .zero || rg2TextField.text?.count == .zero {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.digiteRgCompleto.localized, style: .alert, target: self)
        }
        else if senhaTextField.text?.count == .zero {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.digiteSenha.localized, style: .alert, target: self)
        }
        else if !Requests.Configuracoes.servidorHabilitado || Requests.conectadoInternet() || (senhaTextField.text == Requests.Configuracoes.LoginTesteApple.ResponsavelRg.senha && (rg1TextField.text! + rg2TextField.text! + estadoSelecionado == Requests.Configuracoes.LoginTesteApple.ResponsavelRg.rg + Requests.Configuracoes.LoginTesteApple.ResponsavelRg.digitoRg + Requests.Configuracoes.LoginTesteApple.ResponsavelRg.uf)) {
            let progressHud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
            progressHud.label.text = Localizable.carregando.localized
            progressHud.detailsLabel.text = Localizable.fazendoLogin.localized
            LoginRequest.fazerLogin(login: Constants.rg + rg1TextField.text! + rg2TextField.text! + estadoSelecionado.lowercased(), password: senhaTextField.text!, perfil: .responsavel) { (_, sucesso, erro) in
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
    
    @IBAction func mudouConteudoCampoTexto(_ sender: UITextField) {
        if sender == rg1TextField && sender.text!.count == Constants.tamanhoRg {
            sender.resignFirstResponder()
            rg2TextField.becomeFirstResponder()
        }
        else if sender == rg2TextField && sender.text!.count == Constants.tamanhoDigito {
            sender.resignFirstResponder()
            senhaTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func selecionarEstado() {
        let estadosNavigationController = storyboard?.instantiateViewController(withIdentifier: EstadosViewController.className) as! UINavigationController
        let estadosViewController = estadosNavigationController.viewControllers.first as! EstadosViewController
        estadosViewController.responsavel = true
        estadosViewController.delegate = self
        presentFormSheetViewController(viewController: estadosNavigationController)
    }
    
    @IBAction func sobreRg() {
        UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.naoCadastrado.localized, style: .alert, target: self)
    }
    
    @IBAction func sobreSenha() {
        UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.primeiraSenhaResponavel.localized, style: .alert, target: self)
    }
}

//MARK: EstadoDelegate
extension LoginResponsavelRgViewController: EstadoDelegate {
    func selecionouEstado(estado: String) {
        estadoSelecionado = estado.localizedLowercase
        estadoLabel.text = estado
    }
}

//MARK: UITextFieldDelegate
extension LoginResponsavelRgViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let texto = textField.text {
            let novoTamanho = texto.count + string.count - range.length
            if textField == rg1TextField {
                return novoTamanho <= Constants.tamanhoRg
            }
            if textField == rg2TextField {
                return novoTamanho <= Constants.tamanhoDigito
            }
        }
        return true
    }
}

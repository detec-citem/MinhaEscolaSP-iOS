//
//  LoginAlunoViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 10/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import MBProgressHUD
import UIKit

final class LoginAlunoViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let tamanhoDigito = 1
        static let tamanhoRa = 9
        static let menuNavigationController = "MenuNavigationController"
        static let senhaAlunoSegue = "SenhaAlunoSegue"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var ra1TextField: UITextField!
    @IBOutlet fileprivate weak var ra2Textfield: UITextField!
    @IBOutlet fileprivate weak var estadoLabel: UILabel!
    @IBOutlet fileprivate weak var estadoComboBox: UIView!
    @IBOutlet fileprivate weak var senhaTextField: UITextField!
    @IBOutlet fileprivate weak var entrarButton: UIButton!
    
    //MARK: Variables
    fileprivate var estadoSelecionado = "sp"
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let branco = UIColor.white.cgColor
        entrarButton.layer.borderColor = branco
        estadoComboBox.layer.borderColor = branco
        if !Requests.Configuracoes.servidorHabilitado {
            let estado = Requests.Configuracoes.LoginTesteApple.Aluno.uf
            estadoSelecionado = estado.localizedLowercase
            estadoLabel.text = estado
            ra1TextField.text = Requests.Configuracoes.LoginTesteApple.Aluno.ra
            ra2Textfield.text = Requests.Configuracoes.LoginTesteApple.Aluno.digitoRa
            senhaTextField.text = Requests.Configuracoes.LoginTesteApple.Aluno.senha
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.senhaAlunoSegue, let senhaViewController = segue.destination as? SenhaViewController {
            senhaViewController.aluno = true
        }
    }
    
    //MARK: Actions
    @IBAction func entrar() {
        if ra1TextField.text?.count == .zero || ra2Textfield.text?.count == .zero {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.digiteRaCompleto.localized, style: .alert, target: self)
        }
        else if senhaTextField.text?.count == .zero {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.digiteSenha.localized, style: .alert, target: self)
        }
        else if !Requests.Configuracoes.servidorHabilitado || Requests.conectadoInternet() || (senhaTextField.text == Requests.Configuracoes.LoginTesteApple.Aluno.senha && (ra1TextField.text! + ra2Textfield.text! + estadoSelecionado == Requests.Configuracoes.LoginTesteApple.Aluno.ra + Requests.Configuracoes.LoginTesteApple.Aluno.digitoRa + Requests.Configuracoes.LoginTesteApple.Aluno.uf)) {
            let progressHud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
            progressHud.label.text = Localizable.carregando.localized
            progressHud.detailsLabel.text = Localizable.fazendoLogin.localized
            LoginRequest.fazerLogin(login: ra1TextField.text! + ra2Textfield.text! + estadoSelecionado, password: senhaTextField.text!, perfil: .aluno) { (_, sucesso, erro) in
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
        if sender == ra1TextField && sender.text!.count == Constants.tamanhoRa {
            sender.resignFirstResponder()
            ra2Textfield.becomeFirstResponder()
        }
        else if sender == ra2Textfield && sender.text!.count == Constants.tamanhoDigito {
            sender.resignFirstResponder()
            senhaTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func selecionarEstado() {
        let estadosNavigationController = storyboard?.instantiateViewController(withIdentifier: EstadosViewController.className) as! UINavigationController
        let estadosViewController = estadosNavigationController.viewControllers.first as! EstadosViewController
        estadosViewController.responsavel = false
        estadosViewController.delegate = self
        presentFormSheetViewController(viewController: estadosNavigationController)
    }
    
    @IBAction func sobreRa() {
        UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.duvidaRa.localized, style: .alert, target: self)
    }
    
    @IBAction func sobreSenha() {
        UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.primeiraSenha.localized, style: .alert, target: self)
    }
    
    @IBAction func esqueciSenha() {
    }
}

//MARK: EstadoDelegate
extension LoginAlunoViewController: EstadoDelegate {
    func selecionouEstado(estado: String) {
        estadoSelecionado = estado.localizedLowercase
        estadoLabel.text = estado
    }
}

//MARK: UITextFieldDelegate
extension LoginAlunoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let texto = textField.text {
            let novoTamanho = texto.count + string.count - range.length
            if textField == ra1TextField {
                return novoTamanho <= Constants.tamanhoRa
            }
            if textField == ra2Textfield {
                return novoTamanho <= Constants.tamanhoDigito
            }
        }
        return true
    }
}

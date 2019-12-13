//
//  EditarTelefoneViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 10/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class EditarTelefoneViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let tamanhoDdd = 2
        static let tamanhoComplemento = 20
        static let tipoTelefoneNavigationController = "TipoTelefoneNavigationController"
    }
    
    //MARK: Variables
    @IBOutlet fileprivate weak var complementoTextField: UITextField!
    @IBOutlet fileprivate weak var dddTextField: UITextField!
    @IBOutlet fileprivate weak var telefoneTextField: UITextField!
    @IBOutlet fileprivate weak var tipoTelefoneControl: UIControl!
    @IBOutlet fileprivate weak var tipoTelefoneLabel: UILabel!
    @IBOutlet fileprivate weak var salvarBarButtonItem: UIBarButtonItem!
    
    //MARK: Variables
    var responsavel: Bool!
    var contato: Contato?
    weak var delegate: TelefoneDelegate!
    fileprivate var tipoTelefone: UInt16!

    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tipoTelefoneControl.layer.borderColor = UIColor.white.cgColor
        if let contato = contato {
            navigationItem.title = Localizable.alterarTelefone.localized
            tipoTelefone = contato.codigoTipoTelefone
            dddTextField.text = String(contato.codigoDdd)
            telefoneTextField.text = contato.telefone
            if tipoTelefone == TipoTelefoneInt.celular.rawValue {
                tipoTelefoneLabel.text = TipoTelefone.celular.rawValue
            }
            else if tipoTelefone == TipoTelefoneInt.comercial.rawValue {
                tipoTelefoneLabel.text = TipoTelefone.comercial.rawValue
            }
            else if tipoTelefone == TipoTelefoneInt.recado.rawValue {
                tipoTelefoneLabel.text = TipoTelefone.recado.rawValue
            }
            else {
                tipoTelefoneLabel.text = TipoTelefone.residencial.rawValue
            }
        }
        else {
            tipoTelefone = TipoTelefoneInt.celular.rawValue
            tipoTelefoneLabel.text = TipoTelefone.celular.rawValue
            navigationItem.title = Localizable.cadastrarTelefone.localized
        }
    }
    
    //MARK: Actions
    @IBAction func mostrarTiposTelefone() {
        if let tipoTelefonesNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.tipoTelefoneNavigationController) as? UINavigationController, let tipoTelefoneViewConstroller = tipoTelefonesNavigationController.viewControllers.first as? TipoTelefoneViewController {
            tipoTelefoneViewConstroller.delegate = self
            presentFormSheetViewController(viewController: tipoTelefonesNavigationController)
        }
    }
    
    @IBAction func mudouConteudoCampoTexto() {
        if let ddd = dddTextField.text, ddd.count == Constants.tamanhoDdd {
            dddTextField.resignFirstResponder()
            telefoneTextField.becomeFirstResponder()
        }
        if let complemento = complementoTextField.text, complemento.count == Constants.tamanhoComplemento {
            complementoTextField.resignFirstResponder()
        }
        verificarInformacoes()
    }
    
    @IBAction func sair(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func salvar(_ sender: Any) {
        if let codigoDddText = dddTextField.text, let telefone = telefoneTextField.text, let codigoDdd = UInt16(codigoDddText) {
            if let contato = contato {
                contato.codigoDdd = codigoDdd
                contato.codigoTipoTelefone = tipoTelefone
                contato.telefone = telefone
                contato.complemento = complementoTextField.text
                delegate.editouTelefone(contato: contato, responsavel: responsavel)
            }
            else {
                var contato: Contato!
                let complemento = complementoTextField.text
                if responsavel {
                    contato = ContatoDao.salvarContato(codigoDdd: codigoDdd, complemento: complemento, telefone: telefone, tipoTelefone: tipoTelefone, responsavel: responsavel, usuario: LoginRequest.usuarioLogado)
                }
                else {
                    contato = ContatoDao.salvarContato(codigoDdd: codigoDdd, complemento: complemento, telefone: telefone, tipoTelefone: tipoTelefone, responsavel: false)
                }
                delegate.adicionouTelefone(contato: contato, responsavel: responsavel)
            }
            navigationController?.dismiss(animated: true)
        }
    }
    
    //MARK: Methods
    fileprivate func verificarInformacoes() {
        if let ddd = dddTextField.text, let telefone = telefoneTextField.text, !telefone.isEmpty && ddd.count == 2 {
            if let contato = contato {
                salvarBarButtonItem.isEnabled = UInt16(ddd) != contato.codigoDdd || telefone != contato.telefone || self.tipoTelefone != contato.codigoTipoTelefone
            }
            else {
                salvarBarButtonItem.isEnabled = true
            }
        }
        else {
            salvarBarButtonItem.isEnabled = false
        }
    }
}

//MARK: TipoTelefoneDelegate
extension EditarTelefoneViewController: TipoTelefoneDelegate {
    func selecionouTipoTelefone(tipoTelefone: String) {
        tipoTelefoneLabel.text = tipoTelefone
        if tipoTelefone == TipoTelefone.celular.rawValue {
            self.tipoTelefone = TipoTelefoneInt.celular.rawValue
        }
        else if tipoTelefone == TipoTelefone.comercial.rawValue {
            self.tipoTelefone = TipoTelefoneInt.comercial.rawValue
        }
        else if tipoTelefone == TipoTelefone.recado.rawValue {
            self.tipoTelefone = TipoTelefoneInt.recado.rawValue
        }
        else {
            self.tipoTelefone = TipoTelefoneInt.residencial.rawValue
        }
        verificarInformacoes()
    }
}

//MARK: UITextFieldDelegate
extension EditarTelefoneViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let texto = textField.text {
            let novoTamanho = texto.count + string.count - range.length
            if textField == dddTextField {
                return novoTamanho <= Constants.tamanhoDdd
            }
            if textField == complementoTextField {
                return novoTamanho <= Constants.tamanhoComplemento
            }
        }
        return true
    }
}

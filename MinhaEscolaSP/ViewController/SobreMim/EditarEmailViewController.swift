//
//  EditarEmailViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 01/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class EditarEmailViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let predicateFormat = "SELF MATCHES %@"
        static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,64}"
        static let tamanhoEmail = 100
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var salvarBarButtonItem: UIBarButtonItem!
    @IBOutlet fileprivate weak var confirmeEmailTextField: UITextField!
    @IBOutlet fileprivate weak var emailAtualLabel: UILabel!
    @IBOutlet fileprivate weak var novoEmailTextField: UITextField!
    
    //MARK: Variables
    var email: String!
    weak var delegate: EmailDelegate!
    fileprivate lazy var emailPredicate = NSPredicate(format: Constants.predicateFormat, Constants.emailRegex)
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailAtualLabel.text = email
    }
    
    //MARK: Actions
    @IBAction func mudouConteudoCampoTexto() {
        if let novoEmailText = novoEmailTextField.text, let confirmeEmailText = confirmeEmailTextField.text {
            salvarBarButtonItem.isEnabled = !novoEmailText.isEmpty && !confirmeEmailText.isEmpty && novoEmailText == confirmeEmailText && email != novoEmailText && emailPredicate.evaluate(with: novoEmailText)
        }
        else {
            salvarBarButtonItem.isEnabled = false
        }
    }
    
    @IBAction func sair(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func salvar(_ sender: Any) {
        if let email = novoEmailTextField.text {
            delegate.editouEmail(email: email)
        }
        navigationController?.dismiss(animated: true)
    }
}

//MARK: UITextFieldDelegate
extension EditarEmailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let texto = textField.text {
            let novoTamanho = texto.count + string.count - range.length
            return novoTamanho <= Constants.tamanhoEmail
        }
        return true
    }
}

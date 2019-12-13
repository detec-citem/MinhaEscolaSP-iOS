//
//  EnviarFotoViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 07/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import MBProgressHUD
import UIKit

final class EnviarFotoViewController: ViewController {
    //MARK: Outlets
    @IBOutlet fileprivate weak var mensagemView: UIView!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mensagemView.layer.borderColor = UIColor.white.cgColor
    }
    
    //MARK: Actions
    @IBAction func enviarFoto() {
        UIImagePickerController.mostrarImagePickerController(carteirinha: true, viewController: self)
    }
}

//MARK: UIImagePickerControllerDelegate
extension EnviarFotoViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        var foto: UIImage!
        if let imagemEditada = info[.editedImage] as? UIImage {
            foto = imagemEditada
        }
        else if let imagemOriginal = info[.originalImage] as? UIImage {
            foto = imagemOriginal
        }
        let progressHud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
        progressHud.label.text = Localizable.carregando.localized
        progressHud.detailsLabel.text = Localizable.enviandoFoto.localized
        EnviarFotoRequest.enviarFoto(foto: foto, completion: { (sucesso, resposta) in
            DispatchQueue.main.async {
                progressHud.hide(animated: true)
                if sucesso {
                    UIAlertController.createAlert(title: Localizable.atencao.localized, message: resposta, style: .alert, target: self.navigationController)
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    UIAlertController.createAlert(title: Localizable.atencao.localized, message: resposta, style: .alert, target: self)
                }
            }
        })
    }
}

//MARK: UINavigationControllerDelegate
extension EnviarFotoViewController: UINavigationControllerDelegate {
}

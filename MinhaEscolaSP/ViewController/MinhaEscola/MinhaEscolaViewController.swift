//
//  MinhaEscolaViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 16/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class MinhaEscolaViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let escola = "escola"
        static let minhaEscola = "minha escola"
        static let mapaSegue = "MapaSegue"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var diretorLabel: UILabel!
    @IBOutlet fileprivate weak var diretorView: UIView!
    @IBOutlet fileprivate weak var emailLabel: UILabel!
    @IBOutlet fileprivate weak var emailView: UIView!
    @IBOutlet fileprivate weak var enderecoLabel: UILabel!
    @IBOutlet fileprivate weak var enderecoView: UIView!
    @IBOutlet fileprivate weak var nomeLabel: UILabel!
    @IBOutlet fileprivate weak var nomeView: UIView!
    @IBOutlet fileprivate weak var telefone1Label: UILabel!
    @IBOutlet fileprivate weak var telefone2Label: UILabel!
    @IBOutlet fileprivate weak var telefoneView: UIView!
    @IBOutlet fileprivate weak var telefoneDistancia: NSLayoutConstraint!
    
    //MARK: Variables
    var escola: Escola!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let white = UIColor.white.cgColor
        diretorView.layer.borderColor = white
        emailView.layer.borderColor = white
        enderecoView.layer.borderColor = white
        nomeView.layer.borderColor = white
        telefoneView.layer.borderColor = white
        diretorLabel.text = escola.diretor
        emailLabel.text = escola.email
        enderecoLabel.text = escola.enderecoUnidade
        nomeLabel.text = escola.nome
        if LoginRequest.usuarioLogado.estudante {
            navigationItem.title = Constants.minhaEscola
        }
        else {
            navigationItem.title = Constants.escola
        }
        if let contatos = escola.contatos.allObjects as? [ContatoEscola] {
            if let telefone1 = contatos.first?.telefone {
                telefone1Label.text = telefone1
            }
            if contatos.count > 1 {
                telefone2Label.text = contatos[1].telefone
            }
            else {
                telefoneDistancia.constant = 0
                telefone2Label.text = nil
                view.layoutIfNeeded()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.mapaSegue, let mapaViewController = segue.destination as? MapaViewController {
            mapaViewController.latitude = escola.latitude
            mapaViewController.longitude = escola.longitude
        }
    }
    
    //MARK: Actions
    @IBAction func abrirEmail() {
    }
}

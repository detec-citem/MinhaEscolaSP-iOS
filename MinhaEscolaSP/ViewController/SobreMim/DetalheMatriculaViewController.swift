//
//  DetalheMatriculaViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 05/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class DetalheMatriculaViewController: ViewController {
    //MARK: Outlets
    @IBOutlet fileprivate weak var dataFimLabel: UILabel!
    @IBOutlet fileprivate weak var dataInicioLabel: UILabel!
    @IBOutlet fileprivate weak var escolaLabel: UILabel!
    @IBOutlet fileprivate weak var rendimentoLabel: UILabel!
    @IBOutlet fileprivate weak var situacaoLabel: UILabel!
    @IBOutlet fileprivate weak var turmaLabel: UILabel!
    @IBOutlet fileprivate weak var dataFimView: UIView!
    @IBOutlet fileprivate weak var dataInicioView: UIView!
    @IBOutlet fileprivate weak var escolaView: UIView!
    @IBOutlet fileprivate weak var rendimentoView: UIView!
    @IBOutlet fileprivate weak var situacaoView: UIView!
    @IBOutlet fileprivate weak var turmaView: UIView!
    
    //MARK: Variables
    var matricula: Turma!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = String(matricula.anoLetivo)
        let branco = UIColor.white.cgColor
        dataFimView.layer.borderColor = branco
        dataInicioView.layer.borderColor = branco
        escolaView.layer.borderColor = branco
        rendimentoView.layer.borderColor = branco
        situacaoView.layer.borderColor = branco
        turmaView.layer.borderColor = branco
        dataFimLabel.text = DateFormatter.defaultDateFormatter.string(from: matricula.dataFimMatricula)
        dataInicioLabel.text = DateFormatter.defaultDateFormatter.string(from: matricula.dataInicioMatricula)
        escolaLabel.text = matricula.nomeEscola
        situacaoLabel.text = matricula.situacaoMatricula
        turmaLabel.text = matricula.nomeTurma
    }
}

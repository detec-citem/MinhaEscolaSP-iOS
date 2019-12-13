//
//  MatriculaTableViewCell.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 17/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class MatriculaTableViewCell: UITableViewCell {
    //MARK: Constants
    fileprivate struct Constants {
        static let quebraDeLinha = "\n"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var anoLabel: UILabel!
    @IBOutlet fileprivate weak var descricaoLabel: UILabel!
    @IBOutlet fileprivate weak var informacoesView: UIView!
    
    //MARK: Variables
    var matricula: Turma! {
        didSet {
            configurarCelula()
        }
    }
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        informacoesView.layer.borderColor = UIColor.white.cgColor
    }
    
    //MARK: Methods
    fileprivate func configurarCelula() {
        anoLabel.text = String(matricula.anoLetivo)
        descricaoLabel.text = matricula.nomeEscola + Constants.quebraDeLinha + matricula.nomeTurma
    }
}

//
//  ComposicaoNotaTableViewCell.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 24/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class ComposicaoNotaTableViewCell: UITableViewCell {
    //MARK: Constants
    fileprivate struct Constants {
        static let semNota = "-"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var atividadeLabel: UILabel!
    @IBOutlet fileprivate weak var notaLabel: UILabel!
    
    //MARK: Variables
    var composicaoNota: ComposicaoNota! {
        didSet {
            configurarCelula()
        }
    }
    var semNotas: Bool = false {
        didSet {
            configurarCelula()
        }
    }
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        notaLabel.layer.borderColor = UIColor.white.cgColor
    }
    
    //MARK: Methods
    fileprivate func configurarCelula() {
        if semNotas {
            atividadeLabel.text = Localizable.nenhumaAvaliacaoLancada.localized
            notaLabel.text = Constants.semNota
        }
        else {
            atividadeLabel.text = composicaoNota.descricaoAtividade
            notaLabel.text = NumberFormatter.notaFormatter.string(from: composicaoNota.numeroNota as NSNumber)
        }
    }
}

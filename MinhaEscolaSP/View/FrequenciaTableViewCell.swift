//
//  FrequenciaTableViewCell.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 25/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class FrequenciaTableViewCell: UITableViewCell {
    //MARK: Constants
    fileprivate struct Constants {
        static let porcentagem = "%"
        static let porcentagem100: Float = 100
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var acumuladasLabel: UILabel!
    @IBOutlet fileprivate weak var disciplinaLabel: UILabel!
    @IBOutlet fileprivate weak var faltasLabel: UILabel!
    @IBOutlet fileprivate weak var porcentagemLabel: UILabel!
    
    //MARK: Variables
    var frequencia: Frequencia! {
        didSet {
            configurarCelula()
        }
    }
    
    //MARK: Methods
    fileprivate func configurarCelula() {
        acumuladasLabel.text = String(frequencia.ausenciasCompensadas)
        disciplinaLabel.text = frequencia.nomeDisciplina
        faltasLabel.text = String(frequencia.faltas)
        porcentagemLabel.text = NumberFormatter.notaFormatter.string(from: (Constants.porcentagem100 - frequencia.porcentagemFaltas).rounded() as NSNumber)! + Constants.porcentagem
    }
}

//
//  SobreMimTableViewCell.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 16/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class SobreMimTableViewCell: UITableViewCell {
    //MARK: Constants
    fileprivate struct Constants {
        static let espaco = " "
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var sobreMimLabel: UILabel!
    
    //MARK: Variables
    var aluno: Aluno! {
        didSet {
            configurarCelula()
        }
    }
    
    //MARK: Methods
    fileprivate func configurarCelula() {
        sobreMimLabel.text = aluno.nome.components(separatedBy: Constants.espaco).first?.lowercased()
    }
}

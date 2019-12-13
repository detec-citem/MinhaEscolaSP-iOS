//
//  EventoTableViewCell.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 19/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class EventoTableViewCell: UITableViewCell {
    //MARK: Outlets
    @IBOutlet fileprivate weak var descricaoEventoLabel: UILabel!
    @IBOutlet fileprivate weak var nomeEventoLabel: UILabel!
    
    //MARK: Variables
    var diaEvento: DiaEvento! {
        didSet {
            configurarCelula()
        }
    }
    
    //MARK: Methods
    fileprivate func configurarCelula() {
        descricaoEventoLabel.text = diaEvento.descricaoEvento
        nomeEventoLabel.text = diaEvento.nomeEvento
    }
}

//
//  TelefoneTableViewCell.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 08/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class TelefoneTableViewCell: UITableViewCell {
    //MARK: Outlets
    @IBOutlet fileprivate weak var deletarButtonComprimentoConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var deletarButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var editarButtonComprimentoConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var editarButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var telefoneLabel: UILabel!
    
    //MARK: Variables
    weak var delegate: TelefoneCellDelegate!
    var indice: Int!
    var responsavel: Bool!
    var responsavelTableView: Bool!
    var contato: Contato! {
        didSet {
            configurarCelula()
        }
    }
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Actions
    @IBAction func deletar() {
        delegate.deletarTelefone(indice: indice, responsavel: responsavelTableView)
    }
    
    @IBAction func editar() {
        delegate.editarTelefone(indice: indice, responsavel: responsavelTableView)
    }
    
    //MARK: Methods
    fileprivate func configurarCelula() {
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        if !responsavel && !contato.aluno.maiorDeIdade() {
            deletarButtonComprimentoConstraint.constant = .zero
            deletarButtonLeadingConstraint.constant = .zero
            editarButtonComprimentoConstraint.constant = .zero
            editarButtonLeadingConstraint.constant = .zero
        }
        var texto = "(" + String(contato.codigoDdd) + ") " + contato.telefone + " - "
        if contato.codigoTipoTelefone == TipoTelefoneInt.celular.rawValue {
            texto += TipoTelefone.celular.rawValue
        }
        else if contato.codigoTipoTelefone == TipoTelefoneInt.comercial.rawValue {
            texto += TipoTelefone.comercial.rawValue
        }
        else if contato.codigoTipoTelefone == TipoTelefoneInt.recado.rawValue {
            texto += TipoTelefone.recado.rawValue
        }
        else if contato.codigoTipoTelefone == TipoTelefoneInt.residencial.rawValue {
            texto += TipoTelefone.residencial.rawValue
        }
        telefoneLabel.text = texto
    }
}

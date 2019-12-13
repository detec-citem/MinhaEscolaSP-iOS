//
//  NotaTableViewCell.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 23/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class NotaTableViewCell: UITableViewCell {
    //MARK: Constants
    fileprivate struct Constants {
        static let altura: CGFloat = 64
        static let alturaZero: CGFloat = 0
        static let semNotas = 1
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var alturaTableView: NSLayoutConstraint!
    @IBOutlet fileprivate weak var disciplinaLabel: UILabel!
    @IBOutlet fileprivate weak var notaLabel: UILabel!
    @IBOutlet fileprivate weak var composicoesNotaTableView: UITableView!
    
    //MARK: Variables
    var nota: Nota! {
        didSet {
            configurarCelula()
        }
    }
    
    var expandida: Bool! {
        didSet {
            expandirNota()
        }
    }
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        composicoesNotaTableView.register(UINib(nibName: ComposicaoNotaTableViewCell.className, bundle: nil), forCellReuseIdentifier: ComposicaoNotaTableViewCell.className)
    }
    
    //MARK: Methods
    fileprivate func configurarCelula() {
        disciplinaLabel.text = nota.nomeDisciplina
        notaLabel.text = String(Int(nota.nota))
        expandida = nota.expandida
        if expandida {
            composicoesNotaTableView.dataSource = self
            composicoesNotaTableView.reloadData()
        }
    }
    
    fileprivate func expandirNota() {
        if expandida {
            var altura: CGFloat!
            if nota.composicoesNotaArray.isEmpty {
                altura = Constants.altura
            }
            else {
                altura = CGFloat(nota.composicoesNotaArray.count) * Constants.altura
            }
            alturaTableView.constant = altura
            composicoesNotaTableView.dataSource = self
            composicoesNotaTableView.reloadData()
        }
        else {
            alturaTableView.constant = Constants.alturaZero
        }
        layoutIfNeeded()
    }
}

//MARK: UITableViewDataSource
extension NotaTableViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let composicoesNota = nota.composicoesNota
        if composicoesNota.count == .zero {
            return Constants.semNotas
        }
        return composicoesNota.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ComposicaoNotaTableViewCell = tableView.dequeue(index: indexPath)
        let composicoesNota = nota.composicoesNotaArray!
        if composicoesNota.isEmpty {
            cell.semNotas = true
        }
        else {
            cell.composicaoNota = nota.composicoesNotaArray[indexPath.row]
        }
        return cell
    }
}

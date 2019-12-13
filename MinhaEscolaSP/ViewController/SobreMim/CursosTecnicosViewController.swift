//
//  CursosTecnicosViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 07/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class CursosTecnicosViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let maximoSelecionados = 3
        static let minimoSelecionados = 1
        static let cursoTecnicoTableViewCell = "CursoTecnicoTableViewCell"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var salvarBarButtonItem: UIBarButtonItem!
    @IBOutlet fileprivate weak var cursosTecnicosTableView: UITableView!
    
    //MARK: Variables
    weak var delegate: CursoTecnicoDelegate!
    fileprivate lazy var numeroSelecionados = 0
    fileprivate lazy var selecionados = [Bool]()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cursosTecnicosTableView.tableFooterView = UIView()
        selecionados.reserveCapacity(CursosTecnicos.cursosTecnicos.count)
        for _ in CursosTecnicos.cursosTecnicos {
            selecionados.append(false)
        }
        UIAlertController.createAlert(title: Localizable.atencao.localized, message: "Selecione até 3 cursos técnicos", style: .alert, target: self)
    }
    
    //MARK: Actions
    @IBAction func sair(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func salvar(_ sender: Any) {
        var cursosTecnicos = [String]()
        cursosTecnicos.reserveCapacity(numeroSelecionados)
        let selecionadosCount = selecionados.count
        for i in 0..<selecionadosCount {
            if selecionados[i] {
                cursosTecnicos.append(CursosTecnicos.cursosTecnicos[i])
            }
        }
        delegate.selecionouCursosTecnicos(cursosTecnicos: cursosTecnicos)
        navigationController?.dismiss(animated: true)
    }
}

//MARK: UITableViewDataSource
extension CursosTecnicosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CursosTecnicos.cursosTecnicos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let linha = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cursoTecnicoTableViewCell, for: indexPath)
        cell.textLabel?.text = CursosTecnicos.cursosTecnicos[linha]
        let detailTextLabel = cell.detailTextLabel
        if selecionados[linha] {
            detailTextLabel?.text = String(linha + 1)
        }
        else {
            detailTextLabel?.text = nil
        }
        return cell
    }
}

//MARK: UITableViewDelegate
extension CursosTecnicosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let linha = indexPath.row
        if selecionados[linha] {
            numeroSelecionados -= 1
            selecionados[linha] = false
            salvarBarButtonItem.isEnabled = numeroSelecionados >= Constants.minimoSelecionados && numeroSelecionados <= Constants.maximoSelecionados
            let cell = tableView.cellForRow(at: indexPath)
            cell?.detailTextLabel?.text = nil
        }
        else if numeroSelecionados < Constants.maximoSelecionados {
            numeroSelecionados += 1
            selecionados[linha] = true
            salvarBarButtonItem.isEnabled = numeroSelecionados >= Constants.minimoSelecionados && numeroSelecionados <= Constants.maximoSelecionados
            let cell = tableView.cellForRow(at: indexPath)
            cell?.detailTextLabel?.text = String(indexPath.row + 1)
        }
    }
}

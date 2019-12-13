//
//  TipoTelefoneViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 13/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class TipoTelefoneViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let tipoTelefoneTableViewCell = "TipoTelefoneTableViewCell"
        static let tiposTelefone = [TipoTelefone.celular.rawValue, TipoTelefone.comercial.rawValue, TipoTelefone.recado.rawValue, TipoTelefone.residencial.rawValue]
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var tipoTelefoneTableView: UITableView!
    
    //MARK: TipoTelefoneDelegate
    weak var delegate: TipoTelefoneDelegate!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tipoTelefoneTableView.tableFooterView = UIView()
    }
    
    //MARK: Actions
    @IBAction func sair(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}

//MARK: UITableViewDatasource
extension TipoTelefoneViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.tiposTelefone.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tipoTelefoneTableViewCell, for: indexPath)
        cell.textLabel?.text = Constants.tiposTelefone[indexPath.row]
        return cell
    }
}

//MARK: UITableViewDelegate
extension TipoTelefoneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selecionouTipoTelefone(tipoTelefone: Constants.tiposTelefone[indexPath.row])
        navigationController?.dismiss(animated: true)
    }
}

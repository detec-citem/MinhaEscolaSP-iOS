//
//  TipoLogradouroViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 02/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class TipoLogradouroViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let tiposLogradouro = [TipoLogradouro.rural.rawValue, TipoLogradouro.urbana.rawValue]
        static let tipoLogradouroTableViewCell = "TipoLogradouroTableViewCell"
    }
    
    //MARK: Variables
    @IBOutlet weak var tipoLogradouroTableView: UITableView!
    
    //MARK: Variables
    weak var delegate: TipoLogradouroDelegate!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tipoLogradouroTableView.tableFooterView = UIView()
    }
    
    //MARK: Actions
    @IBAction func sair(_ sender: Any) {
        dismiss(animated: true)
    }
}

//MARK: UITableViewDataSource
extension TipoLogradouroViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.tiposLogradouro.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.tipoLogradouroTableViewCell, for: indexPath)
        cell.textLabel?.text = Constants.tiposLogradouro[indexPath.row]
        return cell
    }
}

//MARK: UITableViewDelegate
extension TipoLogradouroViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selecionouTipoLogradouro(tipoLogradouro: Constants.tiposLogradouro[indexPath.row])
        navigationController?.dismiss(animated: true)
    }
}

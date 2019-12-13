//
//  CidadesViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 08/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class CidadesViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let cidadeTableViewCell = "CidadeTableViewCell"
        static let cidades = Municipios.municipiosDict.keys.sorted()
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var cidadesTableView: UITableView!
    
    //MARK: Variables
    weak var delegate: CidadesDelegate!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        cidadesTableView.tableFooterView = UIView()
    }
    
    //MARK: Actions
    @IBAction func sair(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}

//MARK: UITableViewDataSource
extension CidadesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.cidades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cidadeTableViewCell, for: indexPath)
        cell.textLabel?.text = Constants.cidades[indexPath.row]
        return cell
    }
}

//MARK: UITableViewDelegate
extension CidadesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selecionouCidade(cidade: Constants.cidades[indexPath.row])
        navigationController?.dismiss(animated: true)
    }
}

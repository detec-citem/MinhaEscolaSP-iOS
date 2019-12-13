//
//  LocalizacoesDiferenciadasViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 09/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class LocalizacoesDiferenciadasViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let localizacoesDiferenciadas = [LocalizacaoDiferenciada.assentamento.rawValue,LocalizacaoDiferenciada.indigena.rawValue,LocalizacaoDiferenciada.naoEstaEmAreaDeLocalizacaoDiferenciada.rawValue,LocalizacaoDiferenciada.quilombos.rawValue]
        static let localizacaoDiferenciadaTableViewCell = "LocalizacaoDiferenciadaTableViewCell"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    //MARK: Variables
    weak var delegate: LocalizacaoDiferenciadaDelegate!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
    
    //MARK: Actions
    @IBAction func sair(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}

//MARK: UITableViewDataSource
extension LocalizacoesDiferenciadasViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.localizacoesDiferenciadas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.localizacaoDiferenciadaTableViewCell, for: indexPath)
        cell.textLabel?.text = Constants.localizacoesDiferenciadas[indexPath.row]
        return cell
    }
}

//MARK: UITableViewDelegate
extension LocalizacoesDiferenciadasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selecionouLocalizacaoDiferenciada(localizacaoDiferenciada: Constants.localizacoesDiferenciadas[indexPath.row])
        navigationController?.dismiss(animated: true)
    }
}

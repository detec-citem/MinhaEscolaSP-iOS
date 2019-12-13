//
//  EstadosViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 13/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class EstadosViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let estadoTableViewCell = "EstadoTableViewCell"
        static let semEstado = "Sem Estado"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var estadosTableView: UITableView!
    
    //MARK: Variables
    var responsavel: Bool!
    weak var delegate: EstadoDelegate!
    fileprivate var abreviaturasEstados = ["AC","AL","AP","AM","BA","CE","DF","ES","GO","MA","MT","MS","MG","PA","PB","PR","PE","PI","RJ","RN","RS","RO","RR","SC","SP","SE","TO"]
    fileprivate var nomesEstados = ["Acre","Alagoas","Amapá","Amazonas","Bahia","Ceará","Distrito Federal","Espírito Santo","Goiás","Maranhão","Mato Grosso","Mato Grosso do Sul","Minas Gerais","Pará","Paraíba","Paraná","Pernambuco","Piauí","Rio de Janeiro","Rio Grande do Norte","Rio Grande do Sul","Rondônia","Roraima","Santa Catarina","São Paulo","Sergipe","Tocantins"]
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if responsavel {
            abreviaturasEstados.insert("", at: .zero)
            nomesEstados.insert(Constants.semEstado, at: .zero)
        }
        estadosTableView.reloadData()
    }
    
    //MARK: Actions
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}

//MARK: UITableViewDataSource
extension EstadosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nomesEstados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.estadoTableViewCell, for: indexPath)
        cell.textLabel?.text = nomesEstados[indexPath.row]
        return cell
    }
}

//MARK: UITableViewDelegate
extension EstadosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selecionouEstado(estado: abreviaturasEstados[indexPath.row])
        dismiss(animated: true)
    }
}

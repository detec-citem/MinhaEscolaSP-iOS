//
//  JustificativaNoturnoViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 21/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class JustificativaNoturnoViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let justificativas = ["Trabalho","Cursos em período diurno","Opção do Aluno","Outros"]
        static let justificativaNoturnoTableViewCell = "JustificativaNoturnoTableViewCell"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var justificativasTableView: UITableView!
    
    //MARK: Variables
    weak var delegate: JustificativaNoturnoDelegate!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        justificativasTableView.tableFooterView = UIView()
    }
    
    //MARK: Actions
    @IBAction func sair(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}

//MARK: UITableViewDataSource
extension JustificativaNoturnoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.justificativas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.justificativaNoturnoTableViewCell, for: indexPath)
        cell.textLabel?.text = Constants.justificativas[indexPath.row]
        return cell
    }
}

//MARK: UITableViewDelegate
extension JustificativaNoturnoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selecionouJustificativaNoturno(justificativa: Constants.justificativas[indexPath.row])
        navigationController?.dismiss(animated: true)
    }
}

//
//  TurmasViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 18/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class TurmasViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let turmaTableViewCell = "TurmaTableViewCell"
    }
    
    //MARK: Outlets
    @IBOutlet weak var turmasTableView: UITableView!
    
    //MARK: Variables
    weak var delegate: TurmaDelegate!
    var turmas: [Turma]!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        turmasTableView.tableFooterView = UIView()
    }
    
    //MARK: Actions
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}

//MARK: UITableViewDataSource
extension TurmasViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return turmas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.turmaTableViewCell, for: indexPath)
        cell.textLabel?.text = turmas[indexPath.row].nomeTurma
        return cell
    }
}

//MARK: UITableViewDelegate
extension TurmasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selecionouTurma(turma: turmas[indexPath.row])
        dismiss(animated: true)
    }
}

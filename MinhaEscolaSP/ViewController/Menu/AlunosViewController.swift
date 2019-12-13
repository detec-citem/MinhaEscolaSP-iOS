//
//  AlunosViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 14/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class AlunosViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let alunoTableViewCell = "AlunoTableViewCell"
    }
    
    //MARK: Outlets
    @IBOutlet weak var alunosTableView: UITableView!
    
    //MARK: Variables
    weak var delegate: AlunoDelegate!
    var alunos: [Aluno] = []
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alunosTableView.tableFooterView = UIView()
    }
    
    //MARK: Actions
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}

//MARK: UITableViewDataSource
extension AlunosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alunos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.alunoTableViewCell, for: indexPath)
        cell.textLabel?.text = alunos[indexPath.row].nome
        return cell
    }
}

//MARK: UITableViewDelegate
extension AlunosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selecionouAluno(aluno: alunos[indexPath.row])
        dismiss(animated: true)
    }
}

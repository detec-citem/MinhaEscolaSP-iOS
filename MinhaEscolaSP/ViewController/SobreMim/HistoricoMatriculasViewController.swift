//
//  HistoricoMatriculasViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 17/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class HistoricoMatriculasViewController: ViewController {
    //MARK: Variables
    var matriculas: [Turma]!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        matriculas = matriculas.sorted(by: { (matricula1, matricula2) -> Bool in
            return matricula1.anoLetivo > matricula2.anoLetivo
        })
    }
}

//MARK: UITableViewDataSource
extension HistoricoMatriculasViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matriculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MatriculaTableViewCell = tableView.dequeue(index: indexPath)
        cell.matricula = matriculas[indexPath.row]
        return cell
    }
}

//MARK: UITableViewDataSource
extension HistoricoMatriculasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detalheMatriculaViewController: DetalheMatriculaViewController = storyboard!.instantiateViewController()
        detalheMatriculaViewController.matricula = matriculas[indexPath.row]
        navigationController?.pushViewController(detalheMatriculaViewController, animated: true)
    }
}

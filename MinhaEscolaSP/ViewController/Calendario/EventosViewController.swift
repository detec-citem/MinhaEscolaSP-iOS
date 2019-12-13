//
//  EventosViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 19/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class EventosViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var eventosTableView: UITableView!
    
    //MARK: Variables
    var diasEvento: [DiaEvento]!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        diasEvento.sort { (diaEvento1, diaEvento2) -> Bool in
            return diaEvento1.nomeEvento < diaEvento2.nomeEvento
        }
        EventoTableViewCell.register(eventosTableView)
        eventosTableView.tableFooterView = UIView()
    }
    
    //MARK: Actions
    @IBAction func fechar(_ sender: Any) {
        dismiss(animated: true)
    }
}

//MARK: UITableViewDataSource
extension EventosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diasEvento.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EventoTableViewCell = tableView.dequeue(index: indexPath)
        cell.diaEvento = diasEvento[indexPath.row]
        return cell
    }
}

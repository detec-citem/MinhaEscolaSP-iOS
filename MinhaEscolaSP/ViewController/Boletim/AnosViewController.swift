//
//  AnosViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 18/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class AnosViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let anoTableViewCell = "AnoTableViewCell"
    }
    
    //MARK: Outlets
    @IBOutlet weak var anosTableView: UITableView!
    
    //MARK: Variables
    weak var delegate: AnoDelegate!
    var anos: [UInt16]!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        anosTableView.tableFooterView = UIView()
    }
    
    //MARK: Actions
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}

//MARK: UITableViewDataSource
extension AnosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return anos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.anoTableViewCell, for: indexPath)
        cell.textLabel?.text = String(anos[indexPath.row])
        return cell
    }
}

//MARK: UITableViewDelegate
extension AnosViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.selecionouAno(ano: anos[indexPath.row])
        dismiss(animated: true)
    }
}

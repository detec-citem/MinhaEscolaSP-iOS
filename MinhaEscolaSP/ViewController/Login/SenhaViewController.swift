//
//  SenhaViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 12/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class SenhaViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let esqueciSenhaSegue = "EsqueciSenhaSegue"
    }
    
    //MARK: Variables
    var aluno: Bool!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.esqueciSenhaSegue, let esqueciSenhaVC = segue.destination as? EsqueciMinhaSenhaViewController {
            esqueciSenhaVC.aluno = aluno
        }
    }
}

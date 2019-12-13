//
//  Questao1ViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 21/03/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class Questao1ViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let opcaoNao: UInt8 = 2
        static let opcaoSim: UInt8 = 1
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var naoView: UIControl!
    @IBOutlet fileprivate weak var simView: UIControl!
    
    //MARK: Variables
    var turma: Turma!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let branco = UIColor.white.cgColor
        naoView.layer.borderColor = branco
        simView.layer.borderColor = branco
    }
    
    //MARK: Actions
    @IBAction func nao() {
        irParaQuestao2(questao1: Constants.opcaoNao)
    }
    
    @IBAction func sim() {
        irParaQuestao2(questao1: Constants.opcaoSim)
    }
    
    //MARK: Methods
    fileprivate func irParaQuestao2(questao1: UInt8) {
        let questao2ViewController: Questao2ViewController = storyboard!.instantiateViewController()
        questao2ViewController.questao1 = questao1
        questao2ViewController.turma = turma
        navigationController?.pushViewController(questao2ViewController, animated: true)
    }
}

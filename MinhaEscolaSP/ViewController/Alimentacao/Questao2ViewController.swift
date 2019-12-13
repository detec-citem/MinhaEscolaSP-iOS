//
//  Questao2ViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 25/03/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class Questao2ViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let opcao1: UInt8 = 3
        static let opcao2: UInt8 = 4
        static let opcao3: UInt8 = 5
        static let opcao4: UInt8 = 6
        static let opcao5: UInt8 = 7
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var opcao1View: UIControl!
    @IBOutlet fileprivate weak var opcao2View: UIControl!
    @IBOutlet fileprivate weak var opcao3View: UIControl!
    @IBOutlet fileprivate weak var opcao4View: UIControl!
    @IBOutlet fileprivate weak var opcao5View: UIControl!
    
    //MARK: Variables
    var questao1: UInt8!
    var turma: Turma!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let branco = UIColor.white.cgColor
        opcao1View.layer.borderColor = branco
        opcao2View.layer.borderColor = branco
        opcao3View.layer.borderColor = branco
        opcao4View.layer.borderColor = branco
        opcao5View.layer.borderColor = branco
    }
    
    //MARK: Actions
    @IBAction func selecionarOpcao1() {
        irParaQuestao3(questao2: Constants.opcao1)
    }
    
    @IBAction func selecionarOpcao2() {
        irParaQuestao3(questao2: Constants.opcao2)
    }
    
    @IBAction func selecionarOpcao3() {
        let questao4ViewController: Questao4ViewController = storyboard!.instantiateViewController()
        questao4ViewController.questao1 = questao1
        questao4ViewController.questao2 = Constants.opcao3
        questao4ViewController.turma = turma
        navigationController?.pushViewController(questao4ViewController, animated: true)
    }
    
    @IBAction func selecionarOpcao4() {
        let questao4ViewController: Questao5ViewController = storyboard!.instantiateViewController()
        questao4ViewController.questao1 = questao1
        questao4ViewController.questao2 = Constants.opcao4
        questao4ViewController.turma = turma
        navigationController?.pushViewController(questao4ViewController, animated: true)
    }
    
    @IBAction func selecionarOpcao5() {
        let concluirAvaliacaoViewController: ConcluirAvaliacaoViewController = storyboard!.instantiateViewController()
        concluirAvaliacaoViewController.questao1 = questao1
        concluirAvaliacaoViewController.questao2 = Constants.opcao5
        concluirAvaliacaoViewController.turma = turma
        navigationController?.pushViewController(concluirAvaliacaoViewController, animated: true)
    }
    
    //MARK: Methods
    fileprivate func irParaQuestao3(questao2: UInt8) {
        let questao3ViewController: Questao3ViewController = storyboard!.instantiateViewController()
        questao3ViewController.questao1 = questao1
        questao3ViewController.questao2 = questao2
        questao3ViewController.turma = turma
        navigationController?.pushViewController(questao3ViewController, animated: true)
    }
}

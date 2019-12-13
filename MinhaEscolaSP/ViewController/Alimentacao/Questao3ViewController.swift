//
//  Questao3ViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 25/03/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Lottie
import UIKit

final class Questao3ViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let opcao1: UInt8 = 8
        static let opcao2: UInt8 = 9
        static let opcao3: UInt8 = 10
        static let opcao4: UInt8 = 11
        static let opcao5: UInt8 = 12
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var opcao1Control: UIControl!
    @IBOutlet fileprivate weak var opcao2Control: UIControl!
    @IBOutlet fileprivate weak var opcao3Control: UIControl!
    @IBOutlet fileprivate weak var opcao4Control: UIControl!
    @IBOutlet fileprivate weak var opcao5Control: UIControl!
    @IBOutlet fileprivate weak var opcao1Checkbox: AnimationView!
    @IBOutlet fileprivate weak var opcao2Checkbox: AnimationView!
    @IBOutlet fileprivate weak var opcao3Checkbox: AnimationView!
    @IBOutlet fileprivate weak var opcao4Checkbox: AnimationView!
    @IBOutlet fileprivate weak var opcao5Checkbox: AnimationView!
    
    //MARK: Variables
    fileprivate lazy var opcao1 = false
    fileprivate lazy var opcao2 = false
    fileprivate lazy var opcao3 = false
    fileprivate lazy var opcao4 = false
    fileprivate lazy var opcao5 = false
    var questao1: UInt8!
    var questao2: UInt8!
    var turma: Turma!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let branco = UIColor.white.cgColor
        opcao1Control.layer.borderColor = branco
        opcao2Control.layer.borderColor = branco
        opcao3Control.layer.borderColor = branco
        opcao4Control.layer.borderColor = branco
        opcao5Control.layer.borderColor = branco
        opcao1Checkbox.layer.borderColor = branco
        opcao2Checkbox.layer.borderColor = branco
        opcao3Checkbox.layer.borderColor = branco
        opcao4Checkbox.layer.borderColor = branco
        opcao5Checkbox.layer.borderColor = branco
    }
    
    //MARK: Actions
    @IBAction func selecionarOpcao1() {
        opcao1 = !opcao1
        animaCheckBox(selecionado: opcao1, checkBoxView: opcao1Checkbox)
    }
    
    @IBAction func selecionarOpcao2() {
        opcao2 = !opcao2
        animaCheckBox(selecionado: opcao2, checkBoxView: opcao2Checkbox)
    }
    
    @IBAction func selecionarOpcao3() {
        opcao3 = !opcao3
        animaCheckBox(selecionado: opcao3, checkBoxView: opcao3Checkbox)
    }
    
    @IBAction func selecionarOpcao4() {
        opcao4 = !opcao4
        animaCheckBox(selecionado: opcao4, checkBoxView: opcao4Checkbox)
    }
    
    @IBAction func selecionarOpcao5() {
        opcao5 = !opcao5
        animaCheckBox(selecionado: opcao5, checkBoxView: opcao5Checkbox)
    }
    
    @IBAction func irParaConcluirAvaliacao() {
        let concluirAvaliacaoViewController: ConcluirAvaliacaoViewController = storyboard!.instantiateViewController()
        concluirAvaliacaoViewController.questao1 = questao1
        concluirAvaliacaoViewController.questao2 = questao2
        concluirAvaliacaoViewController.turma = turma
        var questao3 = [UInt8]()
        if opcao1 {
            questao3.append(Constants.opcao1)
        }
        if opcao2 {
            questao3.append(Constants.opcao2)
        }
        if opcao3 {
            questao3.append(Constants.opcao3)
        }
        if opcao4 {
            questao3.append(Constants.opcao4)
        }
        if opcao5 {
            questao3.append(Constants.opcao5)
        }
        concluirAvaliacaoViewController.questao3 = questao3
        navigationController?.pushViewController(concluirAvaliacaoViewController, animated: true)
    }
    
    //MARK: Methods
    fileprivate func animaCheckBox(selecionado: Bool, checkBoxView: AnimationView) {
        if selecionado {
            checkBoxView.animationSpeed = 1
        }
        else {
            checkBoxView.animationSpeed = -1
        }
        checkBoxView.play()
    }
}

//
//  Questao5ViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 25/03/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Lottie
import UIKit

final class Questao5ViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let opcao1: UInt8 = 21
        static let opcao2: UInt8 = 22
        static let opcao3: UInt8 = 23
        static let opcao4: UInt8 = 24
        static let opcao5: UInt8 = 25
        static let opcao6: UInt8 = 26
        static let opcao7: UInt8 = 27
        static let opcao8: UInt8 = 28
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var opcao1Control: UIControl!
    @IBOutlet fileprivate weak var opcao2Control: UIControl!
    @IBOutlet fileprivate weak var opcao3Control: UIControl!
    @IBOutlet fileprivate weak var opcao4Control: UIControl!
    @IBOutlet fileprivate weak var opcao5Control: UIControl!
    @IBOutlet fileprivate weak var opcao6Control: UIControl!
    @IBOutlet fileprivate weak var opcao7Control: UIControl!
    @IBOutlet fileprivate weak var opcao8Control: UIControl!
    @IBOutlet fileprivate weak var opcao1Checkbox: AnimationView!
    @IBOutlet fileprivate weak var opcao2Checkbox: AnimationView!
    @IBOutlet fileprivate weak var opcao3Checkbox: AnimationView!
    @IBOutlet fileprivate weak var opcao4Checkbox: AnimationView!
    @IBOutlet fileprivate weak var opcao5Checkbox: AnimationView!
    @IBOutlet fileprivate weak var opcao6Checkbox: AnimationView!
    @IBOutlet fileprivate weak var opcao7Checkbox: AnimationView!
    @IBOutlet fileprivate weak var opcao8Checkbox: AnimationView!
    
    //MARK: Variables
    fileprivate lazy var opcao1 = false
    fileprivate lazy var opcao2 = false
    fileprivate lazy var opcao3 = false
    fileprivate lazy var opcao4 = false
    fileprivate lazy var opcao5 = false
    fileprivate lazy var opcao6 = false
    fileprivate lazy var opcao7 = false
    fileprivate lazy var opcao8 = false
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
        opcao6Control.layer.borderColor = branco
        opcao7Control.layer.borderColor = branco
        opcao8Control.layer.borderColor = branco
        opcao1Checkbox.layer.borderColor = branco
        opcao2Checkbox.layer.borderColor = branco
        opcao3Checkbox.layer.borderColor = branco
        opcao4Checkbox.layer.borderColor = branco
        opcao5Checkbox.layer.borderColor = branco
        opcao6Checkbox.layer.borderColor = branco
        opcao7Checkbox.layer.borderColor = branco
        opcao8Checkbox.layer.borderColor = branco
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
    
    @IBAction func selecionarOpcao6() {
        opcao6 = !opcao6
        animaCheckBox(selecionado: opcao6, checkBoxView: opcao6Checkbox)
    }
    
    @IBAction func selecionarOpcao7() {
        opcao7 = !opcao7
        animaCheckBox(selecionado: opcao7, checkBoxView: opcao7Checkbox)
    }
    
    @IBAction func selecionarOpcao8() {
        opcao8 = !opcao8
        animaCheckBox(selecionado: opcao8, checkBoxView: opcao8Checkbox)
    }
    
    @IBAction func irParaConcluirAvaliacao() {
        let concluirAvaliacaoViewController: ConcluirAvaliacaoViewController = storyboard!.instantiateViewController()
        concluirAvaliacaoViewController.questao1 = questao1
        concluirAvaliacaoViewController.questao2 = questao2
        concluirAvaliacaoViewController.turma = turma
        var questao5 = [UInt8]()
        if opcao1 {
            questao5.append(Constants.opcao1)
        }
        if opcao2 {
            questao5.append(Constants.opcao2)
        }
        if opcao3 {
            questao5.append(Constants.opcao3)
        }
        if opcao4 {
            questao5.append(Constants.opcao4)
        }
        if opcao5 {
            questao5.append(Constants.opcao5)
        }
        if opcao6 {
            questao5.append(Constants.opcao6)
        }
        if opcao7 {
            questao5.append(Constants.opcao7)
        }
        if opcao8 {
            questao5.append(Constants.opcao8)
        }
        concluirAvaliacaoViewController.questao5 = questao5
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

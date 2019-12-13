//
//  FrequenciaViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 25/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class FrequenciaViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let bimestre = "º bimestre"
        static let frequenciasTableView = "FrequenciasTableView"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var anteriorButton: UIButton!
    @IBOutlet fileprivate weak var bimestreLabel: UILabel!
    @IBOutlet fileprivate weak var frequenciaScrollView: UIScrollView!
    @IBOutlet fileprivate weak var proximoButton: UIButton!
    
    //MARK: Variables
    fileprivate lazy var primeiraVez = true
    fileprivate lazy var indiceAtual: UInt16 = 0
    fileprivate lazy var bimestres = [UInt16]()
    fileprivate lazy var frequenciasMap = [UInt16:[Frequencia]]()
    var frequencias: [Frequencia]!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        proximoButton.transform = CGAffineTransform(rotationAngle: .pi)
        var bimestreSet = Set<UInt16>()
        for frequencia in frequencias {
            let bimestre = frequencia.bimestre - 1
            if !bimestreSet.contains(bimestre) {
                bimestreSet.insert(bimestre)
            }
            if frequenciasMap[bimestre] == nil {
                frequenciasMap[bimestre] = [Frequencia]()
            }
            frequenciasMap[bimestre]?.append(frequencia)
        }
        bimestres = bimestreSet.sorted()
        for bimestre in bimestres {
            frequenciasMap[bimestre]?.sort(by: { (frequencia1, frequencia2) -> Bool in
                return frequencia1.nomeDisciplina < frequencia2.nomeDisciplina
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if primeiraVez {
            primeiraVez = false
            let bimestresCount = bimestres.count
            let height = frequenciaScrollView.frame.height
            let width = view.frame.width
            let frequenciaTableViewCell = UINib(nibName: FrequenciaTableViewCell.className, bundle: nil)
            for i in 0..<bimestresCount {
                let frequenciaTableView = Bundle.main.loadNibNamed(Constants.frequenciasTableView, owner: nil)!.first as! UITableView
                frequenciaTableView.tag = i
                frequenciaTableView.tableFooterView = UIView()
                frequenciaTableView.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: height)
                frequenciaTableView.register(frequenciaTableViewCell, forCellReuseIdentifier: FrequenciaTableViewCell.className)
                frequenciaTableView.dataSource = self
                frequenciaScrollView.addSubview(frequenciaTableView)
            }
            if let bimestre = BimestreDao.bimestreAtual()?.numeroBimestre {
                indiceAtual = bimestre - 1
                configurarTela(animated: false)
            }
            else {
                bimestreLabel.text = String(bimestres.first! + 1) + Constants.bimestre
            }
        }
    }
    
    //MARK: Actions
    @IBAction func anterior() {
        indiceAtual -= 1
        configurarTela()
    }
    
    @IBAction func proximo() {
        indiceAtual += 1
        configurarTela()
    }
    
    @IBAction func sobreAusenciasCompensadas() {
        UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.duvidaAusencias.localized, style: .alert, target: self)
    }
    
    //MARK: Actions
    fileprivate func configurarTela(animated: Bool = true) {
        if indiceAtual == .zero {
            proximoButton.isHidden = false
            anteriorButton.isHidden = true
        }
        else if indiceAtual == bimestres.count - 1 {
            proximoButton.isHidden = true
            anteriorButton.isHidden = false
        }
        else {
            proximoButton.isHidden = false
            anteriorButton.isHidden = false
        }
        bimestreLabel.text = String(indiceAtual + 1) + Constants.bimestre
        frequenciaScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(indiceAtual), y: 0), animated: animated)
    }
}

//MARK: UITableViewDataSource
extension FrequenciaViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let frequencias = frequenciasMap[UInt16(tableView.tag)] {
            return frequencias.count
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FrequenciaTableViewCell = tableView.dequeue(index: indexPath)
        if let frequencias = frequenciasMap[UInt16(tableView.tag)] {
            cell.frequencia = frequencias[indexPath.row]
        }
        return cell
    }
}

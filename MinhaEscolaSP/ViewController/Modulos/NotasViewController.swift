//
//  NotasViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 23/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class NotasViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let altura: CGFloat = 64
        static let bimestre = "º bimestre"
        static let duracaoAnimacao = 0.25
        static let notasTableView = "NotasTableView"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var anteriorButton: UIButton!
    @IBOutlet fileprivate weak var bimestreLabel: UILabel!
    @IBOutlet fileprivate weak var notasScrollView: UIScrollView!
    @IBOutlet fileprivate weak var proximoButton: UIButton!
    
    //MARK: Variables
    fileprivate lazy var primeiraVez = true
    fileprivate lazy var indiceAtual: UInt16 = 0
    fileprivate lazy var bimestres = [UInt16]()
    fileprivate lazy var notasMap = [UInt16:[Nota]]()
    var notas: [Nota]!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        proximoButton.transform = CGAffineTransform(rotationAngle: .pi)
        var bimestreSet = Set<UInt16>()
        for nota in notas {
            nota.expandida = false
            let bimestre = nota.bimestre - 1
            if !bimestreSet.contains(bimestre) {
                bimestreSet.insert(bimestre)
            }
            if notasMap[bimestre] == nil {
                notasMap[bimestre] = [Nota]()
            }
            nota.composicoesNotaArray = (nota.composicoesNota.allObjects as! [ComposicaoNota]).sorted(by: { (composicaoNota1, composicaoNota2) -> Bool in
                return composicaoNota1.descricaoAtividade < composicaoNota2.descricaoAtividade
            })
            notasMap[bimestre]?.append(nota)
        }
        bimestres = bimestreSet.sorted()
        for bimestre in bimestres {
            notasMap[bimestre]?.sort(by: { (nota1, nota2) -> Bool in
                return nota1.nomeDisciplina < nota2.nomeDisciplina
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if primeiraVez {
            primeiraVez = false
            let bimestresCount = bimestres.count
            let height = notasScrollView.frame.height
            let width = view.frame.width
            let notaTableViewCell = UINib(nibName: NotaTableViewCell.className, bundle: nil)
            for i in 0..<bimestresCount {
                let notasTableView = Bundle.main.loadNibNamed(Constants.notasTableView, owner: nil)!.first as! UITableView
                notasTableView.tableFooterView = UIView()
                notasTableView.tag = i
                notasTableView.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: height)
                notasTableView.register(notaTableViewCell, forCellReuseIdentifier: NotaTableViewCell.className)
                notasTableView.dataSource = self
                notasTableView.delegate = self
                notasScrollView.addSubview(notasTableView)
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
    
    //MARK: Methods
    fileprivate func altura(tableView: UITableView, row: Int) -> CGFloat {
        let nota = notasMap[UInt16(tableView.tag)]![row]
        if nota.expandida {
            if nota.composicoesNotaArray.isEmpty {
                return 2 * Constants.altura
            }
            return Constants.altura * CGFloat(nota.composicoesNotaArray.count + 1)
        }
        return Constants.altura
    }
    
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
        notasScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(indiceAtual), y: 0), animated: animated)
    }
}

//MARK: UITableViewDataSource
extension NotasViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let notas = notasMap[UInt16(tableView.tag)] {
            return notas.count
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotaTableViewCell = tableView.dequeue(index: indexPath)
        if let notas = notasMap[UInt16(tableView.tag)] {
            cell.nota = notas[indexPath.row]
        }
        return cell
    }
}

//MARK: UITableViewDelegate
extension NotasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return altura(tableView: tableView, row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return altura(tableView: tableView, row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nota = notasMap[UInt16(tableView.tag)]![indexPath.row]
        let expandida = !nota.expandida
        nota.expandida = expandida
        UIView.animate(withDuration: Constants.duracaoAnimacao, delay: 0, options: .curveEaseInOut, animations: {
            if let cell = tableView.cellForRow(at: indexPath) as? NotaTableViewCell {
                cell.expandida = expandida
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        })
    }
}

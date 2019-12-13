//
//  HorariosViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 22/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class HorariosViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let domingo = 1
        static let sabado = 7
        static let diasDaSemanaInt = ["Segunda-Feira":1,"Terça-Feira":2,"Quarta-Feira":3,"Quinta-Feira":4,"Sexta-Feira":5]
        static let horariosTableView = "HorariosTableView"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var diaDaSemanaLabel: UILabel!
    @IBOutlet fileprivate weak var proximoButton: UIButton!
    @IBOutlet fileprivate weak var voltarButton: UIButton!
    @IBOutlet fileprivate weak var horariosScrollView: UIScrollView!
    
    //MARK: Variables
    fileprivate lazy var primeiraVez = true
    fileprivate lazy var indiceAtual = 0
    fileprivate lazy var diasDaSemana = [String]()
    fileprivate lazy var horarioAulasMap = [String:[HorarioAula]]()
    var horarioAulas: [HorarioAula]!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        proximoButton.transform = CGAffineTransform(rotationAngle: .pi)
        for horarioAula in horarioAulas {
            let diaSemana = horarioAula.diaSemana
            if !diasDaSemana.contains(diaSemana) {
                diasDaSemana.append(diaSemana)
                horarioAulasMap[diaSemana] = []
            }
            horarioAulasMap[diaSemana]?.append(horarioAula)
        }
        diasDaSemana.sort { (diaDaSemana1, diaDaSemana2) -> Bool in
            return Constants.diasDaSemanaInt[diaDaSemana1]! < Constants.diasDaSemanaInt[diaDaSemana2]!
        }
        diaDaSemanaLabel.text = diasDaSemana.first
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if primeiraVez {
            primeiraVez = false
            let height = horariosScrollView.frame.height
            let width = view.frame.width
            let horarioTableViewCell = UINib(nibName: HorarioTableViewCell.className, bundle: nil)
            var i = 0
            for diaDaSemana in diasDaSemana {
                horarioAulasMap[diaDaSemana]?.sort(by: { (horarioAula1, horarioAula2) -> Bool in
                    return horarioAula1.dataHoraInicio < horarioAula2.dataHoraInicio
                })
                let horariosTableView = Bundle.main.loadNibNamed(Constants.horariosTableView, owner: nil)!.first as! UITableView
                horariosTableView.tag = i
                horariosTableView.tableFooterView = UIView()
                horariosTableView.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: height)
                horariosTableView.register(horarioTableViewCell, forCellReuseIdentifier: HorarioTableViewCell.className)
                horariosTableView.dataSource = self
                horariosTableView.delegate = self
                horariosScrollView.addSubview(horariosTableView)
                i += 1
            }
            let calendario = Calendar.current
            var diaDaSemanaHoje = calendario.component(.weekday, from: Date())
            if diaDaSemanaHoje == Constants.domingo || diaDaSemanaHoje == Constants.sabado {
                diaDaSemanaHoje = 0
            }
            else {
                diaDaSemanaHoje -= 2
            }
            if diaDaSemanaHoje < diasDaSemana.count {
                indiceAtual = diaDaSemanaHoje
                configurarTela(animated: false)
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
    fileprivate func configurarTela(animated: Bool = true) {
        if indiceAtual == .zero {
            proximoButton.isHidden = false
            voltarButton.isHidden = true
        }
        else if indiceAtual == diasDaSemana.count - 1 {
            proximoButton.isHidden = true
            voltarButton.isHidden = false
        }
        else {
            proximoButton.isHidden = false
            voltarButton.isHidden = false
        }
        diaDaSemanaLabel.text = diasDaSemana[indiceAtual]
        horariosScrollView.setContentOffset(CGPoint(x: view.frame.width * CGFloat(indiceAtual), y: 0), animated: animated)
    }
}

//MARK: UITableViewDataSource
extension HorariosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return horarioAulasMap[diasDaSemana[tableView.tag]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HorarioTableViewCell = tableView.dequeue(index: indexPath)
        cell.horarioAula = horarioAulasMap[diasDaSemana[tableView.tag]]![indexPath.row]
        return cell
    }
}

//MARK: UITableViewDelegate
extension HorariosViewController: UITableViewDelegate {
}

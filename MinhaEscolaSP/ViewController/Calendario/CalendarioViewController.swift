//
//  CalendarioViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 19/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import FSCalendar
import UIKit

final class CalendarioViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let alturaNavigationBar: CGFloat = 44.0
        static let margem: CGFloat = 16.0
        static let ptBr = "pt-BR"
        static let mesAno = "MMMM yyyy"
        static let corFundoAvaliacao = UIColor(red: 0.67, green: 0, blue: 1, alpha: 1)
        static let corFundoLetivoComEvento = UIColor(red: 0.28, green: 0.76, blue: 0.5, alpha: 1)
        static let corFundoLetivoSemEvento = UIColor(red: 0.33, green: 0.85, blue: 0.56, alpha: 1)
        static let corFundoNaoLetivo = UIColor(red: 0.99, green: 0.66, blue: 0.67, alpha: 1)
        static let corTituloAvaliacao = UIColor(red: 0.2, green: 0.25, blue: 0.29, alpha: 1)
        static let corTituloNaoLetivo = UIColor(red: 1, green: 0, blue: 0.02, alpha: 1)
        static let corTituloLetivo = UIColor(red: 0.14, green: 0.51, blue: 0, alpha: 1)
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var calendarioView: UIView!
    
    //MARK: Variables
    fileprivate lazy var primeiraVez = true
    fileprivate lazy var diasEventoDict = [Date:[DiaEvento]]()
    fileprivate var bimestres: [Bimestre]!
    fileprivate var calendario: FSCalendar!
    fileprivate var dataMaxima: Date!
    fileprivate var dataMinima: Date!
    var diasEvento: [DiaEvento]!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendario = Calendar.current
        diasEvento.sort { (diaEvento1, diaEvento2) -> Bool in
            let dateComponents1 = DateComponents(calendar: calendario, year: Int(diaEvento1.turma.anoLetivo), month: Int(diaEvento1.mes), day: Int(diaEvento1.dia))
            let dateComponents2 = DateComponents(calendar: calendario, year: Int(diaEvento2.turma.anoLetivo), month: Int(diaEvento2.mes), day: Int(diaEvento2.dia))
            if let data1 = calendario.date(from: dateComponents1), let data2 = calendario.date(from: dateComponents2) {
                return data1 < data2
            }
            return false
        }
        if let primeiroDia = diasEvento.first {
            let dateComponents = DateComponents(calendar: calendario, year: Int(primeiroDia.turma.anoLetivo), month: Int(primeiroDia.mes), day: Int(primeiroDia.dia))
            if let data = calendario.date(from: dateComponents) {
                dataMinima = data
            }
        }
        if let ultimoDia = diasEvento.last {
            let dateComponents = DateComponents(calendar: calendario, year: Int(ultimoDia.turma.anoLetivo), month: Int(ultimoDia.mes), day: Int(ultimoDia.dia))
            if let data = calendario.date(from: dateComponents) {
                dataMaxima = data
            }
        }
        for diaEvento in diasEvento {
            let dateComponents = DateComponents(calendar: calendario, year: Int(diaEvento.turma.anoLetivo), month: Int(diaEvento.mes), day: Int(diaEvento.dia))
            if let data = calendario.date(from: dateComponents) {
                if !diasEventoDict.keys.contains(data) {
                    diasEventoDict[data] = [DiaEvento]()
                }
                diasEventoDict[data]?.append(diaEvento)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if primeiraVez {
            primeiraVez = false
            calendario = FSCalendar(frame: CGRect(x: 0, y: 0, width: calendarioView.frame.width, height: calendarioView.frame.height))
            calendario.backgroundColor = .clear
            calendario.dataSource = self
            calendario.delegate = self
            calendario.locale = Locale(identifier: Constants.ptBr)
            calendario.swipeToChooseGesture.isEnabled = true
            let calendarAppeareance = calendario.appearance
            calendarAppeareance.headerMinimumDissolvedAlpha = 0
            calendarAppeareance.borderDefaultColor = .groupTableViewBackground
            calendarAppeareance.eventDefaultColor = .white
            calendarAppeareance.titleTodayColor = .black
            calendarAppeareance.weekdayTextColor = .white
            calendarAppeareance.headerDateFormat = Constants.mesAno
            calendarAppeareance.headerTitleColor = .white
            calendarAppeareance.caseOptions = [.headerUsesUpperCase, .weekdayUsesUpperCase]
            calendarioView.addSubview(calendario)
            bimestres = BimestreDao.buscarBimestres()
            calendario.reloadData()
            var hoje = Date()
            if !Requests.Configuracoes.servidorHabilitado || LoginRequest.usuarioLogado.usuarioMock() {
                let calendar = Calendar.current
                var dateComponents = calendar.dateComponents([.year, .month, .day], from: hoje)
                dateComponents.year = 2018
                if let data = calendar.date(from: dateComponents) {
                    hoje = data
                }
            }
            calendario.setCurrentPage(hoje, animated: false)
        }
    }
    
    //MARK: Methods
    fileprivate func dataDesabilitada(data: Date) -> Bool {
        var ferias = false
        let segundoBimestre = bimestres[1]
        let terceiroBimestre = bimestres[2]
        let dataSemTempo = data.semTempo
        if let primeiroBimestre = bimestres.first, let quartoBimestre = bimestres.last {
            ferias = dataSemTempo < primeiroBimestre.dataInicio || dataSemTempo > quartoBimestre.dataFim || (dataSemTempo > segundoBimestre.dataFim && dataSemTempo < terceiroBimestre.dataInicio)
        }
        let calendar = Calendar.current
        return ferias || calendar.isDateInWeekend(dataSemTempo) || calendar.component(.month, from: dataSemTempo) != calendar.component(.month, from: calendario.currentPage)
    }
}

//MARK: FSCalendarDataSource
extension CalendarioViewController: FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return dataMinima
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return dataMaxima
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if let diasEvento = diasEventoDict[date] {
            return diasEvento.count
        }
        return 0
    }
}

//MARK: FSCalendarDelegate
extension CalendarioViewController: FSCalendarDelegate {
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        calendar.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.deselect(date)
        if let diasEvento = diasEventoDict[date], let eventosNavigationController = storyboard?.instantiateViewController(withIdentifier: EventosViewController.className) as? UINavigationController, let eventosViewController = eventosNavigationController.viewControllers.first as? EventosViewController {
            eventosViewController.diasEvento = diasEvento
            var altura: CGFloat = Constants.alturaNavigationBar + Constants.margem
            let cell = Bundle.main.loadNibNamed(EventoTableViewCell.className, owner: nil)?.first as! EventoTableViewCell
            for diaEvento in diasEvento {
                cell.diaEvento = diaEvento
                cell.layoutIfNeeded()
                altura += cell.frame.height
            }
            presentFormSheetViewController(height: altura, viewController: eventosNavigationController)
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if dataDesabilitada(data: date) {
            return false
        }
        return diasEventoDict.keys.contains(date)
    }
}

//MARK: FSCalendarDelegateAppearance
extension CalendarioViewController: FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        if dataDesabilitada(data: date) {
            return .lightGray
        }
        if let diaEvento = diasEventoDict[date]?.first {
            if !diaEvento.letivo {
                return Constants.corFundoNaoLetivo
            }
            if diaEvento.avaliacao() {
                return Constants.corFundoAvaliacao
            }
            return Constants.corFundoLetivoComEvento
        }
        return Constants.corFundoLetivoSemEvento
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if dataDesabilitada(data: date) {
            return .gray
        }
        if let diaEvento = diasEventoDict[date]?.first {
            if !diaEvento.letivo {
                return Constants.corTituloNaoLetivo
            }
            if diaEvento.avaliacao() {
                 return Constants.corTituloAvaliacao
            }
            return .white
        }
        return Constants.corTituloLetivo
    }
}

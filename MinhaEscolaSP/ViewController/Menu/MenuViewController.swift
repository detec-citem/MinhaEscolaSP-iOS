//
//  MenuViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 14/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Crashlytics
import FirebaseAnalytics
import MBProgressHUD
import UIKit

final class MenuViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let alturaZero: CGFloat = 0
        static let alturaPadrao: CGFloat = 84
        static let numeroDeOpcoes = 11
        static let posicaoMinhaEscola = 0
        static let posicaoSobreMim = 1
        static let posicaoHorario = 2
        static let posicaoNotas = 3
        static let posicaoFrequencia = 4
        static let posicaoCalendario = 5
        static let posicaoAlimentacao = 6
        static let posicaoCarteirinha = 7
        static let posicaoBoletim = 8
        static let posicaoCompartilhar = 9
        static let posicaoSair = 10
        static let escola = "escola"
        static let orientacao = "orientation"
        static let dadosNaoEncontrados = "Dados não encontrados."
        static let calendarioNaoEncontrado = "Calendário não encontrado."
        static let alimentacaoSegue = "AlimentacaoSegue"
        static let boletimSegue = "BoletimSegue"
        static let calendarioSegue = "CalendarioSegue"
        static let carteirinhaSegue = "CarteirinhaSegue"
        static let enviarFotoSegue = "EnviarFotoSegue"
        static let frequenciaSegue = "FrequenciaSegue"
        static let horariosAulaSegue = "HorariosAulaSegue"
        static let minhaEscolaSegue = "MinhaEscolaSegue"
        static let notasSegue = "NotasSegue"
        static let sobreMimSegue = "SobreMimSegue"
        static let minhaEscola = "minha escola"
        static let moduloAlimentacao = "Mód_Alimentação"
        static let moduloBoletim = "Mód_Boletim"
        static let moduloCalendario = "Mód_Calendário"
        static let moduloCarteirinha = "Mód_Carteirinha"
        static let moduloCompartilhar = "Mód_Compartilhar"
        static let moduloFrequencias = "Mód_Frequências"
        static let moduloHorarioAula = "Mód_HorárioAula"
        static let moduloMinhaEscola = "Mód_MinhaEscola"
        static let moduloMinhasNotas = "Mód_MinhasNotas"
        static let moduloSobreMim = "Mód_MenuSobre"
        static let alunosIdentifier = "AlunosViewController"
        static let alimentacaoTableViewCell = "AlimentacaoTableViewCell"
        static let boletimTableViewCell = "BoletimTableViewCell"
        static let calendarioTableViewCell = "CalendarioTableViewCell"
        static let carteirinhaTableViewCell = "CarteirinhaTableViewCell"
        static let compartilharTableViewCell = "CompartilharTableViewCell"
        static let frequenciaTableViewCell = "FrequenciaTableViewCell"
        static let horarioTableViewCell = "HorarioTableViewCell"
        static let minhaEscolaTableViewCell = "MinhaEscolaTableViewCell"
        static let notasTableViewCell = "NotasTableViewCell"
        static let sairTableViewCell = "SairTableViewCell"
        static let sobreMimTableViewCell = "SobreMimTableViewCell"
        static let buttonId = "ButtonID"
        static let perfilAluno = "PerfilAluno"
        static let perfilAlunoInt = 6
        static let perfilResponsavel = "PerfilResponsável"
        static let perfilResponsavelInt = 7
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var alturaStatusBarConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var topStatusBarConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var menuTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var alunoLabel: UILabel!
    @IBOutlet fileprivate weak var alunosComboBox: UIView!
    @IBOutlet fileprivate weak var fundoImageView: UIImageView!
    @IBOutlet fileprivate weak var menuTableView: UITableView!
    
    //MARK: Variables
    
    fileprivate var alunos: [Aluno]!
    fileprivate var alunoSelecionado: Aluno!
    fileprivate var turmaAtiva: Turma?
    fileprivate lazy var alunosRematriculados = 0
    fileprivate lazy var alunosParaMatricular = 0
    fileprivate lazy var fazerRematricula = false
    fileprivate lazy var indiceAlunoSelecionado = 0
    fileprivate lazy var voltandoCarteirinha = false
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alunosComboBox.layer.borderColor = UIColor.white.cgColor
        let alturaStatusBar = UIApplication.shared.statusBarFrame.height
        alturaStatusBarConstraint.constant = alturaStatusBar
        topStatusBarConstraint.constant = -alturaStatusBar
        let usuarioLogado = LoginRequest.usuarioLogado!
        #if DEBUG
        #else
            Crashlytics.sharedInstance().setUserName(usuarioLogado.nome)
        #endif
        alunoLabel.text = usuarioLogado.nome
        if usuarioLogado.estudante {
            #if DEBUG
            #else
            Crashlytics.sharedInstance().setUserIdentifier(usuarioLogado.numeroRa + usuarioLogado.digitoRa + usuarioLogado.ufRa)
            let parametros: [String:Any] = [Constants.perfilAluno:Constants.perfilAlunoInt,AnalyticsParameterContentType:Constants.perfilAluno]
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: parametros)
            Analytics.logEvent(Constants.perfilAluno, parameters: parametros)
            #endif
            alunoSelecionado = usuarioLogado.aluno
            menuTopConstraint.constant = Constants.alturaZero
            alunosComboBox.removeFromSuperview()
            fundoImageView.removeFromSuperview()
        }
        else {
            #if DEBUG
            #else
            Crashlytics.sharedInstance().setUserIdentifier(usuarioLogado.usuario)
            let parametros: [String:Any] = [Constants.perfilResponsavel:Constants.perfilResponsavelInt,AnalyticsParameterContentType:Constants.perfilResponsavel]
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: parametros)
            Analytics.logEvent(Constants.perfilResponsavel, parameters: parametros)
            #endif
            alunos = AlunoDao.buscarAlunos()
            alunoSelecionado = alunos.first
            alunoLabel.text = alunoSelecionado.nome
            for aluno in alunos {
                if aluno.interesseRematricula == nil {
                    alunosParaMatricular += 1
                }
            }
        }
        turmaAtiva = TurmaDao.buscarTurmaAtiva(aluno: alunoSelecionado)
        view.layoutIfNeeded()
        mostrarMensagemRematricula()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        fazerRematricula = false
        if voltandoCarteirinha {
            voltandoCarteirinha = false
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: Constants.orientacao)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !voltandoCarteirinha {
            navigationController?.isNavigationBarHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        if segueIdentifier == Constants.boletimSegue, let boletimViewController = segue.destination as? BoletimViewController {
            boletimViewController.aluno = alunoSelecionado
            enviarEvento(evento: Constants.moduloBoletim)
        }
        else if segueIdentifier == Constants.calendarioSegue, let calendarioViewController = segue.destination as? CalendarioViewController {
            calendarioViewController.diasEvento = turmaAtiva?.diasEvento.allObjects as? [DiaEvento]
        }
        else if segueIdentifier == Constants.carteirinhaSegue, let carteirinhaViewController = segue.destination as? CarteirinhaViewController {
            voltandoCarteirinha = true
            carteirinhaViewController.carteirinha = alunoSelecionado.carteirinha
        }
        else if segueIdentifier == Constants.horariosAulaSegue, let horariosAula = alunoSelecionado.horariosAula.allObjects as? [HorarioAula], let horariosViewController = segue.destination as? HorariosViewController {
            horariosViewController.horarioAulas = horariosAula
        }
        else if segueIdentifier == Constants.frequenciaSegue, let frequencias = alunoSelecionado.frequencias.allObjects as? [Frequencia], let frequenciaViewController = segue.destination as? FrequenciaViewController {
            frequenciaViewController.frequencias = frequencias
        }
        else if segueIdentifier == Constants.minhaEscolaSegue, let minhaEscolaViewController = segue.destination as? MinhaEscolaViewController {
            minhaEscolaViewController.escola = (alunoSelecionado.escolas as? Set<Escola>)?.first
            enviarEvento(evento: Constants.moduloMinhaEscola)
        }
        else if segueIdentifier == Constants.notasSegue, let notasViewController = segue.destination as? NotasViewController {
            notasViewController.notas = alunoSelecionado.notas.allObjects as? [Nota]
        }
        else if segueIdentifier == Constants.sobreMimSegue, let sobreMimViewController = segue.destination as? SobreMimViewController, let turmaAtiva = turmaAtiva {
            sobreMimViewController.aluno = alunoSelecionado
            sobreMimViewController.delegate = self
            sobreMimViewController.fazerRematricula = fazerRematricula
            sobreMimViewController.turmaAtiva = turmaAtiva
            enviarEvento(evento: Constants.moduloSobreMim)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Constants.boletimSegue && alunoSelecionado.matriculas.count == .zero {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.semTurmas.localized, style: .alert, target: self)
            return false
        }
        if identifier == Constants.minhaEscolaSegue, (alunoSelecionado.escolas as? Set<Escola>)?.first == nil {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.semEscola.localized, style: .alert, target: self)
            return false
        }
        if identifier == Constants.sobreMimSegue, turmaAtiva == nil {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.semTurmaAnoAtual.localized, style: .alert, target: self)
            return false
        }
        if identifier == Constants.alimentacaoSegue {
            if let turmaAtiva = turmaAtiva {
                if executarRequisicao() {
                    let progress = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
                    progress.label.text = Localizable.carregando.localized
                    AlimentacaoRequest.podeResponder { (podeResponder, sucesso, erro) in
                        DispatchQueue.main.async {
                            progress.hide(animated: true)
                            if sucesso, let podeResponder = podeResponder {
                                if podeResponder {
                                    let questao1ViewController: Questao1ViewController = self.storyboard!.instantiateViewController()
                                    questao1ViewController.turma = turmaAtiva
                                    self.enviarEvento(evento: Constants.moduloAlimentacao)
                                    self.navigationController?.pushViewController(questao1ViewController, animated: true)
                                }
                                else {
                                    UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.avaliarUmaVezPorDia.localized, style: .alert, target: self.navigationController)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                            else {
                                UIAlertController.createAlert(title: Localizable.atencao.localized, message: erro, style: .alert, target: self.navigationController)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
                else {
                    UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.internet.localized, style: .alert, target: self.navigationController)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.semTurmaAnoAtual.localized, style: .alert, target: self)
            }
            return false
        }
        if identifier == Constants.calendarioSegue {
            if let turmaAtiva = turmaAtiva {
                if executarRequisicao() {
                    let progressHud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
                    progressHud.label.text = Localizable.carregando.localized
                    progressHud.detailsLabel.text = Localizable.carregandoCalendario.localized
                    CalendarioRequest.buscarCalendario(turma: turmaAtiva, completion: { (diasEventos, sucesso, erro) in
                        DispatchQueue.main.async {
                            progressHud.hide(animated: true)
                            if sucesso, let diasEventos = diasEventos {
                                turmaAtiva.diasEvento = NSSet(array: diasEventos)
                                self.enviarEvento(evento: Constants.moduloCalendario)
                                self.performSegue(withIdentifier: Constants.calendarioSegue, sender: nil)
                            }
                            else {
                                var mensagem: String!
                                var titulo: String!
                                if erro == Constants.calendarioNaoEncontrado {
                                    mensagem = Localizable.erroCalendario.localized
                                    titulo = Localizable.ops.localized
                                }
                                else {
                                    mensagem = erro
                                    titulo = Localizable.atencao.localized
                                }
                                UIAlertController.createAlert(title: titulo, message: mensagem, style: .alert, target: self)
                            }
                        }
                    })
                    return false
                }
                if turmaAtiva.diasEvento.count > 0 {
                    enviarEvento(evento: Constants.moduloCalendario)
                    return true
                }
                UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.internetCarteirinha.localized, style: .alert, target: self)
            }
            else {
                UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.semTurmaAnoAtual.localized, style: .alert, target: self)
            }
            return false
        }
        if identifier == Constants.carteirinhaSegue, let usuarioLogado = LoginRequest.usuarioLogado {
            if executarRequisicao() {
                let progressHud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
                progressHud.label.text = Localizable.carregando.localized
                progressHud.detailsLabel.text = Localizable.carregandoCarteirinha.localized
                CarteirinhaRequest.pegarCarteirinha(aluno: alunoSelecionado, completion: { (carteirinha, sucesso, erro) in
                    DispatchQueue.main.async {
                        progressHud.hide(animated: true)
                        if sucesso {
                            if let carteirinha = carteirinha {
                                self.alunoSelecionado.carteirinha = carteirinha
                                self.enviarEvento(evento: Constants.moduloCarteirinha)
                                self.performSegue(withIdentifier: Constants.carteirinhaSegue, sender: nil)
                            }
                            else if usuarioLogado.estudante {
                                self.enviarEvento(evento: Constants.moduloCarteirinha)
                                self.performSegue(withIdentifier: Constants.enviarFotoSegue, sender: nil)
                            }
                            else {
                                UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.alunoSemCarteirinha.localized, style: .alert, target: self)
                            }
                        }
                        else {
                            UIAlertController.createAlert(title: Localizable.atencao.localized, message: erro, style: .alert, target: self)
                        }
                    }
                })
                return false
            }
            if alunoSelecionado.carteirinha != nil {
                enviarEvento(evento: Constants.moduloCarteirinha)
                return true
            }
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.internetCarteirinha.localized, style: .alert, target: self)
            return false
        }
        if identifier == Constants.frequenciaSegue {
            if executarRequisicao() {
                if let turmaAtiva = turmaAtiva {
                    let progressHud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
                    progressHud.label.text = Localizable.carregando.localized
                    progressHud.detailsLabel.text = Localizable.carregandoFrequencias.localized
                    NotasFrequenciaRequest.buscarFrequencias(aluno: alunoSelecionado, turma: turmaAtiva) { (frequencias, sucesso, erro) in
                        DispatchQueue.main.async {
                            progressHud.hide(animated: true)
                            if sucesso, let frequencias = frequencias {
                                if frequencias.isEmpty {
                                    UIAlertController.createAlert(title: Localizable.ops.localized, message: Localizable.semFrequenciaTurmaAtual.localized, style: .alert, target: self)
                                }
                                else {
                                    self.alunoSelecionado.frequencias = NSSet(array: frequencias)
                                    CoreDataManager.sharedInstance.saveContext()
                                    self.enviarEvento(evento: Constants.moduloFrequencias)
                                    self.performSegue(withIdentifier: Constants.frequenciaSegue, sender: nil)
                                }
                            }
                            else if erro == Constants.dadosNaoEncontrados {
                                UIAlertController.createAlert(title: Localizable.ops.localized, message: Localizable.semFrequenciaTurmaAtual.localized, style: .alert, target: self)
                            }
                            else {
                                UIAlertController.createAlert(title: Localizable.atencao.localized, message: erro, style: .alert, target: self)
                            }
                        }
                    }
                }
                else {
                    UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.semTurmaAnoAtual.localized, style: .alert, target: self)
                }
                return false
            }
            if alunoSelecionado.frequencias.count > 0 {
                enviarEvento(evento: Constants.moduloFrequencias)
                return true
            }
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.internetFrequencias.localized, style: .alert, target: self)
            return false
        }
        if identifier == Constants.horariosAulaSegue {
            if executarRequisicao() {
                if let turmaAtiva = turmaAtiva {
                    let progressHud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
                    progressHud.label.text = Localizable.carregando.localized
                    progressHud.detailsLabel.text = Localizable.carregandoHorarios.localized
                    HorariosAulaRequest.pegarHorariosAula(aluno: alunoSelecionado, turma: turmaAtiva) { (horariosAula, sucesso, erro) in
                        DispatchQueue.main.async {
                            progressHud.hide(animated: true)
                            if sucesso, let horariosAula = horariosAula {
                                if horariosAula.isEmpty {
                                    UIAlertController.createAlert(title: Localizable.ops.localized, message: Localizable.semHorarioTurmaAtual.localized, style: .alert, target: self)
                                }
                                else {
                                    self.alunoSelecionado.horariosAula = NSSet(array: horariosAula)
                                    CoreDataManager.sharedInstance.saveContext()
                                    self.enviarEvento(evento: Constants.moduloHorarioAula)
                                    self.performSegue(withIdentifier: Constants.horariosAulaSegue, sender: nil)
                                }
                            }
                            else {
                                UIAlertController.createAlert(title: Localizable.atencao.localized, message: erro, style: .alert, target: self)
                            }
                        }
                    }
                }
                else {
                    UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.semTurmaAnoAtual.localized, style: .alert, target: self)
                }
                return false
            }
            if alunoSelecionado.horariosAula.count > 0 {
                enviarEvento(evento: Constants.moduloHorarioAula)
                return true
            }
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.internetHorarioAula.localized, style: .alert, target: self)
            return false
        }
        if identifier == Constants.notasSegue {
            if executarRequisicao() {
                if let turmaAtiva = turmaAtiva {
                    let progressHud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
                    progressHud.label.text = Localizable.carregando.localized
                    progressHud.detailsLabel.text = Localizable.carregandoNotas.localized
                    NotasFrequenciaRequest.buscarNotas(aluno: alunoSelecionado, turma: turmaAtiva) { (notas, sucesso, erro) in
                        DispatchQueue.main.async {
                            progressHud.hide(animated: true)
                            if sucesso, let notas = notas {
                                if notas.isEmpty {
                                    UIAlertController.createAlert(title: Localizable.ops.localized, message: Localizable.semNotaTurmaAtual.localized, style: .alert, target: self)
                                }
                                else {
                                    self.alunoSelecionado.notas = NSSet(array: notas)
                                    CoreDataManager.sharedInstance.saveContext()
                                    self.enviarEvento(evento: Constants.moduloMinhasNotas)
                                    self.performSegue(withIdentifier: Constants.notasSegue, sender: nil)
                                }
                            }
                            else if erro == Constants.dadosNaoEncontrados {
                                UIAlertController.createAlert(title: Localizable.ops.localized, message: Localizable.semNotaTurmaAtual.localized, style: .alert, target: self)
                            }
                            else {
                                UIAlertController.createAlert(title: Localizable.atencao.localized, message: erro, style: .alert, target: self)
                            }
                        }
                    }
                }
                else {
                    UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.semTurmaAnoAtual.localized, style: .alert, target: self)
                }
                return false
            }
            if alunoSelecionado.notas.count > 0 {
                enviarEvento(evento: Constants.moduloMinhasNotas)
                return true
            }
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.internetNotas.localized, style: .alert, target: self)
            return false
        }
        return true
    }
    
    //MARK: Actions
    @IBAction func mostrarAlunos() {
        let alunosNavigationController = storyboard!.instantiateViewController(withIdentifier: Constants.alunosIdentifier) as! UINavigationController
        let alunosViewController = alunosNavigationController.viewControllers.first as! AlunosViewController
        alunosViewController.delegate = self
        alunosViewController.alunos = alunos
        presentFormSheetViewController(viewController: alunosNavigationController)
    }
    
    //MARK: Methods
    fileprivate func calcularAlturaCelula(linha: Int) -> CGFloat {
        if linha == Constants.posicaoAlimentacao && !LoginRequest.usuarioLogado.estudante {
            return Constants.alturaZero
        }
        return Constants.alturaPadrao
    }
    
    fileprivate func enviarEvento(evento: String) {
        #if DEBUG
        #else
        let parametros: [String:Any] = [Constants.buttonId:UInt8.zero,AnalyticsParameterContentType:evento]
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: parametros)
        Analytics.logEvent(evento, parameters: parametros)
        #endif
    }
    
    fileprivate func executarRequisicao() -> Bool {
        return !Requests.Configuracoes.servidorHabilitado || Requests.conectadoInternet() || LoginRequest.usuarioLogado.usuarioMock()
    }
    
    fileprivate func mostrarMensagemRematricula() {
        if alunoSelecionado.respondeRematricula && alunoSelecionado.interesseRematricula == nil && (!LoginRequest.usuarioLogado.estudante || alunoSelecionado.maiorDeIdade()) {
            let iniciar = UIAlertAction(title: Localizable.iniciar.localized, style: .default) { (_) in
                self.fazerRematricula = true
                self.performSegue(withIdentifier: Constants.sobreMimSegue, sender: nil)
            }
            if let anoLetivo = turmaAtiva?.anoLetivo {
                UIAlertController.createAlert(title: Localizable.atencao.localized, message: String(format: Localizable.realizeAMatriculaDe.localized, anoLetivo + 1), style: .alert, actions: [iniciar], target: self)
            }
        }
        else {
            fazerRematricula = false
        }
    }
}

//MARK: AlunoDelegate
extension MenuViewController: AlunoDelegate {
    func selecionouAluno(aluno: Aluno) {
        if fazerRematricula && aluno.interesseRematricula != nil {
            let ok = UIAlertAction(title: Localizable.ok.localized, style: .default, handler: { _ in
                self.mostrarAlunos()
            })
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.selecioneUmAlunoQueNaoRealizouAMatriculaAinda.localized, style: .alert, actions: [ok], target: self)
        }
        else {
            alunoSelecionado = aluno
            alunoLabel.text = aluno.nome
            if !LoginRequest.usuarioLogado.estudante {
                turmaAtiva = TurmaDao.buscarTurmaAtiva(aluno: alunoSelecionado)
                menuTableView.reloadData()
                mostrarMensagemRematricula()
            }
        }
    }
}

//MARK: RematriculaDelegate
extension MenuViewController: RematriculaDelegate {
    func realizouRematricula() {
        if !LoginRequest.usuarioLogado!.estudante {
            alunosRematriculados += 1
            if alunosRematriculados < alunosParaMatricular {
                mostrarAlunos()
            }
        }
    }
}

//MARK: UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numeroDeOpcoes
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == Constants.posicaoMinhaEscola {
            let cell: MinhaEscolaTableViewCell = tableView.dequeue(index: indexPath)
            if LoginRequest.usuarioLogado.estudante {
                cell.minhaEscolaLabel.text = Constants.minhaEscola
            }
            else {
                cell.minhaEscolaLabel.text = Constants.escola
            }
            return cell
        }
        if row == Constants.posicaoSobreMim {
            let cell: SobreMimTableViewCell = tableView.dequeue(index: indexPath)
            if !LoginRequest.usuarioLogado.estudante {
                cell.aluno = alunoSelecionado
            }
            return cell
        }
        if row == Constants.posicaoHorario {
            return tableView.dequeueReusableCell(withIdentifier: Constants.horarioTableViewCell, for: indexPath)
        }
        if row == Constants.posicaoNotas {
            return tableView.dequeueReusableCell(withIdentifier: Constants.notasTableViewCell, for: indexPath)
        }
        if row == Constants.posicaoFrequencia {
            return tableView.dequeueReusableCell(withIdentifier: Constants.frequenciaTableViewCell, for: indexPath)
        }
        if row == Constants.posicaoCalendario {
            return tableView.dequeueReusableCell(withIdentifier: Constants.calendarioTableViewCell, for: indexPath)
        }
        if row == Constants.posicaoAlimentacao {
            return tableView.dequeueReusableCell(withIdentifier: Constants.alimentacaoTableViewCell, for: indexPath)
        }
        if row == Constants.posicaoCarteirinha {
            return tableView.dequeueReusableCell(withIdentifier: Constants.carteirinhaTableViewCell, for: indexPath)
        }
        if row == Constants.posicaoBoletim {
            return tableView.dequeueReusableCell(withIdentifier: Constants.boletimTableViewCell, for: indexPath)
        }
        if row == Constants.posicaoCompartilhar {
            return tableView.dequeueReusableCell(withIdentifier: Constants.compartilharTableViewCell, for: indexPath)
        }
        return tableView.dequeueReusableCell(withIdentifier: Constants.sairTableViewCell, for: indexPath)
    }
}

//MARK: UITableViewDelegate
extension MenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return calcularAlturaCelula(linha: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calcularAlturaCelula(linha: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        if row == Constants.posicaoSair {
            CoreDataManager.sharedInstance.deleteDatabase()
            UIApplication.shared.keyWindow?.rootViewController = storyboard?.instantiateInitialViewController()
        }
        else if row == Constants.posicaoCompartilhar {
            let activityViewController = UIActivityViewController(activityItems: [Localizable.textoCompartilhar.localized], applicationActivities: nil)
            activityViewController.title = Localizable.tituloCompartilhar.localized
            activityViewController.popoverPresentationController?.sourceView = view
            self.enviarEvento(evento: Constants.moduloCompartilhar)
            present(activityViewController, animated: true)
        }
    }
}

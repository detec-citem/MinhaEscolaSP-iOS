//
//  NotasViewController.swift
//  TodayExtension
//
//  Created by Victor Bozelli Alvarez on 19/03/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit
import NotificationCenter

final class NotasViewController: UIViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let altura: CGFloat = 64
        static let bimestre = "º bimestre"
        static let dadosNaoEncontrados = "Dados não encontrados."
        static let duracaoAnimacao = 0.25
        static let espacoTopo: CGFloat = 37
        static let primeiraAltura: CGFloat = 64
        static let loginAlunoNotas = "Faça login como aluno para visuzalizar as notas"
        static let notasTableView = "NotasTableView"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var anteriorButton: UIButton!
    @IBOutlet fileprivate weak var bimestreLabel: UILabel!
    @IBOutlet fileprivate weak var messageLabel: UILabel!
    @IBOutlet fileprivate weak var notasScrollView: UIScrollView!
    @IBOutlet fileprivate weak var proximoButton: UIButton!
    
    //MARK: Variables
    fileprivate lazy var indiceAtual: UInt16 = 0
    fileprivate lazy var contentHeight = Constants.primeiraAltura
    fileprivate lazy var bimestres = [UInt16]()
    fileprivate var notasMap: [UInt16:[Nota]]!
    fileprivate var notas: [Nota]!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
        else {
            configurarAlturaWidget()
        }
        proximoButton.transform = CGAffineTransform(rotationAngle: .pi)
        LoginRequest.usuarioLogado = UsuarioDao.usuarioLogado()
        atualizarNotas(completion: nil)
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
    fileprivate func atualizarNotas(completion: ((NCUpdateResult) -> Void)?) {
        if let usuarioLogado = LoginRequest.usuarioLogado {
            if usuarioLogado.perfil == UsuarioDao.Perfil.responsavel.rawValue {
                messageLabel.text = Constants.loginAlunoNotas
                configurarModoWidget(erro: true)
                completion?(.failed)
            }
            else {
                let aluno = usuarioLogado.aluno
                if let turmaAtiva = TurmaDao.buscarTurmaAtiva(aluno: aluno) {
                    if !Requests.Configuracoes.servidorHabilitado || Requests.conectadoInternet() || LoginRequest.usuarioLogado.usuarioMock() {
                        activityIndicatorView.startAnimating()
                        NotasFrequenciaRequest.buscarNotas(aluno: aluno, turma: turmaAtiva) { (notas, sucesso, erro) in
                            DispatchQueue.main.async {
                                self.activityIndicatorView.stopAnimating()
                                if sucesso, let notas = notas {
                                    if notas.isEmpty {
                                        self.messageLabel.text = Localizable.ops.localized + " " + Localizable.semNotaTurmaAtual.localized
                                        self.configurarModoWidget(erro: true)
                                        completion?(.noData)
                                    }
                                    else {
                                        self.notas = notas
                                        aluno.notas = NSSet(array: notas)
                                        CoreDataManager.sharedInstance.saveContext()
                                        self.configurarNotas()
                                        self.configurarModoWidget(erro: false)
                                        completion?(.newData)
                                    }
                                }
                                else if erro == Constants.dadosNaoEncontrados {
                                    self.messageLabel.text = Localizable.ops.localized + " " + Localizable.semNotaTurmaAtual.localized
                                    self.configurarModoWidget(erro: true)
                                    completion?(.noData)
                                }
                                else {
                                    self.messageLabel.text = erro
                                    self.configurarModoWidget(erro: true)
                                    completion?(.failed)
                                }
                            }
                        }
                    }
                    else if aluno.notas.count > 0 {
                        notas = aluno.notas.allObjects as? [Nota]
                        configurarNotas()
                        configurarModoWidget(erro: false)
                        completion?(.noData)
                    }
                    else {
                        messageLabel.text = Localizable.atencao.localized + " " + Localizable.internetNotas.localized
                        configurarModoWidget(erro: true)
                        completion?(.failed)
                    }
                }
                else {
                    messageLabel.text = Localizable.atencao.localized + " " + Localizable.semTurmaAnoAtual.localized
                    configurarModoWidget(erro: true)
                    completion?(.failed)
                }
            }
        }
        else {
            messageLabel.text = Constants.loginAlunoNotas
            configurarModoWidget(erro: true)
            completion?(.failed)
        }
    }
    
    fileprivate func configurarAlturaTabela(tableView: UITableView, row: Int) -> CGFloat {
        let nota = notasMap[UInt16(tableView.tag)]![row]
        if nota.expandida {
            if nota.composicoesNotaArray.isEmpty {
                return 2 * Constants.altura
            }
            return Constants.altura * CGFloat(nota.composicoesNotaArray.count + 1)
        }
        return Constants.altura
    }
    
    fileprivate func configurarAlturaWidget() {
        var altura: CGFloat!
        let width = view.frame.size.width
        if #available(iOSApplicationExtension 10, *), let activeDisplayMode = extensionContext?.widgetActiveDisplayMode {
            if activeDisplayMode == .expanded, let alturaMaxima = extensionContext?.widgetMaximumSize(for: activeDisplayMode).height {
                altura = alturaMaxima
                notasScrollView.frame.size.height = alturaMaxima
                self.preferredContentSize = CGSize(width: width, height: alturaMaxima)
            }
            else {
                altura = Constants.primeiraAltura
                notasScrollView.frame.size.height = Constants.primeiraAltura
                self.preferredContentSize = CGSize(width: width, height: Constants.primeiraAltura + Constants.espacoTopo)
            }
        }
        else {
            altura = contentHeight
            notasScrollView.frame.size.height = contentHeight
            self.preferredContentSize = CGSize(width: width, height: contentHeight + Constants.espacoTopo)
        }
        let subviews = notasScrollView.subviews
        for subView in subviews {
            if let tableView = subView as? UITableView {
                tableView.frame.size.height = altura
            }
        }
    }
    
    fileprivate func configurarModoWidget(erro: Bool) {
        if erro {
            contentHeight = Constants.primeiraAltura
        }
        if #available(iOSApplicationExtension 10.0, *) {
            if erro {
                extensionContext?.widgetLargestAvailableDisplayMode = .compact
            }
            else {
                extensionContext?.widgetLargestAvailableDisplayMode = .expanded
            }
        }
        configurarAlturaWidget()
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
    
    fileprivate func configurarNotas() {
        bimestreLabel.isHidden = false
        notasMap = [UInt16:[Nota]]()
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
        let bimestresCount = bimestres.count
        let width = view.frame.width
        let notaTableViewCell = UINib(nibName: NotaTableViewCell.className, bundle: nil)
        for i in 0..<bimestresCount {
            let notasTableView = Bundle.main.loadNibNamed(Constants.notasTableView, owner: nil)!.first as! UITableView
            notasTableView.tag = i
            notasTableView.frame = CGRect(x: width * CGFloat(i), y: 0, width: width, height: 0)
            notasTableView.register(notaTableViewCell, forCellReuseIdentifier: NotaTableViewCell.className)
            notasTableView.dataSource = self
            notasTableView.delegate = self
            notasScrollView.addSubview(notasTableView)
            notasTableView.reloadData()
            contentHeight = notasTableView.contentSize.height
            notasTableView.frame.size.height = contentHeight
        }
        notasScrollView.frame.size.height = contentHeight
        if let bimestre = BimestreDao.bimestreAtual()?.numeroBimestre {
            indiceAtual = bimestre - 1
            configurarTela(animated: false)
        }
        else {
            proximoButton.isHidden = false
            bimestreLabel.text = String(bimestres.first! + 1) + Constants.bimestre
        }
        configurarAlturaWidget()
    }
}

//MARK: NCWidgetProviding
extension NotasViewController: NCWidgetProviding {
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        configurarAlturaWidget()
    }
    
    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        atualizarNotas(completion: completionHandler)
    }
}

//MARK: UITableViewDataSource
extension NotasViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notasMap[UInt16(tableView.tag)]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NotaTableViewCell = tableView.dequeue(index: indexPath)
        cell.nota = notasMap[UInt16(tableView.tag)]![indexPath.row]
        return cell
    }
}

//MARK: UITableViewDelegate
extension NotasViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return configurarAlturaTabela(tableView: tableView, row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return configurarAlturaTabela(tableView: tableView, row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nota = notasMap[UInt16(tableView.tag)]![indexPath.row]
        let expandida = !nota.expandida
        nota.expandida = expandida
        UIView.animate(withDuration: Constants.duracaoAnimacao, delay: 0, options: .curveEaseInOut, animations: {
            if let cell = tableView.cellForRow(at: indexPath) as? NotaTableViewCell {
                cell.expandida = expandida
            }
            let indexPathsVisiveis = tableView.indexPathsForVisibleRows!
            for indexPathsVisivel in indexPathsVisiveis {
                if indexPathsVisivel != indexPath, let cell = tableView.cellForRow(at: indexPathsVisivel) as? NotaTableViewCell {
                    cell.expandida = false
                    cell.nota.expandida = false
                }
            }
            tableView.beginUpdates()
            tableView.endUpdates()
        })
    }
}

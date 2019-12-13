//
//  SobreMimViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 14/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import FirebaseAnalytics
import MBProgressHUD
import MobileCoreServices
import UIKit

final class SobreMimViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let alturaCursoTecnicoView: CGFloat = 177
        static let alturaInteressesView: CGFloat = 498
        static let alturaNoturnoControl: CGFloat = 46
        static let alturaTableViewCell: CGFloat = 44
        static let buttonId = "ButtonID"
        static let cabecalhoJpeg = "data:image/jpeg;base64,"
        static let cursoTecnicoViewTop: CGFloat = 16
        static let cursoTecnicoTableViewCell = "CursoTecnicoTableViewCell"
        static let cursosTecnicosNavigationController = "CursosTecnicosNavigationController"
        static let duracaoAnimacaoMilissegundos = 250
        static let duracaoAnimacaoSegundos = 0.25
        static let editarEmailNavigationController = "EditarEmailNavigationController"
        static let editarEnderecoNavigationController = "EditarEnderecoNavigationController"
        static let editarTelefoneNavigationController = "EditarTelefoneNavigationController"
        static let historicoMatriculasSegue = "HistoricoMatriculasSegue"
        static let imagemBack = "back"
        static let imagemFoto = "foto"
        static let justificativaNoturnoNavigationController = "JustificativaNoturnoNavigationController"
        static let moduloHistoricoMatricula = "Mód_HistóricoMatrícula"
        static let noturnoControlViewTop: CGFloat = 16
        static let separador1 = "-"
        static let separador2 = " - "
        static let separadorUfRa = " / "
        static let sobreComprovanteNavigationController = "SobreComprovanteNavigationController"
        static let termoResponsabilidadeNavigationController = "TermoResponsabilidadeNavigationController"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var adicionarTelefoneComprimentoConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var adicionarTelefoneLeadingConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var bairroLabel: UILabel!
    @IBOutlet fileprivate weak var cepLabel: UILabel!
    @IBOutlet fileprivate weak var cidadeEstadoLabel: UILabel!
    @IBOutlet fileprivate weak var complementoLabel: UILabel!
    @IBOutlet fileprivate weak var comprovanteLabel: UILabel!
    @IBOutlet fileprivate weak var comprovanteView: UIView!
    @IBOutlet fileprivate weak var comprovanteViewAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var comprovanteViewTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var cpfLabel: UILabel!
    @IBOutlet fileprivate weak var cpfView: UIView!
    @IBOutlet fileprivate weak var cursoTecnicoAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var cursoTecnicoView: UIControl!
    @IBOutlet fileprivate weak var cursosTecnicosTableView: UITableView!
    @IBOutlet fileprivate weak var cursosTecnicosTableViewAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var cursoTecnicoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var dataNascimentoLabel: UILabel!
    @IBOutlet fileprivate weak var dataNascimentoView: UIView!
    @IBOutlet fileprivate weak var editarEmailAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var editarEmailAlunoButton: UIButton!
    @IBOutlet fileprivate weak var editarEmailTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var editarEnderecoAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var editarEnderecoTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var emailLabel: UILabel!
    @IBOutlet fileprivate weak var emailView: UIView!
    @IBOutlet fileprivate weak var emailResponsavelLabel: UILabel!
    @IBOutlet fileprivate weak var emailResponsavelView: UIView!
    @IBOutlet fileprivate weak var emailResponsavelViewAlturaContraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var emailResponsavelViewTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var enderecoLabel: UILabel!
    @IBOutlet fileprivate weak var enderecoView: UIView!
    @IBOutlet fileprivate weak var espanholLabelAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var espanholLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var espanholSwitch: UISwitch!
    @IBOutlet fileprivate weak var espanholSwitchAlturaContraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var fotoActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var fotoImageView: UIImageView!
    @IBOutlet fileprivate weak var integralSwitch: UISwitch!
    @IBOutlet fileprivate weak var integralSwitchAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var interessesViewAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var justificativaNoturnoLabel: UILabel!
    @IBOutlet fileprivate weak var localNascimentoLabel: UILabel!
    @IBOutlet fileprivate weak var localNascimentoView: UIView!
    @IBOutlet fileprivate weak var nacionalidadeLabel: UILabel!
    @IBOutlet fileprivate weak var nacionalidadeView: UIView!
    @IBOutlet fileprivate weak var naoSwitch: UISwitch!
    @IBOutlet fileprivate weak var nomeLabel: UILabel!
    @IBOutlet fileprivate weak var nomeView: UIView!
    @IBOutlet fileprivate weak var nomeMaeLabel: UILabel!
    @IBOutlet fileprivate weak var nomeMaeView: UIView!
    @IBOutlet fileprivate weak var nomePaiLabel: UILabel!
    @IBOutlet fileprivate weak var nomePaiView: UIView!
    @IBOutlet fileprivate weak var noturnoControl: UIControl!
    @IBOutlet fileprivate weak var noturnoControlAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var noturnoControlTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var noturnoLabelAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var noturnoLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var noturnoSwitch: UISwitch!
    @IBOutlet fileprivate weak var noturnoSwitchAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var novotecLabelAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var novotecLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var novotecSwitch: UISwitch!
    @IBOutlet fileprivate weak var novotecSwitchAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var raLabel: UILabel!
    @IBOutlet fileprivate weak var raView: UIView!
    @IBOutlet fileprivate weak var rematriculaLabel: UILabel!
    @IBOutlet fileprivate weak var rematriculaView: UIView!
    @IBOutlet fileprivate weak var rematriculaViewAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var rematriculaViewTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var rgLabel: UILabel!
    @IBOutlet fileprivate weak var rgView: UIView!
    @IBOutlet fileprivate weak var salvarButtonAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var salvarButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var simSwitch: UISwitch!
    @IBOutlet fileprivate weak var telefonesAlunoTableView: UITableView!
    @IBOutlet fileprivate weak var telefonesAlunoTableViewAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var telefonesAlunoView: UIView!
    @IBOutlet fileprivate weak var telefonesResponsavelAdicionarAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var telefonesResponsavelLabelAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var telefonesResponsavelLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var telefonesResponsavelTableView: UITableView!
    @IBOutlet fileprivate weak var telefonesResponsavelTableViewAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var telefonesResponsavelTableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var telefonesResponsavelTableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var telefonesResponsavelView: UIView!
    @IBOutlet fileprivate weak var telefonesResponsavelViewAlturaConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var telefonesResponsavelViewTopConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var tipoLogradouroLabel: UILabel!
    
    //MARK: Variables
    var aluno: Aluno!
    var turmaAtiva: Turma!
    lazy var fazerRematricula = false
    weak var delegate: RematriculaDelegate!
    fileprivate var contatosAluno: [Contato]!
    fileprivate var contatosResponsavel: [Contato]!
    fileprivate var comprovante: Data?
    fileprivate var interesseRematricula: InteresseRematricula?
    fileprivate lazy var adicionouInteresseRematricula = false
    fileprivate lazy var comprovanteImagem = false
    fileprivate lazy var comprovanteNecessario = false
    fileprivate lazy var contatosAlunoAdicionados = [Contato]()
    fileprivate lazy var contatosAlunoEditados = [Contato]()
    fileprivate lazy var contatosResponsavelAdicionados = [Contato]()
    fileprivate lazy var contatosResponsavelEditados = [Contato]()
    fileprivate lazy var cursosTecnicos = [String]()
    fileprivate lazy var cursosTecnicosString = ""
    fileprivate lazy var editandoEmailAluno = false
    fileprivate lazy var editouComprovante = false
    fileprivate lazy var editouEmailAluno = false
    fileprivate lazy var editouEmailResponsavel = false
    fileprivate lazy var editouEnderecoAluno = false
    fileprivate lazy var editouInteresseRematricula = false
    fileprivate lazy var editouTelefonesAluno = false
    fileprivate lazy var editouTelefonesResponsavel = false
    fileprivate lazy var emailNecessario = false
    fileprivate lazy var enderecoNecessario = false
    fileprivate lazy var primeiraVez = true
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let voltarBarButtonItem = UIBarButtonItem(image: UIImage(named: Constants.imagemBack), style: .plain, target: self, action: #selector(voltar))
        navigationItem.leftBarButtonItem = voltarBarButtonItem
        let branco = UIColor.white.cgColor
        let vermelho = UIColor.red.cgColor
        cpfView.layer.borderColor = branco
        cursoTecnicoView.layer.borderColor = branco
        dataNascimentoView.layer.borderColor = branco
        fotoImageView.layer.borderColor = branco
        rematriculaView.layer.borderColor = branco
        localNascimentoView.layer.borderColor = branco
        nacionalidadeView.layer.borderColor = branco
        nomeView.layer.borderColor = branco
        nomeMaeView.layer.borderColor = branco
        nomePaiView.layer.borderColor = branco
        raView.layer.borderColor = branco
        rgView.layer.borderColor = branco
        telefonesAlunoView.layer.borderColor = branco
        nomeLabel.text = aluno.nome
        raLabel.text = aluno.numeroRa + Constants.separador1 + aluno.digitoRa + Constants.separadorUfRa + aluno.ufRa
        if let cpf = aluno.cpf {
            cpfLabel.text = cpf
        }
        if let nacionalidade = aluno.nacionalidade {
            nacionalidadeLabel.text = aluno.nacionalidade
        }
        if let nomeMae = aluno.nomeMae {
            nomeMaeLabel.text = nomeMae
        }
        if let nomePai = aluno.nomePai {
            nomePaiLabel.text = nomePai
        }
        if let dataNascimento = aluno.dataNascimento {
            dataNascimentoLabel.text = DateFormatter.defaultDateFormatter.string(from: dataNascimento)
        }
        var rgTexto = ""
        if let rg = aluno.rg {
            rgTexto = rg
        }
        if let digitoRg = aluno.digitoRg {
            rgTexto += (Constants.separador1 + digitoRg)
        }
        rgLabel.text = rgTexto
        let usuarioLogado = LoginRequest.usuarioLogado!
        let alunoMaiorIdade = aluno.maiorDeIdade()
        if usuarioLogado.estudante {
            emailResponsavelViewAlturaContraint.constant = .zero
            emailResponsavelViewTopConstraint.constant = .zero
            telefonesResponsavelAdicionarAlturaConstraint.constant = .zero
            telefonesResponsavelLabelAlturaConstraint.constant = .zero
            telefonesResponsavelLabelTopConstraint.constant = .zero
            telefonesResponsavelTableViewAlturaConstraint.constant = .zero
            telefonesResponsavelTableViewBottomConstraint.constant = .zero
            telefonesResponsavelTableViewTopConstraint.constant = .zero
            telefonesResponsavelViewAlturaConstraint.constant = .zero
            telefonesResponsavelViewTopConstraint.constant = .zero
            if !alunoMaiorIdade {
                editarEmailAlunoButton.isHidden = true
                enderecoView.layer.borderColor = branco
                emailView.layer.borderColor = branco
                emailLabel.text = aluno.email
                adicionarTelefoneComprimentoConstraint.constant = .zero
                adicionarTelefoneLeadingConstraint.constant = .zero
                comprovanteViewAlturaConstraint.constant = .zero
                comprovanteViewTopConstraint.constant = .zero
                editarEmailAlturaConstraint.constant = .zero
                editarEmailTopConstraint.constant = .zero
                editarEnderecoAlturaConstraint.constant = .zero
                editarEnderecoTopConstraint.constant = .zero
                salvarButtonAlturaConstraint.constant = .zero
                salvarButtonTopConstraint.constant = .zero
            }
        }
        else {
            comprovanteView.layer.borderColor = branco
            emailView.layer.borderColor = branco
            enderecoView.layer.borderColor = branco
            telefonesResponsavelView.layer.borderColor = branco
            emailLabel.text = aluno.email
            if usuarioLogado.email == nil {
                emailNecessario = true
                emailResponsavelView.layer.borderColor = vermelho
            }
            else {
                emailResponsavelView.layer.borderColor = branco
                emailResponsavelLabel.text = usuarioLogado.email
            }
        }
        if aluno.email == nil {
            emailNecessario = true
            emailView.layer.borderColor = vermelho
        }
        else {
            emailView.layer.borderColor = branco
            emailLabel.text = aluno.email
        }
        if aluno.endereco == nil {
            comprovanteNecessario = true
            enderecoNecessario = true
            comprovanteView.layer.borderColor = vermelho
            enderecoView.layer.borderColor = vermelho
            comprovanteLabel.text = Localizable.aguardandoEnvio.localized
        }
        else {
            comprovanteLabel.text = Localizable.comprovanteAnexado.localized
            comprovanteView.layer.borderColor = branco
            enderecoView.layer.borderColor = branco
            carregarEndereco()
            carregarTipoLogradouro()
        }
        contatosAluno = (aluno.contatos.allObjects as! [Contato]).sorted(by: { (contato1, contato2) -> Bool in
            return contato1.codigo < contato2.codigo
        })
        carregarTelefones(responsavel: false)
        contatosResponsavel = (usuarioLogado.contatos.allObjects as! [Contato]).sorted(by: { (contato1, contato2) -> Bool in
            return contato1.codigo < contato2.codigo
        })
        carregarTelefones(responsavel: true)
        UIView.setAnimationsEnabled(false)
        if aluno.respondeRematricula && (!usuarioLogado.estudante || alunoMaiorIdade) {
            rematriculaLabel.text = String(format: Localizable.desejaRealizarARematriculaPara.localized, turmaAtiva.anoLetivo + 1)
            let turmaDoEnsinoMedio = turmaAtiva.ensinoMedio()
            if !turmaDoEnsinoMedio {
                noturnoSwitch.isHidden = true
                novotecSwitch.isHidden = true
                integralSwitch.isOn = false
                cursosTecnicosTableViewAlturaConstraint.constant = .zero
                noturnoLabelAlturaConstraint.constant = .zero
                noturnoLabelTopConstraint.constant = .zero
                noturnoSwitchAlturaConstraint.constant = .zero
                novotecLabelAlturaConstraint.constant = .zero
                novotecLabelTopConstraint.constant = .zero
                novotecSwitchAlturaConstraint.constant = .zero
                if !turmaAtiva.nonoAno() {
                    esconderEspanhol()
                }
            }
            else {
                noturnoControl.layer.borderColor = branco
                esconderEspanhol()
            }
            var mostrar: Bool!
            interesseRematricula = InteresseRematriculaDao.interesseRematriculaDoAluno(codigoAluno: aluno.codigoAluno)
            if let interesseRematricula = interesseRematricula {
                mostrar = interesseRematricula.interesseContinuidade
                integralSwitch.isOn = interesseRematricula.interesseTurnoIntegral
                let interesseContinuidade = interesseRematricula.interesseContinuidade
                simSwitch.isOn = interesseContinuidade
                naoSwitch.isOn = !interesseContinuidade
                if turmaDoEnsinoMedio {
                    espanholSwitch.isOn = interesseRematricula.interesseEspanhol
                    noturnoSwitch.isOn = interesseRematricula.interesseTurnoNoturno
                    novotecSwitch.isOn = interesseRematricula.interesseNovotec
                    cursosTecnicos = interesseRematricula.cursoTecnico.components(separatedBy: InteresseRematriculaDao.Constants.separadorCursosTecnicos)
                    let codigoOpcaoNoturno = interesseRematricula.codigoOpcaoNoturno
                    if codigoOpcaoNoturno != .zero {
                        var indice: Int = .zero
                        let valores = OpcoesNoturno.opcoesNoturno.values
                        for valor in valores {
                            if valor == codigoOpcaoNoturno {
                                break
                            }
                            indice += 1
                        }
                        justificativaNoturnoLabel.text = [String](OpcoesNoturno.opcoesNoturno.keys)[indice]
                    }
                    if interesseRematricula.interesseNovotec {
                        carregarCursosTecnicos()
                        expandirCursosTecnicos()
                    }
                    else {
                        esconderCursosTecnicos()
                    }
                    if interesseRematricula.interesseTurnoNoturno {
                        expandirNoturno()
                    }
                    else {
                        esconderNoturno()
                    }
                }
                else {
                    esconderNoturno()
                    esconderCursosTecnicos()
                }
            }
            else {
                mostrar = true
                simSwitch.isOn = true
                naoSwitch.isOn = false
                esconderNoturno()
                esconderCursosTecnicos()
            }
            mostrarRematricula(mostrar: mostrar)
        }
        else {
            cursosTecnicosTableViewAlturaConstraint.constant = .zero
            rematriculaViewTopConstraint.constant = .zero
            rematriculaViewAlturaConstraint.constant = .zero
            esconderNoturno()
            esconderCursosTecnicos()
        }
        UIView.setAnimationsEnabled(true)
        primeiraVez = false
        if let carteirinha = aluno.carteirinha, let fotoBase64 = carteirinha.foto.replacingOccurrences(of: Constants.cabecalhoJpeg, with: "").base64Decoded {
            fotoImageView.image = UIImage(data: fotoBase64)
        }
        else if !Requests.Configuracoes.servidorHabilitado || Requests.conectadoInternet() {
            fotoActivityIndicatorView.startAnimating()
            CarteirinhaRequest.pegarCarteirinha(aluno: aluno, completion: { (carteirinha, sucesso, erro) in
                DispatchQueue.main.async {
                    self.fotoActivityIndicatorView.stopAnimating()
                    if sucesso, let fotoBase64 = carteirinha?.foto.replacingOccurrences(of: Constants.cabecalhoJpeg, with: "").base64Decoded {
                        self.fotoImageView.image = UIImage(data: fotoBase64)
                    }
                    else {
                        self.fotoImageView.isUserInteractionEnabled = true
                        self.fotoImageView.image = UIImage(named: Constants.imagemFoto)
                        self.fotoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.enviarFotoCarteirinha)))
                    }
                }
            })
        }
        else if !fazerRematricula {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.internetCarteirinha.localized, style: .alert, target: self)
        }
        if fazerRematricula {
            comprovanteNecessario = true
            comprovanteView.layer.borderColor = vermelho
            comprovanteLabel.text = Localizable.aguardandoEnvio.localized
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.preenchaTodasInformacoes.localized, style: .alert, target: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        editandoEmailAluno = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.historicoMatriculasSegue, let historicoMatriculasViewController = segue.destination as? HistoricoMatriculasViewController {
            historicoMatriculasViewController.matriculas = aluno.matriculas.allObjects as? [Turma]
            #if DEBUG
            #else
            let parametros: [String:Any] = [Constants.buttonId:UInt8.zero,AnalyticsParameterContentType:Constants.moduloHistoricoMatricula]
            Analytics.logEvent(AnalyticsEventSelectContent, parameters: parametros)
            Analytics.logEvent(Constants.moduloHistoricoMatricula, parameters: parametros)
            #endif
        }
    }
    
    //MARK: Actions
    @IBAction func adicionarContato(sender: UIButton) {
        if let editarTelefoneNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.editarTelefoneNavigationController) as? UINavigationController, let editarTelefoneViewController = editarTelefoneNavigationController.viewControllers.first as? EditarTelefoneViewController {
            editarTelefoneViewController.delegate = self
            editarTelefoneViewController.responsavel = sender.tag != .zero
            presentFormSheetViewController(viewController: editarTelefoneNavigationController)
        }
    }
    
    @IBAction func alterarEmail(botao: UIButton) {
        if let editarEmailNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.editarEmailNavigationController) as? UINavigationController, let editarEmailViewController = editarEmailNavigationController.viewControllers.first as? EditarEmailViewController {
            editarEmailViewController.delegate = self
            if botao.tag == .zero {
                editandoEmailAluno = true
                editarEmailViewController.email = aluno.email
            }
            else {
                editandoEmailAluno = false
                editarEmailViewController.email = LoginRequest.usuarioLogado.email
            }
            presentFormSheetViewController(viewController: editarEmailNavigationController)
        }
    }
    
    @IBAction func alterarEndereço() {
        if let editarEnderecoNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.editarEnderecoNavigationController) as? UINavigationController, let editarEnderecoViewController = editarEnderecoNavigationController.viewControllers.first as? EditarEnderecoViewController {
            editarEnderecoViewController.aluno = aluno
            editarEnderecoViewController.delegate = self
            present(editarEnderecoNavigationController, animated: true)
        }
    }
    
    @IBAction func enviarComprovanteEndereco() {
        let documentoAction = UIAlertAction(title: Localizable.documento.localized, style: .default, handler: { _ in
            let documentPickerViewController = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
            documentPickerViewController.delegate = self
            self.presentFormSheetViewController(viewController: documentPickerViewController)
        })
        let imagemAction = UIAlertAction(title: Localizable.imagem.localized, style: .default, handler: { _ in
            UIImagePickerController.mostrarImagePickerController(carteirinha: false, viewController: self)
        })
        UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.qualOTipoDeArquivoDoComprovante.localized, style: .actionSheet, actions: [documentoAction, imagemAction, UIAlertAction(title: Localizable.cancelar.localized, style: .cancel)], target: self)
    }
    
    @objc fileprivate func enviarFotoCarteirinha() {
        if let enviarFotoViewController: EnviarFotoViewController = storyboard?.instantiateViewController() {
            navigationController?.pushViewController(enviarFotoViewController, animated: true)
        }
    }
    
    @IBAction func mostrarCursosTecnicos() {
        if let cursosTecnicosNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.cursosTecnicosNavigationController) as? UINavigationController, let cursosTecnicosViewController = cursosTecnicosNavigationController.viewControllers.first as? CursosTecnicosViewController {
            cursosTecnicosViewController.delegate = self
            presentFormSheetViewController(viewController: cursosTecnicosNavigationController)
        }
    }
    
    @IBAction func mostrarJustificativasNoturno() {
        if let justificativaNoturnoNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.justificativaNoturnoNavigationController) as? UINavigationController, let justificativaNoturnoViewController = justificativaNoturnoNavigationController.viewControllers.first as? JustificativaNoturnoViewController {
            justificativaNoturnoViewController.delegate = self
            presentFormSheetViewController(viewController: justificativaNoturnoNavigationController)
        }
    }
    
    @IBAction func mudouEstadoInteresseSwitch(_ sender: UISwitch) {
        if sender.isOn {
            if sender == integralSwitch {
                novotecSwitch.setOn(false, animated: true)
                noturnoSwitch.setOn(false, animated: true)
                resetarNoturno()
                resetarCursosTecnicos()
            }
            else if sender == novotecSwitch {
                integralSwitch.setOn(false, animated: true)
                noturnoSwitch.setOn(false, animated: true)
                resetarNoturno()
                carregarCursosTecnicos()
                expandirCursosTecnicos()
                if cursosTecnicos.isEmpty {
                    mostrarCursosTecnicos()
                }
            }
            else {
                integralSwitch.setOn(false, animated: true)
                novotecSwitch.setOn(false, animated: true)
                expandirNoturno()
                resetarCursosTecnicos()
                if justificativaNoturnoLabel.text == nil || justificativaNoturnoLabel.text!.isEmpty {
                    mostrarJustificativasNoturno()
                }
            }
        }
        else {
            sender.setOn(false, animated: true)
            if sender == novotecSwitch {
                resetarCursosTecnicos()
            }
            else if sender == noturnoSwitch {
                resetarNoturno()
            }
        }
        verificarInteresseRematricula()
    }
    
    @IBAction func nao(_ sender: UISwitch) {
        simSwitch.setOn(!sender.isOn, animated: true)
        if sender.isOn {
            desabilitarInteresses()
        }
        mostrarRematricula(mostrar: !sender.isOn)
        verificarInteresseRematricula()
    }
    
    @IBAction func salvar() {
        let usuarioLogado = LoginRequest.usuarioLogado!
        let alunoSemEmail = emailNecessario && usuarioLogado.estudante && aluno.email == nil
        let responsavelSemEmail = emailNecessario && !usuarioLogado.estudante && LoginRequest.usuarioLogado.email == nil
        let metadeAlturaScrollView = scrollView.frame.height / CGFloat(2)
        if alunoSemEmail || responsavelSemEmail {
            let ok = UIAlertAction(title: Localizable.ok.localized, style: .default, handler: {_ in
                if alunoSemEmail {
                    let emailViewFrame = self.emailView.frame
                    self.scrollView.setContentOffset(CGPoint(x: .zero, y: emailViewFrame.origin.y - metadeAlturaScrollView + (emailViewFrame.height / CGFloat(2))), animated: true)
                }
                else {
                    let emailResponsavelViewFrame = self.emailResponsavelView.frame
                    self.scrollView.setContentOffset(CGPoint(x: .zero, y: emailResponsavelViewFrame.origin.y - metadeAlturaScrollView + (emailResponsavelViewFrame.height / CGFloat(2))), animated: true)
                }
            })
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.digiteEmail.localized, style: .alert, actions: [ok], target: self)
        }
        else if enderecoNecessario && aluno.endereco == nil {
            let ok = UIAlertAction(title: Localizable.ok.localized, style: .default, handler: {_ in
                let enderecoViewFrame = self.enderecoView.frame
                self.scrollView.setContentOffset(CGPoint(x: .zero, y: enderecoViewFrame.origin.y - metadeAlturaScrollView + (enderecoViewFrame.height / CGFloat(2))), animated: true)
            })
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.digiteEndereco.localized, style: .alert, actions: [ok], target: self)
        }
        else if comprovanteNecessario && comprovante == nil {
            let ok = UIAlertAction(title: Localizable.ok.localized, style: .default, handler: {_ in
                let comprovanteViewFrame = self.comprovanteView.frame
                self.scrollView.setContentOffset(CGPoint(x: .zero, y: comprovanteViewFrame.origin.y - metadeAlturaScrollView + (comprovanteViewFrame.height / CGFloat(2))), animated: true)
            })
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.necessarioFornecerOComprovanteDeResidencia.localized, style: .alert, actions: [ok], target: self)
        }
        else if adicionouInteresseRematricula || editouEmailAluno || editouEmailResponsavel || editouEnderecoAluno || editouInteresseRematricula || editouTelefonesAluno || editouTelefonesResponsavel {
            if adicionouInteresseRematricula || editouInteresseRematricula, let termoResponsabilidadeNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.termoResponsabilidadeNavigationController) as? UINavigationController, let termoResponsabilidadeViewController = termoResponsabilidadeNavigationController.viewControllers.first as? TermoResponsabilidadeViewController {
                termoResponsabilidadeViewController.delegate = self
                presentFormSheetViewController(viewController: termoResponsabilidadeNavigationController)
            }
            else {
                enviarInformacoes()
            }
        }
    }
    
    @IBAction func sim(_ sender: UISwitch) {
        naoSwitch.setOn(!sender.isOn, animated: true)
        if !sender.isOn {
            desabilitarInteresses()
        }
        if interesseRematricula == nil {
            adicionouInteresseRematricula = true
            interesseRematricula = InteresseRematriculaDao.criarInteresseRematricula(aluno: aluno)
        }
        mostrarRematricula(mostrar: sender.isOn)
        verificarInteresseRematricula()
    }
    
    @IBAction func sobreComprovante() {
        if let sobreComprovanteNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.sobreComprovanteNavigationController) {
            presentFormSheetViewController(viewController: sobreComprovanteNavigationController)
        }
    }
    
    @objc fileprivate func voltar() {
        if adicionouInteresseRematricula || editouComprovante || editouEmailAluno || editouEmailResponsavel || editouEnderecoAluno || editouInteresseRematricula || editouTelefonesAluno || editouTelefonesResponsavel {
            let sim = UIAlertAction(title: Localizable.sim.localized, style: .default, handler: { _ in
                self.aluno.managedObjectContext?.refresh(self.aluno, mergeChanges: false)
                if self.editouEmailResponsavel || self.editouTelefonesResponsavel, let usuarioLogado = LoginRequest.usuarioLogado {
                    usuarioLogado.managedObjectContext?.refresh(usuarioLogado, mergeChanges: false)
                }
                if let interesseRematricula = self.interesseRematricula {
                    if self.adicionouInteresseRematricula {
                        CoreDataManager.sharedInstance.deleteObject(object: interesseRematricula)
                    }
                    else if self.editouInteresseRematricula {
                        interesseRematricula.managedObjectContext?.refresh(interesseRematricula, mergeChanges: false)
                    }
                }
                if self.editouEnderecoAluno {
                    for contatoAdicionado in self.contatosAlunoAdicionados {
                        CoreDataManager.sharedInstance.deleteObject(object: contatoAdicionado)
                    }
                    for contatoEditado in self.contatosAlunoEditados {
                        contatoEditado.managedObjectContext?.refresh(contatoEditado, mergeChanges: false)
                    }
                }
                if self.editouTelefonesResponsavel {
                    for contatoAdicionado in self.contatosResponsavelAdicionados {
                        CoreDataManager.sharedInstance.deleteObject(object: contatoAdicionado)
                    }
                    for contatoEditado in self.contatosResponsavelEditados {
                        contatoEditado.managedObjectContext?.refresh(contatoEditado, mergeChanges: false)
                    }
                }
                CoreDataManager.sharedInstance.saveContext()
                self.navigationController?.popViewController(animated: true)
            })
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.voceTemAlteracoesNaoSalvas.localized, style: .alert, actions: [sim,UIAlertAction(title: Localizable.nao.localized, style: .default)], target: self)
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: Methods
    fileprivate func carregarCursosTecnicos() {
        cursosTecnicosTableViewAlturaConstraint.constant = Constants.alturaTableViewCell * CGFloat(cursosTecnicos.count)
        cursosTecnicosTableView.reloadData()
    }
    
    fileprivate func carregarTelefones(responsavel: Bool) {
        var numeroContatos: Int!
        var alturaConstraint: NSLayoutConstraint!
        var telefonesTableView: UITableView!
        if responsavel {
            numeroContatos = contatosResponsavel.count
            alturaConstraint = telefonesResponsavelTableViewAlturaConstraint
            telefonesTableView = telefonesResponsavelTableView
        }
        else {
            numeroContatos = contatosAluno.count
            alturaConstraint = telefonesAlunoTableViewAlturaConstraint
            telefonesTableView = telefonesAlunoTableView
        }
        alturaConstraint.constant = Constants.alturaTableViewCell * CGFloat(numeroContatos)
        telefonesTableView.reloadData()
    }
    
    fileprivate func carregarTipoLogradouro() {
        if aluno.tipoLogradouro == TipoLogradouroInt.rural.rawValue {
            tipoLogradouroLabel.text = TipoLogradouro.rural.rawValue
        }
        else {
            tipoLogradouroLabel.text = TipoLogradouro.urbana.rawValue
        }
    }
    
    fileprivate func carregarEndereco() {
        bairroLabel.text = aluno.bairroEndereco
        cepLabel.text = aluno.cep
        cidadeEstadoLabel.text = aluno.cidadeEndereco
        complementoLabel.text = aluno.complementoEndereco
        if let endereco = aluno.endereco {
            enderecoLabel.text = endereco + ", " + String(aluno.numeroEndereco)
        }
    }
    
    fileprivate func desabilitarInteresses() {
        espanholSwitch.setOn(false, animated: true)
        integralSwitch.setOn(false, animated: true)
        noturnoSwitch.setOn(false, animated: true)
        novotecSwitch.setOn(false, animated: true)
        resetarNoturno()
        resetarCursosTecnicos()
    }
    
    fileprivate func enviarInformacoes() {
        if Requests.conectadoInternet() {
            let progressHud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
            progressHud.label.text = Localizable.carregando.localized
            progressHud.detailsLabel.text = Localizable.enviandoInformacoes.localized
            let usuarioLogado = LoginRequest.usuarioLogado!
            let emailResponsavelNecessario = emailNecessario && !usuarioLogado.estudante && usuarioLogado.email == nil
            if adicionouInteresseRematricula || editouInteresseRematricula {
                interesseRematricula?.aceitoTermoResponsabilidade = true
                interesseRematricula?.cursoTecnico = cursosTecnicosString
                interesseRematricula?.interesseContinuidade = simSwitch.isOn
                interesseRematricula?.interesseEspanhol = espanholSwitch.isOn
                interesseRematricula?.interesseNovotec = novotecSwitch.isOn
                interesseRematricula?.interesseTurnoIntegral = integralSwitch.isOn
                interesseRematricula?.interesseTurnoNoturno = noturnoSwitch.isOn
                if let justificativaNoturno = justificativaNoturnoLabel.text, let codigoOpcaoNoturno = OpcoesNoturno.opcoesNoturno[justificativaNoturno] {
                    interesseRematricula?.codigoOpcaoNoturno = codigoOpcaoNoturno
                }
                else {
                    interesseRematricula?.codigoOpcaoNoturno = .zero
                }
            }
            EnviarInformacoes.enviarInformacoes(comprovanteImagem: comprovanteImagem, editouEmailAluno: editouEmailAluno, editouEmailResponsavel: editouEmailResponsavel, editouEndereco: editouEnderecoAluno, editouInteresseRematricula: editouInteresseRematricula, editouTelefonesAluno: editouTelefonesAluno, editouTelefonesResponsavel: editouTelefonesResponsavel, emailResponsavelNecessario: emailResponsavelNecessario, comprovante: comprovante, aluno: aluno, interesseRematricula: interesseRematricula, turmaAtiva: turmaAtiva, telefonesAdicionadosAluno: contatosAlunoAdicionados, telefonesAlteradosAluno: contatosAlunoEditados, telefonesAdicionadosResponsavel: contatosResponsavelAdicionados, telefonesAlteradosResponsavel: contatosResponsavelEditados, completion: { (sucesso, erro, codigoInteresseRematricula) in
                progressHud.hide(animated: true)
                if let erro = erro {
                    UIAlertController.createAlert(title: Localizable.atencao.localized, message: erro, style: .alert, target: self)
                }
                else if let codigoInteresseRematricula = codigoInteresseRematricula {
                    if codigoInteresseRematricula != .zero {
                        self.interesseRematricula?.codigoInteresseRematricula = codigoInteresseRematricula
                        CoreDataManager.sharedInstance.saveContext()
                    }
                    if self.fazerRematricula {
                        let ok = UIAlertAction(title: Localizable.ok.localized, style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                            self.delegate.realizouRematricula()
                        })
                        UIAlertController.createAlert(title: Localizable.sucesso.localized, message: Localizable.informacoesEnviadasComSucesso.localized, style: .alert, actions: [ok], target: self)
                    }
                    else {
                        UIAlertController.createAlert(title: Localizable.sucesso.localized, message: Localizable.informacoesEnviadasComSucesso.localized, style: .alert, target: self)
                        self.adicionouInteresseRematricula = false
                        self.comprovanteImagem = false
                        self.comprovanteNecessario = false
                        self.editouComprovante = false
                        self.editouEmailAluno = false
                        self.editouEmailResponsavel = false
                        self.editouEnderecoAluno = false
                        if self.editouInteresseRematricula {
                            self.editouInteresseRematricula = false
                        }
                        if self.editouTelefonesAluno {
                            self.editouTelefonesAluno = false
                            self.contatosAlunoEditados.removeAll()
                            self.contatosAluno = (self.aluno.contatos.allObjects as! [Contato]).sorted(by: { (contato1, contato2) -> Bool in
                                return contato1.codigo < contato2.codigo
                            })
                            self.carregarTelefones(responsavel: false)
                        }
                        if self.editouTelefonesResponsavel {
                            self.editouTelefonesResponsavel = false
                            self.contatosResponsavelEditados.removeAll()
                            self.contatosResponsavel = (LoginRequest.usuarioLogado.contatos.allObjects as! [Contato]).sorted(by: { (contato1, contato2) -> Bool in
                                return contato1.codigo < contato2.codigo
                            })
                            self.carregarTelefones(responsavel: true)
                        }
                    }
                }
            })
        }
        else {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.internetSobreMim.localized, style: .alert, target: self)
        }
    }
    
    fileprivate func esconderCursosTecnicos() {
        UIView.animate(withDuration: Constants.duracaoAnimacaoSegundos, animations: {
            self.cursoTecnicoAlturaConstraint.constant = .zero
            self.cursoTecnicoViewTopConstraint.constant = .zero
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func esconderEspanhol() {
        espanholSwitch.isHidden = true
        espanholLabelAlturaConstraint.constant = .zero
        espanholLabelTopConstraint.constant = .zero
        espanholSwitchAlturaContraint.constant = .zero
    }
    
    fileprivate func esconderNoturno() {
        UIView.animate(withDuration: Constants.duracaoAnimacaoSegundos, animations: {
            self.noturnoControlAlturaConstraint.constant = .zero
            self.noturnoControlTopConstraint.constant = .zero
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func expandirCursosTecnicos() {
        UIView.animate(withDuration: Constants.duracaoAnimacaoSegundos, animations: {
            self.cursoTecnicoAlturaConstraint.constant = Constants.alturaCursoTecnicoView
            self.cursoTecnicoViewTopConstraint.constant = Constants.cursoTecnicoViewTop
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func expandirNoturno() {
        UIView.animate(withDuration: Constants.duracaoAnimacaoSegundos, animations: {
            self.noturnoControlAlturaConstraint.constant = Constants.alturaNoturnoControl
            self.noturnoControlTopConstraint.constant = Constants.noturnoControlViewTop
            self.view.layoutIfNeeded()
        })
    }
    
    fileprivate func mostrarRematricula(mostrar: Bool) {
        if mostrar {
            UIView.animate(withDuration: Constants.duracaoAnimacaoSegundos, animations: {
                self.interessesViewAlturaConstraint.constant = Constants.alturaInteressesView
                self.view.layoutIfNeeded()
                if !self.primeiraVez {
                    self.scrollView.contentOffset.y = self.scrollView.contentSize.height - self.scrollView.bounds.size.height
                }
            })
        }
        else {
            UIView.animate(withDuration: Constants.duracaoAnimacaoSegundos, animations: {
                self.interessesViewAlturaConstraint.constant = .zero
                self.view.layoutIfNeeded()
            })
        }
    }
    
    fileprivate func resetarCursosTecnicos() {
        cursosTecnicosString = ""
        cursosTecnicos.removeAll()
        esconderCursosTecnicos()
    }
    
    fileprivate func resetarNoturno() {
        justificativaNoturnoLabel.text = nil
        esconderNoturno()
    }
    
    fileprivate func verificarInteresseRematricula() {
        if let interesseRematricula = interesseRematricula {
            editouInteresseRematricula = adicionouInteresseRematricula || interesseRematricula.interesseContinuidade != simSwitch.isOn || interesseRematricula.interesseEspanhol != espanholSwitch.isOn || interesseRematricula.interesseNovotec != novotecSwitch.isOn || interesseRematricula.interesseTurnoIntegral != integralSwitch.isOn || interesseRematricula.interesseTurnoNoturno != noturnoSwitch.isOn || interesseRematricula.cursoTecnico != cursosTecnicosString
            comprovanteNecessario = comprovanteNecessario || editouInteresseRematricula
            if comprovanteNecessario {
                comprovanteView.layer.borderColor = UIColor.red.cgColor
                comprovanteLabel.text = Localizable.aguardandoEnvio.localized
            }
        }
        else {
            editouInteresseRematricula = true
        }
    }
}

//MARK: CursoTecnicoDelegate
extension SobreMimViewController: CursoTecnicoDelegate {
    func selecionouCursosTecnicos(cursosTecnicos: [String]) {
        self.cursosTecnicos = cursosTecnicos
        cursosTecnicosString = cursosTecnicos.joined(separator: InteresseRematriculaDao.Constants.separadorCursosTecnicos)
        carregarCursosTecnicos()
        verificarInteresseRematricula()
        view.layoutIfNeeded()
    }
}

//MARK: EmailDelegate
extension SobreMimViewController: EmailDelegate {
    func editouEmail(email: String) {
        if editandoEmailAluno {
            editandoEmailAluno = false
            if email != aluno.email {
                editouEmailAluno = true
                aluno.email = email
                emailLabel.text = email
                emailView.layer.borderColor = UIColor.white.cgColor
            }
        }
        else if email != LoginRequest.usuarioLogado.email {
            editouEmailResponsavel = true
            LoginRequest.usuarioLogado.email = email
            emailResponsavelLabel.text = email
            emailResponsavelView.layer.borderColor = UIColor.white.cgColor
        }
    }
}

//MARK: EnderecoDelegate
extension SobreMimViewController: EnderecoDelegate {
    func editouEndereco() {
        editouEnderecoAluno = true
        comprovanteNecessario = true
        comprovanteView.layer.borderColor = UIColor.red.cgColor
        comprovanteLabel.text = Localizable.aguardandoEnvio.localized
        carregarEndereco()
        if enderecoNecessario {
            enderecoView.layer.borderColor = UIColor.white.cgColor
        }
    }
}

//MARK: JustificativaNoturnoDelegate
extension SobreMimViewController: JustificativaNoturnoDelegate {
    func selecionouJustificativaNoturno(justificativa: String) {
        editouInteresseRematricula = true
        justificativaNoturnoLabel.text = justificativa
    }
}

//MARK: TelefoneDelegate
extension SobreMimViewController: TelefoneCellDelegate {
    func deletarTelefone(indice: Int, responsavel: Bool) {
        var alturaConstraint: NSLayoutConstraint!
        var numeroContatos: Int!
        var tabela: UITableView!
        if responsavel {
            editouTelefonesResponsavel = true
            alturaConstraint = telefonesResponsavelTableViewAlturaConstraint
            tabela = telefonesResponsavelTableView
            contatosResponsavel[indice].operacao = ContatoDao.Contants.operacaoDeletar
            contatosResponsavelEditados.append(contatosResponsavel[indice])
            contatosResponsavel.remove(at: indice)
            numeroContatos = contatosResponsavel.count
        }
        else {
            editouTelefonesAluno = true
            alturaConstraint = telefonesAlunoTableViewAlturaConstraint
            tabela = telefonesAlunoTableView
            contatosAluno[indice].operacao = ContatoDao.Contants.operacaoDeletar
            contatosAlunoEditados.append(contatosAluno[indice])
            contatosAluno.remove(at: indice)
            numeroContatos = contatosAluno.count
        }
        UIView.animate(withDuration: Constants.duracaoAnimacaoSegundos, delay: .zero, options: .curveEaseInOut, animations: {
            alturaConstraint.constant = Constants.alturaTableViewCell * CGFloat(numeroContatos)
            tabela.beginUpdates()
            tabela.deleteRows(at: [IndexPath(row: indice, section: .zero)], with: .automatic)
            tabela.endUpdates()
            self.view.layoutIfNeeded()
        }, completion: { _ in
            tabela.reloadData()
        })
    }
    
    func editarTelefone(indice: Int, responsavel: Bool) {
        if let editarTelefoneNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.editarTelefoneNavigationController) as? UINavigationController, let editarTelefoneViewController = editarTelefoneNavigationController.viewControllers.first as? EditarTelefoneViewController {
            editarTelefoneViewController.delegate = self
            editarTelefoneViewController.responsavel = responsavel
            var contato: Contato!
            if responsavel {
                contato = contatosResponsavel[indice]
            }
            else {
                contato = contatosAluno[indice]
            }
            editarTelefoneViewController.contato = contato
            presentFormSheetViewController(viewController: editarTelefoneNavigationController)
        }
    }
}

//MARK: TelefoneDelegate
extension SobreMimViewController: TelefoneDelegate {
    func adicionouTelefone(contato: Contato, responsavel: Bool) {
        if responsavel {
            editouTelefonesResponsavel = true
            contatosResponsavel.append(contato)
            contatosResponsavelAdicionados.append(contato)
        }
        else {
            editouTelefonesAluno = true
            contato.aluno = aluno
            contatosAluno.append(contato)
            contatosAlunoAdicionados.append(contato)
        }
        carregarTelefones(responsavel: responsavel)
    }
    
    func editouTelefone(contato: Contato, responsavel: Bool) {
        contato.operacao = ContatoDao.Contants.operacaoAlterar
        if responsavel {
            editouTelefonesResponsavel = true
            contatosResponsavelEditados.append(contato)
        }
        else {
            editouTelefonesAluno = true
            contatosAlunoEditados.append(contato)
        }
        carregarTelefones(responsavel: responsavel)
    }
}

//MARK: TermoResponsabilidadeDelegate
extension SobreMimViewController: TermoResponsabilidadeDelegate {
    func concordou() {
        enviarInformacoes()
    }
}

//MARK: UIDocumentPickerDelegate
extension SobreMimViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        comprovanteImagem = false
        controller.dismiss(animated: true)
        comprovanteLabel.text = Localizable.comprovanteAnexado.localized
        do {
            comprovante = try Data(contentsOf: url)
        }
        catch {
        }
    }
}

//MARK: UIImagePickerControllerDelegate
extension SobreMimViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        editouComprovante = true
        comprovanteImagem = true
        comprovanteLabel.text = Localizable.comprovanteAnexado.localized
        comprovanteView.layer.borderColor = UIColor.white.cgColor
        if let imagemEditada = info[.editedImage] as? UIImage {
            comprovante = imagemEditada.jpegData(compressionQuality: 1)
        }
        else if let imagemOriginal = info[.originalImage] as? UIImage {
            comprovante = imagemOriginal.jpegData(compressionQuality: 1)
        }
    }
}

//MARK: UINavigationControllerDelegate
extension SobreMimViewController: UINavigationControllerDelegate {
}

//MARK: UIScrollViewDelegate
extension SobreMimViewController: UIScrollViewDelegate {
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Constants.duracaoAnimacaoMilissegundos), execute: {
                if self.emailNecessario {
                    if LoginRequest.usuarioLogado.estudante {
                        self.emailView.shake()
                    }
                    else {
                        self.emailResponsavelView.shake()
                    }
                }
                else if self.enderecoNecessario && self.aluno.endereco == nil {
                    self.enderecoView.shake()
                }
                else if self.comprovanteNecessario && self.comprovante == nil {
                    self.comprovanteView.shake()
                }
            })
        }
    }
}

//MARK: UITableViewDataSource
extension SobreMimViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == telefonesAlunoTableView {
            return contatosAluno.count
        }
        if tableView == telefonesResponsavelTableView {
            return contatosResponsavel.count
        }
        return cursosTecnicos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indice = indexPath.row
        if tableView == telefonesAlunoTableView || tableView == telefonesResponsavelTableView {
            let telefoneTableViewCell: TelefoneTableViewCell = tableView.dequeue(index: indexPath)
            telefoneTableViewCell.delegate = self
            telefoneTableViewCell.indice = indice
            telefoneTableViewCell.responsavel = !LoginRequest.usuarioLogado!.estudante
            if tableView == telefonesAlunoTableView {
                telefoneTableViewCell.responsavelTableView = false
                telefoneTableViewCell.contato = contatosAluno[indice]
            }
            else {
                telefoneTableViewCell.responsavelTableView = true
                telefoneTableViewCell.contato = contatosResponsavel[indice]
            }
            return telefoneTableViewCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cursoTecnicoTableViewCell, for: indexPath)
        cell.separatorInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .greatestFiniteMagnitude)
        cell.textLabel?.text = String(indice + 1) + Constants.separador2 + cursosTecnicos[indice]
        return cell
    }
}

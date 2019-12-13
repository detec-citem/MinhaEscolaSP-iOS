//
//  BoletimViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 18/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import MBProgressHUD
import UIKit
import WebKit

final class BoletimViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let boletimApi = "Boletim/BoletimEscolar"
        static let boletimVariavel = "oBoletim"
        static let espaco = " "
        static let extensaoPdf = ".pdf"
        static let javascript = "%@;BlobDownloader.download=function(a,b){var c=new FileReader;c.onload=function(){var d=new Int8Array(c.result);window.webkit.messageHandlers.BoletimViewController.postMessage(Array.from(d))};c.readAsArrayBuffer(b)};GerarBoletimUnificado(oBoletim)"
        static let separadorCaminho = "/"
        static let tagAbreScript = "<script type=\"text/javascript\">"
        static let tagFechaScript = "</script>"
        static let underscroll = "_"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var anoLabel: UILabel!
    @IBOutlet fileprivate weak var anoComboBox: UIView!
    @IBOutlet fileprivate weak var turmaLabel: UILabel!
    @IBOutlet fileprivate weak var turmaComboBox: UIView!
    
    //MARK: Variables
    fileprivate lazy var carregouPagina = false
    fileprivate lazy var dispatchGroup = DispatchGroup()
    fileprivate lazy var turmasDoAno = [Turma]()
    fileprivate var anos: [UInt16]!
    fileprivate var anoSelecionado: UInt16!
    fileprivate var boletimJavascript: String!
    fileprivate var turmasDoAluno: Set<Turma>!
    fileprivate var turmaSelecionada: Turma!
    fileprivate var progressHud: MBProgressHUD!
    fileprivate var webView: WKWebView!
    var aluno: Aluno!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let branco = UIColor.white.cgColor
        anoComboBox.layer.borderColor = branco
        turmaComboBox.layer.borderColor = branco
        var anosSet = Set<UInt16>()
        if let turmas = aluno.matriculas as? Set<Turma> {
            turmasDoAluno = turmas
            for turma in turmas {
                let ano = turma.anoLetivo
                if !anosSet.contains(ano) {
                    anosSet.insert(ano)
                }
            }
            anos = anosSet.sorted().reversed()
            anoSelecionado = anos.first
            configurarComboBox()
        }
    }
    
    //MARK: Actions
    @IBAction func gerarBoletim() {
        if Requests.conectadoInternet() {
            progressHud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
            progressHud.label.text = Localizable.carregando.localized
            progressHud.detailsLabel.text = Localizable.carregandoBoletim.localized
            if !carregouPagina, let boletimUrl = URL(string: Requests.Configuracoes.urlServidor + Constants.boletimApi) {
                let configuracao = WKWebViewConfiguration()
                let userContentController = WKUserContentController()
                userContentController.add(self, name: BoletimViewController.className)
                configuracao.userContentController = userContentController
                webView = WKWebView(frame: .zero, configuration: configuracao)
                webView.isHidden = true
                webView.navigationDelegate = self
                view.addSubview(self.webView)
                dispatchGroup.enter()
                webView.load(URLRequest(url: boletimUrl))
            }
            dispatchGroup.enter()
            BoletimRequest.gerarBoletim(ano: anoSelecionado, aluno: aluno, completion: { (html, sucesso, erro) in
                DispatchQueue.main.async(execute: {
                    if sucesso, let boletimHtml = html, boletimHtml.contains(Constants.boletimVariavel) {
                        let componentes = boletimHtml.components(separatedBy: Constants.tagAbreScript)
                        self.boletimJavascript = componentes.last?.replacingOccurrences(of: Constants.tagFechaScript, with: "")
                    }
                    else if let erro = erro {
                        self.boletimJavascript = nil
                        self.progressHud.hide(animated: true)
                        UIAlertController.createAlert(title: Localizable.atencao.localized, message: erro, style: .alert, target: self)
                    }
                    else {
                        self.boletimJavascript = nil
                        self.progressHud.hide(animated: true)
                        UIAlertController.createAlert(title: Localizable.ops.localized, message: Localizable.semBoletim.localized, style: .alert, target: self)
                    }
                    self.dispatchGroup.leave()
                })
            })
            dispatchGroup.notify(queue: .main, execute: {
                if let boletimJavascript = self.boletimJavascript {
                    let javascript = String(format: Constants.javascript, boletimJavascript)
                    self.webView.evaluateJavaScript(javascript)
                }
            })
        }
        else {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.internetBoletim.localized, style: .alert, target: self)
        }
    }
    
    @IBAction func mostrarAnos() {
        let anosNavigationController = storyboard?.instantiateViewController(withIdentifier: AnosViewController.className) as! UINavigationController
        let anosViewController = anosNavigationController.viewControllers.first as! AnosViewController
        anosViewController.delegate = self
        anosViewController.anos = anos
        presentFormSheetViewController(viewController: anosNavigationController)
    }
    
    @IBAction func mostrarTurmas() {
        let turmasNavigationController = storyboard?.instantiateViewController(withIdentifier: TurmasViewController.className) as! UINavigationController
        let turmasViewController = turmasNavigationController.viewControllers.first as! TurmasViewController
        turmasViewController.delegate = self
        turmasViewController.turmas = turmasDoAno
        presentFormSheetViewController(viewController: turmasNavigationController)
    }
    
    //MARK: Methods
    fileprivate func configurarComboBox() {
        anoLabel.text = String(anoSelecionado)
        turmasDoAno = [Turma]()
        for turma in turmasDoAluno {
            if turma.anoLetivo == anoSelecionado {
                turmasDoAno.append(turma)
            }
        }
        turmasDoAno = turmasDoAno.sorted(by: { (turma1, turma2) -> Bool in
            return turma1.codigoTurma > turma2.codigoTurma
        })
        if let primeiraTurma = turmasDoAno.first {
            selecionouTurma(turma: primeiraTurma)
        }
    }
}

//MARK: AnoDelegate
extension BoletimViewController: AnoDelegate {
    func selecionouAno(ano: UInt16) {
        anoSelecionado = ano
        configurarComboBox()
    }
}

//MARK: TurmaDelegate
extension BoletimViewController: TurmaDelegate {
    func selecionouTurma(turma: Turma) {
        turmaSelecionada = turma
        turmaLabel.text = turmaSelecionada.nomeTurma
    }
}

//MARK: WKNavigationDelegate
extension BoletimViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        carregouPagina = true
        dispatchGroup.leave()
    }
}

//MARK: WKScriptMessageHandler
extension BoletimViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        progressHud.hide(animated: true)
        if let boletimIntArray = message.body as? [Int8] {
            let boletimUrl = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + Constants.separadorCaminho + turmaSelecionada.nomeTurma.replacingOccurrences(of: Constants.espaco, with: Constants.underscroll) + Constants.underscroll + String(anoSelecionado) + Constants.extensaoPdf)
            do {
                try Data(buffer: UnsafeBufferPointer(start: boletimIntArray, count: boletimIntArray.count)).write(to: boletimUrl)
                let activityViewController = UIActivityViewController(activityItems: [boletimUrl], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = view
                present(activityViewController, animated: true)
            }
            catch {
            }
        }
        else {
            UIAlertController.createAlert(title: Localizable.ops.localized, message: Localizable.semBoletim.localized, style: .alert, target: self)
        }
    }
}

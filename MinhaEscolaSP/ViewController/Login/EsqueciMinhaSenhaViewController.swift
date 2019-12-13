//
//  EsqueciMinhaSenhaViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 12/02/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit
import WebKit

final class EsqueciMinhaSenhaViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let aluno = "AL"
        static let responsavel = "RA"
        static let javascript1 = "$('.forgot').click();"
        static let javascript2 = "var a='%@';var b=document.getElementById('opcaoPesquisa');var c=b.options;for(var i=c.length-1;i>=0;i--){var d=c[i];if(d.value==a){b.selectedIndex=i;$('#opcaoPesquisa').trigger('change');break}}"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var activityIndicatorView: UIActivityIndicatorView!
    
    //MARK: Variable
    fileprivate lazy var primeiraVez = true
    fileprivate var webView: WKWebView!
    var aluno: Bool!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if Requests.conectadoInternet() {
            activityIndicatorView.startAnimating()
            webView = WKWebView(frame: CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height - 64))
            webView.isHidden = true
            webView.navigationDelegate = self
            view.addSubview(webView)
            webView.load(URLRequest(url: URL(string: Requests.Configuracoes.urlServidor)!))
        }
    }
}

//MARK: WKNavigationDelegate
extension EsqueciMinhaSenhaViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if primeiraVez {
            primeiraVez = false
            webView.isHidden = false
            activityIndicatorView.stopAnimating()
            webView.evaluateJavaScript(Constants.javascript1) { (_, _) in
                var javascript: String!
                if self.aluno {
                    javascript = String(format: Constants.javascript2, Constants.aluno)
                }
                else {
                    javascript = String(format: Constants.javascript2, Constants.responsavel)
                }
                webView.evaluateJavaScript(javascript)
            }
        }
    }
}

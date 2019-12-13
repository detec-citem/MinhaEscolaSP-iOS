//
//  ConcluirAvaliacaoViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 25/03/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import MBProgressHUD
import UIKit

final class ConcluirAvaliacaoViewController: ViewController {
    //MARK: Variables
    lazy var questao3 = [UInt8]()
    lazy var questao4 = [UInt8]()
    lazy var questao5 = [UInt8]()
    var questao1: UInt8!
    var questao2: UInt8!
    var turma: Turma!
    
    //MARK: Actions
    @IBAction func concluirAvaliacao() {
        if !Requests.Configuracoes.servidorHabilitado || Requests.conectadoInternet() || LoginRequest.usuarioLogado.usuarioMock() {
            let progress = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
            progress.label.text = Localizable.carregando.localized
            progress.detailsLabel.text = Localizable.enviandoAvaliacao.localized
            AlimentacaoRequest.enviarAvaliacao(codigoTurma: turma.codigoTurma, questao1: questao1, questao2: questao2, questao3: questao3, questao4: questao4, questao5: questao5) { (sucesso, erro) in
                DispatchQueue.main.async {
                    progress.hide(animated: true)
                    if let erro = erro {
                        UIAlertController.createAlert(title: Localizable.atencao.localized, message: erro, style: .alert, target: self.navigationController)
                    }
                    else {
                        UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.avaliacaoEnviadaComSucesso.localized, style: .alert, target: self.navigationController)
                    }
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        else {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.internetAlimentacao.localized, style: .alert, target: self)
        }
    }
}

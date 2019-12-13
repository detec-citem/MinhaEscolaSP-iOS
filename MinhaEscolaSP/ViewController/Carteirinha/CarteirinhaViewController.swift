//
//  CarteirinhaViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 21/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class CarteirinhaViewController: UIViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let cabecalhoJpeg = "data:image/jpeg;base64,"
        static let cabecalhoPng = "data:image/png;base64,"
        static let nascimento = "Nascimento: "
        static let orientacao = "orientation"
        static let rg = "RG: "
        static let semDataNascimento = "Sem Data de Nascimento"
        static let semRg = "Sem Rg"
        static let separadorEstado = "/"
        static let separadorRa = "-"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var apelidoLabel: UILabel!
    @IBOutlet fileprivate weak var escolaLabel: UILabel!
    @IBOutlet fileprivate weak var nascimentoLabel: UILabel!
    @IBOutlet fileprivate weak var nomeLabel: UILabel!
    @IBOutlet fileprivate weak var qrCodeLabel: UILabel!
    @IBOutlet fileprivate weak var raLabel: UILabel!
    @IBOutlet fileprivate weak var rgLabel: UILabel!
    @IBOutlet fileprivate weak var turmaLabel: UILabel!
    @IBOutlet fileprivate weak var validadeLabel: UILabel!
    @IBOutlet fileprivate weak var fotoImageView: UIImageView!
    @IBOutlet fileprivate weak var qrCodeImageView: UIImageView!
    
    //MARK: Variables
    var carteirinha: Carteirinha!
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: Constants.orientacao)
        apelidoLabel.text = carteirinha.apelido
        qrCodeLabel.text = carteirinha.codigoAlunoCriptografado
        let aluno = carteirinha.aluno
        nomeLabel.text = aluno.nome
        raLabel.text = aluno.numeroRa + Constants.separadorRa + aluno.digitoRa + Constants.separadorEstado + aluno.ufRa
        validadeLabel.text = DateFormatter.mesAno.string(from: carteirinha.validade)
        turmaLabel.text = TurmaDao.buscarTurmaAtiva(aluno: aluno)?.nomeTurma
        if let dataNascimento = aluno.dataNascimento {
            nascimentoLabel.text = DateFormatter.defaultDateFormatter.string(from: dataNascimento)
        }
        else {
            nascimentoLabel.text = Constants.semDataNascimento
        }
        if let escolas = aluno.escolas as? Set<Escola> {
            escolaLabel.text = escolas.first?.nome
        }
        if let rg = aluno.rg, !rg.isEmpty {
            rgLabel.text = rg
        }
        else {
            rgLabel.text = Constants.semRg
        }
        qrCodeImageView.image = UIImage(data: carteirinha.qrCode.replacingOccurrences(of: Constants.cabecalhoPng, with: "").base64Decoded!)
        fotoImageView.image = UIImage(data: carteirinha.foto.replacingOccurrences(of: Constants.cabecalhoJpeg, with: "").base64Decoded!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    //MARK: Actions
    @IBAction func back() {
        navigationController?.popViewController(animated: true)
    }
}

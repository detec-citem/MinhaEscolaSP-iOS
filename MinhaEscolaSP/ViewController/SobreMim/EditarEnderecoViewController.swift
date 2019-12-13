//
//  EditarEnderecoViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 01/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreLocation
import MBProgressHUD
import UIKit

final class EditarEnderecoViewController: ViewController {
    //MARK: Constants
    fileprivate struct Constants {
        static let cidadesNavigationController = "CidadesNavigationController"
        static let localizacoesDiferenciadasNavigationController = "LocalizacoesDiferenciadasNavigationController"
        static let ptBr = "pt_BR"
        static let tamanhoBairro = 30
        static let tamanhoComplemento = 20
        static let tamanhoEndereco = 60
        static let tamanhoNumero = 10
        static let tipoLogradouroNavigationController = "TipoLogradouroNavigationController"
    }
    
    //MARK: Outlets
    @IBOutlet fileprivate weak var bairroActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var bairroTextField: UITextField!
    @IBOutlet fileprivate weak var cepActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var cepTextField: UITextField!
    @IBOutlet fileprivate weak var cidadeActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var cidadeControl: UIControl!
    @IBOutlet fileprivate weak var cidadeLabel: UILabel!
    @IBOutlet fileprivate weak var complementoTextField: UITextField!
    @IBOutlet fileprivate weak var enderecoActivityIndicatorView: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var enderecoTextField: UITextField!
    @IBOutlet fileprivate weak var localizacaoDiferenciadaControl: UIControl!
    @IBOutlet fileprivate weak var localizacaoDiferenciadaLabel: UILabel!
    @IBOutlet fileprivate weak var numeroActivityView: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var numeroTextField: UITextField!
    @IBOutlet fileprivate weak var salvarButton: UIButton!
    @IBOutlet fileprivate weak var tipoLogradouroControl: UIControl!
    @IBOutlet fileprivate weak var tipoLogradouroLabel: UILabel!
    
    //MARK: Variables
    var aluno: Aluno!
    weak var delegate: EnderecoDelegate!
    fileprivate var bairro: String!
    fileprivate var cep: String!
    fileprivate var cidade: String!
    fileprivate var endereco: String!
    fileprivate var numeroEndereco: UInt32!
    fileprivate var latitude: Double!
    fileprivate var localizacaoDiferenciada: UInt16!
    fileprivate var longitude: Double!
    fileprivate var tipoLogradouro: UInt16!
    fileprivate lazy var geolocalizado = false
    fileprivate lazy var geocoder = CLGeocoder()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let branco = UIColor.white.cgColor
        cidadeControl.layer.borderColor = branco
        localizacaoDiferenciadaControl.layer.borderColor = branco
        tipoLogradouroControl.layer.borderColor = branco
        if aluno.endereco == nil {
            localizacaoDiferenciada = LocalizacaoDiferenciadaInt.naoSeEncontra.rawValue
            localizacaoDiferenciadaLabel.text = LocalizacaoDiferenciada.naoEstaEmAreaDeLocalizacaoDiferenciada.rawValue
            tipoLogradouro = TipoLogradouroInt.rural.rawValue
            tipoLogradouroLabel.text = TipoLogradouro.rural.rawValue
        }
        else {
            bairro = aluno.bairroEndereco
            cep = aluno.cep
            cidade = aluno.cidadeEndereco
            endereco = aluno.endereco
            localizacaoDiferenciada = aluno.localizacaoDiferenciada
            numeroEndereco = aluno.numeroEndereco
            tipoLogradouro = aluno.tipoLogradouro
            complementoTextField.text = aluno.complementoEndereco
            configurarCampos()
            if tipoLogradouro == TipoLogradouroInt.rural.rawValue {
                tipoLogradouroLabel.text = TipoLogradouro.rural.rawValue
            }
            else {
                tipoLogradouroLabel.text = TipoLogradouro.urbana.rawValue
            }
            if aluno.localizacaoDiferenciada == LocalizacaoDiferenciadaInt.assentamento.rawValue {
                localizacaoDiferenciadaLabel.text = LocalizacaoDiferenciada.assentamento.rawValue
            }
            else if aluno.localizacaoDiferenciada == LocalizacaoDiferenciadaInt.indigena.rawValue {
                localizacaoDiferenciadaLabel.text = LocalizacaoDiferenciada.indigena.rawValue
            }
            else if aluno.localizacaoDiferenciada == LocalizacaoDiferenciadaInt.naoSeEncontra.rawValue {
                localizacaoDiferenciadaLabel.text = LocalizacaoDiferenciada.naoEstaEmAreaDeLocalizacaoDiferenciada.rawValue
            }
            else {
                localizacaoDiferenciadaLabel.text = LocalizacaoDiferenciada.quilombos.rawValue
            }
        }
    }
    
    //MARK: Actions
    @IBAction func alterouTexto(_ sender: UITextField) {
        verificarInformacoes()
    }
    
    @IBAction func confirmarEndereco() {
        if geolocalizado {
            irParaTelaGeolocalizacao()
        }
        else {
            var enderecoString = ""
            if let endereco = enderecoTextField.text, !endereco.isEmpty {
                enderecoString += endereco
            }
            if let numeroEndereco = numeroTextField.text, !numeroEndereco.isEmpty {
                enderecoString += (", " + numeroEndereco)
            }
            if let bairro = bairroTextField.text, !bairro.isEmpty {
                enderecoString += (" - " + bairro)
            }
            if let cidade = cidadeLabel.text, !cidade.isEmpty {
                enderecoString += (", " + cidade)
            }
            if !enderecoString.isEmpty {
                enderecoString += " - SP"
                let progressHud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
                progressHud.label.text = Localizable.carregando.localized
                progressHud.detailsLabel.text = Localizable.fazendoGeolocalizacao.localized
                geocoder.geocodeAddressString(enderecoString, completionHandler: { (placemarks, erro) in
                    progressHud.hide(animated: true)
                    if let coordenadas = placemarks?.first?.location?.coordinate {
                        self.latitude = coordenadas.latitude
                        self.longitude = coordenadas.longitude
                        self.irParaTelaGeolocalizacao()
                    }
                    else {
                        UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.erroGeolocalizacao.localized, style: .alert, target: self)
                    }
                })
            }
        }
    }
    
    @IBAction func mostrarCidades() {
        if let cidadesNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.cidadesNavigationController) as? UINavigationController, let cidadesViewController = cidadesNavigationController.viewControllers.first as? CidadesViewController {
            cidadesViewController.delegate = self
            presentFormSheetViewController(viewController: cidadesNavigationController)
        }
    }
    
    @IBAction func mostrarLocalizacoesDiferenciadas() {
        if let localizacoesDiferenciadasNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.localizacoesDiferenciadasNavigationController) as? UINavigationController, let localizacoesDiferenciadasViewController = localizacoesDiferenciadasNavigationController.viewControllers.first as? LocalizacoesDiferenciadasViewController {
            localizacoesDiferenciadasViewController.delegate = self
            presentFormSheetViewController(viewController: localizacoesDiferenciadasNavigationController)
        }
    }
    
    @IBAction func mostrasTiposLogradouro() {
        if let tipoLogradouroNavigationController = storyboard?.instantiateViewController(withIdentifier: Constants.tipoLogradouroNavigationController) as? UINavigationController, let tipoLogradouroViewController = tipoLogradouroNavigationController.topViewController as? TipoLogradouroViewController {
            tipoLogradouroViewController.delegate = self
            presentFormSheetViewController(viewController: tipoLogradouroNavigationController)
        }
    }
    
    @IBAction func sair(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func salvar(_ sender: Any) {
        aluno.bairroEndereco = bairro
        aluno.cep = cep
        aluno.cidadeEndereco = cidade
        aluno.endereco = endereco
        aluno.latitude = latitude
        aluno.longitude = longitude
        aluno.localizacaoDiferenciada = localizacaoDiferenciada
        aluno.numeroEndereco = numeroEndereco
        aluno.tipoLogradouro = tipoLogradouro
        delegate.editouEndereco()
        navigationController?.dismiss(animated: true)
    }
    
    //MARK: Methods
    fileprivate func configurarCampos() {
        bairroTextField.text = bairro
        cepTextField.text = cep
        cidadeLabel.text = cidade
        enderecoTextField.text = endereco
        numeroTextField.text = String(numeroEndereco)
    }
    
    fileprivate func processarPlacemarks(placemarks: [CLPlacemark]?) {
        if let placemark = placemarks?.first {
            bairro = placemark.subLocality
            cep = placemark.postalCode
            cidade = placemark.locality
            let enderecoCompleto = placemark.name
            if let partesDoEndereco = enderecoCompleto?.components(separatedBy: ", ") {
                endereco = partesDoEndereco.first
                numeroEndereco = UInt32(partesDoEndereco.last!)
                if numeroEndereco == nil {
                    numeroEndereco = 0
                }
            }
            configurarCampos()
            bairroActivityIndicatorView.stopAnimating()
            cepActivityIndicatorView.stopAnimating()
            cidadeActivityIndicatorView.stopAnimating()
            enderecoActivityIndicatorView.stopAnimating()
            numeroActivityView.stopAnimating()
        }
        else {
            UIAlertController.createAlert(title: Localizable.atencao.localized, message: Localizable.erroGeolocalizacao.localized, style: .alert, target: self)
        }
    }
    
    fileprivate func irParaTelaGeolocalizacao() {
        if let confirmarEnderecoViewController: ConfirmarEnderecoViewController = storyboard?.instantiateViewController() {
            confirmarEnderecoViewController.delegate = self
            confirmarEnderecoViewController.latitude = latitude
            confirmarEnderecoViewController.longitude = longitude
            navigationController?.pushViewController(confirmarEnderecoViewController, animated: true)
        }
    }
    
    fileprivate func verificarInformacoes() {
        if let bairroText = bairroTextField.text, let cidadeText = cidadeLabel.text, let enderecoText = enderecoTextField.text, let numeroText = numeroTextField.text, !bairroText.isEmpty && !cidadeText.isEmpty && !enderecoText.isEmpty && !numeroText.isEmpty {
            geolocalizado = latitude != nil && longitude != nil
            salvarButton.isEnabled = geolocalizado && (bairroText != aluno.bairroEndereco || cepTextField.text != aluno.cep || cidadeText != aluno.cidadeEndereco || enderecoText != aluno.endereco || latitude != aluno.latitude || longitude != aluno.longitude || numeroText != String(aluno.numeroEndereco) || self.localizacaoDiferenciada != aluno.localizacaoDiferenciada || self.tipoLogradouro != aluno.tipoLogradouro)
        }
        else {
            geolocalizado = false
            salvarButton.isEnabled = false
        }
    }
}

//MARK: CidadeDelegate
extension EditarEnderecoViewController: CidadesDelegate {
    func selecionouCidade(cidade: String) {
        cidadeLabel.text = cidade
        verificarInformacoes()
    }
}

//MARK: EnderecoLatitudeLongitudeDelegate
extension EditarEnderecoViewController: EnderecoLatitudeLongitudeDelegate {
    func editouLatitudeLongitude(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        if Requests.conectadoInternet() {
            geolocalizado = true
            bairroTextField.text = nil
            cepTextField.text = nil
            cidadeLabel.text = nil
            enderecoTextField.text = nil
            numeroTextField.text = nil
            bairroActivityIndicatorView.startAnimating()
            cepActivityIndicatorView.startAnimating()
            cidadeActivityIndicatorView.startAnimating()
            enderecoActivityIndicatorView.startAnimating()
            numeroActivityView.startAnimating()
            let localizacao = CLLocation(latitude: latitude, longitude: longitude)
            if #available(iOS 11.0, *) {
                geocoder.reverseGeocodeLocation(localizacao, preferredLocale: Locale(identifier: Constants.ptBr), completionHandler: { (placemarks, erro) in
                    self.processarPlacemarks(placemarks: placemarks)
                })
            }
            else {
                geocoder.reverseGeocodeLocation(localizacao, completionHandler: { (placemarks, erro) in
                    self.processarPlacemarks(placemarks: placemarks)
                })
            }
        }
    }
}

//MARK: LocalizacaoDiferenciadaDelegate
extension EditarEnderecoViewController: LocalizacaoDiferenciadaDelegate {
    func selecionouLocalizacaoDiferenciada(localizacaoDiferenciada: String) {
        localizacaoDiferenciadaLabel.text = localizacaoDiferenciada
        if localizacaoDiferenciada == LocalizacaoDiferenciada.assentamento.rawValue {
            self.localizacaoDiferenciada = LocalizacaoDiferenciadaInt.assentamento.rawValue
        }
        else if localizacaoDiferenciada == LocalizacaoDiferenciada.indigena.rawValue {
            self.localizacaoDiferenciada = LocalizacaoDiferenciadaInt.indigena.rawValue
        }
        else if localizacaoDiferenciada == LocalizacaoDiferenciada.naoEstaEmAreaDeLocalizacaoDiferenciada.rawValue {
            self.localizacaoDiferenciada = LocalizacaoDiferenciadaInt.naoSeEncontra.rawValue
        }
        else {
            self.localizacaoDiferenciada = LocalizacaoDiferenciadaInt.quilombos.rawValue
        }
    }
}

//MARK: TipoLogradouroDelegate
extension EditarEnderecoViewController: TipoLogradouroDelegate {
    func selecionouTipoLogradouro(tipoLogradouro: String) {
        tipoLogradouroLabel.text = tipoLogradouro
        if tipoLogradouro == TipoLogradouro.rural.rawValue {
            self.tipoLogradouro = TipoLogradouroInt.rural.rawValue
        }
        else {
            self.tipoLogradouro = TipoLogradouroInt.urbana.rawValue
        }
        verificarInformacoes()
    }
}

//MARK: UITextFieldDelegate
extension EditarEnderecoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let texto = textField.text {
            let novoTamanho = texto.count + string.count - range.length
            if textField == bairroTextField {
                return novoTamanho <= Constants.tamanhoBairro
            }
            if textField == complementoTextField {
                return novoTamanho <= Constants.tamanhoComplemento
            }
            if textField == enderecoTextField {
                return novoTamanho <= Constants.tamanhoEndereco
            }
            if textField == numeroTextField {
                return novoTamanho <= Constants.tamanhoNumero
            }
        }
        return true
    }
}

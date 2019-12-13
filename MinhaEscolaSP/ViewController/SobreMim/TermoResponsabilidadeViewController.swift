//
//  TermoResponsabilidadeViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 09/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class TermoResponsabilidadeViewController: ViewController {
    //MARK: Outlets
    @IBOutlet fileprivate weak var textView: UITextView!
    
    //MARK: Variables
    weak var delegate: TermoResponsabilidadeDelegate!
    
    //MARK: Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.contentOffset = .zero
    }
    
    //MARK: Actions
    @IBAction func concordo(_ sender: Any) {
        delegate.concordou()
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func sair(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}

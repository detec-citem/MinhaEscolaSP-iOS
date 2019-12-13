//
//  SobreComprovanteViewController.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 08/08/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class SobreComprovanteViewController: ViewController {
    //MARK: Outlet
    @IBOutlet fileprivate weak var textView: UITextView!
    
    //MARK: Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.contentOffset = .zero
    }
    
    //MARK: Actions
    @IBAction func sair(_ sender: Any) {
        navigationController?.dismiss(animated: true)
    }
}

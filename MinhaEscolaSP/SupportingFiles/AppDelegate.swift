//
//  AppDelegate.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 09/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Firebase
import IQKeyboardManagerSwift
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    //MARK: Constants
    fileprivate struct Constants {
        static let main = "Main"
        static let menuNavigationController = "MenuNavigationController"
    }
    
    //MARK: Variables
    var window: UIWindow?

    //MARK: Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if targetEnvironment(simulator)
            print("Diretório do banco:\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)")
        #endif
        IQKeyboardManager.shared.enable = true
        #if DEBUG
        #else
            FirebaseApp.configure()
        #endif
        let appearance = UINavigationBar.appearance()
        appearance.isTranslucent = true
        appearance.barStyle = .black
        appearance.titleTextAttributes = [.foregroundColor:UIColor.white]
        appearance.shadowImage = UIImage()
        appearance.setBackgroundImage(UIImage(), for: .default)
        window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: Constants.main, bundle: nil)
        if let usuarioLogado = UsuarioDao.usuarioLogado() {
            LoginRequest.usuarioLogado = usuarioLogado
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: Constants.menuNavigationController)
        }
        else {
            window?.rootViewController = storyboard.instantiateInitialViewController()
        }
        window?.makeKeyAndVisible()
        ImagemTurmaDao.cadastrarImagensTurmas()
        return true
    }
}

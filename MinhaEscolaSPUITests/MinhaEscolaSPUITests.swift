//
//  MinhaEscolaSPUITests.swift
//  MinhaEscolaSPUITests
//
//  Created by Victor Bozelli Alvarez on 30/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import XCTest

final class MinhaEscolaSPUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
    }

    func testExample() {
        let app = XCUIApplication()
        let alunoButton = app.buttons["aluno"]
        _ = alunoButton.waitForExistence(timeout: 2)
        snapshot("Perfil")
        alunoButton.firstMatch.tap()
        let entrarButton = app.buttons["entrar"]
        _ = entrarButton.waitForExistence(timeout: 2)
        entrarButton.firstMatch.tap()
        let menuTableView = app.tables.firstMatch
        _ = menuTableView.waitForExistence(timeout: 10)
        snapshot("MenuAluno")
        menuTableView.cells.staticTexts["minha escola"].firstMatch.tap()
        let minhaEscolaNavigationBar = app.navigationBars["minha escola"]
        _ = minhaEscolaNavigationBar.waitForExistence(timeout: 2)
        snapshot("MinhaEscola")
        minhaEscolaNavigationBar.firstMatch.buttons["menu"].firstMatch.tap()
        menuTableView.cells.staticTexts["sobre mim"].firstMatch.tap()
        let sobreMimNavigationBar = app.navigationBars["sobre mim"]
        _ = sobreMimNavigationBar.waitForExistence(timeout: 2)
        snapshot("SobreMim")
        sobreMimNavigationBar.firstMatch.buttons["menu"].firstMatch.tap()
        menuTableView.cells.staticTexts["horário de aulas"].firstMatch.tap()
        let horarioDeAulasNavigationBar = app.navigationBars["horários"]
        _ = horarioDeAulasNavigationBar.waitForExistence(timeout: 2)
        snapshot("HorarioAulas")
        horarioDeAulasNavigationBar.firstMatch.buttons["menu"].firstMatch.tap()
        menuTableView.cells.staticTexts["notas"].firstMatch.tap()
        let notasNavigationBar = app.navigationBars["notas"]
        _ = notasNavigationBar.waitForExistence(timeout: 2)
        snapshot("Notas")
        notasNavigationBar.firstMatch.buttons["menu"].firstMatch.tap()
        menuTableView.cells.staticTexts["frequência"].firstMatch.tap()
        let frequenciaNavigationBar = app.navigationBars["frequência"]
        _ = frequenciaNavigationBar.waitForExistence(timeout: 2)
        snapshot("Frequência")
        frequenciaNavigationBar.firstMatch.buttons["menu"].firstMatch.tap()
        menuTableView.cells.staticTexts["calendário"].firstMatch.tap()
        let calendarioNavigationBar = app.navigationBars["calendário"]
        _ = calendarioNavigationBar.waitForExistence(timeout: 2)
        snapshot("Calendário")
        calendarioNavigationBar.firstMatch.buttons["menu"].firstMatch.tap()
        menuTableView.cells.staticTexts["carteirinha"].firstMatch.tap()
        let carteirinhaNavigationBar = app.navigationBars["carteirinha"]
        _ = carteirinhaNavigationBar.waitForExistence(timeout: 2)
        snapshot("Carteirinha")
        app.buttons.firstMatch.tap()
        menuTableView.cells.staticTexts["boletim"].firstMatch.tap()
        _ = app.navigationBars["boletim"].waitForExistence(timeout: 2)
        snapshot("Boletim")
    }
}

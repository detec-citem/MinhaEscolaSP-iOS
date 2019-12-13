//
//  HorarioTableViewCell.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 22/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import UIKit

final class HorarioTableViewCell: UITableViewCell {
    //MARK: Outlets
    @IBOutlet fileprivate weak var horarioLabel: UILabel!
    @IBOutlet fileprivate weak var materiaLabel: UILabel!
    @IBOutlet fileprivate weak var professorLabel: UILabel!
    @IBOutlet fileprivate weak var turmaLabel: UILabel!
    @IBOutlet fileprivate weak var materiaImageView: UIImageView!
    
    //MARK: Variables
    var horarioAula: HorarioAula! {
        didSet {
            configurarCelula()
        }
    }
    
    //MARK: Methods
    fileprivate func configurarCelula() {
        horarioLabel.text = horarioAula.dataHoraInicio + " - " + horarioAula.dataHoraFim
        materiaLabel.text = horarioAula.nomeMateriaCompleto
        //professorLabel.text = horarioAula.nomeProfessor
        turmaLabel.text = horarioAula.turma.nomeTurma
        var nomeImagem = horarioAula.nomeImagem
        if nomeImagem == nil {
            nomeImagem = ImagemTurmaDao.imagemParaHorarioAula(horarioAula: horarioAula)?.nomeImagem
            if nomeImagem == nil {
                nomeImagem = "materia_default"
            }
            horarioAula.nomeImagem = nomeImagem
        }
        if let nomeImagem = nomeImagem {
            materiaImageView.image = UIImage(named: nomeImagem)
        }
    }
}

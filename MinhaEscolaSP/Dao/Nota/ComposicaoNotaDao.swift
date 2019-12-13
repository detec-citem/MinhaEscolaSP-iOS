//
//  ComposicaoNotaDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 23/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class ComposicaoNotaDao {
    //MARK: Constants
    fileprivate struct CamposServidor {
        static let descricaoAtividade = "DescricaoAtividade"
        static let nota = "Nota"
    }
    
    //MARK: Methods
    static func salvarComposicaoNota(json: [String:Any], nota: Nota) {
        if let descricaoAtividade = json[CamposServidor.descricaoAtividade] as? String, let notaString = json[CamposServidor.nota] as? String, let numeroNota = NumberFormatter.notaFormatter.number(from: notaString) as? Float {
            if let composicaoNota = CoreDataManager.sharedInstance.getData(tabela: Tabelas.composicaoNota, predicate: NSPredicate(format: "descricaoAtividade == %@ AND nota.aluno.codigoAluno == %d AND nota.bimestre == %d AND nota.codigoDisciplina == %d", descricaoAtividade, nota.aluno.codigoAluno, nota.bimestre, nota.codigoDisciplina), unique: true)?.first as? ComposicaoNota {
                composicaoNota.numeroNota = numeroNota
                return
            }
            let composicaoNota: ComposicaoNota = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.composicaoNota)
            composicaoNota.descricaoAtividade = descricaoAtividade
            composicaoNota.numeroNota = numeroNota
            composicaoNota.nota = nota
        }
    }
}

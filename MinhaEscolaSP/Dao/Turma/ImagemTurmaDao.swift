//
//  ImagemTurmaDao.swift
//  MinhaEscolaSP
//
//  Created by Victor Bozelli Alvarez on 09/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import Foundation

final class ImagemTurmaDao {
    //MARK: Constants
    fileprivate struct Constants {
        static let codigosMaterias:[UInt16]  = [1100,1111,1118,1119,1130,1131,1132,1200,1201,1202,1300,1400,1401,1407,1408,1500,1800,1813,1814,1816,1900,1903,1905,1908,2000,2100,2105,2112,2200,2208,2300,2306,2308,2309,2400,2413,2426,2500,2504,2600,2605,2607,2700,2707,2713,2800,2812,2831,2832,3100,3105,3107,3108,3200,5100,6900,7000,7235,7240,7245,8001,8002,8003,8004,8005,8006,8007,8008,8009,8010,8011,8012,8013,8014,8015,8016,8017,8018,8019,8020,8021,8022,8023,8024,8025,8026,8027,8028,8029,8030,8031,8032,8033,8034,8035,8036,8037,8038,8039,8040,8041,8042,8043,8044,8045,8046,8047,8048,8049,8050,8051,8052,8053,8054,8055,8056,8057,8058,8059,8060,8061,8062,8063,8064,8065,8066,8067,8068,8069,8070,8071,8072,8073,8074,8075,8076,8077,8078,8079,8080,8081,8082,8083,8084,8085,8086,8087,8088,8089,8090,8091,8092,8093,8094,8095,8096,8097,8098,8099,8100,8101,8102,8103,8104,8105,8106,8107,8108,8109,8110,8111,8112,8113,8114,8115,8116,8117,8118,8119,8120,8121,8122,8123,8124,8125,8126,8127,8128,8129,8130,8131,8132,8133,8134,8135,8136,8137,8138,8139,8140,8141,8142,8143,8144,8145,8146,8147,8148,8149,8150,8151,8152,8153,8154,8155,8156,8157,8158,8159,8160,8161,8162,8163,8164,8165,8166,8167,8168,8169,8170,8171,8172,8173,8174,8175,8176,8177,8178,8179,8180,8181,8182,8183,8184,8185,8186,8187,8188,8189,8190,8191,8192,8193,8194,8195,8196,8197,8198,8199,8200,8201,8202,8203,8204,8205,8206,8207,8208,8209,8210,8211,8212,8213,8214,8215,8216,8217,8218,8222,8223,8224,8225]
        static let materia1100 = "materia1100"
        static let materia1800 = "materia1800"
        static let materia1900 = "materia1900"
        static let materia2100 = "materia2100"
        static let materia2200 = "materia2200"
        static let materia2300 = "materia2300"
        static let materia2400 = "materia2400"
        static let materia2500 = "materia2500"
        static let materia2600 = "materia2600"
        static let materia2700 = "materia2700"
        static let materia2800 = "materia2800"
        static let materia3100 = "materia3100"
        static let materiaDefault = "materia_default"
    }
    
    //MARK: Methods
    static func imagemParaHorarioAula(horarioAula: HorarioAula) -> ImagemTurma? {
        return CoreDataManager.sharedInstance.getData(tabela: Tabelas.imagemTurma, predicate: NSPredicate(format: "codigoMateria == %d", horarioAula.codigoMateria), unique: true)?.first as? ImagemTurma
    }
    
    static func cadastrarImagensTurmas() {
        if CoreDataManager.sharedInstance.getCount(tabela: Tabelas.imagemTurma) == .zero {
            for codigoMateria in Constants.codigosMaterias {
                var nomeImagem: String!
                if (codigoMateria >= 1100 && codigoMateria <= 1500) || codigoMateria == 2000 || codigoMateria == 6900 || codigoMateria == 7000 {
                    nomeImagem = Constants.materia1100
                }
                else if codigoMateria >= 1800 && codigoMateria <= 1816 {
                    nomeImagem = Constants.materia1800
                }
                else if (codigoMateria >= 1900 && codigoMateria <= 1908) || (codigoMateria >= 8001 && codigoMateria <= 8225) {
                    nomeImagem = Constants.materia1900
                }
                else if (codigoMateria >= 2100 && codigoMateria <= 2112) || codigoMateria == 5100 {
                    nomeImagem = Constants.materia2100
                }
                else if codigoMateria == 2200 || codigoMateria == 2208 {
                    nomeImagem = Constants.materia2200
                }
                else if (codigoMateria >= 2300 && codigoMateria <= 2309) || codigoMateria == 3200 {
                    nomeImagem = Constants.materia2300
                }
                else if codigoMateria == 2400 || codigoMateria == 2413 || codigoMateria == 2426 {
                    nomeImagem = Constants.materia2400
                }
                else if codigoMateria == 2500 || codigoMateria == 2504 || codigoMateria == 7240 || codigoMateria == 7245 {
                    nomeImagem = Constants.materia2500
                }
                else if codigoMateria == 2600 || codigoMateria == 2605 || codigoMateria == 2607 {
                    nomeImagem = Constants.materia2600
                }
                else if codigoMateria == 2700 || codigoMateria == 2707 || codigoMateria == 2713 || codigoMateria == 7235 {
                    nomeImagem = Constants.materia2700
                }
                else if codigoMateria == 2800 || codigoMateria == 2812 || codigoMateria == 2831 || codigoMateria == 2832 {
                    nomeImagem = Constants.materia2800
                }
                else if codigoMateria == 3100 || codigoMateria == 3105 || codigoMateria == 3107 || codigoMateria == 3108 {
                    nomeImagem = Constants.materia3100
                }
                else {
                    nomeImagem = Constants.materiaDefault
                }
                let imagemTurma: ImagemTurma = CoreDataManager.sharedInstance.createObject(tabela: Tabelas.imagemTurma)
                imagemTurma.codigoMateria = codigoMateria
                imagemTurma.nomeImagem = nomeImagem
            }
            CoreDataManager.sharedInstance.saveContext()
        }
    }
}

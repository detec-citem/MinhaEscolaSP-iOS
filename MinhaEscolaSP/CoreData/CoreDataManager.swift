//
//  CoreDataManager.swift
//  SEDProfessor
//
//  Created by Victor Bozelli Alvarez on 09/01/19.
//  Copyright © 2019 PRODESP. All rights reserved.
//

import CoreData
import Foundation

struct Tabelas {
    static let aluno = "Aluno"
    static let bimestre = "Bimestre"
    static let carteirinha = "Carteirinha"
    static let composicaoNota = "ComposicaoNota"
    static let contato = "Contato"
    static let contatoEscola = "ContatoEscola"
    static let diaEvento = "DiaEvento"
    static let escola = "Escola"
    static let frequencia = "Frequencia"
    static let horarioAula = "HorarioAula"
    static let imagemTurma = "ImagemTurma"
    static let interesseRematricula = "InteresseRematricula"
    static let nota = "Nota"
    static let turma = "Turma"
    static let usuario = "Usuario"
}

final class CoreDataManager {
    //MARKD: Constants
    fileprivate struct Constants {
        static let nomeBanco = "MinhaEscolaSP"
        static let extensaoModelagem = "momd"
        static let extensaoSqlite = ".sqlite"
        static let identificadorGrupo = "group.br.gov.sp.educacao.minhaescola"
    }
    
    //MARK: Singleton
    static let sharedInstance = CoreDataManager()

    //MARK: CoreData stack
    fileprivate lazy var applicationDocumentsDirectory: URL = {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.identificadorGrupo)!
    }()

    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: Constants.nomeBanco, withExtension: Constants.extensaoModelagem)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(Constants.nomeBanco + Constants.extensaoSqlite)
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true])
        }
        catch {
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initxialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()

    fileprivate lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergePolicy(merge: .mergeByPropertyObjectTrumpMergePolicyType);
        return managedObjectContext
    }()

    func createObject<T: NSManagedObject>(tabela: String) -> T {
        return NSEntityDescription.insertNewObject(forEntityName: tabela, into: managedObjectContext) as! T
    }

    func deleteDatabase() {
        deleteData(tabela: Tabelas.aluno)
        deleteData(tabela: Tabelas.bimestre)
        deleteData(tabela: Tabelas.carteirinha)
        deleteData(tabela: Tabelas.composicaoNota)
        deleteData(tabela: Tabelas.contato)
        deleteData(tabela: Tabelas.contatoEscola)
        deleteData(tabela: Tabelas.diaEvento)
        deleteData(tabela: Tabelas.escola)
        deleteData(tabela: Tabelas.frequencia)
        deleteData(tabela: Tabelas.horarioAula)
        deleteData(tabela: Tabelas.imagemTurma)
        deleteData(tabela: Tabelas.nota)
        deleteData(tabela: Tabelas.turma)
        deleteData(tabela: Tabelas.usuario)
        managedObjectContext.reset()
    }

    func deleteData(tabela: String, predicate _: NSPredicate? = nil) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tabela)
        fetchRequest.includesPropertyValues = false
        do {
            try persistentStoreCoordinator.execute(NSBatchDeleteRequest(fetchRequest: fetchRequest), with: managedObjectContext)
        }
        catch {
        }
    }
    
    func deleteObject(object: NSManagedObject) {
        managedObjectContext.delete(object)
    }
    
    func getCount(tabela: String, predicate: NSPredicate? = nil) -> Int {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: tabela)
        fetchRequest.includesPropertyValues = false
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = predicate
        do {
            return try managedObjectContext.count(for: fetchRequest)
        }
        catch {
        }
        return 0
    }

    func getData(tabela: String, predicate: NSPredicate? = nil, unique: Bool = false, propertiesToFetch: [String]? = nil, sortBy: String? = nil) -> [NSManagedObject]? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: tabela)
        fetchRequest.predicate = predicate
        fetchRequest.propertiesToFetch = propertiesToFetch
        if unique {
            fetchRequest.fetchLimit = 1
        }
        if sortBy != nil {
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: sortBy, ascending: true)]
        }
        do {
            return try managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
        }
        catch {
        }
        return nil
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            managedObjectContext.performAndWait {
                do {
                    try managedObjectContext.save()
                } catch {
                    let error = error as NSError
                    NSLog("Unresolved error \(error), \(error.userInfo)")
                    abort()
                }
            }
        }
    }
}

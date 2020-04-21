//
//  AppDelegate.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import UIKit
import CoreData

extension ItemEntity {
    static func create(context: NSManagedObjectContext, item: ItemElement) {
        let newItem = self.init(context: context)
        newItem.id = Int64(item.id)
        newItem.name = item.name
        newItem.source = item.source.rawValue
        newItem.detail = item.details
        newItem.buy = item.buy == nil ? 0 : Int64(item.buy!)
        newItem.sell = Int64(item.sell)
        newItem.color1 = item.colors.first?.rawValue
        newItem.color2 = item.colors.last?.rawValue
        newItem.tag = item.tag
        
        // bug: variants shouldn't be nested
        item.variants.first?.forEach { variant in
            let newVariant = ItemVariantEntity.init(context: context)
            newVariant.name = variant.name
            newVariant.color1 = variant.colors.first?.rawValue
            newVariant.color2 = variant.colors.last?.rawValue
            newVariant.image = URL(string: variant.image)
            newVariant.item = newItem
        }
        
        if let recipe = item.recipe {
            let newRecipe = RecipeEntity(context: context)
            newRecipe.name = recipe.name
            newRecipe.source = recipe.source
            newRecipe.category = recipe.category.rawValue
            newRecipe.item = newItem
            
            recipe.materials.forEach {
                let newMaterial = RecipeItemEntity(context: context)
                newMaterial.name = $0.name
                newMaterial.count = Int64($0.count)
                newMaterial.addToRecipe(newRecipe)
            }
        }
        
        let hha = HHAInfoEntity.init(context: context)
        hha.concept1 = item.hhaConcepts.first
        hha.concept2 = item.hhaConcepts.last
        
        newItem.hhaInfo = hha
    }
    
    var colors: [String] {
        [color1, color1].compactMap {
            $0
        }
    }
    
    var variantEntities: [ItemVariantEntity]? {
        (variants?.allObjects as? [ItemVariantEntity])
    }
    
    var image: URL? {
        variantEntities?.first?.image
    }
}

extension ItemVariantEntity {
    var colors: [String] {
        [color1, color1].compactMap {
            $0
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }


    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentCloudKitContainer(name: "ACNH")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                
                ["housewares", "miscellaneous", "wall-mounted", "wallpapers", "floors", "rugs"].forEach {
                    if let path = Bundle.main.path(forResource: $0, ofType: "json") {
                        do {
                            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                            let decoded = try JSONDecoder().decode([ItemElement].self, from: data)
                            decoded.forEach {
                                ItemEntity.create(context: container.viewContext, item: $0)
                            }
                        } catch {
                            // handle error
                            print("err: \(error)")
                        }
                    }
                }
                
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}


//
//  FavoriteManager.swift
//  USGBC
//
//  Created by Vishal Raj on 01/12/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteManager {
    
    static func getFavoriteStatus(title: String, favoriteButton: UIButton) -> Bool{
        let realm = try! Realm()
        let favorite = realm.objects(Favorite.self).filter("name = %@", title).first
        if(favorite != nil){
            favoriteButton.setImage(UIImage(named: "star-filled"), for: .normal)
            return true
        }else{
            favoriteButton.setImage(UIImage(named: "star-empty"), for: .normal)
            return false
        }
    }
    
    static func addToFavorite(name: String, id: String, image: String, category: String) -> Bool{
        var isAdded = false
        let realm = try! Realm()
        do{
            try realm.write { () -> Void in
                let favorite = Favorite()
                favorite.name = name
                favorite.id = id
                favorite.category = category
                favorite.image = image
                realm.add(favorite)
                isAdded = true
            }
        }catch {
            print(error.localizedDescription)
        }
        return isAdded
    }
    
    static func removeFromFavorite(name: String, id: String, category: String) -> Bool{
        var isDeleted = false
        let realm = try! Realm()
        do{
            try realm.write {
                realm.delete(realm.objects(Favorite.self).filter("name=%@",name))
                isDeleted = true
            }
        }catch {
            print(error.localizedDescription)
        }
        return isDeleted
    }
}

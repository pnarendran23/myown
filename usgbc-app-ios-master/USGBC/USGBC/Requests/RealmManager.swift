//
//  RealmManager.swift
//  USGBC
//
//  Created by Vishal Raj on 06/09/17.
//  Copyright © 2017 Group10 Technologies. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager<T> {
    static var shared: RealmManager{
        get{
            return RealmManager()
        }
    }
    let realm: Realm!
    
    init() {
        realm = try! Realm()
    }
    
    //retrive data from db
    func getAllData(object: T) -> Results<Object>{
        let results: Results<Object> = realm.objects(object as! Object.Type)
        return results
    }
    
    func getSingleData(object: T, name: String) -> Object?{
        let result = realm.objects(object as! Object.Type).filter("name = %@", name).first
        return result
    }
    
    //write an object in db
    func addData(object: T){
        try! realm.write{
            realm.add(object as! Object, update: true)
        }
    }
    
    func deleteSingleData(object: T, name: String){
        try! realm.write{
            realm.delete(realm.objects(object as! Object.Type).filter("name=%@",name))
        }
    }
    
    func deleteAllData(object: T){
        try! realm.write{
            realm.delete(object as! Object)
        }
    }
}

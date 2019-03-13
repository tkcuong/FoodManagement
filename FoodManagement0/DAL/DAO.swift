//
//  DAO.swift
//  FoodManagement0
//
//  Created by Cuong Tieu-Kim on 9/4/18.
//  Copyright © 2018 TDC. All rights reserved.
//

import Foundation
import UIKit
import os.log

class DatabaseAccessLayer {
    private var dbPath: String
    private let DBNAME: String = "Foods.sqlite"
    private var db: FMDatabase?
    
    //MARK: Foots table properties
    private let TABLE_NAME: String = "meals"
    private let FOOD_ID: String = "_id"
    private let FOOD_NAME: String = "name"
    private let FOOD_RATING: String = "rating"
    private let FOOD_IMAGE: String = "image"
    
    init() {
        let directories:[String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        dbPath = directories[0]+"/"+DBNAME
        db = FMDatabase(path: dbPath)
        if db == nil {
            os_log("Can not create the database.", log: OSLog.default, type: .debug)
        }
        else {
            os_log("Database created!", log: OSLog.default, type: .debug)
        }
    }
    
    func createTable() -> Bool {
        var ok: Bool = false
        if db != nil {
            let sql = "CREATE TABLE " + TABLE_NAME + "( "
                + FOOD_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
                + FOOD_NAME + " TEXT, "
                + FOOD_IMAGE + " TEXT, "
                + FOOD_RATING + " INTEGER)"
            
            if db!.executeStatements(sql){
                ok = true
                os_log("Table created!", log: .default, type: .debug)
            }
            else {
                os_log("Can not create the table!", log: .default, type: .debug)
            }
        }
        else {
            os_log("Database is nil!", log: .default, type: .debug)
        }
        return ok;
    }
    
    func open () -> Bool{
        var ok: Bool = false
        if db != nil {
            guard db!.open() else {
                fatalError("Can not open the database: \(db!.lastErrorMessage())")
            }
            ok = true
            os_log("Database is opened!", log: .default, type: .debug)
        }
        else {
            os_log("Database is nil!", log: .default, type: .debug)
        }
        return ok
    }
    
    func close (){
        if db != nil {
            db!.close()
        }
    }
    //MARK: Database APIs
    func insert(meal: Meal){
        if db != nil {
            let imageData: NSData = UIImagePNGRepresentation(meal.photo!)! as NSData
            let mealPhotoString = imageData.base64EncodedString(options: .lineLength64Characters)
            
            let sql = "INSERT INTO " + TABLE_NAME + "(" + FOOD_NAME + ", " + FOOD_IMAGE + ", " + FOOD_RATING + ")" + " VALUES (?, ?, ?)"
            
            if db!.executeUpdate(sql, withArgumentsIn: [meal.name, mealPhotoString, String(meal.rating)]) {
                os_log("Succeed to Insert into the table!", log: .default, type: .debug)
            }
            else {
                os_log("Fail to Insert into the table!", log: .default, type: .debug)
            }
        }
        else {
            os_log("Database is nil!", log: .default, type: .debug)
        }
    }
    
    func readDatabase( meals: inout [Meal]){
        var results: FMResultSet!
        if db != nil {
            let sql = "SELECT * FROM " + TABLE_NAME
            
            do {
                results = try db!.executeQuery(sql, values: nil)
            }
            catch {
                print(error.localizedDescription)
            }
            if results != nil {
                while results.next(){
                    let mealname = results.string(forColumn: FOOD_NAME)!
                    let photo = results.string(forColumn: FOOD_IMAGE)!
                    let rating = results.int(forColumn: FOOD_RATING)
                    
                    let dataDecoded : Data = Data(base64Encoded: photo, options: .ignoreUnknownCharacters)!
                    let decodedimage = UIImage(data: dataDecoded)
                    
                    let meal = Meal(name: mealname, photo: decodedimage, rating: Int(rating))!
                    meals.append(meal)
                }
            }
        }
        else {
            os_log("Database is nil!", log: .default, type: .debug)
        }
    }
    
    func update (oldMeal: Meal, newMeal: Meal){
        if db != nil {
            let newImageData: NSData = UIImagePNGRepresentation(newMeal.photo!)! as NSData
            let newMealPhotoString = newImageData.base64EncodedString(options: .lineLength64Characters)
            let sql = "UPDATE " + TABLE_NAME
                + " SET "
                + FOOD_NAME + " = ? " + ", " + FOOD_IMAGE + " = ? " + ", " + FOOD_RATING + " = ? "
                + "WHERE \(FOOD_NAME) = ? AND \(FOOD_RATING) = ?"
            do {
                try db!.executeUpdate(sql, values: [newMeal.name, newMealPhotoString, newMeal.rating, oldMeal.name, oldMeal.rating])
                os_log("Succeed to update the table!", log: .default, type: .debug)
            }
            catch {
                os_log("Fail to update into the table!", log: .default, type: .debug)
            }
        }
        else {
            os_log("Database is nil!", log: .default, type: .debug)
        }
    }
    
    func delete (meal: Meal){
        if db != nil {
            let sql = "DELETE FROM \(TABLE_NAME) WHERE \(FOOD_NAME) = ? AND \(FOOD_RATING) = ?"
            do {
                try db!.executeUpdate(sql, values: [meal.name, meal.rating])
                os_log("Succeed to delete from the table!", log: .default, type: .debug)
            }
            catch {
                os_log("Fail to delete from the table!", log: .default, type: .debug)
            }
        }
        else {
            os_log("Database is nil!", log: .default, type: .debug)
        }
    }
}


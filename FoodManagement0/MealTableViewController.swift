//
//  MealTableViewController.swift
//  FoodManagement0
//
//  Created by Cuong Tieu-Kim on 9/3/18.
//  Copyright © 2018 TDC. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    //MARK: Properties
    var meals = [Meal]()
    private var dao = DatabaseAccessLayer()
    static private var tableCreated: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Using editButtonItem of the Tableview
        navigationItem.leftBarButtonItem = editButtonItem
        // Load meals
        loadMeal()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("Can not get the cell")
        }
        // Get the meal appropriated to indexPath
        let meal = meals[indexPath.row]
        cell.lblName.text = meal.name
        cell.imgMeal.image = meal.photo
        cell.ratingControl.ratingValue = meal.rating
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if dao.open() {
                dao.delete(meal: meals[indexPath.row])
            }
            meals.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    //MARK: Actions for navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "addItem":
            os_log("Add a new meal called", log: OSLog.default, type: .debug)
            /*
             guard let addMealNavigatiionController = segue.destination as? UINavigationController else {
             fatalError("Destination - \(segue.destination) is not valid")
             }
             if let addMealController = addMealNavigatiionController.topViewController as? MealViewController {
             addMealController.addmealMode = true
             }
             */
        case "showDetail":
            guard let detailMealController = segue.destination as? MealViewController else {
                fatalError("Destination - \(segue.destination) is not valid")
            }
            //detailMealController.addmealMode = false
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Selected cell - \(String(describing: sender)) is not valid")
            }
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("Can not access the cell in the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            // Pass the meal to the Meal detail controller
            detailMealController.meal = selectedMeal
        default:
            fatalError("Can not identify the segue \(String(describing: segue.identifier))")
        }
    }
    @IBAction func unWindToMealList(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal{
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Edit the meal
                if dao.open() {
                    dao.update(oldMeal: meals[selectedIndexPath.row], newMeal: meal)
                }
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new meal
                meals.append(meal)
                // Update to table view
                let newIndexPath = IndexPath(row: meals.count-1, section: 0)
                tableView.insertRows(at: [newIndexPath], with: UITableViewRowAnimation.automatic)
                
                if dao.open() {
                    dao.insert(meal: meal)
                }
            }
        }
    }
    
    //MARK: Private methods
    private func loadMeal() {
        //Load from database
        if dao.open() {
            if !MealTableViewController.tableCreated {
                MealTableViewController.tableCreated = dao.createTable()
            }
            dao.readDatabase(meals: &meals)
        }
        
        let mealImage = UIImage(named: "defaultImages")
        guard let meal = Meal(name: "Sò nướng", photo: mealImage, rating: 4) else {
            fatalError("Không thể load món đã chọn")
        }
        if meals.count == 0 {
            meals.append(meal)
            //meals += [meal]
            if dao.open() {
                dao.insert(meal: meal)
            }
        }
    }
}

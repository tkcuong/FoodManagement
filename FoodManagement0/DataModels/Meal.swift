//
//  Meal.swift
//  FoodManagement0
//
//  Created by Cuong Tieu-Kim on 9/3/18.
//  Copyright © 2018 TDC. All rights reserved.
//

import UIKit
class Meal {
    //MARK: Properties
    var name: String
    var photo: UIImage?
    var rating: Int
    //MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int) {
        //if name.isEmpty || rating < 0 {
          //  return nil
        //}
        guard !name.isEmpty else {
            return nil
        }
        guard (rating>=0)&&(rating<=5) else {
            return nil
        }
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}

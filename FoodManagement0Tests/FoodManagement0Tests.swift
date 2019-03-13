//
//  FoodManagement0Tests.swift
//  FoodManagement0Tests
//
//  Created by Cuong Tieu-Kim on 8/30/18.
//  Copyright © 2018 TDC. All rights reserved.
//

import XCTest
@testable import FoodManagement0

class FoodManagement0Tests: XCTestCase {
    //MARK: Meal class test
    
    // When pass valid parameters, the initiazer must return valid meal
    func testMealInitializationSucceed(){
        // Zero rating
        let zeroRatingMeal = Meal.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        // Highest positive rating
        let positiveRating = Meal.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRating)
    }
    // When pass not valid parameters, the initiazer must return nil
    func testMealInitializationFail(){
        // Negative rating
        let negativeRating = Meal.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRating)
        //Over maximum rating
        let overMaximumRating = Meal.init(name: "Over maximum rating", photo: nil, rating: 6)
        XCTAssertNil(overMaximumRating)
        // Empty name
        let emptyName = Meal.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyName)
    }
}

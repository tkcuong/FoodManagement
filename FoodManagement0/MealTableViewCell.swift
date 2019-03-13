//
//  MealTableViewCell.swift
//  FoodManagement0
//
//  Created by Cuong Tieu-Kim on 9/3/18.
//  Copyright © 2018 TDC. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgMeal: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

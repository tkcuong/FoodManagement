//
//  RatingControl.swift
//  FoodManagement0
//
//  Created by Cuong Tieu-Kim on 9/2/18.
//  Copyright © 2018 TDC. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    @IBInspectable var ratingValue: Int = 0 {
        didSet {
            updatButtonStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    //MARK: Button's Actions
    @objc func ratingButtonTap(button: UIButton){
        //print("Button tapped")
        guard let index = ratingButtons.index(of: button) else {
            fatalError("Can not find the button \(button) in the aray \(ratingButtons)")
        }
        // Calculate rating value of the seclected button
        let ratingButton = index + 1
        if ratingButton == ratingValue {
            ratingValue -= 1
        }
        else {
            ratingValue = ratingButton
        }
    }
    
    
    //MARK: Private methods
    private func setupButtons(){
        // Clear the old buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Load Images for buttons
        //let emptyStar = UIImage(named: "emptyStar")
        //let hightLightStar = UIImage(named: "hightLightStar")
        //let filledStar = UIImage(named: "filledStar")
        let bundle = Bundle(for: type(of: self))
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let hightLightStar = UIImage(named: "hightLightStar", in: bundle, compatibleWith: self.traitCollection)
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        // Create the rating buttons
        for _ in 0..<starCount {
            // Create the buttons
            let button = UIButton()
            // Set button image
            //button.backgroundColor = UIColor.red
            button.setImage(emptyStar, for: .normal)
            button.setImage(hightLightStar, for: .highlighted)
            button.setImage(filledStar, for: .selected)
            button.setImage(hightLightStar, for: [.highlighted, .selected])
            // Configure the button's attributes
            button.translatesAutoresizingMaskIntoConstraints = true
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            // Setup the button's Action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTap(button:)), for: .touchUpInside)
            // Add the button to the Stackview
            addArrangedSubview(button)
            // Add the new button to the ratingButtons array
            ratingButtons.append(button)
        }
    }
    
    // Update states of buttons
    private func updatButtonStates(){
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < ratingValue
        }
    }
}

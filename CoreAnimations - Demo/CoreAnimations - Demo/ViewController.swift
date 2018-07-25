//
//  ViewController.swift
//  CoreAnimations - Demo
//
//  Created by Ravi Jayaraman on 16/07/18.
//  Copyright © 2018 Ravi Jayaraman. All rights reserved.
//

import UIKit

/// Sample class for demo animations
class ViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var lblAnimatedText: UILabel!
    @IBOutlet weak var lblLightGray: UILabel!
    @IBOutlet weak var lblOffWhite: UILabel!
    @IBOutlet weak var lblLightGreen: UILabel!
    
    //MARK: - Constants
    let str = "Hello Ravi"
    
    //MARK: - Variables
    var bIsCircleAnimating: Bool?
    
    //MARK: - View lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateCircles()
        
//        UIView.animate(withDuration: animationDuration, delay: 0.1, options: .overrideInheritedOptions, animations: {
////            self.lblAnimatedText.transform = CGAffineTransform(a: 0, b: -1, c: -1, d: -1, tx: 0, ty: 0)
//
//            self.lblAnimatedText.transform = CGAffineTransform(scaleX: 1, y: 1)
//            self.lblAnimatedText.layer.cornerRadius = self.lblAnimatedText.frame.height/2
//            self.lblAnimatedText.clipsToBounds = true
//        }, completion: { bool in
//            //Handle
//            self.lblAnimatedText.animate(newText: self.str, characterDelay: animationDuration/Double(self.str.utf16.count))
//        })
    }
}

//MARK:- Extension for defining user defined functions
extension ViewController {
    
    /// Function to random center from the given center of the circles within the view bounds for X
    func getRandomCenterX() -> CGFloat {
        let centerX = arc4random_uniform(UInt32(self.view.frame.midX)) + UInt32(self.lblAnimatedText.frame.width)
        return CGFloat(centerX)
    }
    
    /// Function to random center from the given center of the circles within the view bounds for Y
    func getRandomCenterY() -> CGFloat {
        let centerY = arc4random_uniform(UInt32(self.view.frame.midY)) + UInt32(self.lblAnimatedText.frame.height)
        return CGFloat(centerY)
    }
    
    /// Function to be called when circles need animation
    func animateCircles(animate: Bool = true) {
        
        bIsCircleAnimating = animate    //Set the animated content current called
        
        if animate {
            let animationDuration = 0.5
            self.lblAnimatedText.layer.cornerRadius = self.lblAnimatedText.frame.height/2
            self.lblAnimatedText.clipsToBounds = true
            self.lblOffWhite.layer.cornerRadius = self.lblOffWhite.frame.height/2
            self.lblOffWhite.clipsToBounds = true
            self.lblLightGray.layer.cornerRadius = self.lblLightGray.frame.height/2
            self.lblLightGray.clipsToBounds = true
            self.lblLightGreen.layer.cornerRadius = self.lblLightGreen.frame.height/2
            self.lblLightGreen.clipsToBounds = true
            self.lblAnimatedText.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.lblOffWhite.transform = self.lblAnimatedText.transform
            self.lblLightGray.transform = self.lblAnimatedText.transform
            self.lblLightGreen.transform = self.lblAnimatedText.transform
            UIView.animate(withDuration: animationDuration, delay: 0.1, options: [.repeat,.autoreverse,.allowUserInteraction], animations: {
                self.lblAnimatedText.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.lblOffWhite.transform = self.lblAnimatedText.transform
                self.lblLightGray.transform = self.lblAnimatedText.transform
                self.lblLightGreen.transform = self.lblAnimatedText.transform
            }, completion: { bool in })
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureActivated(_:)))
            self.lblLightGreen.addGestureRecognizer(tapGesture)
            self.lblLightGreen.isUserInteractionEnabled = true
        }
        else {
            self.lblLightGreen.layer.removeAllAnimations()
            self.lblLightGray.layer.removeAllAnimations()
            self.lblOffWhite.layer.removeAllAnimations()
            self.lblAnimatedText.layer.removeAllAnimations()
        }
    }
}

//MARK: - Extension for ViewController with all actions which are user defined
extension ViewController {
    
    /// Objective C deprecated fallback function to be access by both Swift and Obj-C on tap
    ///
    /// - Parameter gesture: UITapGEsture recognizer object
    @objc func tapGestureActivated(_ gesture: UITapGestureRecognizer) {
        
        //Remove animations
        animateCircles(animate: false)
        
        //Recenter the circles
        self.lblAnimatedText.center = CGPoint(x: getRandomCenterX(), y: getRandomCenterY())
        self.lblOffWhite.center = self.lblAnimatedText.center
        self.lblLightGray.center = self.lblAnimatedText.center
        self.lblLightGreen.center = self.lblAnimatedText.center
        
        //Animate circles
        animateCircles()
    }
}

//MARK: - Extension for UILabel
extension UILabel {
    
    /// UILabel extension function to display a text to label character by character
    ///
    /// - Parameters:
    ///   - text: Text to set to label
    ///   - characterDelay: Delay for the characters in between
    func animate(text: String, characterDelay: TimeInterval) {
        
        DispatchQueue.main.async {
            
            self.text = ""
            
            for (index, character) in text.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
    
}

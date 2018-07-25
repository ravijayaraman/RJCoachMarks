//
//  CoachMarkControlVC.swift
//  CoreAnimations - Demo
//
//  Created by Ravi Jayaraman on 18/07/18.
//  Copyright © 2018 Ravi Jayaraman. All rights reserved.
//

import UIKit
import QuartzCore

/// Class which is used to display the coach marks on the screen with an overlay context
class CoachMarkControlVC: UIViewController {

    @IBOutlet weak var txtViwDescription: UITextView!
    @IBOutlet weak var lblInformation: UILabel!
    @IBOutlet weak var lblIcon: UILabel!
    
    //MARK: - Variables
    var animatedDuration:Double = 1
    
    //MARK: - View lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblIcon.layer.cornerRadius = lblIcon.frame.height/2
        lblInformation.layer.cornerRadius = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Show overlay
        showOverlayLayer { (bool) in
            if bool {
                //Perfome further actions after completion has been done for the overlay
            }
        }
    }
}

//MARK: - Extension for user defined functions
extension CoachMarkControlVC {
    
    /// Function which is used to display the black overlay over the screen
    ///
    /// - Parameter completion: animations for overlay is completed
    func showOverlayLayer(completion:@escaping (_ bool:Bool)->Void) {
        
        let view1 = MyCustomView(frame: self.view.bounds)
        view1.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        self.view.backgroundColor = .orange
        view1.alpha = 0
        view1.configureCoachMarks(views: configureCoachMarks(views: [(txtViwDescription, ""),(lblInformation, ""),(lblIcon, "")]))
        self.view.addSubview(view1)
        UIView.animate(withDuration: animatedDuration, animations: {
            view1.alpha = 1
        }, completion: { (bool) in
            //Handle the completion for this animation
            completion(true)
        })
    }
    
    /// Function which generates the points for the views in the heirarchy
    ///
    /// - Parameter views: Views for which need to process
    /// - Returns: Array of CGPoints
    func configureCoachMarks(views: [(UIView,String)]) -> [(CGPoint,CGPath,String,UIView)] {
        
        //Initialise the value to be generated and stored in
        var arrPoints = [(CGPoint,CGPath,String,UIView)]()
        
        //Process the views serially
        for viw in views {
            
            //Handle the point from the view
            guard let point = viw.0.center as CGPoint?, let path = viw.0.layer.cornerRadius > 0 ? UIBezierPath(roundedRect: viw.0.frame, cornerRadius: viw.0.layer.cornerRadius) : UIBezierPath(rect: viw.0.frame) as UIBezierPath? else {
                continue
            }
            
            //Appead the point into the array
            arrPoints.append((point,path.cgPath,viw.1,viw.0))
        }
        
        //return the processed data
        return arrPoints
    }
}

class MyCustomView :UIView{
    
    var objects:[(CGPoint,CGPath,String,UIView)]?
    
    //Write your code in drawRect
    override func draw(_ rect: CGRect) {

        if let centerPoints = objects {
            isHidden = false
            for center in centerPoints {
                // Get current graphics content
                let context = UIGraphicsGetCurrentContext()
                
                // Shadow Declarations
                let shadow = UIColor.white
                let shadowOffset = CGSize(width: 1, height: 1)
                let shadowBlurRadius: CGFloat = 5
                
                // Bezier Drawing
                let path = UIBezierPath()
                path.cgPath = center.1
                
                if context != nil {
                    context!.saveGState()
                    context!.setShadow(offset: shadowOffset, blur: shadowBlurRadius, color: shadow.cgColor)
                    path.fill(with: .clear, alpha: 1)
                    context!.restoreGState()
                }
            }
        }
        else {
            isHidden = true
        }
    }
    
    /// Function to activate and deactivate the glow for views
    ///
    /// - Parameter bool: Activate/Deactivate
    private func activateCoachMarks(bool:Bool = true) {
        
        if let entity = objects {
            
            //Check the activated status
            if bool {
                
                for obj in entity {
                    if obj.3.layer.cornerRadius > 0 {
                        obj.3.clipsToBounds = true
                    }
                    else {
                        obj.3.clipsToBounds = false
                    }
                }
            }
            else {
                
            }
        }
    }
    
    func configureCoachMarks(views:[(CGPoint,CGPath,String,UIView)]) {
        self.objects = views
        self.draw(self.bounds)
        self.activateCoachMarks()
    }
}

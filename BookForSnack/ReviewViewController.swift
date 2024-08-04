//
//  ReviewViewController.swift
//  BookForSnack
//
//  Created by WORK on 5/14/17.
//  Copyright © 2017 WORK. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var closeButtonView: UIButton!
    
    @IBOutlet var rateButtons: [UIButton]!
    
    
    var image: Data?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set background image
        if let image = image {
            backgroundImageView.image = UIImage(data: image)
        }
        
        
        /*
            Add blur effect to the backround image
        */
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        // End of definition
        
        
        // Animations
        let animationZoom = CGAffineTransform(scaleX: 0, y: 0)
        let animationSlide = CGAffineTransform.init(translationX: 0, y: -1000)

        
        //Add animation with zoom
        //containerView.transform = animationZoom
        
        // Add animation with slide
        //containerView.transform = animationSlide
        
        // Combined animations
        let combinedAnimation = animationZoom.concatenating(animationSlide)
        containerView.transform = combinedAnimation
        
        // Close button animation
        let animationSlide2 = CGAffineTransform.init(translationX: 1000, y: 0)
        closeButtonView.transform = animationSlide2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //Add animation from small to big
        if true {
            UIView.animate(withDuration: 0.3) {
                self.containerView.transform = CGAffineTransform.identity
            }
        }
        
        //Spring animation
        if true {
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                
                /*
                 The method should look familiar to you, but it adds the and parameters. Damping takes a value from 0 to 1, and controls how much resistance the spring has when it approaches the end state of an animation. If you
                 want to increase oscillation, set to a lower value. The property specifies the initial spring velocity.
                */
            
                self.containerView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
        // Close button animation
        UIView.animate(withDuration: 0.5) {
            self.closeButtonView.transform = CGAffineTransform.identity // we use identity to reset back to normal
        }
        
        newAnimation()
    }
    
    /* You may have a question about . Why do you implement the animation in this method instead of ? I have briefly explained the view controller life cycle in earlier chapters. The method is called when a view is first loaded, but the view hasn't displayed on the screen. If we implement the animation in this method, the animation may start too early and probably finish even before the view appears on the screen. The method, on the other hand, is automatically called after by iOS when the view is about to appear on the screen. It is more suitable for us to render the animation. This is why we write the code in rather than .
    */
    func newAnimation() {
        // We start with the initial state
        
        // First invisible
        for rateButton in rateButtons {
            rateButton.alpha = 0 // the order of the buttons are the order from when added the connection from the storyboard
        }
        
        // We use the animation
        if (false) {
            UIView.animate(withDuration: 2.0, animations: {
                /*
                 The code is very straightforward. We call the method to animate the change of the alpha value. In the body of the closure, you just need to specify the end state (i.e. alpha = 1.0). The API will automatically compute the animation for you. The duration parameter specifies the duration of the animation. In this example, the animation will complete in 2 seconds.
                 */
                for rateButton in self.rateButtons {
                    rateButton.alpha = 1.0
                }
            })
        } else {
            UIView.animate(withDuration: 4.0, delay: 2.0, options: [], animations: {
                // First it waits the delay and after that it starts
                
                for rateButton in self.rateButtons {
                    rateButton.alpha = 1.0
                }
            }, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

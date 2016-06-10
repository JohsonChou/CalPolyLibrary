//
//  NewsViewController.swift
//  Library
//
//  Created by Johnson Zhou on 5/27/16.
//  Copyright © 2016 Cal Poly SLO. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    let imageStrings = ["image1.jpg", "image2.jpg", "image3.jpg", "image4.jpg", "image5.jpg", "image6.jpg"]
    var slider:TNImageSliderViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if slider != nil {
            var images:[UIImage] = []
            for x in imageStrings {
                images.append(UIImage(named: x)!)
            }
            slider!.images = images
            slider!.options.autoSlideIntervalInSeconds = 5
            slider!.options.backgroundColor = UIColor(netHex: 0x4B4342)
            slider?.options.shouldStartFromBeginning = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "set_imageSlider" {
            let destination = segue.destinationViewController as! TNImageSliderViewController
            slider = destination
        }
    }
    

}

//
//  VideoViewController.swift
//  BookForSnack
//
//  Created by WORK on 06/02/2018.
//  Copyright © 2018 WORK. All rights reserved.
//

import UIKit
import BMPlayer

import AVFoundation // this you need for the `AVPlayer`
import AVKit // this is for the `AVPlayerViewController`

class VideoViewController: UIViewController {

    @IBOutlet weak var player: BMCustomPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //playVideo()
        fullScreenPlay()
    }
    
    func playVideo() {
        // Playing the video
        player.backBlock = { [unowned self] (isFullScreen) in
            if isFullScreen == true {
                return
            }
            let _ = self.navigationController?.popViewController(animated: true)
        }
        
        let asset = BMPlayerResource(url: URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!,
                                     name: "Demo",
                                     cover: nil,
                                     subtitle: nil)
        player.setVideo(resource: asset)
    }
    
    func fullScreenPlay() {
//        var viewController = AVPlayerViewController()
//        let videoURL = "http://you.videourl.com"
//        
//        let url: URL = URL(string: videoURL)!
//        
//        if let player = AVPlayer(url: url) as? AVPlayer {
//            viewController = player
//        }
    }
}

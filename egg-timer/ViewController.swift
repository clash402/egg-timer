//
//  ViewController.swift
//  egg-timer
//
//  Created by Josh Courtney on 4/24/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    let eggTimes = ["Soft": 300, "Medium": 420, "Hard": 720]
    
    var timer: Timer?
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressView.progress = 0
    }
    
    @IBAction func eggBtnTapped(_ sender: UIButton) {
        timer?.invalidate()
        titleLabel.text = "Counting down..."
        progressView.progress = 0
        
        guard let hardness = sender.titleLabel?.text else { return }
        guard let totalTime = eggTimes[hardness] else { return }
        
        var timeElapsed = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {timer in
            if timeElapsed < totalTime {
                timeElapsed += 1
                self.progressView.progress = Float(timeElapsed) / Float(totalTime)
            } else {
                timer.invalidate()
                self.titleLabel.text = "DONE"
                self.playSound()
            }
        }
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url)

            guard let player = player else { return }

            player.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

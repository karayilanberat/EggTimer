//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    let eggTimes = ["Soft": 5, "Medium": 7, "Hard": 12]
    
    var invalidateCounter = false
    var isTimerWorking = false
    
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        if let hardness = sender.currentTitle, let selectedTime = eggTimes[hardness] {
            startCountdown(selectedTime: selectedTime)
        }
        
        // if the timer is already working then invalidate previous timer
        if isTimerWorking == true {
            invalidateCounter = true
        }
        
        // set the timer working
        isTimerWorking = true
    }
    
    func startCountdown(selectedTime: Int) {
        
        let totalTime = selectedTime * 60
        var countdownSeconds = totalTime
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            
            countdownSeconds -= 1
            //print(countdownSeconds)
            
            self.progressBar.progress = Float(Float(totalTime - countdownSeconds) / Float(totalTime))
            
            self.timeLabel.text = "\(countdownSeconds)"
            
            if countdownSeconds == 0 {
                timer.invalidate() // Stop the timer when countdown reaches 0
                self.isTimerWorking = false
                self.timeLabel.text = "DONE"
                self.playSound()
            }
            if self.invalidateCounter {
                timer.invalidate()
                self.invalidateCounter = false
            }
            
        }
    }
    
    func playSound() {
        
        guard let soundURL = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else {
            print("Sound file not found")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Error loading sound file: \(error.localizedDescription)")
        }
        
        audioPlayer?.play()
        
    }
}

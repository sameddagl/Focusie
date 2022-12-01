//
//  AudioManager.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import Foundation
import AVFoundation

final class AudioManager: NSObject {
    
    var player: AVAudioPlayer?
    var bgPlayer: AVAudioPlayer?
    
    var currentTime: TimeInterval?

    func playOneTimeSound() {
        guard let path = Bundle.main.path(forResource: "break2", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            
            guard let player = player else { return }
            player.delegate = self
            
            if let bgPlayer = bgPlayer, bgPlayer.isPlaying {
                bgPlayer.setVolume(0.1, fadeDuration: 1)
            }
            player.play()

            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playBackgroundSound(with sound: BGSound) {
        if sound.rawValue.isEmpty { return }
        
        guard let path = Bundle.main.path(forResource: sound.rawValue, ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            bgPlayer = try AVAudioPlayer(contentsOf: url)
                        
            guard let bgPlayer = bgPlayer else { return }
            
            bgPlayer.numberOfLoops = -1
            bgPlayer.volume = 0.7
            
            if let currentTime = currentTime {
                bgPlayer.play(atTime: bgPlayer.deviceCurrentTime - currentTime)
            }
            else {
                bgPlayer.play()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pausePlayingBackgroundSound() {
        currentTime = bgPlayer?.currentTime
        bgPlayer?.pause()
    }
    
    func endPlayingBackgroundSound() {
        currentTime = 0
        bgPlayer?.pause()
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let bgPlayer = bgPlayer {
            bgPlayer.setVolume(0.7, fadeDuration: 1)
        }
    }
}

//
//  AudioManager.swift
//  Focusie
//
//  Created by Samed Dağlı on 1.12.2022.
//

import Foundation
import AVFoundation

protocol AudioManagerProtocol {
    func playOneTimeSound()
    func stopPlayingOneTimeSound()
    func playBackgroundSound(with sound: BGSounds)
    func pauseBackgroundSound()
    func endPlayingBackgroundSound()
}

final class AudioManager: NSObject, AudioManagerProtocol {
    //MARK: - Properties
    var player: AVAudioPlayer?
    var bgPlayer: AVAudioPlayer?
    
    var currentTime: TimeInterval?

    //MARK: - Play break sounds
    func playOneTimeSound() {
        player = nil
        
        guard let path = Bundle.main.path(forResource: "break2", ofType:"mp3") else { return }
        let url = URL(fileURLWithPath: path)

        do {
            try AVAudioSession.sharedInstance().setCategory(.soloAmbient, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            
            guard let player = player else { return }
            player.delegate = self
            
            if let bgPlayer = bgPlayer, bgPlayer.isPlaying {
                bgPlayer.setVolume(0.1, fadeDuration: 1)
            }
            
            player.play()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopPlayingOneTimeSound() {
        player?.stop()
        player = nil
    }
    
    //MARK: - Play BG Sounds
    func playBackgroundSound(with sound: BGSounds) {
        bgPlayer = nil
                
        guard let path = Bundle.main.path(forResource: sound.rawValue, ofType:"mp3") else { return }
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
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pauseBackgroundSound() {
        currentTime = bgPlayer?.currentTime
        bgPlayer?.pause()
        bgPlayer = nil
    }
    
    func endPlayingBackgroundSound() {
        currentTime = 0
        bgPlayer?.stop()
        bgPlayer = nil
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let bgPlayer = bgPlayer {
            bgPlayer.setVolume(0.7, fadeDuration: 1)
        }
    }
}

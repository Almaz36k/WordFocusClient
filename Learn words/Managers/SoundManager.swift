//
//  SoundManager.swift
//  Learn words
//
//  Created by MacBook on 19.02.2020.
//  Copyright © 2020 MacPro. All rights reserved.
//

import UIKit
import AVFoundation

class SoundManager: NSObject {
 
    static let shared = SoundManager()
    
    enum SoundType {
        case goodAnswer
        case badAnswer
        case waitingAnswer
        case clock
        case helloNewPunter
        
        var sound: String {
            switch self {
            case .goodAnswer: return "good-answer-mp3"
            case .badAnswer: return "bad-answer-mp3"
            case .waitingAnswer: return "waiting-answer-mp3"
            case .clock: return "friend-clock"
            case .helloNewPunter: return "hello-new-punter"
            }
        }
    }
    
    private var player: AVAudioPlayer?
    private var atTime: TimeInterval = TimeInterval.zero

    func playGood() {
        checkAndStop()
        playSound(.goodAnswer)
        player?.play()
    }
    
    func playBad() {
        checkAndStop()
        playSound(.badAnswer)
        player?.play()
    }
    
    func playWaiting() {
        checkAndStop()
        playSound(.waitingAnswer)
        player?.play()
    }
    
    func playNewPunter() {
        checkAndStop()
        playSound(.helloNewPunter)
        player?.play()
    }
    
    func playClock() {
        checkAndStop()
        playSound(.clock)   
        player?.play()
    }
    
    private func checkAndStop() {
        guard let player = player else { return }
        if player.isPlaying { player.stop() }
    }
    
    func setTime(_ atTime: TimeInterval){
        self.atTime = atTime
    }
    
    func stop(){
        player?.stop()
    }
    
    private func playSound(_ nameSund: SoundType){
        if let asset = NSDataAsset(name: nameSund.sound){
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(data: asset.data, fileTypeHint: "mp3")
                player?.delegate = self
            }  catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

extension SoundManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        atTime = TimeInterval.zero
    }
}

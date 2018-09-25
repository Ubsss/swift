//
//  ViewController.swift
//  scribeSpeechToText
//
//  Created by Uchechukwu Uboh on 8/25/18.
//  Copyright © 2018 Uchechukwu Uboh. All rights reserved.
//  Source: https://www.youtube.com/watch?v=2gs5QTRC8Yk for UI and initial audio scribing



import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate{
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var transcriptionTextField: UITextView!
    @IBOutlet weak var CMDWindow: UITextView!
    
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()
        activitySpinner.stopAnimating()
        activitySpinner.isHidden = true
        transcriptionInterpretation()
    }
    
    func requestSpeechAuth(){
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized{
                if let path = Bundle.main.url(forResource: "testRecording", withExtension: "m4a"){
                    do {
                        let sound = try AVAudioPlayer(contentsOf: path)
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        sound.play()
                    } catch{
                        print("Error!")
                    }
                    
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    recognizer?.recognitionTask(with: request) {(result, error) in
                        if let error = error {
                            print("There was an error: \(error)")
                        } else {
                            self.transcriptionTextField.text = (result?.bestTranscription.formattedString)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        requestSpeechAuth()
    }
}

extension ViewController{
    func transcriptionInterpretation() {
    
        self.CMDWindow.text = "Your command will show here"
        if self.transcriptionTextField.text !=  " " {
            
            let interpretation = String(self.transcriptionTextField.text!)
                if interpretation.contains("test") && interpretation.contains("recording"){
                    self.CMDWindow.text = "Yes, this is a test!"
                } else {
                    self.CMDWindow.text = "No instructions where found in your recording!"
                }

        } else {
            self.CMDWindow.text = "Please repeat a valid comand"
        }
    }
}

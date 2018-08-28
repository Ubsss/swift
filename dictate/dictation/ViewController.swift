//
//  ViewController.swift
//  dictation
//
//  Created by Uchechukwu Uboh on 8/25/18.
//  Copyright © 2018 Uchechukwu Uboh. All rights reserved.
//  From: https://www.youtube.com/watch?v=OtlmgmJftiE

import UIKit
import Speech

public class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dictatebutton: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private let audioEngine = AVAudioEngine()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dictatebutton.isEnabled = false
    }

    override public func viewDidAppear(animated: Bool) {
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization {autherizationStatus
            
            OperationQueue.main.addOperation {
                switch autherizationStatus {
                case .authorized:
                    self.dictatebutton.isEnabled = true
                    self.dictatebutton.setTitle("User gave permission for speech recognition", for: .disabled)
                case .denied:
                    self.dictatebutton.isEnabled = false
                    self.dictatebutton.setTitle("User denied access to speech recognition.", for: .disabled)
                case .restricted:
                    self.dictatebutton.isEnabled = false
                    self.dictatebutton.setTitle("Speech recognition restricted on device.", for: .disabled)
                case .notDetermined:
                    self.dictatebutton.isEnabled = false
                    self.dictatebutton.setTitle("Speech recognition not yet authorized.", for: .disabled)
                }
            }
        }
    }

    private func startRecording() throws{
        if let recognitionTask = recognitionTask{
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {fatalError("Audio engine has no input node")}
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object")}
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in var isFinal = false
            
            if let result = result {
                self.textView.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.dictatebutton.isEnabled = true
                self.dictatebutton.setTitle("Start Speaking", for: [])
                
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {(buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
            }
            audioEngine.prepare()
        
            try audioEngine.start()
        
            textView.text = "I'm listening."
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available{
            dictatebutton.isEnabled = true
            dictatebutton.setTitle("Start Recording", for: [])
        } else {
            dictatebutton.isEnabled = false
            dictatebutton.setTitle("Recogniton not available.", for: .disabled)
    
        }
    }
        
    
    @IBAction func dictateAction() {
        if audioEngine.isRunning{
            audioEngine.stop()
            recognitionRequest?.endAudio()
            dictatebutton.isEnabled=false
            dictatebutton.setTitle("Ending... ", for: .disabled)
        }else{
            try! startRecording()
            dictatebutton.setTitle("Stop Recording", for: [])
        }
    }
    
}

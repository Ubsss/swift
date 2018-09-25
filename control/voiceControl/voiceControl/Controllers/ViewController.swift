//
//  ViewController.swift
//  voiceControl
//
//  Created by Uchechukwu Uboh on 9/2/18.
//  Copyright © 2018 Uchechukwu Uboh. All rights reserved.
//

//To add:
// add a window that allows the user to recieve information from bot
// add button to rerecord instruction 

import UIKit
import Speech
import AVFoundation

class ViewController: UIViewController {
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var mostRecentlyProcessedSegmentDuration: TimeInterval = 0
    
    
    
    @IBOutlet weak var transcriptionTextField: UITextView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordButtonLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func recordCMDButton(_ sender: UIButton) {
        sender.tag += 1
        
        if sender.tag > 2 {sender.tag = 0}
        
        switch sender.tag {
        case 1:
           // requestAuth()
            recordButtonLabel.text = "Stop Recording CMD"
        case 2:
           // stopRecording()
            recordButtonLabel.text = "Record CMD"
        default:
            print("This is the default option")
        }
    }
    
    func requestAuth () {
        SFSpeechRecognizer.requestAuthorization {
                [unowned self] (authStatus) in
                switch authStatus {
                    case .authorized:
                        do {
                            try self.startRecording()
                        } catch let error {
                            print("There was a problem starting recording: \(error.localizedDescription)")
                        }
                    case .denied:
                            print("Speech recognition authorization denied")
                    case .restricted:
                        print("Not available on this device")
                    case .notDetermined:
                        print("Not determined")
                }
            }
        }
}

extension ViewController {
    fileprivate func startRecording() throws {
        mostRecentlyProcessedSegmentDuration = 0
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0,
                        bufferSize: 1024,
                        format: recordingFormat ) { [unowned self] (buffer, _)  in self.request.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request){
            [unowned self]
            (result, _) in
            if let transcription = result?.bestTranscription{
                self.transcriptionTextField.text = transcription.formattedString
            }
        }
    }
    
    fileprivate func stopRecording() {
        audioEngine.stop()
        request.endAudio()
        recognitionTask?.cancel()
    }
    
    fileprivate func updateUIWithTranscription(_ transcription: SFTranscription){
        self.updateUIWithTranscription(transcription)
        
        if let lastSegment = transcription.segments.last,
            lastSegment.duration > mostRecentlyProcessedSegmentDuration {
            mostRecentlyProcessedSegmentDuration = lastSegment.duration
            //go and match the word with the face *******
        }
    }
}



extension ViewController{
    fileprivate func initializeCMDInterpritaion() {
        // This will interprete the string created from recording
    }
}

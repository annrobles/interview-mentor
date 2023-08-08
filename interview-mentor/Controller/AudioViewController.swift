//
//  AudioViewController.swift
//  interview-mentor
//
//  Created by Ann Robles on 8/7/23.
//

import AVFoundation
import UIKit

extension QuestionViewController {

    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        recordAudioButton.setImage(UIImage(systemName: "mic"), for: .normal)
        recordAudioButton.setTitle("Tap to record answer", for: .normal)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
        
        audioPath.append(soundURL!)
        newAudioPath.append(soundURL!)
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if error != nil {
            let errorAlert = UIAlertController(title: "Recording Audio", message: error!.localizedDescription, preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(errorAlert, animated: true)
        }
    }
      
    func finishRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
    }
    

    func startRecording() {
        
        let directoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in:
                    FileManager.SearchPathDomainMask.userDomainMask).first
                
        let audioFileName = UUID().uuidString + ".m4a"
        let audioFileURL = directoryURL!.appendingPathComponent(audioFileName)
        soundURL = audioFileName

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()

            recordAudioButton.setImage(UIImage(systemName: "stop.circle.fill"), for: .normal)
            recordAudioButton.setTitle("Stop recording", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func loadRecordingFuntionality() {

        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordAudioButton.isEnabled = true
                    } else {
                        self.recordAudioButton.isEnabled = false
                    }
                }
            }
        } catch {
            print("An error had ocurred configuring the Audio Rec functionality \(error.localizedDescription)")
        }
    }

    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
}

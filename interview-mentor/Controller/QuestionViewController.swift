//
//  QuestionViewController.swift
//  interview-mentor
//
//  Created by Ann Robles on 7/4/23.
//

import UIKit
import Speech
import AVFoundation

class QuestionViewController: UIViewController, AVSpeechSynthesizerDelegate, AVAudioPlayerDelegate,  AVAudioRecorderDelegate {

    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var micIconOutlet: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var responseTextView: UILabel!
    
    var questionNum = 0
    var currentQuestion = Question(title: "", id: -1)
    var questions = [Question]()
    
    var isMicOn = false
    let synthesizer = AVSpeechSynthesizer()
    
    //to delete
    var soundURL: String?
    var audioPath: [String] = []
    var newAudioPath: [String] = []
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder?
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    var responseText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestSpeechAuthorization()
        
        synthesizer.delegate = self
        
        questionNumber.text = "\(currentQuestion.id).) "
        questionLabel.text = "\(currentQuestion.title)"
        questionLabel.numberOfLines = 0

        self.micClicked(self.micIconOutlet)
    }

    @IBAction func micClicked(_ sender: UIButton) {

        if (questionLabel.text?.isEmpty)! { return }
                
        if let speechText = questionLabel.text {
            
            isMicOn = !isMicOn

            if isMicOn {
                let speech = AVSpeechUtterance(string: speechText)
                synthesizer.speak(speech)
                //micIconOutlet.setImage(UIImage(named: "Robot-OutlineX"), for: .normal)
            } else {
                //micIconOutlet.setImage(UIImage(named: "Robot-Outline"), for: .normal)
                if synthesizer.isSpeaking {
                    synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
                }
            }
        }
    }
    
    @IBAction func nextClicked(_ sender: UIButton) {
        if let questionViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as? QuestionViewController {
            self.navigationController?.pushViewController(questionViewController, animated: true)
            
            questionViewController.questions = self.questions
            questionViewController.currentQuestion = self.questions[self.questionNum]
            questionViewController.questionNum = self.questionNum + 1
            
        }
    }
    
    @IBAction func recordAnswerClicked(_ sender: UIButton) {
        //recordTapped()
        
        if isRecording == true {
            cancelRecording()
            isRecording = false
            self.recordAudioButton.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        } else {
            self.recordAudioButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            self.recordAndRecognizeSpeech()
            isRecording = true
        }
    }
    
    func cancelRecording() {
        recognitionTask?.finish()
        recognitionTask = nil
        
        // stop audio
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        self.responseTextView.text = self.responseText
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {

       //robotButtonOutlet.setImage(UIImage(named: "Robot-Outline"), for: .normal)
       isMicOn = false
    }
           

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
    }


    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
    }
       
    override func viewDidDisappear(_ animated: Bool) {
     
       //robotButtonOutlet.setImage(UIImage(named: "Robot-Outline"), for: .normal )
       if synthesizer.isSpeaking {
           synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
       }
    }
    
    func recordAndRecognizeSpeech() {
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            self.sendAlert(title: "Speech Recognizer Error", message: "There has been an audio engine error.")
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not supported for your current locale.")
            return
        }
        if !myRecognizer.isAvailable {
            self.sendAlert(title: "Speech Recognizer Error", message: "Speech recognition is not currently available. Check back at a later time.")
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
                var lastString: String = ""
                for segment in result.bestTranscription.segments {
                    let indexTo = bestString.index(bestString.startIndex, offsetBy: segment.substringRange.location)
                    lastString = String(bestString[indexTo...])
                }
                print(result)
                self.responseText = bestString
            } else if let error = error {
                self.sendAlert(title: "Speech Recognizer Error", message: "There has been a speech recognition error.")
                print(error)
            }
        })
    }
    
//MARK: - Check Authorization Status
func requestSpeechAuthorization() {
    SFSpeechRecognizer.requestAuthorization { authStatus in
        OperationQueue.main.addOperation {
            switch authStatus {
            case .authorized:
                self.recordAudioButton.isEnabled = true
            case .denied:
                self.recordAudioButton.isEnabled = false
                self.responseTextView.text = "User denied access to speech recognition"
            case .restricted:
                self.recordAudioButton.isEnabled = false
                self.responseTextView.text = "Speech recognition restricted on this device"
            case .notDetermined:
                self.recordAudioButton.isEnabled = false
                self.responseTextView.text = "Speech recognition not yet authorized"
            @unknown default:
                return
            }
        }
    }
}
    //MARK: - Alert
        func sendAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
}

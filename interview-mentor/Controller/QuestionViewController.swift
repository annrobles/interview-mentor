//
//  QuestionViewController.swift
//  interview-mentor
//
//  Created by Ann Robles on 7/4/23.
//

import UIKit
import AVFoundation

class QuestionViewController: UIViewController, AVSpeechSynthesizerDelegate {

    @IBOutlet weak var questionNumber: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var micIconOutlet: UIButton!
    
    var questionNum = 0
    var currentQuestion = Question(title: "", id: -1)
    var questions = [Question]()
    var isMicOn = false
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            print(#function, isMicOn)
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
}

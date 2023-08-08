//
//  QuestionViewController.swift
//  interview-mentor
//
//  Created by Ann Robles on 7/4/23.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    
    var questionNum = 0
    var currentQuestion = Question(title: "", id: -1)
    var questions = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = "\(currentQuestion.id).) \(currentQuestion.title) "
        questionLabel.numberOfLines = 0

    }

    @IBAction func nextClicked(_ sender: UIButton) {
        if let questionViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as? QuestionViewController {
            self.navigationController?.pushViewController(questionViewController, animated: true)
            
            questionViewController.questions = self.questions
            questionViewController.currentQuestion = self.questions[self.questionNum]
            questionViewController.questionNum = self.questionNum + 1
            
        }
    }
}

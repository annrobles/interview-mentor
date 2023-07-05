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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLabel.text = "\(currentQuestion.id).) \(currentQuestion.title) "

    }

}

//
//  ViewController.swift
//  interview-mentor
//
//  Created by Ann Robles on 6/14/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let question = Question(title: "", id: -1)
    var questions = [Question]()
    
    override func viewDidLoad() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<QuestionEntity>(entityName: "QuestionEntity")

        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let fetchedQuestions = try managedContext.fetch(fetchRequest)
            
            questions.removeAll()
            
            for question in fetchedQuestions {
                if let questionTitle = question.title {
                    self.questions.append(Question(title: questionTitle, id: Int(question.id) ))
                }
            }
        } catch {
            print("Failed to fetch questions: \(error.localizedDescription)")
        }


        
        super.viewDidLoad()
    }


    @IBAction func startClicked(_ sender: Any) {
        if let questionViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestionViewController") as? QuestionViewController {
            self.navigationController?.pushViewController(questionViewController, animated: true)
            
            questionViewController.questionNum = 1
            questionViewController.currentQuestion = questions[0]
        }
    }
}


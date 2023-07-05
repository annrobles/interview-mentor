//
//  ViewController.swift
//  interview-mentor
//
//  Created by Ann Robles on 6/14/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    
    override func viewDidLoad() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<QuestionEntity>(entityName: "QuestionEntity")

        do {
            let questions = try managedContext.fetch(fetchRequest)
            
            for question in questions {
                if let questionTitle = question.title {
                    print("question \(questionTitle)")
                }
            }

            
        } catch {
            print("Failed to fetch questions: \(error.localizedDescription)")
        }

        
        super.viewDidLoad()
    }


}


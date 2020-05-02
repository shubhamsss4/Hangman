//
//  ViewController.swift
//  Hangman
//
//  Created by Shah, Shubham on 28/03/20.
//  Copyright © 2020 Shubham shah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var wordLabel: UILabel!
    
    @IBAction func guessButtonTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Enter character", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self,weak ac] _ in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac,animated: true)
    }
    
    func submit(_ answer: String) {
        let loweranswer = answer.lowercased()
        if isPossible(word: loweranswer) {
            if isOriginal(word: loweranswer) {
                if !usedWords.contains(loweranswer) && wordToBeGuessed.contains(loweranswer) {
                     self.processLetterEntered(word: loweranswer)
                }
                else {
                    numberOfTries -= 1
                    
                    if numberOfTries == 0 {
                        showError(errorTitle: "Game Over", errorMessage: "Please try again")
                        self.gameStart()
                    }
                    else {
                        showError(errorTitle: "Character not present", errorMessage: "Number of tries \(numberOfTries)")
                    }
                }
            }
            else {
                showError(errorTitle: "Character already used", errorMessage: "Be more original!")
            }
        }
        else {
            showError(errorTitle: "Enter Single Character", errorMessage: "Enter Single Character as Input and not \(answer)")
        }
    }
    
    func isPossible(word: String) -> Bool {
        guard word.count == 1 else { return false }
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    func processLetterEntered(word: String) {
        
        var promptWord = ""
        
        usedWords.append(word)

        for letter in wordToBeGuessed {
            let strLetter = String(letter)

            if usedWords.contains(strLetter) {
                promptWord += strLetter
            } else {
                promptWord += "?"
            }
        }
        print(promptWord)
        wordLabel.text = promptWord
        if !promptWord.contains("?") {
            showError(errorTitle: "Word correctly guessed", errorMessage: "You guessed the word correctly :: \(promptWord)")
            self.gameStart()
        }

    }
    
    @objc func gameStart() {
        
        wordToBeGuessed = allWords.randomElement() ?? ""
        wordGuessed = ""
        for _ in 0..<wordToBeGuessed.count {
            wordGuessed += "?"
        }
        
        wordLabel.text = wordGuessed
        print(wordToBeGuessed)
        
        numberOfTries = 3
        
        usedWords.removeAll(keepingCapacity: true)
        
        triesLeftLabel.text = "Tries Left :: \(numberOfTries)"
        
    }
    
    
    func showError(errorTitle: String,errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac,animated: true)
    }
    
    
    @IBOutlet var triesLeftLabel: UILabel!
    
    var allWords = [String]()
    var usedWords = [String]()
    var wordGuessed: String = ""
    var wordToBeGuessed: String = ""
    var numberOfTries = 3 {
        didSet {
             triesLeftLabel.text = "Tries Left :: \(numberOfTries)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Change Word", style: .plain, target: self, action: #selector(gameStart))
        
        // Do any additional setup after loading the view.
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: ".txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        self.gameStart()
    }


}


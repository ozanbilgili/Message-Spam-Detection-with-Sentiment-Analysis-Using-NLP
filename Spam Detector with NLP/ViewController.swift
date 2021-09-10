//
//  ViewController.swift
//  Spam Detector with NLP
//
//  Created by Ozan Bilgili on 9.09.2021.
//
// Commit test line

import UIKit
import NaturalLanguage

class ViewController: UIViewController {


    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var spamLabel: UILabel?
    @IBOutlet weak var sentimentLabel: UILabel?
    @IBAction func checkButton(_ sender: UIButton) {
        guard let message = self.messageTextView?.text else {
            return
        }
        
        detectSpam(message: message)
        detectSentiment(message: message)
    }


    private func detectSpam(message: String) {
        do {
            let spamDetector = try NLModel(mlModel: SpamAnalyzer_1().model)
            guard let prediction = spamDetector.predictedLabel(for: message) else {
                print("Failed to predict result")
                return
            }
            
            spamLabel?.text = "spam status: \(prediction == "spam" ? "SPAM" : "NOT SPAM")"
        } catch {
            fatalError("Failed to load Natural Language Model: \(error)")
        }
    }
    
    // range -1.0 (negative) to 1.0 (positive)
    private func detectSentiment(message: String) {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = message
        
        let (sentiment, _) = tagger.tag(at: message.startIndex, unit: .paragraph, scheme: .sentimentScore)
        
        // it supports 7 languages: English, French, Italian, German, Spanish, Portuguese, and simplified Chinese.
        guard let sentimentScore = sentiment?.rawValue else {
            return
        }
        
        sentimentLabel?.text = "sentiment score: \(sentimentScore)"
    }
}


//
//  ViewController.swift
//  MatchApp
//
//  Created by BURAK EKMEN on 16.05.2020.
//  Copyright © 2020 Burak Ekmen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer:Timer?
    var milliSeconds:Int = 10 * 1000
    
    var firstSelectedCardIndexPath:IndexPath?
    
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        // set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        soundPlayer.playSound(effect: .shuffle)
    }
    
    
    
    @objc func timerFired(){
        
        milliSeconds -= 1
        
        let seconds :Double = Double(milliSeconds)/1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        if milliSeconds == 0{
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            checkForGameEnd()
        }
        
    }
    
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // return number array count
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // return it
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cardCell = cell as? CardCollectionViewCell
        // TODO: configure it
        cardCell?.configureCell(card: cardsArray[indexPath.row])
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false{
            cell?.flipUp()
            
            soundPlayer.playSound(effect: .flip)
            
            if firstSelectedCardIndexPath != nil {
                isMatch(indexPath)
            }else{
                firstSelectedCardIndexPath = indexPath
            }
        }
        
    }
    
    
    func isMatch(_ secondCardIndexPath:IndexPath){
        
        let cardOne = cardsArray[firstSelectedCardIndexPath!.row]
        let cardTwo = cardsArray[secondCardIndexPath.row]
        
        let cardOneCell = collectionView.cellForItem(at: firstSelectedCardIndexPath!) as? CardCollectionViewCell
        let cardTwoCell = collectionView.cellForItem(at: secondCardIndexPath) as? CardCollectionViewCell
        
        if cardOne.imageName == cardTwo.imageName {
            
            soundPlayer.playSound(effect: .match)
            // match
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            checkForGameEnd()
        }else{
            
            soundPlayer.playSound(effect: .nomatch)
            // not match
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            cardOneCell?.flipDown()
            cardTwoCell?.flipDown()
        }
        
        firstSelectedCardIndexPath = nil
    }
    
    
    
    func checkForGameEnd(){
        
        var hasWon = true
        
        for card in cardsArray{
            if card.isMatched == false{
                hasWon = false
                break
            }
        }
        
        
        if hasWon {
            
            showAlert(title: "Tebrikler", message: "Oyunu Kazandın!")
            
        }else{
            
            if milliSeconds <= 0{
                showAlert(title: "Zaman Doldu", message: "Bir dahaki sefere kısmetse!")
            }
        }
        
    }
    
    
    
    
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Tamam", style: .default, handler: nil)
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    

}


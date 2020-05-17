//
//  CardModel.swift
//  MatchApp
//
//  Created by BURAK EKMEN on 17.05.2020.
//  Copyright © 2020 Burak Ekmen. All rights reserved.
//

import Foundation

class CardModel{
    
    func getCards() -> [Card]{
        
        var genereatedCards = [Card]()
        
        for _ in 1...8{
            
            let randomNumber = Int.random(in: 1...8)
            
            let cardOne = Card()
            let cardTwo = Card()
            
            cardOne.imageName = "card\(randomNumber)"
            cardTwo.imageName = "card\(randomNumber)"
         
            genereatedCards += [cardOne,cardTwo]
            print(randomNumber)
        }
        
        genereatedCards.shuffle()
        
        return genereatedCards
    }
}

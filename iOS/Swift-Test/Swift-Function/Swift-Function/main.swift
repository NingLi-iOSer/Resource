//
//  main.swift
//  Swift-Function
//
//  Created by Ning Li on 2019/8/12.
//  Copyright © 2019 Ning Li. All rights reserved.
//

import Foundation

enum Coin: Int {
    case SilverDollar   =   100
    case HalfDollar     =   50
    case Quarter        =   20
    case Dime           =   10
    case Nickel         =   5
    case Penny          =   1
    
    static func coninsInDescendingOrder() -> [Coin] {
        
        return [
            .SilverDollar,
            .HalfDollar,
            .Quarter,
            .Dime,
            .Nickel,
            .Penny
        ]
    }
}
func countWaysToBreakAmount(amount: Int ,coins: [Coin]) -> Int {
    
    let (coin , smallerCoins) = (coins[0],Array(coins[1 ..< coins.count]))
    if coin == .Penny {
        return 1
    }
    let coinCounts = [Int](0 ... amount/coin.rawValue)
    return coinCounts.reduce(0, { (sum, cointCount) in
        let remainingAmount = amount - (coin.rawValue * cointCount)
        return sum + countWaysToBreakAmount(amount: remainingAmount, coins: smallerCoins)
    })
}
let sum = countWaysToBreakAmount(amount: 5, coins: Coin.coninsInDescendingOrder())
print(sum)

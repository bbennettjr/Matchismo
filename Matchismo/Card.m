//
//  Card.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/15/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "Card.h"

@implementation Card
-(BOOL)isChosen{
    if (!_isChosen) _isChosen = NO;
    return _isChosen;
}

-(BOOL)isMatched{
    if (!_isMatched) _isMatched = NO;
    return _isMatched;
}

//Match two cards against eachother for a score
-(int)match:(NSArray *)otherCards{
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score += 1;
        }
    }
    return score;
}

@end

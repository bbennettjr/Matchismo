//
//  PlayingCard.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/15/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(NSString *)contents{
    NSArray *ranks = [PlayingCard validRanks];
    return [ranks[self.rank] stringByAppendingString:self.suit];
}

#pragma mark - Private API
//overriden match: method to improve the scoring for matching n playing cards
-(int)match:(NSArray *)otherCards{
    int score = 0;
    int bonus = 0;
    for (PlayingCard *card in otherCards) {
        if ([self.suit isEqualToString:card.suit]){
            score +=2;
            bonus++;
        }
        if (self.rank == card.rank){
            score +=8;
            bonus++;
        }
    }
    score = score ^(bonus);
    return score;
}

#pragma mark - Rank Setter & Getter
@synthesize rank = _rank;
-(NSUInteger)rank{
    return _rank ? _rank : 0;
}
-(void)setRank:(NSUInteger)rank{
    if ([[PlayingCard validRanks] objectAtIndex:rank]) {
        _rank = rank;
    }
}

#pragma mark - Suit Setter & Getter
@synthesize suit = _suit;
-(NSString *)suit{
    return _suit ? _suit : @"?"; //I dont understand this notation
}
-(void)setSuit:(NSString *)newSuit{
    if ([[PlayingCard validSuits] containsObject:newSuit]) {
        _suit = newSuit;
    }
}

#pragma mark - Class Methods
//returns the valid suits and ranks for any playing card
+(NSArray *)validSuits{
    return @[@"♠️",@"♣️",@"♦️",@"♥️"];
}
+(NSArray *)validRanks{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}
+(NSUInteger)maxRank{
    return [[PlayingCard validRanks] count]-1;
}
@end

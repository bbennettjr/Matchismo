//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/16/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck
//initialize a playing card deck by using addCard: a method from its super
-(instancetype)init{
    self = [super init];
    if (self) {
        for (NSString *suit in [PlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank <= [PlayingCard maxRank]; rank++) {
                PlayingCard *card = [[PlayingCard alloc]init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }
        }
    }
    return self;
}


@end

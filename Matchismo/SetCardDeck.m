//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/29/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck
-(instancetype)init{
    self = [super init];
    if (self) {
        //create the deck with each individual card, using class methods for SetCard
        for (NSString *shape in [SetCard validShapes]) {
            for (NSString *shade in [SetCard validShades]) {
                for (NSString *color in [SetCard validColors]) {
                    for (int number = 1; number <= [SetCard maxNumber]; number++) {
                        SetCard *card = [[SetCard alloc]init];
                        card.shade = shade;
                        card.color = color;
                        card.number = number;
                        card.shape = shape;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}
@end

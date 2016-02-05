//
//  MatchingGame.h
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/16/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface MatchingGame : NSObject
@property (nonatomic) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards; //of cards
@property (nonatomic, strong) NSMutableArray *chosenCards;
@property (nonatomic) NSString *status;
@property (nonatomic) NSInteger numberOfMatchingCards;
@property (nonatomic, getter=match) BOOL match;

//previously constants now properties to change in subclasses
@property (nonatomic) NSInteger matchBonus;
@property (nonatomic) NSInteger mismatchPenalty;
@property (nonatomic) NSInteger costToChoose;

-(instancetype)initWithDeck:(Deck *)deck
              andCardNumber:(NSUInteger)numberOfCards;
-(instancetype)initWithDeck:(Deck *)deck;
-(Card *)cardAtIndex:(NSUInteger)index;
-(void)chooseCardAtIndex:(NSUInteger)index;
-(void)descriptionOfFlip;

@end

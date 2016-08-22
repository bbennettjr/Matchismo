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
@property (nonatomic) NSString *descr;
@property (nonatomic) NSInteger numberOfMatchingCards;
@property (readonly, nonatomic) NSUInteger numberOfDealtCards;
@property (nonatomic, getter=match) BOOL match;
    //Status is a dictionary containing the status of each game.  Methods to get an array of the keys need to be subclassed. readonly so the listener cannot change
@property (nonatomic, strong) NSString *status;

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

    //Class methods
    //Subclass this method to get the key values for the dictionary of status values
+(NSArray *)statusValues;

@end

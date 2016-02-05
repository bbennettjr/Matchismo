//
//  Deck.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/15/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "Deck.h"
#import "Card.h"

@interface Deck ()
@property (strong, nonatomic) NSMutableArray *cards;
@end

@implementation Deck
-(NSMutableArray *)cards{
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}
//add cards to the deck
-(void)addCard:(Card *)card
         atTop:(BOOL)atTop{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}
-(void)addCard:(Card *)card{
    [self addCard:card atTop:NO];
}

//draw a random card from the deck
-(Card *)drawRandomCard{
    Card *card;
    if ([self.cards count]) {
        unsigned index = arc4random() % [self.cards count];
        card = [self.cards objectAtIndex:index];
        [self.cards removeObjectAtIndex:index];
    }
    return card;
}

//return the size of the deck
-(NSUInteger)deckSize{
    return [self.cards count]-1;
}

#pragma mark - Class Methods
@end

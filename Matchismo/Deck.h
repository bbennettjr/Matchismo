//
//  Deck.h
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/15/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject
-(void)addCard:(Card *)card
         atTop:(BOOL)atTop;
-(void)addCard:(Card *)card;
-(Card *)drawRandomCard;
-(NSUInteger)deckSize;
@end

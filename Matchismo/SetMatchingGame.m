//
//  SetMatchingGame.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/1/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "SetMatchingGame.h"
#import "SetCard.h"

@interface SetMatchingGame ()

@end

@implementation SetMatchingGame
-(instancetype)initWithDeck:(Deck *)deck{
    return [super initWithDeck:deck];
}

//choosing a card at the button index to then change attributes of the card (it is chosen and matched) and eventually to match the three cards so that a score can be calculated
-(void)chooseCardAtIndex:(NSUInteger)index{
    Card *card = [self cardAtIndex:index];
    if (card) { //do if the card exists
        if ([self.chosenCards count] == self.numberOfMatchingCards-1) { //have we chosen two other cards
            int initialMatchScore = [card match:self.chosenCards]; //initial match scoring
            [self.chosenCards addObject:card];

                //Match! Now add bonuses, set all card's isMatched = YES and self.match = YES
            if (initialMatchScore) {
                self.score += self.matchBonus * initialMatchScore;
                self.match = YES;
            }

                //No Match.  Subtract the penalty.
            if (!initialMatchScore) { self.score -= self.mismatchPenalty; self.match = NO; }

        } else {
            if (!card.isMatched) {
                if (!card.isChosen) { [self.chosenCards addObject:card]; }
                if (card.isChosen) { [self.chosenCards removeObject:card]; }
                card.isChosen = !card.isChosen;
                self.match = NO;
            }
        }
        [self descriptionOfFlip];
        self.score -= self.costToChoose;
    }
}

-(void)descriptionOfFlip{
    self.status = [NSString stringWithFormat:@""];
    if ([self.chosenCards count]) {
        for (Card *card in self.chosenCards) {
            if ([card isKindOfClass:[SetCard class]]) {
                SetCard *newCard = (SetCard *)card;
                //create a string of every card
                if (![self.status length]) {
                    self.status = [NSString stringWithFormat:@"%@%@%@%d", newCard.shape, newCard.shade, newCard.color, newCard.number];
                } else {
                    self.status = [self.status stringByAppendingFormat:@",%@%@%@%d", newCard.shape, newCard.shade, newCard.color, newCard.number];
                }
            }
        }
    } else {
        //no cards chosen, status says choose a set
    }
}
@end

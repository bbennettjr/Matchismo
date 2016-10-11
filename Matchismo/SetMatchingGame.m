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
static NSString *const NO_ACTION = @"NO ACITON";
static NSString *const MID_TURN = @"MID TURN";
static NSString *const MATCH = @"MATCH";

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

                //Call descriptionOfFlip here to take advantage of cards while they are in chosenCards (assuming match occurs)
            [self descriptionOfFlip];

                //Match! Now add bonuses, set all card's isMatched = YES and self.match = YES
            if (initialMatchScore) {
                self.score += self.matchBonus * initialMatchScore;
                self.match = YES;
                return;
            }

                //No Match.  Subtract the penalty.
            if (!initialMatchScore) {
                self.score -= self.mismatchPenalty;
                self.match = NO;
            }

        } else {
            if (!card.isMatched) {
                if (!card.isChosen) { [self.chosenCards addObject:card]; }
                if (card.isChosen) { [self.chosenCards removeObject:card]; }
                    //change status to mid turn if any move was chosen
                if (![self.status isEqualToString:MID_TURN]) { self.status = MID_TURN; }
                card.isChosen = !card.isChosen;
                [self descriptionOfFlip];
            }
        }
        self.score -= self.costToChoose;
    }
}

-(void)descriptionOfFlip{
    self.descr = [NSString stringWithFormat:@""];
    if ([self.chosenCards count]) {
        for (Card *card in self.chosenCards) {
            if ([card isKindOfClass:[SetCard class]]) {
                SetCard *newCard = (SetCard *)card;
                //create a string of every card
                if (![self.descr length]) {
                    self.descr = [NSString stringWithFormat:@"%@%@%@%d", newCard.shape, newCard.shade, newCard.color, newCard.number];
                } else {
                    self.descr = [self.descr stringByAppendingFormat:@",%@%@%@%d", newCard.shape, newCard.shade, newCard.color, newCard.number];
                }
            }
        }
    } else {
        //no cards chosen, descr says choose a set
    }
}
@end

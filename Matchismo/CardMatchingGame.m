//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/7/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "CardMatchingGame.h"
@interface CardMatchingGame()
@end

@implementation CardMatchingGame
#pragma mark - Main
//logic to choose a card at any index of the button in the view.  Then compares to see
//if the card is matched or not, and the total matches currently in the game.  Once the matches
//equals what the user set, score the selections and set the values to be displayed.
-(void)chooseCardAtIndex:(NSUInteger)index {
    Card *card = [self.cards objectAtIndex:index];
    if (!card.isMatched && card.isChosen) {
        card.isChosen = NO;
        [self.chosenCards removeLastObject];

        if ([self.chosenCards count]) {
            self.descr = [NSString stringWithFormat:@"Chosen cards %@", [self.chosenCards componentsJoinedByString:@", "]];
        } else {
            self.descr =@"Pick a card, any card";
        }

    } else if (!card.isMatched) {
        [self.chosenCards addObject:card];

        if (self.numberOfMatchingCards == (NSInteger)[self.chosenCards count]){
            [self.chosenCards removeLastObject];
            int matches = [card match:self.chosenCards];

            if (matches) {
                self.score += (matches * self.matchBonus);
                NSString *dummyString = [[NSString alloc]init];
                for (Card *newCard in self.chosenCards) {
                    dummyString = [dummyString stringByAppendingString:newCard.contents];
                    newCard.isMatched = YES;
                }
                card.isMatched = YES;
                self.match = YES;
                self.descr = [NSString stringWithFormat:@"Matched %@ with %@ for %d points!", card.contents, dummyString, matches];
                [self.chosenCards removeAllObjects];
            } else {
                self.score -= self.mismatchPenalty;

                for (Card *newCard in self.chosenCards) {
                    newCard.isChosen = NO;
                }
                self.match = NO;
                self.descr = [NSString stringWithFormat:@"No match! Lose %d points.", self.mismatchPenalty];
                [self.chosenCards removeAllObjects];
                [self.chosenCards addObject:card];
            }

        } else {
            if ([self.chosenCards count] > 1){
                NSString *dummyString = [[NSString alloc]init];
                for (Card *newCard in self.chosenCards) {
                    dummyString = [dummyString stringByAppendingString:newCard.contents];
                }
                self.descr = [NSString stringWithFormat:@"Chosen cards %@", dummyString];
            }
            else {self.descr = [NSString stringWithFormat:@"Chosen card %@", card.contents];}
        }
        self.score -= self.costToChoose;
        card.isChosen = YES;
    }
}

-(void)descriptionOfFlip{
    //code here
}
@end

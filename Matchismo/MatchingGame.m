//
//  MatchingGame.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/16/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "MatchingGame.h"
#import "Card.h"
#import "GameResult.h"
#import "Settings.h"

@interface MatchingGame ()
@property (nonatomic, strong) Settings *settings;
@property (nonatomic, strong) Deck *deck;
@end

@implementation MatchingGame
static NSString *const NO_ACTION = @"NO ACITON";
static NSString *const MID_TURN = @"MID TURN";
static NSString *const MATCH = @"MATCH";

#pragma mark - Lazy Instantiation
-(NSMutableArray *)chosenCards{
    return (!_chosenCards) ? _chosenCards = [[NSMutableArray alloc]init] : _chosenCards; //fast enumeration
}
-(NSMutableArray *)cards{
    if (!_cards) _cards = [[NSMutableArray alloc]init];
    return _cards;
}
@synthesize score = _score;
-(NSInteger)score{
    return (!_score) ? 0 : _score;
}
-(void)setScore:(NSInteger)score{
    _score = score;
}
-(void)setNumberOfDealtCards:(NSUInteger)numberOfDealtCards{
    _numberOfDealtCards = numberOfDealtCards;
}
    //Setter and getter for deck
@synthesize deck = _deck;
-(Deck *)deck{
    return _deck;
}
-(void)setDeck:(Deck *)deck{
    _deck = deck;
}
-(NSString *)descr{
    return (!_descr) ? _descr = [[NSString alloc]initWithFormat:@"Find a Set!"] : _descr;
}
@synthesize match = _match;
-(void)setMatch:(BOOL)match{
        //If a match occurs, set all cards in the chosenCards array to isMatched = YES and remove them from the array.
    if (match) {
        for (Card *card in self.chosenCards) {
            card.isMatched = YES;
            card.isChosen = YES;
            [self removeMatchedCard]; //Remove the matched cards here
            self.status = MATCH;
        }
        [self.chosenCards removeAllObjects];
    } else if ([self.chosenCards count] == self.numberOfMatchingCards) { //Code for match = NO and removing all cards
        for (Card *card in self.chosenCards) {
            card.isMatched = NO;
            card.isChosen = NO;
            self.status = NO_ACTION;
        }
        [self.chosenCards removeAllObjects];
    }
    _match = match;
}
-(BOOL)match{
    return(!_match ? _match = NO : _match);
}
    //Status getter and setter
@synthesize status = _status;
-(NSString *)status{
    if (!_status) {
        _status = [NSString stringWithFormat:@""];
    }
    return _status;
}
-(Settings *)settings{
    return !_settings ? _settings = [Settings currentSettings] : _settings;
}
-(NSInteger)matchBonus{
    return (!_matchBonus ? _matchBonus = self.settings.matchBonus : _matchBonus);
}
-(NSInteger)mismatchPenalty{
    return (!_mismatchPenalty) ? _mismatchPenalty = self.settings.mismatchPenalty : _mismatchPenalty;
}
-(NSInteger)costToChoose{
    return (!_costToChoose) ? _costToChoose = self.settings.costToChoose : _costToChoose;
}

#pragma mark - Private API

#pragma mark - Initializers
//designated initializer
-(instancetype)initWithDeck:(Deck *)deck
              andCardNumber:(NSUInteger)numberOfCards{
    [self setDeck:deck];
    self = [super init];
    if (self) {
        for (NSUInteger index = 0; index < numberOfCards; index++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}
//nondesignated initializer
-(instancetype)initWithDeck:(Deck *)deck{
    return [self initWithDeck:deck andCardNumber:[deck deckSize]];
}

#pragma mark - Public API
    //Draw a new card from the deck, if the deck size is zero set our deckIsEmpty flag
-(void)drawNewCard{
    if ([self.deck deckSize] > 0) {
        Card *card = [self.deck drawRandomCard];
        [self.cards addObject:card];
    }
    if ([self.deck deckSize] == 0) { self.deckIsEmpty = YES; }
}

    //Remove a card that has been matched and is no longer actionable on the playing field
-(void)removeMatchedCard{
    for (Card *card in self.chosenCards) {
        if ([card isKindOfClass:[Card class]]) {[self.cards removeObject:card];}
    }
}

//return a card at the specified index using fast enum
-(Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? [self.cards objectAtIndex:index] : nil;
}

//logic to choose a card at any index of the button in the view.  Then compares to see
//if the card is matched or not, and the total matches currently in the game.  Once the matches
//equals what the user set, score the selections and set the values to be displayed.  
-(void)chooseCardAtIndex:(NSUInteger)index {
    //implement in subclasses
}

-(void)descriptionOfFlip{
//tell about the flip
}

#pragma mark - Class Methods
    //Status values possible for each game.  Subclass if necessary
+(NSArray *)statusValues{
    NSArray *status = @[NO_ACTION, MID_TURN, MATCH];
    return status;
}
@end

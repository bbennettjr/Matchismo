//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/7/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardView.h"

@interface CardGameViewController ()
@property (nonatomic, strong) CardMatchingGame *cardGame;
@end

@implementation CardGameViewController
#pragma mark - Definitions
#define MAX_CARD_WIDTH 160.0
#define MAX_CARD_HEIGHT 240.0

#pragma mark - View Controller life cycle
-(void)viewDidLoad{
    //set up the number of cards to play with and update the UI

    //initialize the grid statistics
    self.numberOfStartingCards = 35;
    self.maxCardSize = CGSizeMake(MAX_CARD_WIDTH, MAX_CARD_HEIGHT);
    self.grid.maxCellWidth = self.maxCardSize.width;
    self.grid.maxCellHeight = self.maxCardSize.height;
    self.grid.minCellWidth = self.minCardSize.width;
    self.grid.minCellHeight = self.minCardSize.height;
    //initialize the cardViews array
    [self cardViews];

    [super viewDidLoad];
}

#pragma mark - Lazy Instantiation
//creat the deck
-(Deck *)createDeck{
    self.gameType = @"Playing Cards";
    return [[PlayingCardDeck alloc]init];
}

//create the card game with deck and number of cards
-(MatchingGame *)cardGame{
    if (!_cardGame) {
        _cardGame = [[CardMatchingGame alloc]initWithDeck:[self createDeck]
                                            andCardNumber:self.numberOfDealtCards];
        self.cardGame.numberOfMatchingCards = 2;
    }
    return _cardGame;
}

-(NSMutableArray *)cardViews{
    NSMutableArray *cardViews = [super cardViews];  //return the synthesized variable pointer

    //only initialize all the cards if there is nothing in the cardview array
    if (![cardViews count]) {
        PlayingCardView *cardView;
        PlayingCard *card;
        int index = 0;

        //only do it if the inputs are valid for making a card game
        if (self.grid.inputsAreValid) {
            //first add the flipCards tap gesture to the gridView
            [self.gridView addGestureRecognizer:self.flipCards];

            for (int row = 0; row < self.grid.rowCount; row++) {
                for (int column = 0; column < self.grid.columnCount; column++) {
                    cardView = [[PlayingCardView alloc]initWithFrame:[self.grid frameOfCellAtRow:row inColumn:column]];
                    card = (PlayingCard *)[self.cardGame cardAtIndex:index];
                    cardView.rank = card.rank;
                    cardView.suit = card.suit;
                    [self.flipCards addTarget:cardView action:@selector(flipCard:)];
                    [cardViews addObject:cardView];
                    [self.gridView addSubview:cardView];
                    index++;
                }
            }
        } else {

            //let us know the inputs were invalid
            UILabel *label = [[UILabel alloc]initWithFrame:self.gridView.frame];
            label.text = @"Inputs were invalid";
            [self.gridView addSubview:label];
        }
    }
    return cardViews;
}


#pragma mark - Main
//deal a new game with a new created deck and number of cards.  Set the number of matching cards.
- (IBAction)dealNewGame:(UIButton *)sender {
    self.cardGame = [[CardMatchingGame alloc]initWithDeck:[self createDeck] andCardNumber:self.numberOfDealtCards];
    self.cardGame.numberOfMatchingCards = 2;
    [super dealNewGame:sender];
}

//update the UI when something changes in the model or Deal occurs
-(void)updateUI{
    for (UIView *cardView in self.cardViews) {
        if ([cardView isKindOfClass:[PlayingCardView class]]) {
            PlayingCardView *playingCardView = (PlayingCardView *)cardView;
            if (playingCardView.faceUp) {
                [self.cardGame chooseCardAtIndex:[self.cardViews indexOfObject:playingCardView]];
            }
        }
    }
    [super updateUI];
}

#pragma mark - Gestures
- (IBAction)flipCardsSwipeGesture:(UITapGestureRecognizer *)sender {
    [self updateUI];
}

- (IBAction)stackCardsPinchGesture:(UIPinchGestureRecognizer *)sender {
    for (UIView *view in self.cardViews) {
        if ([view isKindOfClass:[PlayingCardView class]]) {
            PlayingCardView *playingCardView = (PlayingCardView *)view;
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{ playingCardView.center = [sender locationInView:self.view]; self.stacked = !self.stacked; } completion:nil];
        }
    }
}
/*
- (IBAction)panStackedCardsGesture:(UIPanGestureRecognizer *)sender {
    if (self.stacked) {
        if (sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged) {
            for (UIView *view in self.cardViews) {
                if ([view isKindOfClass:[PlayingCardView class]]) {
                    PlayingCardView *playingCardView = (PlayingCardView *)view;
                    playingCardView.center = [sender locationInView:self.view];
                }
            }
        }
    }
}*/
@end

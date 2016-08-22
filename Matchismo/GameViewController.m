//
//  GameViewController.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/16/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()
@property (strong, nonatomic) MatchingGame *cardGame;
@property (strong, nonatomic) GameResult *results;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.  Set the number of cards and update the UI
    self.scoreLabel.adjustsFontSizeToFitWidth = YES;
    [self updateUI];
}

#pragma mark - Lazy Instantiation
//create the deck
-(Deck *)createDeck{
    return [[PlayingCardDeck alloc]init];
}

//initialize the card game with a deck and number of starting cards
-(MatchingGame *)cardGame{
    if (!_cardGame) _cardGame = [[MatchingGame alloc]initWithDeck:[self createDeck]
                                                        andCardNumber:self.numberOfDealtCards];
    return _cardGame;
}

//the result to be displayed
-(GameResult *)result{
    if (!_results) {
        _results = [[GameResult alloc]init];
        _results.gameType = self.gameType;
    }
    return _results;
}

//game type to be displayed in the leaderboard
-(NSString *)gameType{
    return !_gameType ? _gameType = @"?" : _gameType;
}

//grid to layout the custom views of every card
-(Grid *)grid{
    if (!_grid) {
        _grid = [[Grid alloc]init];
        _grid.minimumNumberOfCells = self.numberOfDealtCards;
        _grid.cellAspectRatio = self.maxCardSize.width/self.maxCardSize.height;
        _grid.maxCellWidth = self.maxCardSize.width;
        _grid.maxCellHeight = self.maxCardSize.height;
        _grid.minCellWidth = self.minCardSize.width;
        _grid.minCellHeight = self.minCardSize.height;
        _grid.size = self.gridView.frame.size;
    }
    return _grid;
}

//returns the number of cards dealt in the game
-(NSUInteger)numberOfDealtCards{
        return self.grid.exactNumberOfCells;
}

//array holding the custom views of each card, returns nil for subclassing
-(NSMutableArray *)cardViews{
    return !_cardViews ? _cardViews = [[NSMutableArray alloc]init] : _cardViews;
}

//swipe gesture recognizer for flipping cards
@synthesize flipCards = _flipCards;
-(UITapGestureRecognizer *)flipCards{
    if (!_flipCards) {
        _flipCards = [[UITapGestureRecognizer alloc]init];
    }
    return _flipCards;
}
-(void)setFlipCards:(UITapGestureRecognizer *)flipCards{
    _flipCards = flipCards;
}


#pragma mark - UI Interaction and Updating
//reset the game
- (IBAction)dealNewGame:(UIButton *)sender {
    self.results = nil;
    [self resetCardViews];
    [self updateUI];
}

//removes the cards from the view hierarchy when a new game is dealt
-(void)resetCardViews{
    [self.cardViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.cardViews = nil;
    [self cardViews];
}

//set the labels and cards to properly reflect what is occuring in the game.
-(void)updateUI{
    [self updateScoreLabel];
    self.result.score = (int)self.cardGame.score;
}

-(void)updateScoreLabel{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.cardGame.score];
}

#pragma mark - Segue
/*
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
}*/
@end

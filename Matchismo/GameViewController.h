//
//  GameViewController.h
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/16/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "MatchingGame.h"
#import "GameResult.h"
#import "Grid.h"

    //comments to test Git ;)
@interface GameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *flipCards;
@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, strong) Grid *grid;
@property (nonatomic) BOOL stacked;

//public properties for setting up the Grid class
@property (weak, nonatomic) IBOutlet UIView *gridView;
@property (nonatomic, strong) NSMutableArray *cardViews;
@property (nonatomic) NSInteger numberOfStartingCards;
@property (nonatomic) CGSize maxCardSize;
@property (nonatomic) CGSize minCardSize;
@property (nonatomic) NSUInteger numberOfDealtCards;

//animation
@property (nonatomic, strong) UIDynamicAnimator *animator;

//instance methods
- (IBAction)dealNewGame:(UIButton *)sender;
-(void)updateUI;
-(void)updateScoreLabel;
@end

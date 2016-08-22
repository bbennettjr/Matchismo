//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/28/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardView.h"

@interface SetGameViewController ()
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tap;
@property (strong, nonatomic) SetMatchingGame *cardGame;
@end

@implementation SetGameViewController
#pragma mark - Definitions
static NSString *const NO_ACTION = @"NO ACITON";
static NSString *const MID_TURN = @"MID TURN";
static NSString *const MATCH = @"MATCH";
#define MAX_CARD_WIDTH 1000.0
#define MAX_CARD_HEIGHT 1000.0
#define MIN_CARD_WIDTH 180.0
#define MIN_CARD_HEIGHT 180.0

#pragma mark - View Controller life cycle
-(void)viewDidLoad{
    //set up the number of cards to play with and update the UI
    self.numberOfStartingCards = 12;
    self.maxCardSize = CGSizeMake(MAX_CARD_WIDTH, MAX_CARD_HEIGHT);
    self.minCardSize = CGSizeMake(MIN_CARD_WIDTH, MIN_CARD_HEIGHT);

    //initalize the cardviews array
    [self cardViews];

    [super viewDidLoad];
}

#pragma mark - Lazy Instantiation
-(Deck *)createDeck{
    self.gameType = @"Set Cards";
    return [[SetCardDeck alloc]init];
}
-(SetMatchingGame *)cardGame{
    if (!_cardGame) {
        _cardGame = [[SetMatchingGame alloc]initWithDeck:[self createDeck]];
        self.cardGame.numberOfMatchingCards = 3;
    }
    return _cardGame;
}
- (IBAction)dealNewGame:(UIButton *)sender {
    self.cardGame = [[SetMatchingGame alloc]initWithDeck:[self createDeck]];
    self.cardGame.numberOfMatchingCards = 3;
    [super dealNewGame:sender];
}

//getter for cardViews array
-(NSMutableArray *)cardViews{
    NSMutableArray *cardViews = [super cardViews];

    //if there are no cards in the array initialize all the card views
    if (![cardViews count]) {
        //code to create the setcard views
        SetCardView *cardView;
        SetCard *card;
            //index = 0 here because this relates to the views on screen, not the remaining available deck in the cardGame.
        int index = 0;

        //only do if the inputs are valid
        if (self.grid.inputsAreValid) {
            for (NSUInteger row = 0; row < self.grid.rowCount; row++) {
                for (NSUInteger column = 0; column < self.grid.columnCount; column++) {
                    cardView = [[SetCardView alloc]initWithFrame:[self.grid frameOfCellAtRow:row inColumn:column]];
                    card = (SetCard *)[self.cardGame cardAtIndex:index];
                    cardView.shape = card.shape;
                    cardView.shade = card.shade;
                    cardView.color = card.color;
                    cardView.number = card.number;
                    [self.tap addTarget:cardView action:@selector(selectCard:)];
                    [cardViews addObject:cardView];
                    [self.gridView addSubview:cardView];
                    index++;
                    if (index >= self.numberOfStartingCards) return cardViews;  //return if the card views have been filled
                }
            }
        } else {
            UILabel *label = [[UILabel alloc]init];
            label.text = @"Inputs are invalid";
            [self.gridView addSubview:label];
        }
    }
    return cardViews;
}

#pragma mark - User Interface Updating
#define ADD_CARDS 3
-(IBAction)addThreeCardsButton:(UIButton *)sender{
    for (int i = 1; i == ADD_CARDS; i++) {
        [self.cardGame drawNewCard];
    }
    [self updateUI];
}

- (IBAction)selectCardsToMatch:(UITapGestureRecognizer *)sender {
    //evaluate each touch event to see which card was chosen, then send that card to the model
    for (SetCardView *cardView in self.cardViews) {
        if (CGRectContainsPoint(cardView.bounds, [sender locationInView:cardView])) {
            [self.cardGame chooseCardAtIndex:[self.cardViews indexOfObject:cardView]];
        }
    }
    [self updateUI];
}

-(void)updateUI{
    [super updateUI];
    //get the card for correct cardview object

        //parse out actions depending on current game status

    if ([self.cardGame.status isEqualToString:MATCH]) { [self animateMatch]; }
    if ([self.cardGame.status isEqualToString:NO_ACTION]) { [self resetCards]; }
}

//when a match occurs in game, animate the cards
-(void)animateMatch{
        //Array to clean up the cards as they are removed from the game.  Do not touch the self.cardViews array while its being enumerated
    NSMutableArray *cardViewCleanUp = [[NSMutableArray alloc] init];
        //use a weakSelf version of our VC for the animation block below
        //__weak SetGameViewController *weakSelf = self;
    for (SetCardView *cardView in self.cardViews) {
        if (cardView.selected) {
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                //not working
                //cardView.transform = CGAffineTransformMakeTranslation(self.view.bounds.origin.x, self.view.bounds.origin.y);
                //cardView.transform = CGAffineTransformMakeTranslation(0, -1000);
                    //use a weak version of self to remove the cardView object after the transformation is complete
                    //[weakSelf.cardViews removeObject:cardView];
                [cardView removeMatchedCard:self.view.window.bounds];
                    //Add cardView to the clean up array to later remove these from self.cardViews
                [cardViewCleanUp addObject:cardView];
                    //[cardView removeFromSuperview];
            } completion:nil];
        }
    }
    self.cardGame.match = NO;
}

    //Reset cards calls all cardviews in the window and resets them to the default non-selected position
-(void)resetCards{
        //this code will call a method within SetCardView to toggle selected state
}
@end

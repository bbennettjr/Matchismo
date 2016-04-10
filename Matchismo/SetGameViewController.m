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

    if (self.cardGame.match) {
        [self animateMatch];
    }
}

//when a match occurs in game, animate the cards
-(void)animateMatch{
        //use a weakSelf version of our VC for the animation block below
    __weak SetGameViewController *weakSelf = self;
    for (SetCardView *cardView in self.cardViews) {
        if (cardView.selected) {
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                //not working
                cardView.transform = CGAffineTransformMakeTranslation(self.view.bounds.origin.x, self.view.bounds.origin.y);
                    //use a weak version of self to remove the cardView object after the transformation is complete
                [weakSelf.cardViews removeObject:cardView];
                [cardView removeFromSuperview];
            } completion:nil];
        }
    }
    self.cardGame.match = NO;
}

- (NSAttributedString *)updateAttributedString:(NSAttributedString *)attributedString withAttributesOfCard:(SetCard *)card{
    NSMutableAttributedString *mutableAttributedString = [attributedString mutableCopy];
    NSRange range = [[mutableAttributedString string] rangeOfString:card.shape];
    if (range.location != NSNotFound) {
        NSString *symbol = @"?";
        if ([card.shape isEqualToString:@"circle"]) symbol = @"●";
        if ([card.shape isEqualToString:@"triangle"]) symbol = @"▲";
        if ([card.shape isEqualToString:@"square"]) symbol = @"■";
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        if ([card.color isEqualToString:@"red"])
            [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
        if ([card.color isEqualToString:@"green"])
            [attributes setObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
        if ([card.color isEqualToString:@"purple"])
            [attributes setObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];
        if ([card.shade isEqualToString:@"solid"])
            [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
        if ([card.shade isEqualToString:@"striped"])
            [attributes addEntriesFromDictionary:@{
                                                   NSStrokeWidthAttributeName : @-5,
                                                   NSStrokeColorAttributeName : attributes[NSForegroundColorAttributeName],
                                                   NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.15]
                                                   }];
        if ([card.shade isEqualToString:@"open"])
            [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
        symbol = [symbol stringByPaddingToLength:card.number withString:symbol startingAtIndex:0];
        [mutableAttributedString replaceCharactersInRange:range
                                     withAttributedString:[[NSAttributedString alloc] initWithString:symbol
                                                                                          attributes:attributes]];
    }
    return mutableAttributedString;
}

//highlight the selected button with a new background image using fast enumeration
-(void)showSelectedButton:(UIButton *)button forCard: (Card *)card{
    [button setBackgroundImage:[UIImage imageNamed:card.isChosen ? @"selectedSetCard" : @"cardFront"] forState:UIControlStateNormal];
}

-(void)updateScoreLabel{
    UIColor *color;
    NSString *updatedScore = [[NSString alloc]initWithFormat:@"Score: %ld", (long)self.cardGame.score];
    if (self.cardGame.match) {
        color = [UIColor greenColor];
    } else {
        color = [UIColor blackColor];
    }
    self.scoreLabel.attributedText = [[NSAttributedString alloc] initWithString:updatedScore attributes:@{ NSForegroundColorAttributeName : color }];
}


-(NSAttributedString *)updateGameStatusDisplay{
    //take the game status and convert it into an attributable string to show in updateactionbarlabel
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc]init];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]init];
    NSArray *contents = [self.cardGame.status componentsSeparatedByString:@","];
    //do only if the status and contents exist
    if (contents) {
        //enum through each card
        for (NSString *eachCard in contents) {
            NSString *symbol = @"?";
            NSInteger number = 0;
            //compare the card attributes to set up our NSAttributedString
            if ([eachCard rangeOfString:@"circle"].location != NSNotFound) symbol = @"●";
            if ([eachCard rangeOfString:@"square"].location != NSNotFound) symbol = @"■";
            if ([eachCard rangeOfString:@"triangle"].location != NSNotFound) symbol = @"▲";
            if ([eachCard rangeOfString:@"red"].location != NSNotFound) [attributes setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
            if ([eachCard rangeOfString:@"purple"].location != NSNotFound) [attributes setObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];
            if ([eachCard rangeOfString:@"green"].location != NSNotFound) [attributes setObject:[UIColor greenColor] forKey:NSForegroundColorAttributeName];
            if ([eachCard rangeOfString:@"open"].location != NSNotFound) [attributes setObject:@5 forKey:NSStrokeWidthAttributeName];
            if ([eachCard rangeOfString:@"striped"].location != NSNotFound)
                [attributes addEntriesFromDictionary:@{
                                                       NSStrokeWidthAttributeName : @-5,                                     NSStrokeColorAttributeName : [attributes objectForKey:NSForegroundColorAttributeName], NSForegroundColorAttributeName : [attributes[NSForegroundColorAttributeName] colorWithAlphaComponent:0.15] }];
            if ([eachCard rangeOfString:@"solid"].location != NSNotFound) [attributes setObject:@-5 forKey:NSStrokeWidthAttributeName];
            if ([eachCard rangeOfString:@"1"].location != NSNotFound) number = 1;
            if ([eachCard rangeOfString:@"2"].location != NSNotFound) number = 2;
            if ([eachCard rangeOfString:@"3"].location != NSNotFound) number = 3;
            symbol = [symbol stringByPaddingToLength:number withString:symbol startingAtIndex:0];
            //finally create and add to the attributed string
            if (![mutableAttributedString length]) {
                mutableAttributedString = [[NSMutableAttributedString alloc]initWithString:symbol attributes:attributes];
            } else {
                NSAttributedString *nextCardContents = [[NSAttributedString alloc]initWithString:symbol attributes:attributes];
                NSMutableAttributedString *commaString = [[NSMutableAttributedString alloc]initWithString:@", "];
                [commaString appendAttributedString:nextCardContents];
                [mutableAttributedString appendAttributedString:commaString];
            }

        }
    }
    return mutableAttributedString;
}
@end

//
//  LeaderboardViewController.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/11/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "LeaderboardViewController.h"
#import "MatchingGame.h"
#import "GameResult.h"

@interface LeaderboardViewController ()
@property (strong, nonatomic) NSArray *allResults;
@end

@implementation LeaderboardViewController

#pragma mark - ViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.leaderboard.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    self.allResults = [[[NSArray alloc]initWithArray:[GameResult allGameResults]] sortedArrayUsingSelector:@selector(compareScore:)];
    [self updateUI];
}

#pragma mark - Lazy Instantiation
-(NSArray *)allResults{
    return !_allResults ? _allResults = [[NSArray alloc]init] : _allResults;
}

#pragma mark - UI Methods
-(void)updateUI{
    //update the UI with new high scores
    [self updateLeaderboard];
}

-(void)updateLeaderboard{
    NSString *allGameResultsString = [[NSString alloc]init];
    for (GameResult *result in self.allResults) {
        allGameResultsString = [allGameResultsString stringByAppendingString:[self stringForGameResult:result]];
    }
    self.leaderboard.text = allGameResultsString;
    NSArray *sortedAllResults = [self.allResults sortedArrayUsingSelector:@selector(compareScore:)];
    [self changeLeaderboardResult:[sortedAllResults firstObject] toColor:[UIColor greenColor]];
    [self changeLeaderboardResult:[sortedAllResults lastObject] toColor:[UIColor blueColor]];
    sortedAllResults = [self.allResults sortedArrayUsingSelector:@selector(compareDuration:)];
    [self changeLeaderboardResult:[sortedAllResults firstObject] toColor:[UIColor orangeColor]];
    [self changeLeaderboardResult:[sortedAllResults lastObject] toColor:[UIColor purpleColor]];

}

-(NSString *)stringForGameResult:(GameResult *)result{
    NSString *string;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    string = [NSString stringWithFormat:@"%@: %d, %@ and %f\n", result.gameType, result.score, [dateFormatter stringFromDate:result.start], round(result.duration)];
    return string;
}

-(void)changeLeaderboardResult:(GameResult *)result toColor:(UIColor *)color{
    NSRange range = [self.leaderboard.text rangeOfString:[self stringForGameResult:result]];
    [self.leaderboard.textStorage addAttribute:NSForegroundColorAttributeName value:color range:range];
}


- (IBAction)sort:(UIButton *)sender {
    if ([sender.currentTitle containsString:@"Scores"])
        self.allResults = [[NSArray alloc]initWithArray:[self.allResults sortedArrayUsingSelector:@selector(compareScore:)]];
    if ([sender.currentTitle containsString:@"Duration"])
        self.allResults = [[NSArray alloc]initWithArray:[self.allResults sortedArrayUsingSelector:@selector(compareDuration:)]];
    if ([sender.currentTitle containsString:@"Most Recent"])
        self.allResults = [[NSArray alloc]initWithArray:[self.allResults sortedArrayUsingSelector:@selector(compareStart:)]];
    [self updateUI];
}

- (IBAction)resetLeaderboard:(UIButton *)sender {
    [NSUserDefaults resetStandardUserDefaults];
    [self updateUI];
}
@end

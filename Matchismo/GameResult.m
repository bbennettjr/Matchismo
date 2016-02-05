//
//  GameResult.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/15/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "GameResult.h"
@interface GameResult()
@property (nonatomic, readwrite) NSDate *start;
@property (nonatomic, readwrite) NSDate *end;
@end

@implementation GameResult
#pragma mark - Constants
//alternate syntex below.  Can use static const NSString *XYZ
static NSString *const ALL_RESULTS_KEY = @"ALL_RESULTS_KEY";
static NSString *const START_KEY = @"START_KEY";
static NSString *const END_KEY = @"END_KEY";
static NSString *const SCORE_KEY = @"SCORE_KEY";
static NSString *const GAME_TYPE_KEY = @"GAME_TYPE_KEY";

#pragma mark - Instantiation
-(instancetype)init{
    self = [super init];
    if (self) {
        _start = [NSDate date]; //on generating a result, set the start and end times
        _end = _start;
    }
    return self;
}
-(instancetype)initFromPropertyList:(NSDictionary *)pList{
    self = [super init];
    if (self) {
        if ([pList isKindOfClass:[NSDictionary class]]) {
            _start = [pList objectForKey:START_KEY];
            _end = [pList objectForKey:END_KEY];
            _score = [[pList objectForKey:SCORE_KEY] intValue];
            _gameType = [pList objectForKey:GAME_TYPE_KEY];
            if (!_start || !_end) self = nil;
        }
    }
    return self;
}
-(NSTimeInterval)duration{
    return [self.end timeIntervalSinceDate:self.start];
}
-(void)setScore:(int)score{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

#pragma mark - Instance Methods
-(NSComparisonResult)compareScore:(GameResult *)result{
    return [@(result.score) compare:@(self.score)];
}
-(NSComparisonResult)compareDuration:(GameResult *)result{
    return [@(self.duration) compare:@(result.duration)];
}
-(NSComparisonResult)compareStart:(GameResult *)result{
    return [result.start compare:self.start];
}

//every time a score is recorded, add the game's results to the store by start date description being the key to find this game's results
-(void)synchronize{
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableGameResultsFromUserDefaults) { mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc]init]; }
    [mutableGameResultsFromUserDefaults setObject:[self asPropertyList] forKey:[self.start description]];
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
}
//return the property list to save to NSUserDefaults for each game's results
-(id)asPropertyList{
    return @{ START_KEY : self.start,
              END_KEY : self.end,
              SCORE_KEY : @(self.score),
              GAME_TYPE_KEY : self.gameType };
}

#pragma mark - Class Methods
//create new GameResult objects for each property list stored!  Genius, recreate the objects on the back end with a class method.  Store the data (ie properties) into a property list since NSObjects cannot be property lists, add the data to NSUserDefaults and recreate in another ViewController
+(NSArray *)allGameResults{
    NSMutableArray *allGameResults = [[NSMutableArray alloc]init];
    GameResult *result;
    for (id propertyList in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        if ([propertyList isKindOfClass:[NSDictionary class]]) { result = [[GameResult alloc] initFromPropertyList:propertyList]; }
        [allGameResults addObject:result];
    }
    return allGameResults;
}
@end

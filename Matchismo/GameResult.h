//
//  GameResult.h
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/15/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResult : NSObject
@property (nonatomic, readonly) NSDate *start;
@property (nonatomic, readonly) NSDate *end;
@property (nonatomic, strong) NSString *gameType;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (nonatomic) int score;

-(NSComparisonResult)compareScore:(GameResult *)result;
-(NSComparisonResult)compareDuration:(GameResult *)result;
-(NSComparisonResult)compareStart:(GameResult *)result;

+(NSArray *)allGameResults;
@end

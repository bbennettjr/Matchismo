//
//  PlayingCard.h
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/15/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card
@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (nonatomic, getter=isUp) BOOL isUp;

#pragma mark - Public Class Methods
+(NSArray *)validSuits;
+(NSUInteger)maxRank;
@end

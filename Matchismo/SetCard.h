//
//  SetCard.h
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/29/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card
#pragma mark - Public Properties
@property (nonatomic, strong) NSString *shape;
@property (nonatomic, strong) NSString *shade;
@property (nonatomic, strong) NSString *color;
@property (nonatomic) NSInteger number;

#pragma mark - Class Methods
+(NSArray *)validShapes;
+(NSArray *)validShades;
+(NSArray *)validColors;
+(NSInteger)maxNumber;
+(NSInteger)setScore;
@end

//
//  SetCard.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/29/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

-(NSString *)contents{
    return nil;
}

#pragma mark - Setters and Getters
@synthesize shape = _shape;
-(NSString *)shape{
    return _shape ? _shape : @"?";
}
-(void)setShape:(NSString *)shape{
    if ([[SetCard validShapes] containsObject:shape]){
        _shape = shape;
    }
}
@synthesize shade = _shade;
-(NSString *)shade{
    return _shade ? _shade : @"?";
}
-(void)setShade:(NSString *)shade{
    if ([[SetCard validShades] containsObject:shade]) {
        _shade = shade;
    }
}
@synthesize color = _color;
-(NSString *)color{
    return _color ? _color : @"?";
}
-(void)setColor:(NSString *)color{
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
}
@synthesize number = _number;
-(NSInteger)number{
    return _number ? _number : 0;
}
-(void)setNumber:(NSInteger)number{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

#pragma mark - Instance Methods
static const int NUMBER_OF_MATCHING_CARDS = 3;
static const int NUMBER_OF_NONMATCHING_CARDS = 1;
-(int)match:(NSArray *)otherCards{
    int score = 0;
    if ([otherCards count] == NUMBER_OF_MATCHING_CARDS - 1) {
    NSMutableSet *shapes = [[NSMutableSet alloc]initWithObjects:self.shape, nil];
    NSMutableSet *shades = [[NSMutableSet alloc]initWithObjects:self.shade, nil];
    NSMutableSet *colors = [[NSMutableSet alloc]initWithObjects:self.color, nil];
    NSMutableSet *numbers = [[NSMutableSet alloc]initWithObjects:@(self.number), nil];
        for (id otherCard in otherCards) {
            if ([otherCard isKindOfClass:[SetCard class]]) {
                SetCard *setCard = (SetCard *)otherCard;
                if (![shapes containsObject:setCard.shape]) {[shapes addObject:setCard.shape];}
                if (![shades containsObject:setCard.shade]) {[shades addObject:setCard.shade];}
                if (![colors containsObject:setCard.color]) {[colors addObject:setCard.color];}
                if (![numbers containsObject:@(setCard.number)]) {[numbers addObject:@(setCard.number)];}
            }
        }

        if (([shapes count] == NUMBER_OF_NONMATCHING_CARDS || [shapes count] == NUMBER_OF_MATCHING_CARDS) && ([shades count] == NUMBER_OF_NONMATCHING_CARDS || [shades count] == NUMBER_OF_MATCHING_CARDS) && ([colors count] == NUMBER_OF_NONMATCHING_CARDS || [colors count] == NUMBER_OF_MATCHING_CARDS) && ([numbers count] == NUMBER_OF_NONMATCHING_CARDS || [numbers count] == NUMBER_OF_MATCHING_CARDS)) {
            score = [SetCard setScore];
        }
    }
    return score;
}

#pragma mark - Class Methods
+(NSArray *)validShapes{
    return @[@"squiggly",@"diamond",@"oval"];
}
+(NSArray *)validShades{
    return @[@"solid",@"striped",@"open"];
}
+(NSArray *)validColors{
    return @[@"purple",@"blue",@"orange"];
}
+(NSInteger)maxNumber{
    return [[SetCard validShapes] count];
}
+(NSInteger)setScore{
    return 4;
}

@end

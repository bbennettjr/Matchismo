//
//  Card.h
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/15/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter=isChosen) BOOL isChosen;
@property (nonatomic, getter=isMatched) BOOL isMatched;

-(int)match:(NSArray *)otherCards;

@end

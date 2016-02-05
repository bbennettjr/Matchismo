//
//  Settings.h
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/17/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject
@property (nonatomic) int matchBonus;
@property (nonatomic) int mismatchPenalty;
@property (nonatomic) int costToChoose;

#pragma mark - Instance Methods
-(NSDictionary *)asPropertyList;

#pragma mark - Class Methods
+(Settings *)currentSettings;
+(void)resetToDefaultSettings;
+(void)setCurrentSettings:(Settings *)settings;
@end

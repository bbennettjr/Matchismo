//
//  Settings.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/17/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "Settings.h"

@interface Settings ()
@end

@implementation Settings
static NSString *const MATCH_BONUS_KEY = @"MATCH_BONUS_KEY";
static NSString *const MISMATCH_PENALTY_KEY = @"MISMATCH_PENALTY_KEY";
static NSString *const COST_TO_CHOOSE_KEY = @"COST_TO_CHOOSE_KEY";
static NSString *const CURRENT_SETTINGS_KEY = @"CURRENT_SETTINGS_KEY";
static const int DEFAULT_MATCH_BONUS = 4;
static const int DEFAULT_MISMATCH_PENALTY = 2;
static const int DEFAULT_COST_TO_CHOOSE = 1;

#pragma mark - Instance Methods
-(instancetype)init{
    self = [super init];
    if (self) {
        //no code here
    }
    return self;
}
//property list is a dictionary describing every settings object properties
-(id)asPropertyList{
    return @{ MATCH_BONUS_KEY : @(self.matchBonus),
              MISMATCH_PENALTY_KEY : @(self.mismatchPenalty),
              COST_TO_CHOOSE_KEY : @(self.costToChoose) };
}

#pragma mark - Class Methods
//class method to return a single settings object which is initialized with current settings from user defaults
+(Settings *)currentSettings{
    NSDictionary *settingsPropertyList = [[NSUserDefaults standardUserDefaults] dictionaryForKey:CURRENT_SETTINGS_KEY];
    Settings *settings = [[Settings alloc]init];
    if (settingsPropertyList) {
    settings.matchBonus = [[settingsPropertyList objectForKey:MATCH_BONUS_KEY] intValue];
    settings.mismatchPenalty = [[settingsPropertyList objectForKey:MISMATCH_PENALTY_KEY] intValue];
    settings.costToChoose = [[settingsPropertyList objectForKey:COST_TO_CHOOSE_KEY] intValue];
    } else {
        settings.matchBonus = DEFAULT_MATCH_BONUS;
        settings.mismatchPenalty = DEFAULT_MISMATCH_PENALTY;
        settings.costToChoose = DEFAULT_COST_TO_CHOOSE;
    }
    return settings;
}
+(void)resetToDefaultSettings{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CURRENT_SETTINGS_KEY];
}
//set the current settings using a settings object to user defaults
+(void)setCurrentSettings:(Settings *)settings{
    [[NSUserDefaults standardUserDefaults] setObject:[settings asPropertyList] forKey:CURRENT_SETTINGS_KEY];
}

@end

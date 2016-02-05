//
//  SettingsViewController.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/14/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *matchBonus;
@property (weak, nonatomic) IBOutlet UITextField *mismatchPenalty;
@property (weak, nonatomic) IBOutlet UITextField *costToChoose;
@property (nonatomic, weak) Settings *settings;

@end

@implementation SettingsViewController

-(Settings *)settings{
    return !_settings ? _settings = [Settings currentSettings] : _settings;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}
-(void)updateUI{
    self.settings = [Settings currentSettings];
    self.matchBonus.text = [NSString stringWithFormat:@"%d", self.settings.matchBonus];
    self.mismatchPenalty.text = [NSString stringWithFormat:@"%d", self.settings.mismatchPenalty];
    self.costToChoose.text = [NSString stringWithFormat:@"%d", self.settings.costToChoose];

}
- (IBAction)save:(UIButton *)sender {
    //Synchronize current settings
    self.settings.matchBonus = [self.matchBonus.text intValue];
    self.settings.mismatchPenalty = [self.mismatchPenalty.text intValue];
    self.settings.costToChoose = [self.costToChoose.text intValue];
    [Settings setCurrentSettings:self.settings];
    [self updateUI];
}
- (IBAction)reset:(UIButton *)sender {
    [Settings resetToDefaultSettings];
    [self updateUI];
}

@end

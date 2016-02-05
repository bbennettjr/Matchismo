//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 9/29/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *history;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self updateUI];
}

-(void)updateUI{
    self.history.attributedText = self.textToDisplay;
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.history.font = font;
}



@end

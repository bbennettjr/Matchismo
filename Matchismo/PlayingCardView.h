//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/20/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView
@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSInteger rank;
@property (nonatomic) BOOL faceUp;
@property (nonatomic) CGFloat aspectRatio;

-(void)flipCard:(UITapGestureRecognizer *)swipe;
@end

//
//  SetCardView.h
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/30/15.
//  Copyright © 2015 Rennox, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView
//A view class that displays the three shapes, colors, fills and number of a set card.
//Shapes include: squiggly, diamond, oval
//Colors include: orange, purple, blue
//Fills include: open, striped, solid
//Max number of shapes is 3, range is 1-3
@property (nonatomic, weak) NSString *shape;
@property (nonatomic, weak) NSString *shade;
@property (nonatomic, weak) NSString *color;
@property (nonatomic) NSInteger number;

//select the card tapped upon
@property (nonatomic) BOOL selected;

//scale the tapped card
-(void)selectCard:(UITapGestureRecognizer *)tap;
-(void)removeMatchedCard:(CGRect)windowBounds;

@end

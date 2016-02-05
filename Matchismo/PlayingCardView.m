//
//  PlayingCardView.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/20/15.
//  Copyright (c) 2015 Rennox, LLC. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView ()
@property (nonatomic) CGFloat faceCardScaleFactor;
@end

@implementation PlayingCardView
#pragma mark - Properties

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90
@synthesize faceCardScaleFactor = _faceCardScaleFactor;

-(CGFloat)faceCardScaleFactor{
    return !_faceCardScaleFactor ? _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR : _faceCardScaleFactor;
}
-(void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

-(void)setSuit:(NSString *)suit{
    _suit = suit;
    [self setNeedsDisplay];
}

-(void)setRank:(NSInteger)rank{
    _rank = rank;
    [self setNeedsDisplay];
}

-(void)setFaceUp:(BOOL)faceUp{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - Scaling
#define CORNER_SCALE_FACTOR 180.0
#define CORNER_RADIUS 12.0
#define CORNER_OFFSET 3.0
-(CGFloat)cornerScaleFactor{ return self.bounds.size.height / CORNER_SCALE_FACTOR; }
-(CGFloat)cornerRadius{ return [self cornerScaleFactor] * CORNER_RADIUS; }
-(CGFloat)cornerOffset{ return [self cornerRadius] / CORNER_OFFSET; }

#pragma mark - Setup & Initialization
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //setup
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:[self cornerRadius]];
    [[UIColor whiteColor] setFill];
    [[UIColor blackColor] setStroke];
    [path fill];
    [path stroke];
    [path addClip];

    //create rect using bounds of each new view to draw the images into
    CGRect imageRect = CGRectInset(self.bounds,
                                   self.bounds.size.width * (1.0-self.faceCardScaleFactor),
                                   self.bounds.size.height * (1.0-self.faceCardScaleFactor));
    if (self.faceUp) {
        UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit]];
        if (faceImage) {
            [faceImage drawInRect:imageRect];
        } else {
            //draw pips
            [self drawPips];
        }
        [self drawCorners];
    } else {
        //draw card back
        [[UIImage imageNamed:@"cardBack"] drawInRect:imageRect];
    }

}


- (void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}


#pragma mark - Pips

#define PIP_HOFFSET_PERCENTAGE 0.165
#define PIP_VOFFSET1_PERCENTAGE 0.090
#define PIP_VOFFSET2_PERCENTAGE 0.175
#define PIP_VOFFSET3_PERCENTAGE 0.270

- (void)drawPips
{
    if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:0
                        mirroredVertically:NO];
    }
    if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:0
                            verticalOffset:PIP_VOFFSET2_PERCENTAGE
                        mirroredVertically:(self.rank != 7)];
    }
    if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET3_PERCENTAGE
                        mirroredVertically:YES];
    }
    if ((self.rank == 9) || (self.rank == 10)) {
        [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                            verticalOffset:PIP_VOFFSET1_PERCENTAGE
                        mirroredVertically:YES];
    }
}

#define PIP_FONT_SCALE_FACTOR 0.012

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                          upsideDown:(BOOL)upsideDown
{
    if (upsideDown) [self pushContextAndRotateUpsideDown];
    CGPoint middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];
    NSAttributedString *attributedSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{ NSFontAttributeName : pipFont }];
    CGSize pipSize = [attributedSuit size];
    CGPoint pipOrigin = CGPointMake(
                                    middle.x-pipSize.width/2.0-hoffset*self.bounds.size.width,
                                    middle.y-pipSize.height/2.0-voffset*self.bounds.size.height
                                    );
    [attributedSuit drawAtPoint:pipOrigin];
    if (hoffset) {
        pipOrigin.x += hoffset*2.0*self.bounds.size.width;
        [attributedSuit drawAtPoint:pipOrigin];
    }
    if (upsideDown) [self popContext];
}

- (void)drawPipsWithHorizontalOffset:(CGFloat)hoffset
                      verticalOffset:(CGFloat)voffset
                  mirroredVertically:(BOOL)mirroredVertically
{
    [self drawPipsWithHorizontalOffset:hoffset
                        verticalOffset:voffset
                            upsideDown:NO];
    if (mirroredVertically) {
        [self drawPipsWithHorizontalOffset:hoffset
                            verticalOffset:voffset
                                upsideDown:YES];
    }
}

#pragma mark - Draw Corners
-(void)drawCorners{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.alignment = NSTextAlignmentCenter;

    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:(cornerFont.pointSize * [self cornerScaleFactor])];

    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",[self rankAsString], self.suit] attributes:@{ NSFontAttributeName : cornerFont, NSParagraphStyleAttributeName : paragraphStyle }];

    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [cornerText size];

    [cornerText drawInRect:textBounds];

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
    [cornerText drawInRect:textBounds];

}

#pragma mark - Gestures
-(void)flipCard:(UITapGestureRecognizer *)swipe{
    //only do for this card if the tap was inside the bounds of its card
    if (CGRectContainsPoint(self.bounds, [swipe locationInView:self])) {
        CGRect bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
        CGPoint center = CGPointMake(self.center.x, self.center.y);
        CGSize sideView = CGSizeMake(10.0, self.bounds.size.height);

        //animation to resize the card appearing as though its being flipped.
        [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.bounds = CGRectMake(center.x, center.y, sideView.width, sideView.height);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.15 delay:0.0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut) animations:^{ self.bounds = bounds; } completion:nil];

            //do not redraw the image until the card flips over (why its nested in the animation block)
            self.faceUp = !self.faceUp;
        }];
    }
}

#pragma mark - Rank as String
-(NSString *)rankAsString{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}


@end

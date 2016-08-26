//
//  SetCardView.m
//  Matchismo
//
//  Created by Bradford Bennett Jr on 10/30/15.
//  Copyright © 2015 Rennox, LLC. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView ()
@end

@implementation SetCardView
#pragma mark - Definitions
#define CONTENT_SCALE_FACTOR 180.0
#define CORNER_RADIUS 12.0
#define EDGE_OFFSET 8.0
#define SHAPE_OFFSET 4.0
#define MAX_NUMBER_OF_SHAPES 3
#define LINE_WIDTH 2.5
#define SQUIGGLY_HEIGHT 3.0
#define STRIPED_OFFSET 10.0

#pragma mark - Scaling
-(CGFloat)contentScaleFactor { return self.bounds.size.height / CONTENT_SCALE_FACTOR; }
-(CGFloat)cornerRadius{ return [self contentScaleFactor] * CORNER_RADIUS; }
-(CGFloat)offsetAboveAndBelow{ return (self.bounds.size.height - (self.number * [self shapeSize].height + (self.number - 1) * [self shapeOffset])) / 2; }
-(CGFloat)offsetLeftAndRight{ return (self.bounds.size.width - [self shapeSize].width) / 2; }
-(CGFloat)edgeOffset{ return [self contentScaleFactor] * EDGE_OFFSET; };
-(CGFloat)shapeOffset{ return [self contentScaleFactor] * SHAPE_OFFSET; }
-(CGSize)shapeSize{ return CGSizeMake(self.bounds.size.width * 2 / 3, (self.bounds.size.height - (2 * [self edgeOffset] + 2 * [self shapeOffset])) / MAX_NUMBER_OF_SHAPES); }
-(CGFloat)lineWidth{ return [self contentScaleFactor] * LINE_WIDTH; }
-(CGFloat)squigglyHeight{ return [self contentScaleFactor] * SQUIGGLY_HEIGHT; }

#pragma mark - Lazy Instantiation
@synthesize shape = _shape;
-(NSString *)shape{
    return !_shape ? _shape = [NSString stringWithFormat:@"?"] : _shape;
}
-(void)setShape:(NSString *)shape{
    _shape = shape;
    [self setNeedsDisplay];
}
@synthesize shade = _shade;
-(NSString *)shade{
    return !_shade ? _shade = [NSString stringWithFormat:@"?"] : _shade;
}
-(void)setShade:(NSString *)shade{
    _shade = shade;
    [self setNeedsDisplay];
}
@synthesize color = _color;
-(NSString *)color{
    return !_color ? _color = [NSString stringWithFormat:@"?"] : _color;
}
-(void)setColor:(NSString *)color{
    _color = color;
    [self setNeedsDisplay];
}
@synthesize number = _number;
-(NSInteger)number{
    return !_number ? _number = 0 : _number;
}
-(void)setNumber:(NSInteger)number{
    _number = number;
    [self setNeedsDisplay];
}
-(void)setTransform:(CGAffineTransform)transform{
    [super setTransform:transform];
    [self setNeedsDisplay];
}

#pragma mark - Initalization
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code create the card
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:[self cornerRadius]];
    [[UIColor whiteColor] setFill];
    [[UIColor blackColor] setStroke];
    [path addClip];
    [path fill]; [path stroke];

    //draw the face of each card
    [self drawFace];
}

//draw the face of each card
-(void)drawFace{
    [self drawShapes];
}

static const CGFloat rectInsetValueX = 20.0;
static const CGFloat rectInsetValueY = 10.0;
//draw the shape shown on each card
-(void)drawShapes{
    for (NSValue *rect in [self rectsForShapesInBounds]) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);

        UIBezierPath *path;

        if ([self.shape isEqualToString:@"squiggly"]) {
            path = [self drawSquigglyForRect:rect];
        }
        if ([self.shape isEqualToString:@"diamond"]) {
            path = [self drawDiamondForRect:rect];
        }
        if ([self.shape isEqualToString:@"oval"]) {
            path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset([rect CGRectValue], rectInsetValueX, rectInsetValueY)];
        }


        //draw the shades in each of the shapes
        [self drawShadesInPath:path forRect:rect];
        CGContextRestoreGState(context);
    }
}

//draw the fill on each card
-(void)drawShadesInPath:(UIBezierPath *)path forRect:(NSValue *)rect{
    path.lineWidth = [self lineWidth];

    if ([self.shade isEqualToString:@"open"]) {
        //only stroke the path at the end
        [[self drawColor] setStroke]; [path stroke];
    }
    if ([self.shade isEqualToString:@"striped"]) {
        //stroke the path first, otherwise if you do it later, you cannot control the line width
        [[self drawColor] setStroke]; [path stroke];
        [path addClip];

        CGRect newRect = [rect CGRectValue];
        UIBezierPath *stripedPath = [[UIBezierPath alloc]init];
        stripedPath.lineWidth = [self lineWidth];
        //lines angled and incremented through the shape
        for (CGFloat xIndex = newRect.origin.x; xIndex < (newRect.origin.x + newRect.size.width); xIndex += STRIPED_OFFSET) {
            [stripedPath moveToPoint:CGPointMake(xIndex, newRect.origin.y + newRect.size.height)];
            [stripedPath addLineToPoint:CGPointMake(xIndex + STRIPED_OFFSET, newRect.origin.y)];
        }
        [[self drawColor] setStroke]; [stripedPath stroke];
    }
    if ([self.shade isEqualToString:@"solid"]) {
        [[self drawColor] setFill]; [path fill];
        [[self drawColor] setStroke]; [path stroke];
    }
}

//set the color of each shape and fill
-(UIColor *)drawColor{
    if ([self.color isEqualToString:@"orange"]) return [UIColor orangeColor];
    if ([self.color isEqualToString:@"purple"]) return [UIColor purpleColor];
    if ([self.color isEqualToString:@"blue"]) return [UIColor blueColor];
    return [UIColor blackColor]; //know error
}


static const CGFloat leftOfCenterControlPointScaleX = 21.0/48.0;
static const CGFloat topOfCenterControlPointScaleY = 7.0/16.0;
static const CGFloat rightOfCenterControlPointScaleX = 27.0/48.0;
static const CGFloat bottomOfCenterControlPointScaleY = 9.0/16.0;
-(UIBezierPath *)drawDiamondForRect:(NSValue *)rect{
    //declarations
    UIBezierPath *path = [[UIBezierPath alloc]init];
    CGRect newRect = [rect CGRectValue];

    //lines to draw the diamond shape.  Use quad curve function to add slight curves to the sides
    //left point
    [path moveToPoint:CGPointMake(newRect.origin.x + newRect.size.width / 3, newRect.origin.y + newRect.size.height / 2)];
    //top point
    [path addQuadCurveToPoint:CGPointMake(newRect.origin.x + newRect.size.width / 2, newRect.origin.y) controlPoint:CGPointMake(newRect.origin.x + newRect.size.width * leftOfCenterControlPointScaleX, newRect.origin.y + newRect.size.height * topOfCenterControlPointScaleY)];
    //right point
    [path addQuadCurveToPoint:CGPointMake(newRect.origin.x + newRect.size.width * 2 / 3, newRect.origin.y + newRect.size.height / 2) controlPoint:CGPointMake(newRect.origin.x + newRect.size.width * rightOfCenterControlPointScaleX, newRect.origin.y + newRect.size.height * topOfCenterControlPointScaleY)];
    //bottom point
    [path addQuadCurveToPoint:CGPointMake(newRect.origin.x + newRect.size.width / 2,  newRect.origin.y + newRect.size.height) controlPoint:CGPointMake(newRect.origin.x + newRect.size.width * rightOfCenterControlPointScaleX, newRect.origin.y + newRect.size.height * bottomOfCenterControlPointScaleY)];
    //close to left point
    [path addQuadCurveToPoint:CGPointMake(newRect.origin.x + newRect.size.width / 3, newRect.origin.y + newRect.size.height / 2) controlPoint:CGPointMake(newRect.origin.x + newRect.size.width * leftOfCenterControlPointScaleX, newRect.origin.y + newRect.size.height * bottomOfCenterControlPointScaleY)];
 return path;
}

static const CGFloat squigglyLeftControlPointX = 3.0/8.0;
static const CGFloat squigglyRightControlPointX = 5.0/8.0;
-(UIBezierPath *)drawSquigglyForRect:(NSValue *)rect{
    //declarations
    UIBezierPath *path = [[UIBezierPath alloc]init];
    CGRect newRect = [rect CGRectValue];

    //lines to draw the squiggly
    //left most point
    [path moveToPoint:CGPointMake(newRect.origin.x + newRect.size.width / 5, newRect.origin.y + newRect.size.height / 4)];
    //center
    [path addQuadCurveToPoint:CGPointMake(newRect.origin.x + newRect.size.width / 2, newRect.origin.y + newRect.size.height / 4) controlPoint:CGPointMake(newRect.origin.x + newRect.size.width * squigglyLeftControlPointX, newRect.origin.y)];
    //right point
    [path addQuadCurveToPoint:CGPointMake(newRect.origin.x + newRect.size.width * 4 / 5, newRect.origin.y + newRect.size.height / 4) controlPoint:CGPointMake(newRect.origin.x + newRect.size.width * squigglyRightControlPointX, newRect.origin.y + newRect.size.height / 2)];
    //move stright down on the right side
    [path addLineToPoint:CGPointMake(newRect.origin.x + newRect.size.width * 4 / 5, newRect.origin.y + newRect.size.height * 3 / 4)];
    //2nd point on right, bottom line
    [path addQuadCurveToPoint:CGPointMake(newRect.origin.x + newRect.size.width / 2, newRect.origin.y + newRect.size.height * 3/ 4) controlPoint:CGPointMake(newRect.origin.x + newRect.size.width * squigglyRightControlPointX, newRect.origin.y + newRect.size.height)];
    //2nd point on left, bottom line
    [path addQuadCurveToPoint:CGPointMake(newRect.origin.x + newRect.size.width / 5, newRect.origin.y + newRect.size.height * 3 / 4) controlPoint:CGPointMake(newRect.origin.x + newRect.size.width * squigglyLeftControlPointX, newRect.origin.y + newRect.size.height / 2)];
    //move straight up on the left side
    [path closePath];
    return path;
}

//
-(NSArray *)rectsForShapesInBounds{
    NSMutableArray *rects = [[NSMutableArray alloc]init];

    //add 1, 2, or 3 CGRect structs to the array to return the drawing coordinates to the calling method
    if (self.number == 1) {
        [rects addObject:[NSValue valueWithCGRect:CGRectMake([self offsetLeftAndRight], [self offsetAboveAndBelow], [self shapeSize].width, [self shapeSize].height)]];
    }
    if (self.number == 2) {
        [rects addObject:[NSValue valueWithCGRect:CGRectMake([self offsetLeftAndRight], [self offsetAboveAndBelow], [self shapeSize].width, [self shapeSize].height)]];
        [rects addObject:[NSValue valueWithCGRect:CGRectMake([self offsetLeftAndRight], [self offsetAboveAndBelow] + [self shapeOffset] + [self shapeSize].height, [self shapeSize].width, [self shapeSize].height)]];
    }
    if (self.number == 3) {
        [rects addObject:[NSValue valueWithCGRect:CGRectMake([self offsetLeftAndRight], [self offsetAboveAndBelow], [self shapeSize].width, [self shapeSize].height)]];
        [rects addObject:[NSValue valueWithCGRect:CGRectMake([self offsetLeftAndRight], [self offsetAboveAndBelow] + [self shapeOffset] + [self shapeSize].height, [self shapeSize].width, [self shapeSize].height)]];
        [rects addObject:[NSValue valueWithCGRect:CGRectMake([self offsetLeftAndRight], [self offsetAboveAndBelow] + 2 * ([self shapeOffset] + [self shapeSize].height), [self shapeSize].width, [self shapeSize].height)]];
    }
    return rects;
}

#define SCALE_CARDS_DOWN 0.75
#define SCALE_CARDS_NORMAL 1.0
-(void)selectCard:(UITapGestureRecognizer *)tap{
    //if the tap is located in the view of this card, do the card selection animation.  The animation is to rotate 180 degrees clockwise and scale down to signify selection.  Then scale back up and un-rotate back to normal to signify not being selected.

    if (CGRectContainsPoint(self.bounds, [tap locationInView:self])) {
        self.selected = !self.selected;
        /** Testing how to animate the match **/
        __weak SetCardView *weakself = self;
        /** Testing how to animate the match **/
        if (self.selected) {
                [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut animations:^{
                self.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(M_PI), CGAffineTransformMakeScale(SCALE_CARDS_DOWN, SCALE_CARDS_DOWN));
                } completion:^(BOOL finished){
                    [weakself removeMatchedCard];
                }];
        } else {
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut animations:^{
                self.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(0.000001), CGAffineTransformMakeScale(SCALE_CARDS_NORMAL, SCALE_CARDS_NORMAL));
            } completion:nil];
        }
    }
}

    //Remove the cards from the view by translating within the context reference
-(void)removeMatchedCard{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(-1000, -1000);
    }];
}

@end

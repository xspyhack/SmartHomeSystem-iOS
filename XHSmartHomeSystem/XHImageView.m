//
//  XHImageView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 4/12/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHImageView.h"

@interface XHImageView ()
@property (nonatomic) CGFloat imageScaleFactor;
@end

@implementation XHImageView

#pragma mark - Properties

@synthesize imageScaleFactor = _imageScaleFactor;
@synthesize lineWidth = _lineWidth;

#define DEFAULT_USER_IMAGE_SCALE_FACTOR 1

- (CGFloat)imageScaleFactor
{
    if (!_imageScaleFactor) _imageScaleFactor = DEFAULT_USER_IMAGE_SCALE_FACTOR;
    return _imageScaleFactor;
}

- (void)setImageScaleFactor:(CGFloat)imageScaleFactor
{
    _imageScaleFactor = imageScaleFactor;
    [self setNeedsDisplay];
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (CGFloat)lineWidth
{
    if (!_lineWidth)
        _lineWidth = 3;
    return _lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 80.0
#define CORNER_RADIUS 80.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:self.bounds.size.width/2-1 startAngle:- M_PI_2 endAngle:(M_PI * 2) * _progress - M_PI_2 clockwise:YES];;
    
    arcLayer = [CAShapeLayer layer];
    arcLayer.path = path.CGPath;//46,169,230
    
    arcLayer.fillColor = [UIColor colorWithWhite:1 alpha:0].CGColor;
    arcLayer.strokeColor = self.color.CGColor;
    arcLayer.lineWidth = self.lineWidth;
    //arcLayer.frame = self.frame;
    [self.layer addSublayer:arcLayer];

    UIImage *faceImage = [UIImage imageNamed:self.imageName];
    if (faceImage) {
        CGRect imageRect = CGRectInset(self.bounds,
                                       self.bounds.size.width * (1.0 - self.imageScaleFactor),
                                       self.bounds.size.height * (1.0 - self.imageScaleFactor));
        
        UIBezierPath *faceRect = [UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:[self cornerRadius]];
        [faceRect addClip];
        [faceImage drawInRect:imageRect];
    }
}

-(void)drawLineAnimationWithLayer:(CALayer*)layer duration:(CGFloat)time
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = time;
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    
    [layer addAnimation:bas forKey:@"key"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //[self drawProgressBackground];
    //if (animation)
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"playWell" object:self];
    //NSLog(@"post Notification");
}

- (void)animationDidStart:(CAAnimation *)anim
{
}

- (void)drawProgressBackground
{
    arcLayer.strokeColor = [UIColor whiteColor].CGColor;
    //[self.layer addSublayer:self.arcLayer];
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    [self.color setFill];
    UIRectFill(self.bounds);
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setUp];
}

@end

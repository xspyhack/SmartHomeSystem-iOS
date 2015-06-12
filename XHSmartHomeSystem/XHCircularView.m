//
//  XHCircularView.m
//  XHSmartHomeSystem
//
//  Created by bl4ckra1sond3tre on 6/7/15.
//  Copyright (c) 2015 bl4ckra1sond3tre. All rights reserved.
//

#import "XHCircularView.h"

#define TITLE_HEIGHT (self.bounds.size.height - self.bounds.size.width)

@interface XHCircularView () {
    CAShapeLayer *_arcLayer;
    UIBezierPath *_path;
}
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation XHCircularView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.lineWidth = 10.0f;
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    _path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.width/2) radius:self.bounds.size.width/2-1 startAngle:-M_PI_2 endAngle:(M_PI * 2) * _progress - M_PI_2 clockwise:YES];;
    
    _arcLayer = [CAShapeLayer layer];
    _arcLayer.path = _path.CGPath;//46,169,230
    
    _arcLayer.fillColor = [UIColor colorWithWhite:1 alpha:0].CGColor;
    _arcLayer.strokeColor = [self.color colorWithAlphaComponent:.7].CGColor;
    //_arcLayer.edgeAntialiasingMask = YES;
    //_arcLayer.allowsEdgeAntialiasing = YES;
    
    _arcLayer.lineWidth = self.lineWidth;
    //_arcLayer.lineCap = @"square";
    //_arcLayer.lineJoin = @"bevel";
    //arcLayer.frame = self.frame;
    [self.layer addSublayer:_arcLayer];

    [self drawLineAnimationWithLayer:_arcLayer duration:self.progress];
}

- (void)drawLineAnimationWithLayer:(CALayer *)layer duration:(CGFloat)second
{
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = second;
    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    
    [layer addAnimation:bas forKey:@"key"];
}

- (void)setValue:(CGFloat)value
{
    _value = value;
    self.valueLabel.text = [NSString stringWithFormat:@"%.2f", value];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (UILabel *)valueLabel
{
    if (!_valueLabel) {
        CGRect frame = CGRectMake(0, 0, self.frame.size.width, (self.frame.size.height - TITLE_HEIGHT));
        _valueLabel = [[UILabel alloc] initWithFrame:frame];
        _valueLabel.textColor = self.color;
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        _valueLabel.font = [UIFont systemFontOfSize:self.bounds.size.width / 5];
        [self addSubview:_valueLabel];
    }
    return _valueLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGRect frame = CGRectMake(0, self.bounds.size.width, self.frame.size.width, 50);
        _titleLabel = [[UILabel alloc] initWithFrame:frame];
        _titleLabel.textColor = self.color;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:self.bounds.size.width / 5];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end

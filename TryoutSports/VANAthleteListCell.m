//
//  VANAthleteListCell.m
//  Tryout Sports
//
//  Created by Aaron VandenBrink on 2013-05-17.
//  Copyright (c) 2013 Aaron VandenBrink. All rights reserved.
//
//  With code taken and adjusted from the project at : https://github.com/alikaragoz/MCSwipeTableViewCell
//

static CGFloat const kStop1 = 0.35;
static CGFloat const kBounceAmplitude = 20.0;
static NSTimeInterval const kBounceDuration1 = 0.2;
static NSTimeInterval const kBounceDuration2 = 0.1;
static NSTimeInterval const kDurationLowLimit = 0.25;
static NSTimeInterval const kDurationHighLimit = 0.1;

#import "VANAthleteListCell.h"
#import "VANTeamColor.h"

@interface VANAthleteListCell () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) swipeTableViewCellDirection direction;
@property (nonatomic, assign) CGFloat currentPercentage;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UIView *colorView;
@property (strong, nonatomic) UILabel *colorViewLabel;

@end

@implementation VANAthleteListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initializer {
    if (!_colorView) {
        _colorView = [[UIView alloc] initWithFrame:self.bounds];
        [_colorView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        _colorView.backgroundColor = [UIColor clearColor];
        [self insertSubview:_colorView atIndex:0];
    }
    if (!_colorViewLabel) {
        CGRect labelFrame = CGRectMake(0, 0, _colorView.bounds.size.width/3, _colorView.bounds.size.height);
        _colorViewLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _colorViewLabel.textAlignment = NSTextAlignmentCenter;
        [_colorViewLabel setContentMode:UIViewContentModeCenter];
        [_colorView addSubview:_colorViewLabel];
        _colorViewLabel.text = @"Flag";
        _colorViewLabel.textColor = [UIColor whiteColor];
        _colorViewLabel.alpha = 0.0f;
    }
    
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
        [self addGestureRecognizer:_panGesture];
        _panGesture.delegate = self;
    }
    
    _isDragging = NO;
    
    _shouldDrag = YES;
    
    _firstTrigger = kStop1;
    
    _modeForState1 = swipeTableViewCellModeNone;
    _modeForState2 = swipeTableViewCellModeNone;
    _modeForState3 = swipeTableViewCellModeNone;
    _modeForState4 = swipeTableViewCellModeNone;
}



-(void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)gesture {
    
    if (!_shouldDrag) return;
    
    UIGestureRecognizerState state = [gesture state];
    
    CGPoint translation = [gesture translationInView:self];
    CGPoint velocity = [gesture velocityInView:self];
    CGFloat percentage = [self percentageWithOffset:CGRectGetMinX(self.contentView.frame) relativeToWidth:CGRectGetWidth(self.bounds)];
    NSTimeInterval animationDuration = [self animationDurationWithVelocity:velocity];
    _direction = [self directionWithPercentage:percentage];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        _isDragging = YES;
        
        CGPoint center = {self.contentView.center.x + translation.x, self.contentView.center.y};
        [self.contentView setCenter:center];
        [self  animateWithOffset:CGRectGetMinX(self.contentView.frame)];
        [gesture setTranslation:CGPointZero inView:self];
        
        if ([_delegate respondsToSelector:@selector(swipeTableViewCell:didSwipeWithPercentage:)]) {
            [_delegate swipeTableViewCell:self didSwipeWithPercentage:percentage];
        }
    } else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
        _isDragging = NO;
        
        _currentPercentage = percentage;
        
        swipeTableViewCellState cellState = [self stateWithPercentage:percentage];
        
        swipeTableViewCellMode cellMode;
        
        if (cellState == swipeTableViewCellState1 && self.modeForState1 != swipeTableViewCellModeNone) {
            cellMode = self.modeForState1;
        } else if (cellState == swipeTableViewCellState2 && self.modeForState2 != swipeTableViewCellModeNone) {
            cellMode = self.modeForState2;
        } else if (cellState == swipeTableViewCellState3 && self.modeForState3 != swipeTableViewCellModeNone) {
            cellMode = self.modeForState3;
        } else if (cellState == swipeTableViewCellState4 && self.modeForState4 != swipeTableViewCellModeNone) {
            cellMode = self.modeForState4;
        } else {
            cellMode = self.mode;
        }
        
        if (cellMode == swipeTableViewCellModeExit && _direction != swipeTableViewCellDirectionCenter) {
            [self moveWithDuration:animationDuration andDirection:_direction];
        } else {
            __weak VANAthleteListCell *weakSelf = self;
            [self swipeToOriginWithCompletion:^{
                __strong VANAthleteListCell *strongSelf = weakSelf;
                [strongSelf notifyDelegate];
            }];
        }
        
    }
    
    
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer class] == [UIPanGestureRecognizer class]) {
        
        UIPanGestureRecognizer *g = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [g velocityInView:self];
        if (fabs(point.x) > fabs(point.y)) {
            if (point.x < 0.1 && point.x > -0.1) {
                return NO;
            }

            if ([_delegate respondsToSelector:@selector(swipeTableViewCellDidStartSwiping:)]) {
                [_delegate swipeTableViewCellDidStartSwiping:self];
            }
        return YES;
        }
    }
    return NO;
}


- (CGFloat)percentageWithOffset:(CGFloat)offset relativeToWidth:(CGFloat)width {
    CGFloat percentage = offset / width;
    
    if (percentage < -1.0) percentage = -1.0;
    else if (percentage > 1.0) percentage = 1.0;
    
    return percentage;
}

- (NSTimeInterval)animationDurationWithVelocity:(CGPoint)velocity {
    CGFloat width = CGRectGetWidth(self.bounds);
    NSTimeInterval animationDurationDiff = kDurationHighLimit - kDurationLowLimit;
    CGFloat horizontalVelocity = velocity.x;
    
    if (horizontalVelocity < -width) horizontalVelocity = -width;
    else if (horizontalVelocity > width) horizontalVelocity = width;
    
    return (kDurationHighLimit + kDurationLowLimit) - fabs(((horizontalVelocity / width) * animationDurationDiff));
}

- (swipeTableViewCellDirection)directionWithPercentage:(CGFloat)percentage {
    if (percentage < 0)
        return swipeTableViewCellDirectionLeft;
    else if (percentage > 0)
        return swipeTableViewCellDirectionRight;
    else
        return swipeTableViewCellDirectionCenter;
}

- (UIColor *)colorWithPercentage:(CGFloat)percentage {
    UIColor *color;

    //Dont need this fancy yet...
    /*
    // Background Color
    if (percentage >= _firstTrigger && percentage < _secondTrigger)
        color = _firstColor;
    else if (percentage >= _secondTrigger)
        color = _secondColor;
    else if (percentage < -_firstTrigger && percentage > -_secondTrigger)
        color = _thirdColor;
    else if (percentage <= -_secondTrigger)
        color = _fourthColor;
    else
        color = self.defaultColor ? self.defaultColor : [UIColor clearColor];
    */
    
    
    //With only One trigger
    if (percentage >= _firstTrigger) {
        if (_isFlagged) {
            color = [UIColor darkGrayColor];
            _colorViewLabel.alpha = 1.0f;
            _colorViewLabel.text = @"Remove Flag";
        } else {
            VANTeamColor *team = [[VANTeamColor alloc] init];
            color = [team findTeamColor];
            _colorViewLabel.alpha = 1.0f;
            _colorViewLabel.text = @"Flag";
        }
    } else {
        color = [UIColor lightGrayColor];
        _colorViewLabel.alpha = 0.0f;
    }
    return color;
}

- (swipeTableViewCellState)stateWithPercentage:(CGFloat)percentage {
    swipeTableViewCellState state;
    
    state = swipeTableViewCellStateNone;
    
    if (percentage >= _firstTrigger) {
        if (_isFlagged) {
             state = swipeTableViewCellState2;
        } else {
            state = swipeTableViewCellState1;
        }
    } else if (percentage <= -_firstTrigger)
        state = swipeTableViewCellState3;
    return state;
}


#pragma mark - Movement

- (void)animateWithOffset:(CGFloat)offset {
    CGFloat percentage = [self percentageWithOffset:offset relativeToWidth:CGRectGetWidth(self.bounds)];
    
    // Image Name
//    NSString *imageName = [self imageNameWithPercentage:percentage];
    
    // Image Position
 //   if (imageName != nil) {
 //       [_slidingImageView setImage:[UIImage imageNamed:imageName]];
 //       [_slidingImageView setAlpha:[self imageAlphaWithPercentage:percentage]];
//        [self slideImageWithPercentage:percentage imageName:imageName isDragging:self.shouldAnimatesIcons];
//    }
    
    // Color
    UIColor *color = [self colorWithPercentage:percentage];
    if (color != nil) {
        [_colorView setBackgroundColor:color];
    }
}

- (void)moveWithDuration:(NSTimeInterval)duration andDirection:(swipeTableViewCellDirection)direction {
    CGFloat origin;
    
    if (direction == swipeTableViewCellDirectionLeft)
        origin = -CGRectGetWidth(self.bounds);
    else
        origin = CGRectGetWidth(self.bounds);
    
 //   CGFloat percentage = [self percentageWithOffset:origin relativeToWidth:CGRectGetWidth(self.bounds)];
    CGRect rect = self.contentView.frame;
    rect.origin.x = origin;
    
    // Color
    UIColor *color = [self colorWithPercentage:_currentPercentage];
    if (color != nil) {
        [_colorView setBackgroundColor:color];
    }
    
    [UIView animateWithDuration:duration delay:0.0 options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction) animations:^{
        [self.contentView setFrame:rect];

    } completion:^(BOOL finished) {
        [self notifyDelegate];
    }];
}


- (void)swipeToOriginWithCompletion:(void(^)(void))completion {
    CGFloat bounceDistance = kBounceAmplitude * _currentPercentage;
    
    [UIView animateWithDuration:kBounceDuration1 delay:0 options:(UIViewAnimationOptionCurveEaseOut) animations:^{
        
        CGRect frame = self.contentView.frame;
        frame.origin.x = -bounceDistance;
        [self.contentView setFrame:frame];
        
        // Setting back the color to the default
        _colorView.backgroundColor = self.defaultColor;
        
    } completion:^(BOOL finished1) {
        
        [UIView animateWithDuration:kBounceDuration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            CGRect frame = self.contentView.frame;
            frame.origin.x = 0;
            [self.contentView setFrame:frame];
            
            // Clearing the indicator view
            _colorView.backgroundColor = [UIColor clearColor];
            
        } completion:^(BOOL finished2) {
            if (completion) {
                completion();
            }
        }];
    }];
}


- (void)notifyDelegate {
    swipeTableViewCellState state = [self stateWithPercentage:_currentPercentage];
    
    swipeTableViewCellMode mode = self.mode;
    
    if (mode == swipeTableViewCellModeNone) {
        switch (state) {
            case swipeTableViewCellState1: {
                mode = self.modeForState1;
            } break;
                
            case swipeTableViewCellState2: {
                mode = self.modeForState2;
            } break;
                
            case swipeTableViewCellState3: {
                mode = self.modeForState3;
            } break;
                
            case swipeTableViewCellState4: {
                mode = self.modeForState4;
            } break;
                
            default:
                break;
        }
    }
    
    // We notify the delegate that we just ended dragging
    if ([_delegate respondsToSelector:@selector(swipeTableViewCellDidEndSwiping:)]) {
        [_delegate swipeTableViewCellDidEndSwiping:self];
    }
    
    // This is only called if a state has been triggered
    if (state != swipeTableViewCellStateNone) {
        if ([_delegate respondsToSelector:@selector(swipeTableViewCell:didEndSwipingSwipingWithState:mode:)]) {
            [_delegate swipeTableViewCell:self didEndSwipingSwipingWithState:state mode:mode];
        }
    }
}

@end

//
//  LyricViewCell.m
//  LyricScrollDemo
//
//  Created by jj L on 2017/6/1.
//  Copyright © 2017年 jj L. All rights reserved.
//

#import "LyricViewCell.h"
#import "Masonry.h"
#import "LXMLyricsLabel.h"

static const CGFloat CellHorizontalPadding = 20;
static const CGFloat CellVerticalPadding = 8;

static const NSInteger LyricFont = 15;

@interface LyricViewCell ()

@property (nonatomic, strong) LXMLyricsLabel *label;

@end

@implementation LyricViewCell

+ (instancetype)reusableCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier {
    id cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
//        [self setupMaskLayer];
    }
    return self;
}

- (void)setupSubviews {
    self.label = [[LXMLyricsLabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.label.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, self.center.y);
    self.label.font = [UIFont systemFontOfSize:LyricFont];
    self.label.maskLabel.textColor = [UIColor greenColor];
    self.label.textLabel.textColor = [UIColor grayColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.maskLabel.numberOfLines = 0;
    self.label.textLabel.numberOfLines = 0;
    [self.contentView addSubview:self.label];
    
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.label.superview);
////        make.left.equalTo(self.label.superview).offset(CellHorizontalPadding);
////        make.right.equalTo(self.label.superview).offset(-CellHorizontalPadding);
//    }];
}

+ (CGFloat)cellHeightWithText:(NSString *)text {
    return ceil([text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - CellHorizontalPadding * 2, FLT_MAX)
                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:LyricFont]}
                                   context:nil].size.height + CellVerticalPadding * 2);
}

+ (CGFloat)lyricWidthWithText:(NSString *)text {
    CGFloat textWidth = ceil([text boundingRectWithSize:CGSizeMake(FLT_MAX, 0)
                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:LyricFont]}
                                                context:nil].size.width);
    return MIN(textWidth, [UIScreen mainScreen].bounds.size.width - CellHorizontalPadding * 2);
}



- (void)bindDataWithText:(NSString *)text highlighted:(BOOL)highlighted duration:(CGFloat)duration {
    self.label.text = text;
    if (highlighted) {
        [self.label startLyricsAnimationWithTimeArray:@[@(0), @(0.01 * duration), @(0.99 * duration), @(duration)] andLocationArray:@[@(0), @(0.3), @(0.7), @(1)]];
    } else {
        [self.label stopAnimation];
    }
//    self.label.textColor = highlighted ? [UIColor greenColor] : [UIColor grayColor];
//    self.label.textColor = [UIColor grayColor];
//    if (highlighted) {
//        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
////        animation.keyTimes = keyTimes;
////        animation.values = values;
//        animation.duration = duration;
//        animation.calculationMode = kCAAnimationLinear;
//        animation.fillMode = kCAFillModeForwards;
//        animation.removedOnCompletion = NO;
//        [self.maskLayer addAnimation:animation forKey:@"MaskAnimation"];
//    }
}

@end

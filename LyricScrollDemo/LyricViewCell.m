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
#import "LyricUtils.h"

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayStatusNotificationHandler:) name:@"MusicPlayStatus" object:nil];
    }
    return self;
}

- (void)setupSubviews {
    self.label = [[LXMLyricsLabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 34)];
    self.label.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, self.center.y);
    self.label.font = [UIFont systemFontOfSize:LyricFont];
    self.label.maskLabel.textColor = [UIColor greenColor];
    self.label.textLabel.textColor = [UIColor grayColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.label];
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
    NSString *pattern = @"\\(\\d+,\\d+\\)";
    NSMutableString *tempText = [text mutableCopy];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    [regex replaceMatchesInString:tempText options:0 range:NSMakeRange(0, text.length) withTemplate:@""];
    self.label.text = [tempText copy];
    
    if (highlighted) {
        NSArray *timeArray = [LyricUtils timeArrayWithLyricLine:text];
        NSArray *locationArray = [LyricUtils locationArrayWithLyricLine:text];
        NSLog(@"%@", timeArray);
        NSLog(@"%@", locationArray);
        if (timeArray.count <= 1) {
            timeArray = @[@0, @(duration)];
            locationArray = @[@0, @1];
        }
        [self.label startLyricsAnimationWithTimeArray:timeArray andLocationArray:locationArray];
    } else {
        [self.label stopAnimation];
    }
}

- (void)musicPlayStatusNotificationHandler:(NSNotification *)notification {
    BOOL play = [notification.userInfo[@"play"] boolValue];
    if (play) {
        [self.label resumeAnimation];
    } else {
        [self.label pauseAnimation];
    }
}

@end

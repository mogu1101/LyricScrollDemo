//
//  LyricViewCell.m
//  LyricScrollDemo
//
//  Created by jj L on 2017/6/1.
//  Copyright © 2017年 jj L. All rights reserved.
//

#import "LyricViewCell.h"
#import "Masonry.h"

static const CGFloat CellHorizontalPadding = 20;
static const CGFloat CellVerticalPadding = 8;

static const NSInteger LyricFont = 15;

@interface LyricViewCell ()

@property (nonatomic, strong) UILabel *label;

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
    }
    return self;
}

- (void)setupSubviews {
    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont systemFontOfSize:LyricFont];
    self.label.textColor = [UIColor grayColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.label];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.label.superview);
        make.left.equalTo(self.label.superview).offset(CellHorizontalPadding);
        make.right.equalTo(self.label.superview).offset(-CellHorizontalPadding);
    }];
}

+ (CGFloat)cellHeightWithText:(NSString *)text {
    return ceil([text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - CellHorizontalPadding * 2, FLT_MAX)
                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:LyricFont]}
                                   context:nil].size.height);
}

- (void)bindDataWithText:(NSString *)text highlighted:(BOOL)highlighted {
    self.label.text = text;
    self.label.textColor = highlighted ? [UIColor greenColor] : [UIColor grayColor];
}

@end

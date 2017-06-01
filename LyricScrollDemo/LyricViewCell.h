//
//  LyricViewCell.h
//  LyricScrollDemo
//
//  Created by jj L on 2017/6/1.
//  Copyright © 2017年 jj L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricViewCell : UITableViewCell

+ (instancetype)reusableCellWithTableView:(UITableView *)tableView reuseIdentifier:(NSString *)reuseIdentifier;

+ (CGFloat)cellHeightWithText:(NSString *)text;

- (void)bindDataWithText:(NSString *)text highlighted:(BOOL)highlighted;

@end

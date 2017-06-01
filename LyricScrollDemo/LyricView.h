//
//  LyricView.h
//  LyricScrollDemo
//
//  Created by jj L on 2017/6/1.
//  Copyright © 2017年 jj L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricView : UIView

- (void)bindDataWithLyricArray:(NSArray<NSString *> *)lyricArray playingLine:(NSInteger)playingLine duration:(CGFloat)duration;

@end

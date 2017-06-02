//
//  LyricUtils.h
//  LyricScrollDemo
//
//  Created by jj L on 2017/6/1.
//  Copyright © 2017年 jj L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LyricUtils : NSObject

+ (NSArray<NSNumber *> *)timeArrayWithLyric:(NSString *)lyric;

+ (NSArray<NSString *> *)lyricArrayWithLyric:(NSString *)lyric;

+ (NSArray<NSNumber *> *)timeArrayWithLyricLine:(NSString *)line;

+ (NSArray<NSNumber *> *)locationArrayWithLyricLine:(NSString *)line;

@end

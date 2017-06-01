//
//  LyricUtils.m
//  LyricScrollDemo
//
//  Created by jj L on 2017/6/1.
//  Copyright © 2017年 jj L. All rights reserved.
//

#import "LyricUtils.h"

@implementation LyricUtils

+ (NSArray<NSNumber *> *)timeArrayWithLyric:(NSString *)lyric {
    NSMutableArray<NSNumber *> *timeArray = [NSMutableArray array];
    NSArray<NSString *> *lineArray = [lyric componentsSeparatedByString:@"\n"];
    for (NSString *line in lineArray) {
        NSArray *array = [line componentsSeparatedByString:@"]"];
        if ([array[0] length] > 8) {
            NSString *str1 = [line substringWithRange:NSMakeRange(3, 1)];
            NSString *str2 = [line substringWithRange:NSMakeRange(6, 1)];
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
//                NSString *lrcString = [array lastObject];
                NSNumber *lrcTime = [self timeToSecond:[array[0] substringWithRange:NSMakeRange(1, 8)]];
                [timeArray addObject:lrcTime];
            }
        }
    }
    return [timeArray copy];
}

+ (NSArray<NSString *> *)lyricArrayWithLyric:(NSString *)lyric {
    NSMutableArray<NSString *> *lrcArray = [NSMutableArray array];
    NSArray<NSString *> *lineArray = [lyric componentsSeparatedByString:@"\n"];
    for (NSString *line in lineArray) {
        NSArray *array = [line componentsSeparatedByString:@"]"];
        if ([array[0] length] > 8) {
            NSString *str1 = [line substringWithRange:NSMakeRange(3, 1)];
            NSString *str2 = [line substringWithRange:NSMakeRange(6, 1)];
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                NSString *lrcString = [array lastObject];
//                NSNumber *lrcTime = [self timeToSecond:[array[0] substringWithRange:NSMakeRange(1, 5)]];
                [lrcArray addObject:lrcString];
            }
        }
    }
    return [lrcArray copy];
}

+ (NSNumber *)timeToSecond:(NSString *)timeString {
    if ([[timeString substringWithRange:NSMakeRange(2, 1)] isEqualToString:@":"] && [[timeString substringWithRange:NSMakeRange(5, 1)] isEqualToString:@"."]) {
        NSArray *array = [timeString componentsSeparatedByString:@":"];
        NSInteger min = [array[0] integerValue];
        NSArray *secArr = [array[1] componentsSeparatedByString:@"."];
        NSInteger sec = [secArr[0] integerValue];
        CGFloat msec = [secArr[1] integerValue] * 0.01;
        return @(min * 60 + sec + msec);
    }
    return nil;
}

@end

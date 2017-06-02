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

+ (NSArray<NSNumber *> *)timeArrayWithLyricLine:(NSString *)line {
    NSString *pattern = @"(\\d+,\\d+)";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray<NSTextCheckingResult *> *results = [regex matchesInString:line options:0 range:NSMakeRange(0, line.length)];
    NSMutableArray<NSNumber *> *timeArray = [NSMutableArray arrayWithObject:@0];
    [results enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull result, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *timeString = [[line substringWithRange:result.range] componentsSeparatedByString:@","][1];
        NSLog(@"%@", [line substringWithRange:result.range]);
        CGFloat time = 0;
        time = timeString.integerValue / 1000.0 + timeArray[idx].floatValue;
        [timeArray addObject:@(time)];
    }];
    return [timeArray copy];
}

+ (NSArray<NSNumber *> *)locationArrayWithLyricLine:(NSString *)line {
    NSMutableString *tempLine = [line mutableCopy];
    NSString *pattern = @"\\(\\d+,\\d+\\)";
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    [regex replaceMatchesInString:tempLine options:0 range:NSMakeRange(0, line.length) withTemplate:@"^^"];
    NSArray<NSString *> *lineComponents = [tempLine componentsSeparatedByString:@"^^"];
    NSMutableArray<NSNumber *> *locations = [NSMutableArray arrayWithObject:@0];
    __block CGFloat totalLength = 0;
    [lineComponents enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        totalLength += obj.length;
    }];
    for (NSInteger i = 0, idx = 0; i < lineComponents.count - 1; i++) {
        NSInteger length = lineComponents[i].length;
        if (length == 0) {
            continue;
        }
        [locations addObject:@((length + locations[idx].floatValue) / totalLength)];
    }
    [locations addObject:@1];
    return [locations copy];
}

@end

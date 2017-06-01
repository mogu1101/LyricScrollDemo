//
//  Track.m
//  LyricScrollDemo
//
//  Created by jj L on 2017/6/1.
//  Copyright © 2017年 jj L. All rights reserved.
//

#import "Track.h"

@implementation Track

- (NSString *)lyric {
    return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"music.lrc" ofType:nil]  encoding:NSUTF8StringEncoding error:nil];
}

@end

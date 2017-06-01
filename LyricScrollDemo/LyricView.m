//
//  LyricView.m
//  LyricScrollDemo
//
//  Created by jj L on 2017/6/1.
//  Copyright © 2017年 jj L. All rights reserved.
//

#import "LyricView.h"
#import "Masonry.h"
#import "LyricViewCell.h"

@interface LyricView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *lyricLines;
@property (nonatomic, assign) NSInteger playingLine;

@end

@implementation LyricView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lyricLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyricViewCell *cell = [LyricViewCell reusableCellWithTableView:tableView reuseIdentifier:@"lyricCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell bindDataWithText:self.lyricLines[indexPath.row] highlighted:(self.playingLine == indexPath.row)];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LyricViewCell cellHeightWithText:self.lyricLines[indexPath.row]];
}

- (void)bindDataWithLyricArray:(NSArray<NSString *> *)lyricArray playingLine:(NSInteger)playingLine {
    self.lyricLines = lyricArray;
    self.playingLine = playingLine;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:playingLine inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self.tableView reloadData];
}

@end

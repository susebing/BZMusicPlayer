//
//  BZNavagationView.m
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import "BZShowLrcView.h"
#import "BZLrcModel.h"

static NSString *cellid = @"BZShowLrcViewCellid";

@interface BZShowLrcView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray <BZLrcModel *>*lrcLines;
/**
 *  记录当前显示歌词在数组里面的index
 */
@property (nonatomic, assign) int currentIndex;

@property(nonatomic, copy) ButtonClickBlock leftBlock;
@property(nonatomic, copy) ButtonClickBlock rightBlock;

@end

@implementation BZShowLrcView

-(instancetype)initWithFrame:(CGRect)frame withLeftBlock:(ButtonClickBlock)leftBlock withRightBlock:(ButtonClickBlock)rightBlock{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorFromHexString:MainBgColorString];

        if (leftBlock) { self.leftBlock = leftBlock; }
        if (rightBlock) { self.rightBlock = rightBlock; }

        [self addSubview:self.bgImageView];
        [self addSubview:self.lrcTableView];
        [self addSubview:self.leftButton];
        [self addSubview:self.rightButton];
        [self addSubview:self.introView];
    }
    return self;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lrcLines.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

    cell.textLabel.text = self.lrcLines[indexPath.row].word;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    if (indexPath.row == self.currentIndex) {
        cell.textLabel.font = AABlodFont(30);
        cell.textLabel.textColor = [UIColor colorFromHexString:MainThemeColorString];
    }
    else{
        cell.textLabel.font = AAFont(26);
    }
    return cell;
}

#pragma mark Getter
-(UIView *)introView{
    if (!_introView) {
        _introView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 60, self.frame.size.width, 60)];
        _introView.backgroundColor = [UIColor grayColor];
        _introView.alpha = 0.7;

        [_introView addSubview:self.singerLabel];
        [_introView addSubview:self.songLabel];
    }
    return _introView;
}

-(UILabel *)songLabel{
    if (!_songLabel) {
        _songLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,5, self.frame.size.width - 40, 21)];
        _songLabel.font = AAFont(28);
        _songLabel.textColor = [UIColor whiteColor];
    }
    return _songLabel;
}

-(UILabel *)singerLabel{
    if (!_singerLabel) {
        _singerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.songLabel.frame) + 5, self.frame.size.width - 40, 21)];
        _singerLabel.font = AAFont(26);
        _singerLabel.textColor = [UIColor whiteColor];
    }
    return _singerLabel;
}

-(UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
    }
    return _bgImageView;
}

-(UITableView *)lrcTableView{
    if (!_lrcTableView) {
        _lrcTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width, self.frame.size.height - 100) style:UITableViewStylePlain];
        _lrcTableView.delegate = self;
        _lrcTableView.dataSource = self;
        [_lrcTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_lrcTableView setBackgroundColor:[UIColor clearColor]];
        [_lrcTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellid];
        _lrcTableView.hidden = YES;
    }
    return _lrcTableView;
}

-(BZSysButton *)leftButton{
    if (!_leftButton) {
        __weak typeof(self) weakSelf = self;
        _leftButton = [[BZSysButton alloc] initWithFrame:AAdaptionRect(0, 0, 82, 96)
                                            withCenter:CGPointMake(10 + 82/2, 60)
                                               WithTag:1001
                                   withNormalImageName:@"quit"
                                   withSelectImageName:@"quit"
                                       withButtonClick:^(UIButton *sender) {
                                           weakSelf.leftBlock(sender);
                                       }];
    }
    return _leftButton;
}

-(BZSysButton *)rightButton{
    if (!_rightButton) {
        __weak typeof(self) weakSelf = self;
        _rightButton = [[BZSysButton alloc] initWithFrame:AAdaptionRect(0, 0, 82, 96)
                                             withCenter:CGPointMake(self.frame.size.width - 10 - 82/2, 60)
                                                WithTag:1002
                                    withNormalImageName:@"pic_normal"
                                    withSelectImageName:@"lyric_normal" withButtonClick:^(UIButton *sender) {
                                        sender.selected = !sender.selected;
                                        weakSelf.rightBlock(sender);
                                    }];
        _rightButton.selected = YES;
    }
    return _rightButton;
}

- (NSMutableArray *)lrcLines
{
    if (_lrcLines == nil) {
        _lrcLines = [BZLrcModel lrcLinesWithFileName:self.fileName];
    }
    return _lrcLines;
}

#pragma mark Setter

- (void)setFileName:(NSString *)fileName
{
    if ([_fileName isEqualToString:fileName]) {
        return;
    }
    _fileName = [fileName copy];
    [_lrcLines removeAllObjects];
    _lrcLines = nil;
    [self.lrcTableView reloadData];
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    if (_currentTime > currentTime) {
        self.currentIndex = 0;
    }
    _currentTime = currentTime;

    int minute = currentTime / 60;
    int second = (int)currentTime % 60;
    int msecond = (currentTime - (int)currentTime) * 100;
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02d:%02d.%02d", minute, second, msecond];

    for (int i = self.currentIndex; i < self.lrcLines.count; i++) {
        BZLrcModel *currentLine = self.lrcLines[i];
        NSString *currentLineTime = currentLine.time;
        NSString *nextLineTime = nil;

        if (i + 1 < self.lrcLines.count) {
            BZLrcModel *nextLine = self.lrcLines[i + 1];
            nextLineTime = nextLine.time;
        }

        if (([currentTimeStr compare:currentLineTime] != NSOrderedAscending) && ([currentTimeStr compare:nextLineTime] == NSOrderedAscending) && (self.currentIndex != i)) {

            NSArray *reloadLines = @[
                                     [NSIndexPath indexPathForItem:self.currentIndex inSection:0],
                                     [NSIndexPath indexPathForItem:i inSection:0]
                                     ];
            self.currentIndex = i;
            [self.lrcTableView reloadRowsAtIndexPaths:reloadLines withRowAnimation:UITableViewRowAnimationNone];
            [self.lrcTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
}


@end

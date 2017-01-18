//
//  BZMusicListViewController.m
//  BZMusicPlayer
//
//  Created by zhengbing on 2017/1/17.
//  Copyright © 2017年 zhengbing. All rights reserved.
//

#import "BZMusicListViewController.h"
#import "BZMusicPlayViewController.h"
#import "BZMusicManager.h"
#import "BZMusicModel.h"

static NSString *cellid = @"musicListTableViewCellid";

@interface BZMusicListViewController ()<UITableViewDelegate, UITableViewDataSource>

/**
 播放的 Controller
 */
@property (nonatomic, strong) BZMusicPlayViewController *playingVc;

/**
 播放的 index
 */
@property (nonatomic, assign) int currentIndex;

/**
 歌曲列表表视图
 */
@property(nonatomic, strong) UITableView *musicListTableView;

/**
 歌曲数据源
 */
@property(nonatomic, strong) NSArray <BZMusicModel *> *musicListArray;

@end

@implementation BZMusicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark addSubviews
-(void)addSubviews{
    [self.view addSubview:self.musicListTableView];
}

#pragma mark UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    cell.backgroundColor = [UIColor colorFromHexString:MainBgColorString];

    cell.textLabel.text = _musicListArray[indexPath.row].name;
    cell.textLabel.font = AAFont(32);
    cell.detailTextLabel.text = _musicListArray[indexPath.row].singer;
    cell.detailTextLabel.font = AAFont(26);
    cell.imageView.image = [UIImage imageNamed:_musicListArray[indexPath.row].singerIcon];

    return cell;
}
#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    [BZMusicManager setPlayingMusic:[BZMusicManager musics][indexPath.row]];

    BZMusicModel *preMusic = [BZMusicManager musics][self.currentIndex];
    preMusic.playing = NO;
    BZMusicModel *music = [BZMusicManager musics][indexPath.row];
    music.playing = YES;
    NSArray *indexPaths = @[
                            [NSIndexPath indexPathForItem:self.currentIndex inSection:0],
                            indexPath
                            ];
    [self.musicListTableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];

    self.currentIndex = (int)indexPath.row;

    [self presentViewController:self.playingVc animated:YES completion:^{

    }];
}
#pragma mark Getter
-(BZMusicPlayViewController *)playingVc{

    if (!_playingVc) {
        _playingVc = [[BZMusicPlayViewController alloc] init];
    }
    return _playingVc;
}

-(NSArray *)musicListArray{
    if (!_musicListArray) {
        _musicListArray = [BZMusicManager musics];
    }
    return _musicListArray;
}

-(UITableView *)musicListTableView{
    if (!_musicListTableView) {
        _musicListTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _musicListTableView.dataSource = self;
        _musicListTableView.delegate = self;
    }
    return _musicListTableView;
}

@end

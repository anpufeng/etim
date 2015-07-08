//
//  ChatViewController.m
//  ETImClient
//
//  Created by Ethan on 14/9/15.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"
#import "LeftMarginTextField.h"
#import "BuddyModel.h"
#import "MsgModel.h"
#import "BuddyModel.h"
#import "ReceivedManager.h"
#import "DBManager.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;
using namespace std;

#define kToolBarH 44
#define kTextFieldH 30

@interface ChatViewController () {
    UITableView         *_tableView;
    UIImageView         *_barImgView;
}

@property (nonatomic, strong) NSMutableArray *chatList;
//存储发送消息对应的行
@property (nonatomic, strong) NSMutableDictionary *sentDic;
@property (nonatomic, assign) int toId;
@property (nonatomic, copy) NSString *toName;
//所有CELL高度和 避免一开始会话少时键盘上移
@property (nonatomic, assign) CGFloat totalCellHeight;

@end

@implementation ChatViewController

- (void)dealloc {
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithUser:(BuddyModel *)user {
    if (self = [super init]) {
        self.toId = user.userId;
        self.toName = user.username;
        
        [self initdataWithPeerId:self.toId];
    }
    
    return self;
}

- (id)initWithListMsg:(ListMsgModel *)listMsg {
    if (self = [super init]) {
        self.toId = [listMsg peerId];
        self.toName = [listMsg.lastestMsg peerName];
        
        [self initdataWithPeerId:self.toId];
    }
    
    return self;
}

- (void)initdataWithPeerId:(int)peerId {
    self.totalCellHeight = 0;
    self.chatList = [NSMutableArray array];
    self.sentDic = [NSMutableDictionary dictionary];
    NSMutableArray *msgs = [[DBManager sharedInstance] peerRecentMsgs:peerId];
    
    for (MsgModel *model in msgs) {
        ChatCellFrame *lastFrame = [self.chatList lastObject];
        ChatCellFrame *cellFrame = [[ChatCellFrame alloc] init];
        model.showTime = ![model.requestTime isEqualToString:lastFrame.message.requestTime];
        //暂时写死
        model.showTime = YES;
        cellFrame.message = model;
        [self.chatList addObject:cellFrame];
        self.totalCellHeight = self.totalCellHeight + cellFrame.cellHeight;
    }
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notiToSendMsg:)
                                                 name:notiNameFromCmd(CMD_SEND_MSG)
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notiToPushSendMsg:)
                                                 name:notiNameFromCmd(PUSH_SEND_MSG)
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notiToSendMsg:)
                                                 name:notiNameFromCmd(CMD_SEND_MSG)
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notiToRetrieveUnreadMsg:)
                                                 name:notiNameFromCmd(CMD_RETRIEVE_UNREAD_MSG)
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self scrollToBottom];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    self.title = self.toName;
    [self createUI];
}

- (void)createUI {
    self.view.backgroundColor = RGB_TO_UICOLOR(235, 235, 235);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, RECT_WIDTH(self.view), RECT_HEIGHT(self.view) - kNavigationBarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = self.view.backgroundColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    [_tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
    
    [self.view addSubview:_tableView];
    
    //bottom bar
    _barImgView = [[UIImageView alloc] init];
    _barImgView.frame = CGRectMake(0, RECT_MAX_Y(_tableView), RECT_WIDTH(_tableView), kNavigationBarHeight);
    _barImgView.image = [UIImage imageNamed:@"chat_bottom_bg"];
    _barImgView.userInteractionEnabled = YES;
    [self.view addSubview:_barImgView];
    
    UIButton *voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceBtn.frame = CGRectMake(0, 0, kCommonBtnHeight44, kCommonBtnHeight44);
    [voiceBtn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor"] forState:UIControlStateNormal];
    [_barImgView addSubview:voiceBtn];
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(RECT_WIDTH(self.view) - kCommonBtnHeight44, 0, kCommonBtnHeight44, kCommonBtnHeight44);
    [moreBtn setImage:[UIImage imageNamed:@"chat_bottom_up_nor"] forState:UIControlStateNormal];
    [_barImgView addSubview:moreBtn];
    
    UIButton *emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emojiBtn.frame = CGRectMake(RECT_WIDTH(self.view) - kCommonBtnHeight44 * 2, 0, kCommonBtnHeight44, kCommonBtnHeight44);
    [emojiBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
    [_barImgView addSubview:emojiBtn];
    
    LeftMarginTextField *textField = [[LeftMarginTextField alloc] init];
    textField.returnKeyType = UIReturnKeySend;
    textField.clearButtonMode = UITextFieldViewModeNever;
    textField.enablesReturnKeyAutomatically = YES;
    textField.frame = CGRectMake(RECT_MAX_X(voiceBtn),
                                 (RECT_HEIGHT(_barImgView) - 30) * 0.5,
                                 RECT_WIDTH(_barImgView) - 3 * kNavigationBarHeight,
                                 30);
    textField.background = [UIImage imageNamed:@"chat_bottom_textfield"];
    textField.delegate = self;
    [_barImgView addSubview:textField];
}

- (void)scrollToBottom {
    if ([self.chatList count]) {
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.chatList.count - 1 inSection:0];
        [_tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.chatList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCellFrame *cellFrame = self.chatList[indexPath.row];
    return cellFrame.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"buddyCell";
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.cellFrame = self.chatList[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark -
#pragma mark response
///发送消息结果
- (void)notiToSendMsg:(NSNotification *)noti {
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == CMD_SEND_MSG) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"发送消息失败" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            [[DBManager sharedInstance] updateLocalMsgStatus:[[ReceivedManager sharedInstance] sendMsgReturn]];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"发送消息错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

///收到对方消息
- (void)notiToPushSendMsg:(NSNotification *)noti {
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetRecvCmd() == PUSH_SEND_MSG) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"接收消息失败" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeError];
        } else {
            MsgModel *newMsg = [[ReceivedManager sharedInstance] receivedMsg];
            ChatCellFrame *cellFrame = [[ChatCellFrame alloc] init];
            ChatCellFrame *lastCellFrame = [self.chatList lastObject];
            //    message.showTime = ![lastCellFrame.message.time isEqualToString:message.time];
            newMsg.showTime = YES;
            newMsg.source = kMsgSourceOther;
            cellFrame.message = newMsg;
            //4.添加进去，并且刷新数据
            [self.chatList addObject:cellFrame];
            [_tableView reloadData];
            self.totalCellHeight = self.totalCellHeight + cellFrame.cellHeight;
            NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.chatList.count - 1 inSection:0];
            [_tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"接收消息错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }
}

- (void)notiToRetrieveUnreadMsg:(NSNotification *)noti {
    NSMutableArray *unread = [[ReceivedManager sharedInstance] unreadMsgArr];
    
    NSArray *sorted = [unread sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        MsgModel *msg1 = (MsgModel *)obj1;
        MsgModel *msg2 = (MsgModel *)obj2;
        
        return [msg1.requestTime compare:msg2.requestTime];
    }];
    
    for (int i = 0; i < [sorted count]; i++) {
        MsgModel *msg = sorted[i];
        if ([[msg peerIdStr] intValue] == self.toId) {
            ChatCellFrame *lastFrame = [self.chatList lastObject];
            ChatCellFrame *cellFrame = [[ChatCellFrame alloc] init];
            msg.showTime = ![msg.requestTime isEqualToString:lastFrame.message.requestTime];
            //暂时写死
            msg.showTime = YES;
            cellFrame.message = msg;
            [self.chatList addObject:cellFrame];
            
            [_tableView reloadData];
            self.totalCellHeight = self.totalCellHeight + cellFrame.cellHeight;
            NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.chatList.count - 1 inSection:0];
            [_tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    

}


#pragma mark -
#pragma mark uitextfield delegate

- (BOOL)textFieldShouldReturn:(LeftMarginTextField *)textField
{

    //2.创建一个MessageModel类
    MsgModel *message = [[MsgModel alloc] initWithToId:self.toId toName:self.toName text:textField.text];

    
    //3.创建一个CellFrameModel类
    ChatCellFrame *cellFrame = [[ChatCellFrame alloc] init];
    ChatCellFrame *lastCellFrame = [self.chatList lastObject];
//    message.showTime = ![lastCellFrame.message.time isEqualToString:message.time];
    message.showTime = YES;
    cellFrame.message = message;
    
    //4.添加进去，并且刷新数据
    [self.chatList addObject:cellFrame];
    [_tableView reloadData];
    self.totalCellHeight = self.totalCellHeight + cellFrame.cellHeight;
    
    //5.自动滚到最后一行
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.chatList.count - 1 inSection:0];
    [_tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    NSString *uuid = [NSString uuid];
    [self.sentDic  setObject:lastPath forKey:uuid];
    int lastId = 0;
    if ([[DBManager sharedInstance] insertOneMsg:message fromServer:NO msgId:&lastId]) {
        message.msgId = lastId;
    }
    
    etim::Session *sess = [[Client sharedInstance] session];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[NSString stringWithFormat:@"%d", [[[Client sharedInstance] user] userId]] forKey:@"from"];
    [param setObject:[NSString stringWithFormat:@"%d", self.toId] forKey:@"to"];
    [param setObject:textField.text forKey:@"text"];
    [param setObject:[NSNUM_WITH_INT(lastId) stringValue] forKey:@"uuid"];
    [[Client sharedInstance] doAction:*sess cmd:CMD_SEND_MSG param:param];

    
    textField.text = @"";
    
    return YES;
}

/**
 *  键盘发生改变执行
 */
- (void)keyboardWillChange:(NSNotification *)note
{
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - self.view.frame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
    }];
}

- (void)endEdit
{
    [self.view endEditing:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

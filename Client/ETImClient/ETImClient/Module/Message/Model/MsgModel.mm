//
//  MsgModel.m
//  ETImClient
//
//  Created by Ethan on 14/9/15.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "MsgModel.h"
#import "BuddyModel.h"
#import "ChatTableViewCell.h"
#import "NSDate+Additions.h"

#import "Client.h"

using namespace etim;

@interface MsgModel ()

@property (nonatomic, readwrite) NSDate *sendDate;

@end

@implementation MsgModel

- (id)initWithMsg:(etim::IMMsg)msg {
    if (self = [super init]) {
        self.msgId = msg.msgId;
        self.fromId = msg.fromId;
        self.toId = msg.toId;
        self.fromName = stdStrToNsStr(msg.fromName);
        self.toName = stdStrToNsStr(msg.toName);
        self.text = stdStrToNsStr(msg.text);
        self.requestTime = stdStrToNsStr(msg.requestTime);
        self.sendTime = stdStrToNsStr(msg.sendTime);
        
        self.showTime = YES;
        BuddyModel *user = [[Client sharedInstance] user];
        if (user) {
            if (user.userId == self.toId) {
                self.source = kMsgSourceOther;
            } else {
                self.source = kMsgSourceSelf;
            }
        }

        self.sentStatus = kMsgSent;
    }
    
    return self;
}


- (id)initWithToId:(int)toId toName:(NSString *)toName text:(NSString *)text {
    if ([self init]) {

        BuddyModel *user = [[Client sharedInstance] user];
        self.msgId = -1;
        self.fromId = user.userId;
        self.toId = toId;
        self.fromName = user.username;
        self.toName = toName;
        self.text = text;
        self.sent = 0;
        
        self.requestTime = [NSDate dateStr:[NSDate date] type:DateFormatTypeLong];
        self.sendTime = self.requestTime;
        
//        self.msgId = (int)[self hash];
        self.showTime = YES;
        self.source = kMsgSourceSelf;
        self.sentStatus = kMsgUnsent;
    }
    
    return self;
}

- (NSDate *)sendDate {
    if (!_sendDate) {
        //NSDateFormatter
        //_sendDate =

    }
    
    return _sendDate;
}

- (NSString *)peerIdStr {
    int myId = [Client sharedInstance].user.userId;
    return self.fromId == myId ? [NSNUM_WITH_INT(self.toId) stringValue] : [NSNUM_WITH_INT(self.fromId) stringValue];
}

- (NSString *)peerName {
    int myId = [Client sharedInstance].user.userId;
     return self.fromId == myId ? self.toName : self.fromName;
}


+ (NSMutableArray *)msgs:(const std::list<etim::IMMsg> &)msgs {
    NSMutableArray *result = [NSMutableArray array];
    std::list<IMMsg>::const_iterator it;
    for (it = msgs.begin(); it != msgs.end(); ++it) {
        MsgModel *model = [[MsgModel alloc] initWithMsg:*it];
        [result addObject:model];
    }
    
    return result;
}

- (NSUInteger)hash {
    ///toId-2015-04-16 09:41:42-text
    NSString *str = [NSString stringWithFormat:@"%@-%@-%@", [self peerIdStr], self.requestTime, self.text];
    
    return [str hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"消息id: %06d, 从用户 %d  名字:%@, 到用户:%d, 名字: %@ 发送时间: %@",
            self.msgId,
            self.fromId,
            self.fromName,
            self.toId,
            self.toName,
            self.requestTime];
}
@end


@implementation ListMsgModel

- (NSInteger)unreadMsgCount {
    return 0;
}

@end

#define timeH 30
#define padding 10
#define iconW 40
#define iconH 40
#define textW 150

@implementation ChatCellFrame

- (void)setMessage:(MsgModel *)message
{
    _message = message;
    CGRect frame = [UIScreen mainScreen].bounds;
    
    //1.时间的Frame
    if (message.showTime) {
        CGFloat timeFrameX = 0;
        CGFloat timeFrameY = 0;
        CGFloat timeFrameW = frame.size.width;
        CGFloat timeFrameH = timeH;
        _timeFrame = CGRectMake(timeFrameX, timeFrameY, timeFrameW, timeFrameH);
    }
    
    //2.头像的Frame
    CGFloat iconFrameX = message.source ? padding : (frame.size.width - padding - iconW);
    CGFloat iconFrameY = CGRectGetMaxY(_timeFrame);
    CGFloat iconFrameW = iconW;
    CGFloat iconFrameH = iconH;
    _iconFrame = CGRectMake(iconFrameX, iconFrameY, iconFrameW, iconFrameH);
    
    //3.内容的Frame
    CGSize textMaxSize = CGSizeMake(textW, MAXFLOAT);
    CGSize textSize = [message.text sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:textMaxSize];
    CGSize textRealSize = CGSizeMake(textSize.width + textPadding * 2, textSize.height + textPadding * 2);
    CGFloat textFrameY = iconFrameY;
    CGFloat textFrameX = message.source ? (2 * padding + iconFrameW) : (frame.size.width - (padding * 2 + iconFrameW + textRealSize.width));
    _textFrame = (CGRect){textFrameX, textFrameY, textRealSize};
    
    //4.cell的高度
    _cellHeight = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame)) + padding;
}

@end
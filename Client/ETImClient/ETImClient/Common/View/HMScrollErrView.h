//
//  HMScrollErrView.h
//  Listening
//
//  Created by xuqing on 15/1/29.
//  Copyright (c) 2015年 ethan. All rights reserved.
//

#import "HMView.h"

@class HMLabel;

/**当UISCROLLVIEW或UITABLEVIEW网络请求出错 或者
 服务器出错时的提示
 **/

@interface HMScrollErrView : HMView

@property (strong, nonatomic) UIImageView *errImgView;

@property (strong, nonatomic) HMLabel *errLabel;


@end

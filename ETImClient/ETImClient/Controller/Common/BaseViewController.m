//
//  BaseViewController.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController () 

@property (nonatomic, retain, readwrite) JKTokenController *tokenController;

@end

@implementation BaseViewController

- (void)dealloc {
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
}

- (void)createDefaultBg {
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    if (IPHONE5) {
        bgImgView.image = IMAGE_JPG(@"login_bg_ip5");
    } else {
        bgImgView.image = IMAGE_JPG(@"login_bg");
    }
    [self.view addSubview:bgImgView];
}

- (void)writeLog:(NSString *)log
{
    NSFileManager * filemangage =[NSFileManager defaultManager];
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    [filemangage changeCurrentDirectoryPath:[documentsDir stringByExpandingTildeInPath]];
    
    if(![filemangage fileExistsAtPath:@"memoryLog.txt"])
    {
        [filemangage createFileAtPath:@"memoryLog.txt" contents:nil attributes:nil];
    }
    NSString * fullfilename=[documentsDir stringByAppendingPathComponent:@"memoryLog.txt"];
    const  char* pcpath = [fullfilename cStringUsingEncoding:NSASCIIStringEncoding];
    
    FILE* filelog=fopen(pcpath, "a+");
    
    fprintf(filelog,"%s\n", [log cStringUsingEncoding:NSUTF8StringEncoding]);
    
    fclose(filelog);
}

- (void)removeBgImageView
{
    [[self.view viewWithTag:1111] removeFromSuperview];
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

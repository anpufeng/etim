//
//  BaseViewController.m
//  Listening
//
//  Created by ethan on 14/12/25.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "HMViewController.h"

@interface HMViewController ()

@end

@implementation HMViewController

- (void)dealloc {
    DDLogDebug(@"%@ dealloc", NSStringFromClass([self class]));
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    self.view.backgroundColor = RGB_TO_UICOLOR(238, 238, 238);
    
    /*
    if (IS_BIGGER_THAN(7.0)){
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;               //视图控制器，四条边不指定
        self.extendedLayoutIncludesOpaqueBars = NO;                 //不透明的操作栏<br>
    }
    
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]){
        NSString *navImageName = nil;
        if (IS_BIGGER_THAN(7.0)) {
            navImageName = @"nav-bg-7@2x.png";
        }else {
            navImageName = @"nav-bg@2x.png";
            
            self.navigationController.navigationBar.layer.masksToBounds = YES;
        }
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:navImageName] forBarMetrics:UIBarMetricsDefault];
    }
     */
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


- (void)addObserverKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeObserverKeyword {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
}


#pragma mark -
#pragma mark Orientations

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];

    self.animating = NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.animating = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

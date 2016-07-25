//
//  i072ViewController.m
//  072EatBun
//705149FD1445A578829EF1494849ABD759BD911D
//  Created by alnpet on 16/5/22.
//  Copyright © 2016年 alnpet. All rights reserved.
//

#import "i072ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioToolbox.h>
#import "APIConnection.h"
#import "AppDelegate.h"


#define T_ACCOUNT @"test1"
#define IXCODE_ACCOUNT @"test2"


#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

#define LABEL_WIDTH  (140.0/640)
#define LEFT_WIDTH (40.0/640)
#define HEDER_WIDTH (22.0/640)
#define LEFT_HEIGHT (20.0/640)
#define TIME_HEIGHT  (50.0/640)
#define EAT_HEIGHT (30.0/640)
#define PANDA_WIDTH (607.0/640)
#define PANDA_HEIGHT_TO_WIDTH (521.0/640)
#define PANDA_LEFT (20.0/640)
#define PANDA_DOWN (27.0/640)
#define SPEAK_LEFT (154.0/640)
#define SPEAK_UP (290.0/640)
#define SPEAK_HEIGHT_WIDTH (160.0/340)

#define SIGN_WIDTH (36.0/640)
#define TWO_WIDTH (8.0/640)


@interface i072ViewController ()
{
    UIImageView *backImage;
    
    UILabel *lifeLabel;
    UIView *lifeView;
    
    UILabel *fightLabel;
    UIView *fightView;
    
    UILabel *timeLabel;
    
    UILabel *eatCountLabel;
    
    UIImageView *pandaImageV;
    
    int eatCount;
    BOOL isShake;
    BOOL isDone;
    BOOL isOK;
    
    BOOL oneShaking;
    
    BOOL oneYunxing;
    
    int shakeCount;
    int timeCount;
    
    NSTimer *eightTimer;
    NSTimer *waitTimer;
    NSTimer *pandaTimer;
    NSTimer *shakeTimer;
    
    UIImageView *speakView;
    UIView *eatCountView;
    
    UIImageView *signImageV;
    UIImageView *randomCountImageV;
    
    UILabel *randomLabel;
    
    NSMutableArray *imageArr;
    NSMutableArray *imageEatArr;
    
    UIView *waitView;
    UILabel *waitLabel;
    
    UIView *leaveView;
    
    int waitTime;
    
    
    AppDelegate *app;
}

@property (nonatomic,strong)NSOperationQueue *operationQueue;


@end





@implementation i072ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(conn_state_changed)name:globalConn.stateChangedNotification object:nil];
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(response_received)name:globalConn.responseReceivedNotification object:nil];
    
    
    
    app = [UIApplication sharedApplication].delegate;
    
    eatCount = 0;
    isShake = NO;
    isDone = NO;
    isOK = NO;
    
    oneShaking = NO;
    oneYunxing = NO;
    
    timeCount = 8;
    shakeCount = 0;
    waitTime = 300;
    
    
    self.title = @"你摇我就吃";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255/255.0 green:211/255.0 blue:0 alpha:1];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    backBtn.frame = CGRectMake(0, 0, 10, 17);
    
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"i292_fanhui@3x"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backBar;
    
    [self createUI];
    
}


- (void)backAction
{
    speakView.hidden = YES;
    
    leaveView.hidden = NO;
    
}

- (void)createUI
{
    backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backImage.image = [UIImage imageNamed:@"qiangyouxi_xiongmao_beidjing_0001"];
    
    [self.view addSubview:backImage];
    
    backImage.userInteractionEnabled = YES;
    
    
    //创建熊猫
    [self pandaImageView];
    
    
    lifeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*LEFT_HEIGHT, 64+SCREEN_WIDTH*HEDER_WIDTH, SCREEN_WIDTH*LABEL_WIDTH, SCREEN_WIDTH*LEFT_HEIGHT)];
    lifeLabel.textColor = [UIColor blackColor];
    
    lifeLabel.text = @"生命值9999";
    lifeLabel.font = [UIFont systemFontOfSize:12];
    if (self.view.frame.size.width==320) {
        lifeLabel.font = [UIFont systemFontOfSize:10];
    }
    [backImage addSubview:lifeLabel];
    
    lifeView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*LEFT_HEIGHT, 64+SCREEN_WIDTH*LEFT_HEIGHT +SCREEN_WIDTH*HEDER_WIDTH+4, SCREEN_WIDTH*LABEL_WIDTH, SCREEN_WIDTH*LEFT_HEIGHT/2)];
    lifeView.backgroundColor = [UIColor colorWithRed:118/255.0 green:239/255.0 blue:58/255.0 alpha:1];
    [backImage addSubview:lifeView];
    
    
    
    fightLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*LEFT_HEIGHT, 64+SCREEN_WIDTH*HEDER_WIDTH +SCREEN_WIDTH*LEFT_HEIGHT*1.5+8, SCREEN_WIDTH*LABEL_WIDTH, SCREEN_WIDTH*LEFT_HEIGHT)];
    fightLabel.textColor = [UIColor blackColor];
    
    fightLabel.text = @"生命值999999";
    fightLabel.font = [UIFont systemFontOfSize:12];
    if (self.view.frame.size.width==320) {
        fightLabel.font = [UIFont systemFontOfSize:10];
    }
    
    [backImage addSubview:fightLabel];
    
    fightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*LEFT_HEIGHT, 64+SCREEN_WIDTH*LEFT_HEIGHT*2.5 +SCREEN_WIDTH*HEDER_WIDTH+12, SCREEN_WIDTH*LABEL_WIDTH, SCREEN_WIDTH*LEFT_HEIGHT/2)];
    fightView.backgroundColor = [UIColor colorWithRed:255/255.0 green:211/255.0 blue:0 alpha:1];
    [backImage addSubview:fightView];
    
    
    UILabel *daojishi = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+SCREEN_WIDTH*HEDER_WIDTH, SCREEN_WIDTH*LABEL_WIDTH, SCREEN_WIDTH*TIME_HEIGHT)];
    
    daojishi.center = CGPointMake(self.view.center.x, 64+SCREEN_WIDTH*HEDER_WIDTH+SCREEN_WIDTH*TIME_HEIGHT/2);
    daojishi.textColor = [UIColor blackColor];
    daojishi.textAlignment = NSTextAlignmentCenter;
    daojishi.text = @"倒计时";
    daojishi.font = [UIFont fontWithName:@"FZSongKeBenXiuKaiS-R-GB" size:24];
    if (self.view.frame.size.width==320) {
        daojishi.font = [UIFont fontWithName:@"FZSongKeBenXiuKaiS-R-GB" size:21];
    }
    
    [backImage addSubview:daojishi];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(daojishi.frame.origin.x, daojishi.frame.origin.y + SCREEN_WIDTH*TIME_HEIGHT+8, SCREEN_WIDTH*LABEL_WIDTH, SCREEN_WIDTH*TIME_HEIGHT)];
    timeLabel.textColor = [UIColor blackColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = @"08";
    timeLabel.font = [UIFont fontWithName:@"FZSongKeBenXiuKaiS-R-GB" size:30];
    if (self.view.frame.size.width==320) {
        timeLabel.font = [UIFont fontWithName:@"FZSongKeBenXiuKaiS-R-GB" size:27];
    }
    
    [backImage addSubview:timeLabel];
    
    
    UILabel *eatLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH*LABEL_WIDTH-30 , 64+SCREEN_WIDTH*HEDER_WIDTH, SCREEN_WIDTH*LABEL_WIDTH, SCREEN_WIDTH*EAT_HEIGHT)];
    eatLabel.textColor = [UIColor blackColor];
    eatLabel.textAlignment = NSTextAlignmentRight;
    eatLabel.text = @"吃包子数:";
    eatLabel.font = [UIFont systemFontOfSize:18];
    if (self.view.frame.size.width==320) {
        eatLabel.font = [UIFont systemFontOfSize:16];
    }
    
    [backImage addSubview:eatLabel];
    
    eatCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 64+SCREEN_WIDTH*HEDER_WIDTH, 30, SCREEN_WIDTH*EAT_HEIGHT)];
    eatCountLabel.textColor = [UIColor colorWithRed:255/255.0 green:211/255.0 blue:0 alpha:1];
    eatCountLabel.text = @" 0";
    
    eatCountLabel.font = [UIFont systemFontOfSize:20];
    if (self.view.frame.size.width==320) {
        eatCountLabel.font = [UIFont systemFontOfSize:16];
    }
    
    [backImage addSubview:eatCountLabel];
    
    
    
    //创建说话的条框
    speakView = [[UIImageView alloc] initWithFrame:CGRectMake(SPEAK_LEFT*SCREEN_WIDTH, SCREEN_WIDTH*SPEAK_UP+64, SCREEN_WIDTH*(1-SPEAK_LEFT*2), SCREEN_WIDTH*(1-SPEAK_LEFT*2)*SPEAK_HEIGHT_WIDTH)];
    
    if (self.view.frame.size.width==640) {
        speakView.image = [UIImage imageNamed:@"qiangyouxi_qipaokuang_0001@3x"];
    }else{
        speakView.image = [UIImage imageNamed:@"qiangyouxi_qipaokuang_0001@2x"];
    }
    
    [backImage addSubview:speakView];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, speakView.frame.size.width, speakView.frame.size.height/2)];
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"你摇我就吃";
    label1.textAlignment = NSTextAlignmentCenter;
    
    
    if (self.view.frame.size.width==640) {
        //label1.font = [UIFont systemFontOfSize:30];
        
        label1.font = [UIFont fontWithName:@"FZSongKeBenXiuKaiS-R-GB" size:30];
        
    }else{
        
        //label1.font = [UIFont systemFontOfSize:26];
        label1.font = [UIFont fontWithName:@"FZSongKeBenXiuKaiS-R-GB" size:26];
    }
    
    [speakView addSubview:label1];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, speakView.frame.size.height/2+7, speakView.frame.size.width, speakView.frame.size.height/5)];
    label2.backgroundColor = [UIColor clearColor];
    label2.text = @"摇手机吃包子加体力";
    label2.textAlignment = NSTextAlignmentCenter;
    
    if (self.view.frame.size.width==640) {
        label2.font = [UIFont fontWithName:@"FZSongKeBenXiuKaiS-R-GB" size:16];
    }else{
        
        label2.font = [UIFont fontWithName:@"FZSongKeBenXiuKaiS-R-GB" size:12];
    }
    
    [speakView addSubview:label2];
    
    
    //创建产生随机数的视图
    eatCountView = [[UIView alloc] initWithFrame:speakView.frame];
    eatCountView.backgroundColor = [UIColor clearColor];
    
    [backImage addSubview:eatCountView];
    
    
    
    signImageV = [[UIImageView alloc] initWithFrame:CGRectMake(eatCountView.frame.size.width/2-SCREEN_WIDTH*(SIGN_WIDTH+TWO_WIDTH*2), eatCountView.frame.size.height/4, SCREEN_WIDTH*SIGN_WIDTH, SCREEN_WIDTH*SIGN_WIDTH/2)];
    
    if (self.view.frame.size.width==640) {
        signImageV.image = [UIImage imageNamed:@"qiangyouxi_shuzhi_-@3x"];
    }else{
        signImageV.image = [UIImage imageNamed:@"qiangyouxi_shuzhi_-@2x"];
    }
    
    [eatCountView addSubview:signImageV];
    
    
    
    randomCountImageV = [[UIImageView alloc] initWithFrame:CGRectMake(eatCountView.frame.size.width/2-SCREEN_WIDTH*TWO_WIDTH, 0, SCREEN_WIDTH*SIGN_WIDTH*2, SCREEN_WIDTH*SIGN_WIDTH*1.26*2)];
    
    if (self.view.frame.size.width==640) {
        randomCountImageV.image = [UIImage imageNamed:@"qiangyouxi_shuzhi_06@3x"];
    }else{
        randomCountImageV.image = [UIImage imageNamed:@"qiangyouxi_shuzhi_06@2x"];
    }
    
    [eatCountView addSubview:randomCountImageV];
    
    randomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, eatCountView.frame.size.height/2, eatCountView.frame.size.width, eatCountView.frame.size.height/2)];
    randomLabel.backgroundColor = [UIColor clearColor];
    
    randomLabel.textAlignment = NSTextAlignmentCenter;
    randomLabel.text = @"再摇一次，向巅峰冲刺";
    // randomLabel.backgroundColor = [UIColor redColor];
    
    NSLog(@"=====%f",self.view.frame.size.width);
    
    if (self.view.frame.size.width==640) {
        randomLabel.font = [UIFont systemFontOfSize:20];
    }else{
        
        randomLabel.font = [UIFont systemFontOfSize:18];
    }
    
    
    [eatCountView addSubview:randomLabel];
    
    
    
    waitView = [[UIView alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH*2/3, SCREEN_WIDTH*8/15)];
    waitView.center = backImage.center;
    
    waitView.backgroundColor = [UIColor whiteColor];
    
    [backImage addSubview:waitView];
    
    int waitLabel_Height = waitView.frame.size.height/8;
    int waitLabel_Width = waitView.frame.size.width;
    
    UILabel *wait1 = [[UILabel alloc] initWithFrame:CGRectMake(0, waitLabel_Height, waitLabel_Width, waitLabel_Height)];
    wait1.text = @"等待对手应战";
    wait1.textAlignment = NSTextAlignmentCenter;
    
    if (self.view.frame.size.width==640) {
        wait1.font = [UIFont systemFontOfSize:18];
    }else{
        
        wait1.font = [UIFont systemFontOfSize:14];
    }
    
    [waitView addSubview:wait1];
    
    UILabel *wait2 = [[UILabel alloc] initWithFrame:CGRectMake(0, waitLabel_Height*2, waitLabel_Width, waitLabel_Height)];
    wait2.text = @"结算完成前无法抢夺下一人，";
    wait2.textAlignment = NSTextAlignmentCenter;
    
    if (self.view.frame.size.width==640) {
        wait2.font = [UIFont systemFontOfSize:16];
    }else{
        
        wait2.font = [UIFont systemFontOfSize:12];
        
    }
    [waitView addSubview:wait2];
    
    UILabel *wait3 = [[UILabel alloc] initWithFrame:CGRectMake(0, waitLabel_Height*3, waitLabel_Width, waitLabel_Height)];
    wait3.text = @"君可记好";
    wait3.textAlignment = NSTextAlignmentCenter;
    
    if (self.view.frame.size.width==640) {
        wait3.font = [UIFont systemFontOfSize:16];
    }else{
        
        wait3.font = [UIFont systemFontOfSize:12];
    }
    
    [waitView addSubview:wait3];
    
    
    waitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, waitLabel_Height*4, waitLabel_Width, waitLabel_Height*2)];
    waitLabel.text = @"05:00";
    waitLabel.textAlignment = NSTextAlignmentCenter;
    
    if (self.view.frame.size.width==640) {
        waitLabel.font = [UIFont boldSystemFontOfSize:22];
    }else{
        
        waitLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    
    [waitView addSubview:waitLabel];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(10, waitLabel_Height*6, waitLabel_Width-20, 1)];
    view1.backgroundColor = [UIColor grayColor];
    
    [waitView addSubview:view1];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button.frame = CGRectMake(0, waitLabel_Height*6, waitLabel_Width, waitLabel_Height*2);
    button.backgroundColor = [UIColor clearColor];
    
    [button setTitle:@"记住了" forState:UIControlStateNormal];
    
    if (self.view.frame.size.width==640) {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    }else{
        
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [waitView addSubview:button];
    
    waitView.hidden = YES;
    
    
    //创建放弃的试图
    leaveView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*2/3, SCREEN_WIDTH/3)];
    leaveView.center = backImage.center;
    leaveView.backgroundColor = [UIColor clearColor];
    
    [backImage addSubview:leaveView];
    
    leaveView.hidden = YES;
    
    
    UIView *leView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, leaveView.frame.size.width-15, leaveView.frame.size.height-15)];
    leView.backgroundColor = [UIColor whiteColor];
    
    leView.layer.cornerRadius = 5;
    
    [leaveView addSubview:leView];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(leaveView.frame.size.width-30, 0, 30, 30);
    
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"tanchuang_guanbianniu_0002@3x"] forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"tanchuang_guanbianniu_0001@3x"] forState:UIControlStateHighlighted];
    
    [closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [leaveView addSubview:closeBtn];
    
    int close_height = leView.frame.size.height/6;
    int close_width = leView.frame.size.width;
    
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, close_height, close_width, close_height)];
    label5.text = @"少侠莫放弃";
    label5.textColor = [UIColor redColor];
    label5.textAlignment = NSTextAlignmentCenter;
    
    
    if (self.view.frame.size.width==640) {
        label5.font = [UIFont systemFontOfSize:16];
    }else{
        
        label5.font = [UIFont systemFontOfSize:12];
    }
    
    [leView addSubview:label5];
    
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(0, close_height*2, close_width, close_height)];
    label6.text = @"放弃本局将直接判为失败，";
    label6.textColor = [UIColor blackColor];
    label6.textAlignment = NSTextAlignmentCenter;
    
    
    if (self.view.frame.size.width==640) {
        label6.font = [UIFont systemFontOfSize:16];
    }else{
        
        label6.font = [UIFont systemFontOfSize:12];
    }
    
    [leView addSubview:label6];
    
    UILabel *label7 = [[UILabel alloc] initWithFrame:CGRectMake(0, close_height*3, close_width, close_height)];
    label7.text = @"君可想好";
    label7.textColor = [UIColor blackColor];
    label7.textAlignment = NSTextAlignmentCenter;
    
    
    if (self.view.frame.size.width==640) {
        label7.font = [UIFont systemFontOfSize:16];
    }else{
        
        label7.font = [UIFont systemFontOfSize:12];
    }
    
    [leView addSubview:label7];
    
    UIView *view6 = [[UIView alloc] initWithFrame:CGRectMake(10, close_height*4, close_width-20, 1)];
    view6.backgroundColor = [UIColor lightGrayColor];
    
    [leView addSubview:view6];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    
    button2.frame = CGRectMake(0, close_height*4, close_width, close_height*2);
    button2.backgroundColor = [UIColor clearColor];
    
    [button2 setTitle:@"放弃" forState:UIControlStateNormal];
    
    if (self.view.frame.size.width==640) {
        button2.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    }else{
        
        button2.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    
    [button2 addTarget:self action:@selector(button2Action) forControlEvents:UIControlEventTouchUpInside];
    
    [leView addSubview:button2];
    
    
    eatCountView.hidden = YES;
    
    
    //eightTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
    
    // [self setPandaCount:5];
    
    
    
    
}


- (void)pandaImageView
{
    pandaImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*PANDA_LEFT, SCREEN_HEIGHT-SCREEN_WIDTH*PANDA_HEIGHT_TO_WIDTH - SCREEN_WIDTH*PANDA_DOWN, SCREEN_WIDTH*PANDA_WIDTH, SCREEN_WIDTH*PANDA_HEIGHT_TO_WIDTH)];
    
    pandaImageV.image = [UIImage imageNamed:@"qiangyouxi_xiongmao_chi_0001"];
    
    [backImage addSubview:pandaImageV];
    
    imageArr = [NSMutableArray arrayWithCapacity:0];
    imageEatArr = [NSMutableArray arrayWithCapacity:0];
    
    [imageArr removeAllObjects];
    [imageEatArr removeAllObjects];
    
    for (int i=1; i<9; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"qiangyouxi_xiongmao_000%d",i]];
        
        [imageEatArr addObject:image];
        
        if (i<8) {
            [imageArr addObject:image];
        }
    }
    
    pandaImageV.animationImages = imageArr;
    pandaImageV.animationDuration = 1;
    
    [pandaImageV startAnimating];
}



- (void)setPandaCount:(int)num
{
    //yes是“ + ”   no是“ - ”
    
    static int chaZhi;
    
    
    BOOL sign = YES;
    
    if ((num-eatCount)>0) {
        sign = YES;
        
        chaZhi = num - eatCount;
    }else if((num-eatCount)==0){
        
        eatCountView.hidden = YES;
        
        chaZhi = 0;
    }else{
        sign = NO;
        
        chaZhi = eatCount - num;
    }
    
    eatCount = num;
    
    eatCountLabel.text = [NSString stringWithFormat:@" %d",eatCount];
    
    NSLog(@"================%d",eatCount);
    
    if (sign) {
        signImageV.frame = CGRectMake(eatCountView.frame.size.width/2-SCREEN_WIDTH*(SIGN_WIDTH+TWO_WIDTH*2), eatCountView.frame.size.height/4-SCREEN_WIDTH*SIGN_WIDTH/3, SCREEN_WIDTH*SIGN_WIDTH, SCREEN_WIDTH*SIGN_WIDTH);
        
        if (self.view.frame.size.width==640) {
            signImageV.image = [UIImage imageNamed:@"qiangyouxi_shuzhi_+@3x"];
        }else{
            signImageV.image = [UIImage imageNamed:@"qiangyouxi_shuzhi_+@2x"];
        }
    }else{
        signImageV.frame = CGRectMake(eatCountView.frame.size.width/2-SCREEN_WIDTH*(SIGN_WIDTH+TWO_WIDTH*2), eatCountView.frame.size.height/4, SCREEN_WIDTH*SIGN_WIDTH, SCREEN_WIDTH*SIGN_WIDTH/2);
        
        if (self.view.frame.size.width==640) {
            signImageV.image = [UIImage imageNamed:@"qiangyouxi_shuzhi_-@3x"];
        }else{
            signImageV.image = [UIImage imageNamed:@"qiangyouxi_shuzhi_-@2x"];
        }
    }
    
    
    if (self.view.frame.size.width==640) {
        randomCountImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"qiangyouxi_shuzhi_0%d@3x",chaZhi]];
    }else{
        randomCountImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"qiangyouxi_shuzhi_0%d@2x",chaZhi]];
    }
    
    
    if (eatCount<=3) {
        randomLabel.text = @"重头再来，颜值高的人运气都不差";
    }else if (eatCount==6){
        randomLabel.text = @"君若一抖，一无所有";
    }else{
        randomLabel.text = @"再摇一次，向巅峰冲刺";
    }
    
    oneYunxing = NO;
    
    if (chaZhi!=0) {
        eatCountView.hidden = NO;
    }
}







- (void)runAction{
    
    //手机震动
    // AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    
    timeCount--;
    
    
    //NSLog(@"========%d",timeCount);
    timeLabel.text = [NSString stringWithFormat:@"0%d",timeCount];
    
    if (timeCount == 0) {
        
        //手机震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        shakeTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(shakeAction) userInfo:nil repeats:NO];
        
        
        
        isDone = YES;
        
        
    }
}

- (void)waitAction
{
    waitTime--;
    
    int minute = waitTime/60;
    int second = waitTime%60;
    
    waitLabel.text = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    
    if (waitTime==0) {
        
        [waitTimer invalidate];
        waitTimer = nil;
        
        //跳转到 请求结果的界面
        
        // [self robGoods_result];
    }
    
}

- (void)shakeAction
{
    //手机震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    [eightTimer invalidate];
    eightTimer = nil;
    
    [shakeTimer invalidate];
    shakeTimer = nil;
    
    ////////////=======================5分钟倒计时=====================
    //用户自己点进来的
    //将吃包子的数目，发送给服务器。并进行倒计时
    eatCountView.hidden = YES;
    waitView.hidden = NO;
    
    waitTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitAction) userInfo:nil repeats:YES];
    ////////////=======================5分钟倒计时=====================
}

//5分钟倒计时，
- (void)buttonAction
{
    // [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}



//放弃本局
- (void)button2Action
{
    //向服务器发送放弃本局的数据
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

//关闭放弃本局的试图
- (void)closeBtnAction
{
    leaveView.hidden = YES;
    
    speakView.hidden = NO;
}


-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self resignFirstResponder];
    
    [super viewDidDisappear:animated];
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    NSLog(@"shake=====end===");
    //
    //    if (motion==UIEventSubtypeMotionShake) {
    //
    //        if (!oneShaking) {
    //
    //            oneShaking = YES;
    //
    //            speakView.hidden = YES;
    //
    //            //eatCountView.hidden = NO;
    //
    //            eightTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
    //            //手机震动
    //            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //        }
    //
    //
    //        if (!isDone) {
    //
    //            int number = arc4random()%6+1;//(产生1-6的随机数)
    //
    //            if (!oneYunxing) {
    //
    //                oneYunxing = YES;
    //
    //                pandaImageV.animationImages = imageEatArr;
    //                pandaImageV.animationDuration = 1;
    //
    //                [pandaImageV startAnimating];
    //
    //                pandaTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(exchangePandaImages) userInfo:nil repeats:NO];
    //
    //                [self setPandaCount:number];
    //                NSLog(@"你摇动我了====");
    //            }
    //
    //        }
    //}
    
}


-(void)exchangePandaImages
{
    //    pandaImageV.animationImages = imageArr;
    //    pandaImageV.animationDuration = 1;
    
    [pandaImageV startAnimating];
    
    [pandaTimer invalidate];
    pandaTimer = nil;
}


-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"shake=====begin===");
    
    
    if (motion==UIEventSubtypeMotionShake) {
        
        if (!oneShaking) {
            
            oneShaking = YES;
            
            speakView.hidden = YES;
            
            //eatCountView.hidden = NO;
            
            eightTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runAction) userInfo:nil repeats:YES];
            //手机震动
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        
        
        if (!isDone) {
            
            int number = arc4random()%6+1;//(产生1-6的随机数)
            
            if (!oneYunxing) {
                
                oneYunxing = YES;
                //
                //                pandaImageV.animationImages = imageEatArr;
                //                pandaImageV.animationDuration = 1;
                //
                //                [pandaImageV startAnimating];
                
                [pandaImageV stopAnimating];
                
                pandaTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(exchangePandaImages) userInfo:nil repeats:NO];
                
                [self setPandaCount:number];
                NSLog(@"你摇动我了====");
            }
            
        }
    }
}

-(void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"shake=====cancell===");
}





////抽出计算宽度的方法第一个 25 像素表示:0~1000 点血,第二个 25 像素 表示: 1000~10000 ,第三个 25 像素表示: 10000~50000,第四个 25 像素表示 50000~100000, 第五个 25 像素表示:100000~最大值
//- (CGFloat)getWidth:(NSString *)point
//{
//    CGFloat life = [point floatValue];
//
//    CGFloat width = 0;
//
//    if (life < 1000) {
//        width = 25;
//    }else if (life < 10000)
//    {
//        width = 50;
//    }else if (life < 50000)
//    {
//        width = 75;
//    }else if (life < 100000)
//    {
//        width = 100;
//    }else
//    {
//        width = 125;
//    }
//
//    return width;
//}




//rob robGoods_shake 用户摇晃结束之后发起的请求		TOP ↑
//输入：
//{
//    "obj":"rob",
//    "act":"robGoods_shake"
//    "person_id":
//    "rob_id":用户抢的行为信息表_id
//    "shake_point":用户抢游戏过程中摇晃次数
//}

- (void)robGoods_shake
{
    NSMutableDictionary* req = [[NSMutableDictionary alloc] init];
    [req setObject:@"rob" forKey:@"obj"];
    [req setObject:@"robGoods_shake" forKey:@"act"];
    //if (self.person_id.length >0) {


   // [req setObject:app.user_id forKey:@"person_id"];
    [req setObject:[NSNumber numberWithInt:eatCount] forKey:@"shake_point"];
    //[req setObject:rob_id forKey:@"rob_id"];

    [globalConn send:req];


}

//rob robGoods_result 用户请求抢游戏的比赛结果		TOP ↑
//输入：
//{
//    "obj":"rob",
//    "act":"robGoods_result",
//    "person_id":
//    "rob_id":
//}

- (void)robGoods_result
{
    NSMutableDictionary* req = [[NSMutableDictionary alloc] init];
    [req setObject:@"rob" forKey:@"obj"];
    [req setObject:@"robGoods_result" forKey:@"act"];
    //if (self.person_id.length >0) {


  //  [req setObject:app.user_id forKey:@"person_id"];
     [req setObject:[NSNumber numberWithInt:eatCount] forKey:@"shake_point"];
   // [req setObject:rob_id forKey:@"rob_id"];

    [globalConn send:req];
}



- (void)response_received {

    NSLog(@"response: %@:%@ uerr:%@",
          (NSString*)[globalConn.response objectForKey:@"obj"],
          (NSString*)[globalConn.response objectForKey:@"act"],
          (NSString*)[globalConn.response objectForKey:@"uerr"]);


    if([(NSString*)[globalConn.response objectForKey:@"act"] isEqualToString:@"robGoods_shake"]){
        if ([[globalConn.response objectForKey:@"status"] isEqualToString:@"success"]) {


            //======发起游戏的一方返回的结果======

            eatCountView.hidden = YES;
            waitView.hidden = NO;

            waitTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(waitAction) userInfo:nil repeats:YES];


        }else if ([[globalConn.response objectForKey:@"status"] isEqualToString:@"end"]){
           //=======被动方返回的结果====直接请求结果===

            [self robGoods_result];

        }


    }else if([(NSString*)[globalConn.response objectForKey:@"act"] isEqualToString:@"robGoods_result"]){


         //=====跳转到比赛结果界面====

    }

}



- (void)conn_state_changed {
    if (globalConn.state == LOGIN_SCREEN_ENABLED) {
        if (globalConn.from_state == INITIAL_LOGIN || globalConn.from_state == SESSION_LOGIN) {

            return;
        }
        if (globalConn.from_state == REGISTRATION) {

            return;
        }
        NSLog(@"连接中");
        [globalConn credential:IXCODE_ACCOUNT withPasswd:@"1"];
        [globalConn connect];
    } else if (globalConn.state == IN_SESSION) {
        //        OUTPUT.text = @"Login OK!";
        NSLog(@"登入成功");
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

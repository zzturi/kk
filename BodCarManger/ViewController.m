//
//  ViewController.m
//  BodCarManger
//
//  Created by cszhan on 13-9-16.
//  Copyright (c) 2013年 cszhan. All rights reserved.
//

#import "ViewController.h"
#import "CarServiceNetDataMgr.h"
@interface ViewController ()
{
    UIImageView *testView;
}
@end

@implementation ViewController
static CGFloat  degrees = 0.f;
- (void)checkRunningData{
    [self performSelectorOnMainThread:@selector(doRotation:) withObject:nil  waitUntilDone:NO];
}
- (void)doRotation:(id)sender{

    degrees = degrees+20.f;
    CGAffineTransform rotation = CGAffineTransformMakeRotation(degrees/2*M_PI/360);
    [testView setTransform:rotation];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIImageWithFileName(UIImage *bg, @"run_arrow.png");
    
    testView = [[UIImageView alloc] initWithFrame:CGRectMake(50.f, 60.f, bg.size.width/kScale, bg.size.height/kScale)];
    testView.image = bg;
    [self.view addSubview:testView];
    SafeRelease(testView);
    
    
    NSTimer *timer  = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(checkRunningData) userInfo:nil repeats:YES];
    
    return;
    
    
    NSString *imgPath = nil;
    UIImage *defaultStatusImg,*selectStatusImg;
    CGRect itemRect = CGRectMake(0.f,100.f,64.f,50.f);
    NSDictionary *param = nil;
    CarServiceNetDataMgr *cardNetMgr = [CarServiceNetDataMgr getSingleTone];
    param = [NSDictionary dictionaryWithObjectsAndKeys:
             @"2013",@"year",
             @"10",@"month",
             nil];
    //[cardNetMgr getDetailByMonth:param];
    param = [NSDictionary dictionaryWithObjectsAndKeys:
             @"2013",@"year",
             @"10",@"month",
             nil];
    [cardNetMgr getCarBand];
//    [cardNetMgr carUserRegister:[NSDictionary dictionaryWithObjectsAndKeys:
//                              @"test",@"name",
//                              @"123456",@"password",
//                              @"18964598378",@"phoneNumber",
//                              nil]];
//    
    [cardNetMgr carUserLogin:[NSDictionary dictionaryWithObjectsAndKeys:
                              @"test",@"name",
                              @"123456",@"password",
                              nil]];
    
//    [cardNetMgr carInforQuery:@"kkzhan"];
//    [cardNetMgr carInforUpdate:nil withType:0];
    //[cardNetMgr getRouterRealTimeData:@"SHD05728"];
    
//    [cardNetMgr getRouterDataByMonth:@"" withYear:@""];
//    [cardNetMgr getRouterDataByDay:@"" withMoth:@"" withYear:@""];
    //[cardNetMgr getCarMaintainanceData:@"SHD05728"];
    //[cardNetMgr getCarCheckData:@"SHD05728"];
    //[cardNetMgr getDriveDataByCarId:@"" withMonth:@"" withYear:@""];
//    [cardNetMgr getDriveActionAnalysisDataByCarId:@"" withMoth:@"" withYear:@""];
//    [cardNetMgr getDriveOilAnalysisDataByCarId:@"" withMoth:@"" withYear:@""];
    //[cardNetMgr getMessageList:nil];
    
    CGFloat currX = 0.f;
    for(int i = 0; i<5;i++)
	{
		UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
		/*
		 imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"mainpagebtn%d",i] ofType:@"png"];
		 bgImag =  [UIImage imageWithContentsOfFile:imgPath];
		 */
		imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:kTabItemNarmalImageFileNameFormart,i] ofType:kTabItemImageSubfix];
		assert(imgPath);
		defaultStatusImg =  [UIImage imageWithContentsOfFile:imgPath];
       // defaultStatusImg =  [UIImage_Extend imageWithColor:[UIColor whiteColor] withImage:defaultStatusImg withSize:itemRect.size];
		imgPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:kTabItemSelectImageFileNameFormart,i] ofType:kTabItemImageSubfix];
		assert(imgPath);
		selectStatusImg =  [UIImage imageWithContentsOfFile:imgPath];
        
        selectStatusImg = [UIImage_Extend imageWithColor:[UIColor whiteColor] withImage:selectStatusImg withSize:itemRect.size];
        
        
        
		//[btn setBackgroundImage:bgImag forState:UIControlStateNormal];
		[btn setImage:defaultStatusImg forState:UIControlStateNormal];
		[btn setImage:selectStatusImg forState:UIControlStateSelected];
		//[btn setBackgroundImage:statusImg forState:UIControlStateNormal];
		btn.frame = CGRectMake(currX,40.f,defaultStatusImg.size.width/kScale, defaultStatusImg.size.height/kScale);
		//[mainView.mainFramView addSubview:btn];
        
        //btn.frame = itemRect;
        if(i == 0)
        btn.selected = YES;
        currX = currX+40;
        [self.view addSubview:btn];
        
    }
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

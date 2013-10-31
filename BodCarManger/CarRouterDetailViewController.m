//
//  CarRouterMapViewController.m
//  BodCarManger
//
//  Created by cszhan on 13-9-17.
//  Copyright (c) 2013年 cszhan. All rights reserved.
//

#import "CarRouterDetailViewController.h"
#import "MapView.h"
#import "CarDetailPenalView.h"

#import "CarRouterDateViewController.h"

@interface CarRouterDetailViewController (){
    MapView     *mMapView;
    Place       *mStartPoint;
    Place       *mEndPoint;
    CarDetailPenalView * carDetailPenalView;
    DateStruct  mDateStruct;
}
@end

@implementation CarRouterDetailViewController
@synthesize mData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *bgImage = nil;
    UIImageWithFileName(bgImage, @"BG.png");
    
    mainView.bgImage = bgImage;
    
    UIImageWithFileName(bgImage, @"share.png");
     //[self setNavgationBarRightBtnImage:bgImage forStatus:UIControlStateNormal];
    
    //map
    
     UIImageWithFileName(bgImage, @"calendar.png");
    
    UIButton *btn = [UIComUtil createButtonWithNormalBGImage:bgImage withHightBGImage:bgImage withTitle:@"" withTag:2];
    [btn addTarget:self action:@selector(didSelectorTopNavItem:) forControlEvents:UIControlEventTouchUpInside];
    [mainView.topBarView addSubview:btn];
    
    btn.frame = CGRectMake(0,0.f,bgImage.size.width/kScale,bgImage.size.height/kScale);
    btn.center = CGPointMake(mainView.topBarView.center.x+65,mainView.topBarView.center.y);
    
    
    mMapView = [[MapView alloc] initWithFrame:
               CGRectMake(0, 44, self.view.frame.size.width,460-44)];
    
	[self.view addSubview:mMapView];
    
    
    
    
    carDetailPenalView = [UIComUtil instanceFromNibWithName:@"CarDetailPenalView"];
    [self.view addSubview:carDetailPenalView];
    carDetailPenalView.frame = CGRectMake(0.f,kDeviceScreenHeight-kMBAppStatusBar-carDetailPenalView.frame.size.height, carDetailPenalView.frame.size.width, carDetailPenalView.frame.size.height);
    
    [UIView animateWithDuration:0.5 animations:^()
     {
         
        }
     ];
    
    [self initMapPointData:mData];
   
    //[mMapView showRouteFrom:mStartPoint to:mEndPoint];
    
    [self loadRouterHistoryData];
    
    //[mainView.topBarView ];
	// Do any additional setup after loading the view.
}

- (void)loadRouterHistoryData{

    CarServiceNetDataMgr *cardShopMgr = [CarServiceNetDataMgr getSingleTone];

    //kNetStartShow(@"数据加载...", self.view);
    NSString *tipId = [self.mData objectForKey:@"tripId"];
    NSString *startTime = [self.mData objectForKey:@"startTime"];
    self.request = [cardShopMgr  getRouterHistoryData:@"SHD05728" withRouterId:tipId withStartTime:startTime];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#define kMaxScale 1000000.f
- (void)initMapPointData:(NSDictionary*)data{
    
    /*
     "driveflg": "1",
     "starttime": "17:54",
     "distance": "12",
     "time": "43",
     "oil": "25",
     "startadr": "张江地铁",
     "endadr": "人民广场",
     "startadr2": "121.607931, 31.211412",
     "endadr2": "121.48117, 31.236416",
     
     "rotate": "86",
     "speed": "34",
     "water temp": "64",
     "oiltest": "8",
     "drivetest": "7"
        */
    /*
    NSString *start = @"";
    [data objectForKey:@"startadr"];
    */
    mStartPoint = [[Place alloc] init] ;
	mStartPoint.name = @"";
	mStartPoint.description = @"";
    NSString *latLogStr = [data objectForKey:@"startadr2"];
    NSArray *latLogArr  = [latLogStr componentsSeparatedByString:@","];
    mStartPoint.latitude = [latLogArr[1]floatValue]/kMaxScale;
	mStartPoint.longitude = [latLogArr[0]floatValue]/kMaxScale;
	
	mEndPoint = [[Place alloc] init] ;
	mEndPoint.name = [data objectForKey:@"endadr"];
	mEndPoint.description = @"";
    latLogStr = [data objectForKey:@"endadr2"];
    latLogArr  = [latLogStr componentsSeparatedByString:@","];
    mEndPoint.latitude = [latLogArr[1]floatValue]/kMaxScale;
	mEndPoint.longitude = [latLogArr[0]floatValue]/kMaxScale;
    /*
     "rotate": "86",
     "speed": "34",
     "water temp": "64",
     "oiltest": "8",
     "drivetest": "7"
     */
    NSString *distance = [data objectForKey:@"distance"];
    NSString *speed = [data objectForKey:@"speed"];
    NSString *rotate = [data objectForKey:@"rotate"];
    NSString *tempreture = [data objectForKey:@"tempreture"];
    carDetailPenalView.mRunDistanceLabel.text = [NSString stringWithFormat:@"行驶距离:-  %@km",distance];
    carDetailPenalView.mRunSpeedLabel.text = [NSString stringWithFormat:@"行驶速度:-  %@km/h",speed];
    carDetailPenalView.mRotateSpeedLabel.text= [NSString stringWithFormat:@"转度:-  %@次",rotate];
    carDetailPenalView.mRunTemperatureLabel.text = [NSString stringWithFormat:@"水温:-  %@度",tempreture];
    
    NSString *timeStr = [data objectForKey:@"starttime"];
    
    NSArray *timeArr  = [timeStr componentsSeparatedByString:@" "];
    
    [self setNavgationBarTitle:timeArr[0]];
	NSArray *dateArr = [timeArr[0] componentsSeparatedByString:@"/"];
    mDateStruct.year = [dateArr[0]intValue];
    mDateStruct.month = [dateArr[1]intValue];
    mDateStruct.day =  [dateArr[2]intValue];
    
    int oiltest = [[data objectForKey:@"economicScore"]intValue];
    if(oiltest>=10) oiltest = 10;
    int drivetest = [[data objectForKey:@"safeScore"]intValue];
    if(drivetest>=10) drivetest = 10;
    
    NSString *fileName = [NSString stringWithFormat:@"dashboard%d.png",oiltest];
    UIImageWithFileName(UIImage *bgImage, fileName);
    carDetailPenalView.mOilCostAnalaysisImageView.image = bgImage;
    fileName = [NSString stringWithFormat:@"dashboard%d.png",drivetest];
    UIImageWithFileName(bgImage, fileName);
    carDetailPenalView.mDriveAnalaysisImageView.image = bgImage;
}
#pragma mark -
#pragma mark navigation bar action
//-(void)didSelectorTopNavItem:(id)navObj{
//    switch ([navObj tag]) {
//        case  0:
//            [self.navigationController popViewControllerAnimated:YES];// animated:<#(BOOL)animated#>
//			break;
//        case 2:
//        case 1:{
//                //[ZCSNotficationMgr postMSG:kPopAllViewController obj:nil];
//            
//            /*
//            CarRouterDateViewController *carRouterDateChooseVc = [[CarRouterDateViewController alloc]init];
//            carRouterDateChooseVc.mCurrDate = mDateStruct;
//            [self.navigationController pushViewController:carRouterDateChooseVc animated:YES];
//            Safe_Release(carRouterDateChooseVc);
//             */
//           
//            }
//            break;
//            
//        default:
//            break;
//    }
//}
-(void)didNetDataOK:(NSNotification*)ntf
{
    
    id obj = [ntf object];
    id respRequest = [obj objectForKey:@"request"];
    id data = [obj objectForKey:@"data"];
    NSString *resKey = [obj objectForKey:@"key"];
    //NSString *resKey = [respRequest resourceKey];
    if(self.request ==respRequest && [resKey isEqualToString:kResRouterHistory])
    {
        NSDictionary *netData = [data objectForKey:@"data"];
        [self  performSelectorOnMainThread:@selector(updateUIData:) withObject:netData waitUntilDone:NO ];
        //[mDataDict setObject:netData forKey:mMothDateKey];
        //}
        kNetEnd(self.view);
        
    }
    
}
- (void)updateUIData:(NSDictionary*)data{


}
@end

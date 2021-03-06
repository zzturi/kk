//
//  UserSettingViewController.m
//  DressMemo
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserSettingViewController.h"
#import "SettingTableViewCell.h"
#import "CarInfoManageViewController.h"
#import "UIShareCell.h"
#import "constant.h"
#import "SharePlatformCenter.h"
#import "CancelBindViewController.h"

#import "CardShopLoginViewController.h"
#import "UserChangePasswordViewController.h"
//
//////#import "FriendInvitationViewController.h"
//////#import "UserInforEditViewController.h"
//////#import "AppSetting.h"
//////#import "LoginAndResignMainViewController.h"
////#import "SharePlatformCenter.h"
////#import "UIShareCell.h"
////#import "CancelBindViewController.h"
//
//#import "AboutViewController.h"

static NSString *kSectionOneArr[] =
{
    @"用户名",@"修改密码",@"手机号码",@"积分",
};
static NSString *kSectionTwoArr[] = {
    @"添加车辆和终端",@"记住车辆位置",
};

static NSString *kCellImageArr[] = {
    @"setting_cell_header.png",@"setting_cell_middle.png",@"setting_cell_footer.png",@"setting_cell_one.png",
};
@interface UserSettingViewController (){

    UISwitch *locationSwitch ;
    UILabel  *usrNameLabel ;
    UILabel  *creditLabel;
    BOOL     isCardAdd;
}
@property(nonatomic,strong)NSDictionary *userData;
@property(nonatomic,strong)NSMutableArray *imageArray;
@end
@implementation UserSettingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.mainContentViewPendingY = -3.f;
        self.imageArray = [NSMutableArray array];
        
    }
    return self;
}
-(void)addObservers
{
    [super addObservers];
    [ZCSNotficationMgr addObserver:self call:@selector(needAddCarInfo:) msgName:kNeedCarBindMSG];
}
- (void)needAddCarInfo:(NSNotification*)ntf{
    isCardAdd = YES;
}
- (void)locationSetting:(UISwitch*)sender
{
    //kNetStartShow(@"数据加载...", self.view);
    CarServiceNetDataMgr *cardShopMgr = [CarServiceNetDataMgr getSingleTone];
    NSString *useName = [AppSetting getLoginUserId];
    NSString *type = @"0";
    if(sender.on){
        type = @"1";
    }
    [cardShopMgr carUserLocationSet:useName withType:type];
    //isNeedFresh = NO;
    [AppSetting setCarLocationSetting:[NSNumber numberWithBool:sender.on]];

}
- (void)loadView{
    [super loadView];
    locationSwitch = [[UISwitch alloc]init];
    [locationSwitch addTarget:self action:@selector(locationSetting:) forControlEvents:UIControlEventValueChanged];
    //if([AppSetting getCarLocationSetting]){
    
    /*
     CGFloat bgWidth = kDeviceScreenWidth-2*KLoginAndResignPendingX;
     CGFloat bgHeight = 2*kLoginCellItemHeight+KLoginAndResignPendingX*2;
     */
    
 
    logInfo = [[UITableView alloc] initWithFrame:CGRectMake(0,kMBAppTopToolBarHeight-self.mainContentViewPendingY,kDeviceScreenWidth,kDeviceScreenHeight-kMBAppTopToolBarHeight-kMBAppStatusBar-kMBAppBottomToolBarHeght)
                                                         style:UITableViewStyleGrouped];
	//logInfo.contentInset
#if 0
    UIImage *bgImage = nil;
    UIImageWithFileName(bgImage, @"server_bg.png");
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:logInfo.frame];
    bgView.image = bgImage;
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    SafeRelease(bgView);
    logInfo.backgroundColor = [UIColor clearColor];
#else
    logInfo.backgroundColor = HexRGB(202, 202, 204);
#endif
	logInfo.allowsSelectionDuringEditing = NO;
	logInfo.delegate = self;
	logInfo.dataSource = self;
	logInfo.scrollEnabled = YES;
	logInfo.allowsSelection = YES;
    logInfo.clipsToBounds = YES;
    //logInfo.layer.cornerRadius = 5.f;
    //logInfo.backgroundColor = HexRGB(202, 202, 204);
    logInfo.backgroundView = nil;
    //logInfo.backgroundView.backgroundColor = [UIColor clearColor];
    //logInfo.backgroundView.layer.contents = (id)bgImage.CGImage;
    logInfo.separatorStyle = UITableViewCellSeparatorStyleNone;
	//logInfo.separatorColor = kLoginAndSignupCellLineColor;
    //logInfo.layer.cornerRadius = kLoginViewRadius;
    //CGPoint origin = bgView.frame.origin;
    //bgView.frame = logInfo.frame;
    //logInfo.contentSize = CGSizeMake(bgWidth,bgHeight);
    //UIImage *bgImageName = nil;
    for(int i = 0;i<4;i++){
    
        UIImageWithFileName(UIImage *bgImage,kCellImageArr[i]);
        assert(bgImage);
        
        UIImageView *bgView = [[UIImageView alloc]initWithImage:bgImage];
        
        bgView.frame = CGRectMake(0.f, 0.f,300.f,42.f);
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"cell%d",i]];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.textLabel.textColor = HexRGB(64, 64, 64);
        cell.backgroundView = bgView;
        [self.imageArray addObject:cell];
        SafeRelease(cell);
        
        
    }
    
    
    
    
    [self.view addSubview:logInfo];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if 1
    UIImage *bgImage = nil;
    UIImageWithFileName(bgImage, @"car_bg.png");
    mainView.bgImage = bgImage;
#else
     mainView.mainFramView.backgroundColor = HexRGB(202, 202, 204);
#endif

    //mainView.alpha = 0.;
    [self setNavgationBarTitle:NSLocalizedString(@"设置", @""
                                                 )];
    [self setRightBtnHidden:YES];
    [self setHiddenLeftBtn:YES];
    [self addFonterView];
    //[self shouldLoadDataFromNet];
    
    NSString *userId = [AppSetting getLoginUserId];
    if(userId){
        self.userData = [AppSetting getLoginUserDetailInfo:userId];
    }
    /*
    logInfo.contentSize = CGSizeMake(logInfo.contentSize.width, logInfo.contentSize.height+ btnsize.height+10);
     */
       //[self setRightTextContent:NSLocalizedString(@"Done", @"")];
	// Do any additional setup after loading the view.
    
    
    
    
}
- (void)addFonterView{
    
//    logInfo.frame = CGRectMake(0,kMBAppTopToolBarHeight-self.mainContentViewPendingY,kDeviceScreenWidth,kDeviceScreenHeight-kMBAppTopToolBarHeight-kMBAppStatusBar-kMBAppBottomToolBarHeght- 60 );
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0.f,0.f,300.f,80)];
    bgView.backgroundColor = HexRGB(202, 202, 204);
    
    CGFloat currY = kDeviceScreenHeight-kMBAppTopToolBarHeight-kMBAppStatusBar-kMBAppBottomToolBarHeght- 60+10.f;
    UIButton *oilAnalaysisBtn = [UIComUtil createButtonWithNormalBGImageName:@"setting_logout_btn.png" withHightBGImageName:@"setting_logout_btn.png" withTitle:@"" withTag:0];

     CGSize btnsize= oilAnalaysisBtn.frame.size;
                      currY = 10.f;
     oilAnalaysisBtn.frame = CGRectMake(10.f,currY,btnsize.width,btnsize.height);
     [oilAnalaysisBtn addTarget:self action:@selector(logOutConfirm:) forControlEvents:UIControlEventTouchUpInside];
     //[logInfo addSubview:oilAnalaysisBtn];
     //
     [bgView addSubview:oilAnalaysisBtn];
     [logInfo setTableFooterView:bgView];                 
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController popToRootViewControllerAnimated:NO];
   
    //[logInfo reloadData];
    [self performSelectorInBackground:@selector(shouldLoadDataFromNet) withObject:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if(isCardAdd){
//        
//        CarInfoManageViewController *carInfoVc = [[CarInfoManageViewController alloc]init];
//        [self.navigationController pushViewController:carInfoVc animated:NO];
//        SafeRelease(carInfoVc);
//        isCardAdd = NO;
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc{
    SafeRelease(logInfo);
    
    [super dealloc];
}
#pragma mark -
#pragma mark tableView dataSource
//- (NSInteger)tableView:(UITableView *)tableView section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(section == 3)
        return 1;
    else if (section == 0)
    {
        return 4;
    } 
    else 
    {
        return 2;
    }
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 1 &&
//        (indexPath.row == 1 || indexPath.row == 2)) {
//        return [UIShareCell cellHeight];
//    }
    
    return  42.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
#define LAZY 0

- (UITableViewCell*)getCellByIndexPath:(NSIndexPath*)indexPath withTable:(UITableView *)tableView{

    //UITableViewCell *bgImageName = nil;
    NSString *bgImageName = nil;
    UITableViewCell *cell = nil;
    if(indexPath.section == 3){
#if LAZY
        bgImageName = [self.imageArray objectAtIndex:3];
#else
        bgImageName = @"setting_cell_one.png";
#endif
    }
    else{
        if(indexPath.section == 0){
            
            switch (indexPath.row) {
                case 0:
#if LAZY
                    bgImageName = [self.imageArray objectAtIndex:0];
#else
                    bgImageName = @"setting_cell_header.png";
#endif
                    
                    break;
                case 3:
#if LAZY
                    bgImageName = [self.imageArray objectAtIndex:2];
#else
                    bgImageName = @"setting_cell_footer.png";
#endif
                    break;
                    
                default:
#if LAZY
                    bgImageName = [self.imageArray objectAtIndex:1];
#else
                    bgImageName = @"setting_cell_middle.png";
#endif
                    break;
            }
        }
        else{
            switch (indexPath.row) {
                case 0:
#if LAZY
                    bgImageName = [self.imageArray objectAtIndex:0];
#else
                    bgImageName = @"setting_cell_header.png";
#endif
                    break;
                case 1:
#if LAZY
                    bgImageName = [self.imageArray objectAtIndex:2];
#else
                    bgImageName = @"setting_cell_footer.png";
#endif
                    break;
                default:
                    break;
            }
            
        }
    }
    cell = [tableView dequeueReusableCellWithIdentifier:bgImageName];
    
    if(cell == nil){
        int i = 0;
        for(i =0;i<4;i++){
            if([kCellImageArr[i]isEqualToString:bgImageName])
                break;
        }
        cell = [self.imageArray objectAtIndex:i];
        
    }
    return cell;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    UITableViewCell *cell = [self getCellByIndexPath:indexPath withTable:tableView];
    
    int index = [indexPath row];
    switch (indexPath.section) 
    {
        case 0:
            
            cell.textLabel.text = kSectionOneArr[indexPath.row];
            NSString *detailText = @"";
            NSString *tempText = nil;
            switch (indexPath.row) {
                    case 0:
                        tempText = [AppSetting getLoginUserId];//[self.userData objectForKey:@"name"];
                        if(tempText){
                            detailText = tempText;
                        }
                        break;
                   case 2:
                        tempText = [self.userData objectForKey:@"phoneNumber"];
                        if(tempText){
                            detailText = tempText;
                        }
                        break;
                    case 3:
                        tempText = [NSString stringWithFormat:@"%d",[[self.userData objectForKey:@"points"]intValue]];
                        if(tempText){
                            detailText = tempText;
                        }
                        break;
                    default:
                        break;
                }
            if(![detailText isKindOfClass:[NSNull class]])
                cell.detailTextLabel.text = detailText;
            break;
        case 1:
        {
        
            cell.textLabel.text = kSectionTwoArr[index];
            
        }
            break;
        case 2:{
        
            if (indexPath.row == 0 || indexPath.row == 1)
            {
                               static NSString *shareCellIdentifier = @"shareCell";
                
                              UIShareCell *shareCell = [tableView dequeueReusableCellWithIdentifier:shareCellIdentifier];
                
                                if (![shareCell isKindOfClass:[UIShareCell class]])
                               {
                                    shareCell = [[UIShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:shareCellIdentifier];
                                   shareCell.backgroundColor = [UIColor clearColor];
                                }
                
                
                               if (indexPath.row == 0)
                               {
                                    [shareCell reloadData:K_PLATFORM_Sina];
                                }else{
                                    [shareCell reloadData:K_PLATFORM_Tencent];
                                }
                shareCell.shareNameLabel.textColor = HexRGB(64, 64, 64);
                shareCell.nameLabel.textColor = [UIColor blueColor];//cell.detailTextLabel.textColor;
                 shareCell.shareNameLabel.font = [UIFont systemFontOfSize:15];
                shareCell.nameLabel.font = [UIFont systemFontOfSize:15];
                cell = shareCell;
                               //return shareCell;
            }

        }
            break;
        case 3:
        {
        
            //int index = [indexPath row];
            switch (index)
            {
                case 0:
                    cell.textLabel.text = @"关于";
                    cell.detailTextLabel.text = @"";
                    break;
                case 1:
                      cell.textLabel.text = @"退出登陆";
                    break;
            }
        
        }
        default:
            break;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if(indexPath.section == 0){
        if(indexPath.row == 0||indexPath.row == 3){
            if(indexPath.row == 0){
                /*
                usrNameLabel = [UIComUtil createLabelWithFont:[UIFont systemFontOfSize:12] withTextColor:[UIColor grayColor] withText:@"1245678" withFrame:CGRectMake(40.f, 0.f, 320.f, 20)];
                usrNameLabel.backgroundColor = [UIColor clearColor];
                 
                [cell addSubview:usrNameLabel];
                 */
                //cell.detailTextLabel.text = @"123456789";
                //cell.detailTextLabel.textColor = [UIColor grayColor];
            
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
    }
    else if(indexPath.section == 1){
    
        if(indexPath.row == 1){
            cell.accessoryView = locationSwitch;
            BOOL status = [AppSetting getCarLocationSetting];
            locationSwitch.on = status;
        }
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //[cell setNeedsLayout];
	return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int index = [indexPath row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) 
    {
       case 0:{
           if(indexPath.row ==1 ||indexPath.row ==2){
               UserChangePasswordViewController *frInviteVc = [[UserChangePasswordViewController alloc]init];
               [frInviteVc setNavgationBarTitle:cell.textLabel.text];
               frInviteVc.type = indexPath.row -1;
               frInviteVc.srcText = cell.detailTextLabel.text;
               frInviteVc.subClassInputTextField.text = cell.detailTextLabel.text;
               [self.navigationController pushViewController:frInviteVc animated:YES];
               [frInviteVc release];
           }
            //cell.textLabel.text = @"邀请好友";
        }
            break;
        case 2:
        {
            switch (index)
            {
                case 0:
//                {
//                
//                    UserInforEditViewController *userEditVc = [[UserInforEditViewController alloc]init];
//                    NSDictionary *userData = [AppSetting getLoginUserDetailInfo:[AppSetting getLoginUserId]];
//                    userEditVc.userData = userData;
//                    userEditVc.delegate  = self;
//                    [self.navigationController pushViewController:userEditVc animated:YES];
//                    [userEditVc release];
//                
//                }
//                    break;
                case 1: //新浪微博
                case 2: //腾讯微博
                {
                    NSString *type = nil;
                
                    if (index == 0) {
                        type = K_PLATFORM_Sina;
                    }else{
                        type = K_PLATFORM_Tencent;
                    }
                    
                    if ([[SharePlatformCenter defaultCenter] modelDataWithType:type]) {
                        CancelBindViewController *tc = [[CancelBindViewController alloc] init];
                        tc.platformType = type;
                        [self.navigationController pushViewController:tc animated:YES];
                        SafeRelease(tc);
                        
                    }else
                        [[SharePlatformCenter defaultCenter] bindPlatformWithKey:type WithController:self];
                    
                    
//                }
            }
            //cell.textLabel.text = kSectionOneArr[index];
        }
        }
            break;
        case 1:
        {
            CarInfoManageViewController *carInfoVc = [[CarInfoManageViewController alloc]init];
            [self.navigationController pushViewController:carInfoVc animated:YES];
            SafeRelease(carInfoVc);
        }
            break;
//        case 2:
//        {
//            
//            //int index = [indexPath row];
//            switch (index)
//            {
//                case 0:
//                {
//                    //cell.textLabel.text = @"关于DressMemo";
////                    AboutViewController *abVc = [[AboutViewController alloc]init];
////                    
////                    [self.navigationController pushViewController:abVc animated:YES];
////                    [abVc release];
//                }
//                    break;
//                case 1:
//                {
//                    
//                    //cell.textLabel.text = @"退出登陆";//a)	ALERT提示“是否真的要退出” 按钮两个“确定”“取消”，点击确定退出到登陆页面。
//                    /*
//                    kUIAlertConfirmView(NSLocalizedString(@"提示", @""),NSLocalizedString(@"是否真的要退出",@""),NSLocalizedString(@"Cancel",@""),NSLocalizedString(@"Ok",@""))
//                    */
//                   
//                }
//                    break;
//            }
            
        default:
            break;
    }
}
/*
- (void)setUserData:(NSDictionary*)data{
    self.userData = data;
}
*/
#pragma mark  -
#pragma mark logout confir delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
    
        [self.navigationController popToRootViewControllerAnimated:NO];
#if 1
        [AppSetting  clearCurrentLoginUser];
        [AppSetting  setLoginUserId:@""];
        [AppSetting  setUserCarId:@"" withUserId:@""];
#else
        [AppSetting setCurrentLoginUser:@""];
#endif
       /*
        NSString *loginUserId = [AppSetting getLoginUserId];
        [AppSetting setLoginUserInfo:[NSD] withUserKey:loginUserId];
         */
        [AppSetting setUserLoginStatus:NO];
        CardShopLoginViewController *loginVc = [[CardShopLoginViewController alloc]init];
        //[self.navigationController pushViewController:tagchooseBrandVc animated:YES];
        UINavigationController *loginNav  = [[UINavigationController alloc]initWithRootViewController:loginVc];
        loginNav.navigationBarHidden = YES;
        /*
         [navCtrl presentModalViewController:loginNav animated:YES];
         */
        [ZCSNotficationMgr postMSG:kUserDidLogOut obj:nil];
        [ZCSNotficationMgr postMSG:kPresentModelViewController obj:loginNav];
        [loginVc release];
        SafeAutoRelease(loginNav);

    }
}
#pragma mark -
#pragma mark
- (void)logOutConfirm:(id)sender{
    
    UIAlertView *alertErr = [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", @"")message:NSLocalizedString(@"是否真的要退出",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消",@"") otherButtonTitles:NSLocalizedString(@"确定",@""),nil]autorelease];
    [alertErr show];

}
#pragma mark -
#pragma mark net work
- (void)shouldLoadDataFromNet{
    
    CarServiceNetDataMgr *cardShopMgr = [CarServiceNetDataMgr getSingleTone];
    NSString *userName = @"";
    NSString *userPassword = @"";
#if 1
    userName = [AppSetting getLoginUserId];
    userPassword = [AppSetting getLoginUserPassword];
#else
    userName = @"kkzhan";
    userPassword= @"123456";
#endif
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:
                           userName,@"name",
                           userPassword,@"password",
                           nil];
    [cardShopMgr carUserLogin:param];
}
-(void)didNetDataOK:(NSNotification*)ntf{
    id obj = [ntf object];
    //id respRequest = [obj objectForKey:@"request"];
    id data = [obj objectForKey:@"data"];
    NSString *resKey = [obj objectForKey:@"key"];//[respRequest resourceKey];
    //NSString *resKey = [respRequest resourceKey];
    if([resKey isEqualToString:kNetLoginRes]){
        self.userData = data;
        [AppSetting setLoginUserInfo:data];
        [logInfo reloadData];
    }
    BOOL status = YES;
    if([[self.data objectForKey:@"locateType"]intValue]==0){
        status = NO;
    }
    [AppSetting setCarLocationSetting:status];
  
}
@end

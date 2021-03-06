//
//  AboutViewController.m
//  BodCarManger
//
//  Created by cszhan on 13-12-4.
//  Copyright (c) 2013年 cszhan. All rights reserved.
//

#import "AboutViewController.h"
#import "UICarTableViewCell.h"


#define kAppVersionFormart  @"人保e行%@"
@interface AboutViewController (){
    NSInteger curVersionNumber;
}
@end

@implementation AboutViewController

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
    UIImageWithFileName(bgImage, @"car_bg.png");
    mainView.bgImage = bgImage;
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0.f, kMBAppTopToolBarHeight,kDeviceScreenWidth, kDeviceScreenHeight-kMBAppTopToolBarHeight-kMBAppStatusBar)];
    bgView.backgroundColor = HexRGB(202, 202, 204);
	// Do any additional setup after loading the view.
    [self setNavgationBarTitle:NSLocalizedString(@"关于", @""
                                                 )];
    [self setRightBtnHidden:YES];
    [self setHiddenLeftBtn:NO];
    [self.view insertSubview:bgView belowSubview:logInfo];
    
    SafeRelease(bgView);
    UIImageWithNibName(bgImage, @"about_logo.png");
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    
    imageView.image =bgImage;
    imageView.frame = CGRectMake((320.f-bgImage.size.width/kScale)/2.f,kMBAppTopToolBarHeight+15.f,bgImage.size.width/kScale, bgImage.size.height/kScale);
    [self.view addSubview:imageView];
    SafeRelease(imageView);
    CGFloat currHeight = imageView.frame.origin.y+bgImage.size.height/kScale;
    UILabel *navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.f,currHeight+10.f, kDeviceScreenWidth, 20.f)];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.font = [UIFont systemFontOfSize:14];
    navTitleLabel.textColor = [UIColor blackColor];
    navTitleLabel.backgroundColor = [UIColor clearColor];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSNumber *number = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    NSString* strVersionPrompt = [NSString stringWithFormat:kAppVersionFormart,version];
    curVersionNumber = [number intValue];
    
    navTitleLabel.text = strVersionPrompt;
    navTitleLabel.textColor = [UIColor grayColor];
    currHeight = currHeight+navTitleLabel.frame.size.height+20.f;
    [self.view addSubview:navTitleLabel];
    SafeRelease(navTitleLabel);
    
    
    currHeight = currHeight;
    CGRect tableRect = logInfo.frame;
    ///[logInfo setTableHeaderView:<#(UIView *)#>];
    CGFloat tableHeight = 160.f;
    if(kDeviceCheckIphone5){
        tableHeight = 240.f;
    }
    logInfo.frame = CGRectMake(0.f, currHeight,tableRect.size.width ,tableHeight);
    logInfo.hidden = NO;
    logInfo.backgroundColor = [UIColor clearColor];
    
    
    
    CGFloat currY = kDeviceScreenHeight-kMBAppTopToolBarHeight-kMBAppStatusBar-kMBAppBottomToolBarHeght- 60;
//    UIButton *oilAnalaysisBtn = [UIComUtil createButtonWithNormalBGImageName:nil  withHightBGImageName:nil  withTitle:@"使用条框和隐私政策" withTag:0];
    UIButton *oilAnalaysisBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [oilAnalaysisBtn setTitle:@"使用条框和隐私政策"  forState:UIControlStateNormal];
    [oilAnalaysisBtn setTitle:@"使用条框和隐私政策"  forState:UIControlStateSelected];
    
    [oilAnalaysisBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [oilAnalaysisBtn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    
    CGSize btnsize= oilAnalaysisBtn.frame.size;
    //currY = 10.f;
    oilAnalaysisBtn.frame = CGRectMake(0,currY,320,30);
    [oilAnalaysisBtn addTarget:self action:@selector(logOutConfirm:) forControlEvents:UIControlEventTouchUpInside];
    //[logInfo addSubview:oilAnalaysisBtn];
    //
    //
    
    oilAnalaysisBtn.hidden = YES;
    currY = currY+50;
#if 1
    UILabel *companyLabel = [UIComUtil createLabelWithFont:[UIFont systemFontOfSize:11] withTextColor:[UIColor grayColor] withText:@"杭州麦特斯智能科技有限公司" withFrame:CGRectMake(0,currY,320.f,20)];
    [self.view addSubview:companyLabel];
    companyLabel.textColor = HexRGB(0x2b, 0x61, 0x91);
#else
     currY = currY-10;
#endif
    //@"CopyRightAll Right Reserved"
   
    NSString *otherCompanyString = @"上海宝信软件股份有限公司联合开发";
    UILabel *rightLabel = [UIComUtil createLabelWithFont:[UIFont systemFontOfSize:11] withTextColor:[UIColor grayColor] withText:otherCompanyString withFrame:CGRectMake(0,currY,320.f,60)];
    rightLabel.numberOfLines = 0;
    [self.view addSubview:rightLabel];
    rightLabel.textColor = HexRGB(0x2b, 0x61, 0x91);
    [self.view  addSubview:oilAnalaysisBtn];
    
    
}
#pragma mark -
#pragma mark tableView dataSource
//- (NSInteger)tableView:(UITableView *)tableView section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 4.f;
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section == 1 &&
    //        (indexPath.row == 1 || indexPath.row == 2)) {
    //        return [UIShareCell cellHeight];
    //    }
    if(kDeviceCheckIphone5){
        return 42.f;
    }
    return  35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *LabelTextFieldCell = @"LabelTextFieldCell";
	
	UITableViewCell *cell = nil;
    
	cell = [tableView dequeueReusableCellWithIdentifier:LabelTextFieldCell];
	
    
    if (cell == nil)
    {
#if 1
		cell = [[UICarTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LabelTextFieldCell];
        cell.backgroundColor = [UIColor clearColor];
        
        //cell.clipsToBounds = YES;
        //cell.contentView.clipsToBounds = YES;
        
        //cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        cell.textLabel.textColor = HexRGB(64, 64, 64);
        
        
#else
        cell = [[SettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LabelTextFieldCell];
        SafeAutoRelease(cell);
#endif
	}
    /*
     
     [resultDict setValue:[info get:@"retType"] forKey:@"retType"];
     [resultDict setValue:[info get:@"milage"] forKey:@"milage"];
     [resultDict setValue:[info get:@"insureExpDate"] forKey:@"insureExpDate"];
     [resultDict setValue:[info get:@"model"] forKey:@"model"];
     [resultDict setValue:[info get:@"vin"] forKey:@"vin"];
     [resultDict setValue:[info get:@"brandy"] forKey:@"brandy"];
     [resultDict setValue:[info get:@"NO"] forKey:@"NO"];
     [resultDict setValue:[info get:@"lastmaintainDate"] forKey:@"lastmaintainDate"];
     [resultDict setValue:[info get:@"OBD"] forKey:@"OBD"];
     */
    
    
    
    
    int index = [indexPath row];
    NSString *bgImageName = nil;
    NSString *tempText = @"";
    NSString *dataText = @"";
    switch (indexPath.row)
    {
            case 0:
            cell.textLabel.text = @"功能介绍";
            break;
        case 1:
            cell.textLabel.text = @"评分";
            break;
            case 2:
            cell.textLabel.text = @"意见与反馈";
            break;
            
            case 3:
            cell.textLabel.text = @"版本更新";
            break;
            
    }
    switch (indexPath.row) {
        case 0:
            //bgImageName = [self.imageArray objectAtIndex:0];
            bgImageName = @"setting_cell_header.png";
            break;
        case 3:
            //bgImageName = [self.imageArray objectAtIndex:2];
            bgImageName = @"setting_cell_footer.png";
            break;
        default:
            bgImageName = @"setting_cell_middle.png";
            break;
    }

    cell.detailTextLabel.text = dataText;
    UIImageWithNibName(UIImage *bgImage,bgImageName);
    UIImageView *bgView = [[UIImageView alloc]initWithImage:bgImage];
    bgView.frame = CGRectMake(0.f, 0.f,300.f,42.f);
    
    //[cell insertSubview:bgView belowSubview:cell.contentView];
    //[cell.contentView  addSubview: bgView];
    cell.backgroundView = bgView;
    SafeRelease(bgView);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.backgroundColor = [UIColor clearColor];
	return cell;
    
}
- (void)addFonterView{
    
    //    logInfo.frame = CGRectMake(0,kMBAppTopToolBarHeight-self.mainContentViewPendingY,kDeviceScreenWidth,kDeviceScreenHeight-kMBAppTopToolBarHeight-kMBAppStatusBar-kMBAppBottomToolBarHeght- 60 );
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row  == 3){
        
        NSDictionary *data = [AppSetting getLoginUserInfo];
        NSString *versionStr = [data objectForKey:@"versionIOS"];
        if([versionStr intValue]>curVersionNumber){
            [self logOutConfirm:nil]
            ;            //kUIAlertConfirmView(<#title#>, <#msg#>, <#left#>, <#right#>)
        }
        else{
            kUIAlertView(@"提示", @"当前是最新版本");
        }
    }
    else{
        kUIAlertView(@"提示", @"正在建设，敬请期待");
    }
}

- (void)logOutConfirm:(id)sender{
    
    UIAlertView *alertErr = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"提示", @"")message:NSLocalizedString(@"是否要更新新版本",@"") delegate:self cancelButtonTitle:NSLocalizedString(@"取消",@"") otherButtonTitles:NSLocalizedString(@"确定",@""),nil];
    [alertErr show];
    SafeAutoRelease(alertErr);
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        [self updateNewVersion];
    }
}
-(void)updateNewVersion{
    NSDictionary *data = [AppSetting getLoginUserInfo];
    
    NSString *urlStr = [data objectForKey:@"urlIOS"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlStr]];
}
@end

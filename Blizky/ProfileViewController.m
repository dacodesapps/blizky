//
//  ProfileViewController.m
//  Blizky
//
//  Created by Carlos Vela on 14/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileInfoTableViewCell.h"
#import "MapViewController.h"
#import "FollowersFollowingViewController.h"
#import "HomeTableViewCell.h"
#import "AFNetworking.h"
#import <Security/Security.h>
#import "KeychainItemWrapper.h"
#import "UIImageView+WebCache.h"
#import "MapViewController.h"
#import "ServiceProfileViewController.h"
#import "EditProfileViewController.h"
#import "SideMenuDacodes.h"
#import "TagTableViewCell.h"
#import "ActivityProfileTableViewCell.h"
#import "FollowRequestTableViewCell.h"

@interface ProfileViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL button1;
    BOOL button2;
    BOOL button3;
    BOOL button4;
    BOOL activity;
    BOOL tag;
    CGFloat offsetSection;
    NSString* selectedIndex;
    NSDictionary* profileInfo;
    NSArray* servicesRecommended;
    NSInteger currentIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) SideMenuDacodes *menuView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Profile";
    
    if (self.idUserProfile != nil){
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    [refreshControl addTarget:self action:@selector(fetchProfile:) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableVC = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    [tableVC setTableView:self.myTableView];
    tableVC.refreshControl = refreshControl;
    
    button1 = YES;
    button2 = NO;
    button3 = NO;
    button4 = NO;
    
    tag = YES;
    activity = NO;
    currentIndex = 0;
    
    [self fetchProfile:nil];
    [self servicesRecommended:nil];
    
    [self createMenu];
    
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.menuView action:@selector(panGestureRecognized:)]];
}

-(void)createMenu{
    self.menuView = [[SideMenuDacodes alloc] initWithFrame:CGRectMake(-300, 0, 300, self.view.frame.size.height+64)];
    self.menuView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:1.0];
    self.menuView.firstName = @"";
    self.menuView.lastName = @"";
    self.menuView.email = [self emailUser];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
}

-(IBAction)showMenu{
    [self.menuView showMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
////    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
////    self.navigationController.navigationBar.shadowImage = nil;
////    self.navigationController.navigationBar.translucent = YES;
//}

#pragma mark - Fetch Data

-(void)fetchProfile:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    UIRefreshControl*refresh = (UIRefreshControl *)sender;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //NSLog(@"%@",[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/profile?otherId=%@&access_token=%@",[self idUser],[self idUser],[self authToken]]);
    [manager GET:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/profile?otherId=%@&access_token=%@",[self idUser],self.idUserProfile == nil ? [self idUser] : self.idUserProfile,[self authToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [sender endRefreshing];
        profileInfo  = (NSDictionary *)responseObject;
        self.menuView.firstName = profileInfo[@"firstName"];
        self.menuView.lastName = profileInfo[@"lastName"];
        self.menuView.profilePic = profileInfo[@"photoUrl"];
        [self.menuView reloadTable];
        NSLog(@"%@",profileInfo);
        [self.myTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [refresh endRefreshing];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Blizky" message:@"Connection failure" preferredStyle:UIAlertControllerStyleAlert]; // 1
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"Accept");
        }];
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"Error: %@", error);
    }];
}

-(void)servicesRecommended:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    UIRefreshControl*refresh = (UIRefreshControl *)sender;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/recomendationsOfServices?access_token=%@",[self idUser],[self authToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [sender endRefreshing];
        servicesRecommended  = (NSArray *)responseObject;
        NSLog(@"%@",servicesRecommended);
        [self.myTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [refresh endRefreshing];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Blizky" message:@"Connection failure" preferredStyle:UIAlertControllerStyleAlert]; // 1
        UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Accept" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"Accept");
        }];
        [alert addAction:firstAction];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return [servicesRecommended count];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        NSString*string=@"Biosnajsknxaskjxnaksxnaksjxnaskjxnaxkjnxkajnkjxnakjxnakxjaskjxnk";
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0]};
        CGRect rect = [string boundingRectWithSize:CGSizeMake(282, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        CGFloat height = rect.size.height;
        if (offsetSection <= 200.0) {
            offsetSection = 115+height+50-25;
        }else{
            offsetSection = 115+height+42-27;
        }
        return offsetSection;
    }else{
        if(tag){
            return 104.0;
        }else{
            if(indexPath.row == 1 && indexPath.section == 1){
                return 35.0;
            }else{
                return 51.0;
            }
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView*sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.0)];
        
        return sectionView;
    }else{
        UIView*sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35.0)];
        sectionView.backgroundColor = [UIColor whiteColor];
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"TAGS",@"ACTIVITY"]];
        segmentedControl.frame = CGRectMake(-2, 0, self.view.frame.size.width+4, 35);
        segmentedControl.selectedSegmentIndex = currentIndex;
        [segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:11.0],NSForegroundColorAttributeName:[UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0]} forState:UIControlStateNormal];
        [segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:11.0],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
        [segmentedControl setTintColor:[UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0]];
        [segmentedControl addTarget:self action:@selector(segmentedIndex:) forControlEvents:UIControlEventValueChanged];
        [sectionView addSubview:segmentedControl];
        
        if (currentIndex == 0) {
            UIView*topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width/2), 1.0)];
            topView.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0];
            [sectionView addSubview:topView];
            
            UIView*topView2 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width == 320.0 || self.view.frame.size.width == 414.0) ? (self.view.frame.size.width/2) : (self.view.frame.size.width/2)+0.5, 0, self.view.frame.size.width/2, 2.0)];
            topView2.backgroundColor = [UIColor whiteColor];
            [sectionView addSubview:topView2];
            
            UIView*bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, self.view.frame.size.width/2, 1.0)];
            bottomView.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0];
            [sectionView addSubview:bottomView];
            
            UIView*bottomView2 = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width == 320.0 || self.view.frame.size.width == 414.0) ? (self.view.frame.size.width/2) : (self.view.frame.size.width/2)+0.5, 34, self.view.frame.size.width/2, 1.0)];
            bottomView2.backgroundColor = [UIColor whiteColor];
            [sectionView addSubview:bottomView2];
        }else{
            UIView*topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (self.view.frame.size.width == 320.0 || self.view.frame.size.width == 414.0) ? (self.view.frame.size.width/2)-1 : (self.view.frame.size.width/2)-0.5, 2.0)];
            topView.backgroundColor = [UIColor whiteColor];
            [sectionView addSubview:topView];
            
            UIView*topView2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width == 320.0 ? (self.view.frame.size.width/2) : (self.view.frame.size.width/2)-0.5, 0, self.view.frame.size.width/2, 1.0)];
            topView2.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0];
            [sectionView addSubview:topView2];
            
            UIView*bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, (self.view.frame.size.width == 320.0 || self.view.frame.size.width == 414.0) ? (self.view.frame.size.width/2)-1 : (self.view.frame.size.width/2)-0.5, 1.0)];
            bottomView.backgroundColor = [UIColor whiteColor];
            [sectionView addSubview:bottomView];
            
            UIView*bottomView2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width == 320.0 ? (self.view.frame.size.width/2) : (self.view.frame.size.width/2)-0.5, 34, self.view.frame.size.width/2, 1.0)];
            bottomView2.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0];
            [sectionView addSubview:bottomView2];
        }
        
        return sectionView;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 35.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier;
    if (indexPath.row == 0 && indexPath.section == 0) {
        cellIdentifier = @"CellProfile";
        ProfileInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

        [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",profileInfo[@"photoUrl"]]] placeholderImage:nil];

        cell.username.text = profileInfo != nil ? [NSString stringWithFormat:@"%@ %@",profileInfo[@"firstName"],profileInfo[@"lastName"]] : @"";
        
        cell.bio.text = @"Biosnajsknxaskjxnaksxnaksjxnaskjxnaxkjnxkajnkjxnakjxnakxjaskjxnk";
        
        [cell.services addTarget:self action:@selector(goServices:) forControlEvents:UIControlEventTouchUpInside];
        [cell.services setTitle:[NSString stringWithFormat:@"%li",[profileInfo[@"recomendationsOfServicesCount"] integerValue]] forState:UIControlStateNormal];
        [cell.followers addTarget:self action:@selector(goFollowers:) forControlEvents:UIControlEventTouchUpInside];
        [cell.followers setTitle:[NSString stringWithFormat:@"%lu",[profileInfo[@"friends"] count]] forState:UIControlStateNormal];
        [cell.following addTarget:self action:@selector(goFollowing:) forControlEvents:UIControlEventTouchUpInside];
        [cell.following setTitle:[NSString stringWithFormat:@"%lu",[profileInfo[@"friends"] count]] forState:UIControlStateNormal];
        
//        for (int i=0; i<[cell.segmentedControl.subviews count]; i++)
//        {
//            if ([[cell.segmentedControl.subviews objectAtIndex:i] isSelected])
//            {
//                [[cell.segmentedControl.subviews objectAtIndex:i] setTintColor:[UIColor clearColor]];
//            }
//            else
//            {
//                UIColor *tintcolor=[UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0];
//                [[cell.segmentedControl.subviews objectAtIndex:i] setTintColor:tintcolor];
//            }
//        }
        
        //cell.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        
//        UIColor *newTintColor = [UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0];
//        cell.segmentedControl.tintColor = newTintColor;
//        
//        UIColor *newSelectedTintColor = [UIColor whiteColor];
//        [[[cell.segmentedControl subviews] objectAtIndex:0] setTintColor:newSelectedTintColor];
        
        [cell.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:11.0],NSForegroundColorAttributeName:[UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0]} forState:UIControlStateNormal];
        [cell.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:11.0],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
        [cell.segmentedControl addTarget:self action:@selector(segmentedIndex:) forControlEvents:UIControlEventValueChanged];

        //[self segmentedIndex:cell.segmentedControl];

        
//        [cell.button1 addTarget:self action:@selector(button1:) forControlEvents:UIControlEventTouchUpInside];
//        cell.button1.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        cell.button2.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [cell.button3 addTarget:self action:@selector(button3:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.button4 addTarget:self action:@selector(button4:) forControlEvents:UIControlEventTouchUpInside];
//        cell.button4.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    }else{
        if (tag) {
            cellIdentifier = @"CellTag";
            
            TagTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            
            //        HomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
            //        if (button1) {
            //            cell.textLabel.text=@"Service Recommended";
            //            cell.imageView.image = [UIImage imageNamed:@"profile.jpg"];
            //        }else if (button2){
            //            cell.textLabel.text=@"2";
            //        }else if (button3){
            //            cell.textLabel.text=@"News";
            //            cell.imageView.image = nil;
            //        }else if (button4){
            //            cell.textLabel.text=@"Hashtags";
            //            cell.imageView.image = nil;
            //        }
            //
            //        NSString *imageString = servicesRecommended[indexPath.row-1][@"thumbnailUrl"];
            //        NSRange range = [imageString rangeOfString:@"?dimension=thumbs"];
            //        if (range.location != NSNotFound) {
            //            imageString = [imageString substringWithRange:NSMakeRange(0, range.location)];
            //        }
            //
            //        cell.username.text = servicesRecommended[indexPath.row-1][@"serviceName"];
            //        cell.descriptionHome.text = servicesRecommended[indexPath.row-1][@"address"];
            //        cell.distanceCategory.text = @"2Km, Categoría";
            //        cell.friends.text = @"25 friends";
            //        [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",imageString]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //            if (image) {
            //                cell.profilePic.image=image;
            //                [cell layoutIfNeeded];
            //                [cell setNeedsLayout];
            //            }
            //        }];
            //    
            //        cell.buttonRecommended.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            [cell layoutIfNeeded];
            [cell setNeedsLayout];
            
            return cell;
        }else{
            if (indexPath.row == 0) {
                cellIdentifier = @"CellRequest";
                
                FollowRequestTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                [cell layoutIfNeeded];
                [cell setNeedsLayout];
                
                return cell;
            }else if(indexPath.row == 1){
                cellIdentifier = @"CellRecent";
                
                UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                cell.textLabel.text = @"RECENT";
                cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-SemiBold" size:13.0f];
                
                [cell layoutIfNeeded];
                [cell setNeedsLayout];
                
                return cell;
            }else{
                cellIdentifier = @"CellActivity";
                
                ActivityProfileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
                
                [cell layoutIfNeeded];
                [cell setNeedsLayout];
                
                return cell;
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0 && indexPath.section == 0){
        HomeTableViewCell* cellHome = (HomeTableViewCell*)cell;
        cellHome.profilePic.layer.cornerRadius = cellHome.profilePic.frame.size.width/2;
        cellHome.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
        cellHome.profilePic.layer.borderWidth = 2.0;
        cellHome.profilePic.layer.masksToBounds = YES;
    }else{
        if (tag) {
            TagTableViewCell* cellTag = (TagTableViewCell*)cell;
            cellTag.taggerPic.layer.cornerRadius = cellTag.taggerPic.frame.size.width/2;
            cellTag.taggerPic.layer.borderColor = [UIColor clearColor].CGColor;
            cellTag.taggerPic.layer.borderWidth = 2.0;
            cellTag.taggerPic.layer.masksToBounds = YES;
            
            cellTag.servicePic.layer.cornerRadius = cellTag.servicePic.frame.size.width/2;
            cellTag.servicePic.layer.borderColor = [UIColor clearColor].CGColor;
            cellTag.servicePic.layer.borderWidth = 2.0;
            cellTag.servicePic.layer.masksToBounds = YES;
        }else{
            if (indexPath.row == 0) {
                FollowRequestTableViewCell* cellRequest = (FollowRequestTableViewCell*)cell;
                cellRequest.requestPic.layer.cornerRadius = cellRequest.requestPic.frame.size.width/2;
                cellRequest.requestPic.layer.borderColor = [UIColor clearColor].CGColor;
                cellRequest.requestPic.layer.borderWidth = 2.0;
                cellRequest.requestPic.layer.masksToBounds = YES;
                
                cellRequest.requestNumber.layer.cornerRadius = cellRequest.requestNumber.frame.size.width/2;
                cellRequest.requestNumber.layer.borderColor = [UIColor clearColor].CGColor;
                cellRequest.requestNumber.layer.borderWidth = 2.0;
                cellRequest.requestNumber.layer.masksToBounds = YES;
            }else if(indexPath.row > 1){
                ActivityProfileTableViewCell* cellActivity = (ActivityProfileTableViewCell*)cell;
                cellActivity.activityPic.layer.cornerRadius = cellActivity.activityPic.frame.size.width/2;
                cellActivity.activityPic.layer.borderColor = [UIColor clearColor].CGColor;
                cellActivity.activityPic.layer.borderWidth = 2.0;
                cellActivity.activityPic.layer.masksToBounds = YES;
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        [self performSegueWithIdentifier:@"showService" sender:self];
    }
}

#pragma mark - SegmentedControl

- (void)segmentedIndex:(id)sender {
    
//    for (int i=0; i<[((UISegmentedControl *)sender).subviews count]; i++)
//    {
//        if ([[((UISegmentedControl *)sender).subviews objectAtIndex:i] respondsToSelector:@selector(isSelected)] && [[((UISegmentedControl *)sender).subviews objectAtIndex:i] isSelected])
//        {
//            [[((UISegmentedControl *)sender).subviews objectAtIndex:i] setTintColor:[UIColor whiteColor]];
//        }
//        if ([[((UISegmentedControl *)sender).subviews objectAtIndex:i] respondsToSelector:@selector(isSelected)] && ![[((UISegmentedControl *)sender).subviews objectAtIndex:i] isSelected])
//        {
//            [[((UISegmentedControl *)sender).subviews objectAtIndex:i] setTintColor:[UIColor blackColor]];
//        }
//    }
//    for (int i = 0; i < ((UISegmentedControl *)sender).subviews.count; i++)
//    {
//        id subView = [((UISegmentedControl *)sender).subviews objectAtIndex:i];
//        NSLog(@"%@",subView);
//        if ([subView isSelected])
//            [subView setTintColor:[UIColor whiteColor]];
//        else
//            [subView setTintColor:[UIColor blackColor]];
//    }
//    
//    [((UISegmentedControl *)sender) setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:11.0],NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
//    [((UISegmentedControl *)sender) setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:11.0],NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
    
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            NSLog(@"Tag");
            tag = YES;
            activity = NO;
            currentIndex = 0;
            [self.myTableView reloadData];
            break;
        case 1:
            NSLog(@"Activity");
            tag = NO;
            activity = YES;
            currentIndex = 1;
//            [self fetchFeed:nil];
            [self.myTableView reloadData];
            break;
    }
}

#pragma mark - Actions

-(void)goServices:(id)sender{
    [self.myTableView setContentOffset:CGPointMake(0, offsetSection) animated:YES];
}

-(void)goFollowers:(id)sender{
    selectedIndex=@"Followers";
    [self performSegueWithIdentifier:@"open" sender:self];
}

-(void)goFollowing:(id)sender{
    selectedIndex=@"Following";
    [self performSegueWithIdentifier:@"open" sender:self];
}

-(void)button1:(id)sender{
    button1 = YES;
    button2 = NO;
    button3 = NO;
    button4 = NO;
    [self.myTableView reloadData];
}

-(void)button2:(id)sender{
    button1 = NO;
    button2 = YES;
    button3 = NO;
    button4 = NO;
    [self.myTableView reloadData];
}

-(void)button3:(id)sender{
    button1 = NO;
    button2 = NO;
    button3 = YES;
    button4 = NO;
    [self.myTableView reloadData];
}

-(void)button4:(id)sender{
    button1 = NO;
    button2 = NO;
    button3 = NO;
    button4 = YES;
    [self.myTableView reloadData];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"map"]) {
        MapViewController* destinationController = segue.destinationViewController;
        destinationController.services = servicesRecommended;
        self.tabBarController.tabBar.hidden=YES;
    }
    if ([segue.identifier isEqualToString:@"open"]) {
        FollowersFollowingViewController* destinationController = segue.destinationViewController;
        destinationController.fromWhereTitle = selectedIndex;
        destinationController.followingsOrFollowers = profileInfo[@"friends"];
    }
    
    if ([segue.identifier isEqualToString:@"showService"]) {
        NSIndexPath*indexPath = [self.myTableView indexPathForSelectedRow];
        ServiceProfileViewController* destinationController = segue.destinationViewController;
        destinationController.idService = servicesRecommended[indexPath.row-1][@"id"];
        destinationController.serviceName = servicesRecommended[indexPath.row-1][@"serviceName"];
        destinationController.serviceCategory = servicesRecommended[indexPath.row-1][@"category"][@"name"];
        destinationController.servicePhoto = servicesRecommended[indexPath.row-1][@"thumbnailUrl"];
        destinationController.serviceDescription = servicesRecommended[indexPath.row-1][@"description"];
    }
    if ([segue.identifier isEqualToString:@"edit"]) {
        UINavigationController*nav = segue.destinationViewController;
        EditProfileViewController* destinationController = (EditProfileViewController *)[nav topViewController];
        destinationController.firstName = profileInfo[@"firstName"];
        destinationController.lastNameUser = profileInfo[@"lastName"];
        destinationController.bioUser = @"";
    }
}

#pragma mark - Credentials

-(NSString*)authToken{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"BlizkyToken" accessGroup:nil];
    return [keychainItem objectForKey:(id)kSecAttrAccount];
}

-(NSString*)idUser{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"idUser" accessGroup:nil];
    return [keychainItem objectForKey:(id)kSecAttrAccount];
}

-(NSString*)emailUser{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"emailUser" accessGroup:nil];
    return [keychainItem objectForKey:(id)kSecAttrAccount];
}

@end

//
//  ServiceProfileViewController.m
//  Blizky
//
//  Created by Dacodes on 15/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "ServiceProfileViewController.h"
#import "ServiceHeaderTableViewCell.h"
#import "ServiceSegmentedTableViewCell.h"
#import "ServiceDescriptionTableViewCell.h"
#import "ServiceLocationTableViewCell.h"
#import "ServiceTabBarTableViewCell.h"
#import "ServiceFeedTableViewCell.h"
#import "AFNetworking.h"
#import <Security/Security.h>
#import "KeychainItemWrapper.h"
#import "UIImageView+WebCache.h"

@interface ServiceProfileViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MKMapViewDelegate>{
    BOOL info;
    BOOL feed;
    NSDictionary*serviceInfo;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ServiceProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.title = self.serviceName;
    self.title = @"Service";
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Check for iOS 8
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 100.0f;
    self.locationManager.headingFilter = 5;
    
    info = YES;
    feed = NO;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    [refreshControl addTarget:self action:@selector(fetchService:) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableVC = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    [tableVC setTableView:self.myTableView];
    tableVC.refreshControl = refreshControl;
    
    [self fetchService:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetch Data

//@"http://69.46.5.166:3002/api/Suppliers/%@/profile?access_token=ziagnbhJJ1lBHIems1QZL2XNa4JEUvDfZ9oWXJl1T03015gz1OtXnbSr22PF8Gru"

-(void)fetchService:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    UIRefreshControl*refresh = (UIRefreshControl *)sender;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Suppliers/%@/profile?access_token=%@",self.idService,[self authToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [sender endRefreshing];
        serviceInfo  = (NSDictionary *)responseObject;
        NSLog(@"%@",serviceInfo);
        [self.myTableView reloadData];
        self.myTableView.hidden = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        [refresh endRefreshing];
        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Blizky" message:@"No se puede conectar a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
        [alert show];
        NSLog(@"Error: %@", error);
    }];
}

-(void)fetchFeed:(id)sender{
//    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
//    
//    UIRefreshControl*refresh = (UIRefreshControl *)sender;
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager GET:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Suppliers/%@/feeds?access_token=%@",self.idService,[self authToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
//        [sender endRefreshing];
//        NSDictionary* temp  = (NSDictionary *)responseObject;
//        NSLog(@"%@",temp);
//        [self.myTableView reloadData];
//        self.myTableView.hidden = NO;
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
//        [refresh endRefreshing];
//        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"TeleNews Pro" message:@"No se puede conectar a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
//        [alert show];
//        NSLog(@"Error: %@", (NSDictionary *)operation.responseObject);
//    }];
}

-(void)recommendService:(id)sender{
    UIButton*tempButton = (UIButton *)sender;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    if ([tempButton tag] == 0) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager PUT:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/recomendationsOfServices/rel/%@?access_token=%@",[self idUser],self.idService,[self authToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            NSDictionary* temp  = (NSDictionary *)responseObject;
            NSLog(@"%@",temp);
            [tempButton setTintColor:[UIColor whiteColor]];
            [tempButton setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0]];
            [tempButton setTitle:[NSString stringWithFormat:@"%li",[tempButton.titleLabel.text integerValue] + 1] forState:UIControlStateNormal];
            tempButton.tag = 1;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
//            UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"TeleNews Pro" message:@"No se puede conectar a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
//            [alert show];
            NSLog(@"Error: %@", (NSDictionary *)operation.responseObject);
        }];
    }else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager DELETE:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/recomendationsOfServices/rel/%@?access_token=%@",[self idUser],self.idService,[self authToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            NSDictionary* temp  = (NSDictionary *)responseObject;
            NSLog(@"%@",temp);
            [tempButton setTintColor:[UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0]];
            [tempButton setBackgroundColor:[UIColor whiteColor]];
            [tempButton setTitle:[NSString stringWithFormat:@"%li",[tempButton.titleLabel.text integerValue] - 1] forState:UIControlStateNormal];
            tempButton.tag = 0;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
//            UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"TeleNews Pro" message:@"No se puede conectar a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
//            [alert show];
            NSLog(@"Error: %@", (NSDictionary *)operation.responseObject);
        }];
    }
}

-(void)saveService:(id)sender{
    UIButton*tempButton = (UIButton *)sender;
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    if ([tempButton tag] == 0) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager PUT:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/favouritesServices/rel/%@?access_token=%@",[self idUser],self.idService,[self authToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            NSDictionary* temp  = (NSDictionary *)responseObject;
            NSLog(@"%@",temp);
            [tempButton setTintColor:[UIColor whiteColor]];
            [tempButton setBackgroundColor:[UIColor colorWithRed:69.0/255.0 green:146.0/255.0 blue:247.0/255.0 alpha:1.0]];
            [tempButton setTitle:[NSString stringWithFormat:@"%li",[tempButton.titleLabel.text integerValue] + 1] forState:UIControlStateNormal];
            tempButton.tag = 1;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
//            UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"TeleNews Pro" message:@"No se puede conectar a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
//            [alert show];
            NSLog(@"Error: %@", (NSDictionary *)operation.responseObject);
        }];
    }else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        [manager DELETE:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/favouritesServices/rel/%@?access_token=%@",[self idUser],self.idService,[self authToken]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
            NSDictionary* temp  = (NSDictionary *)responseObject;
            NSLog(@"%@",temp);
            [tempButton setTintColor:[UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0]];
            [tempButton setBackgroundColor:[UIColor whiteColor]];
            [tempButton setTitle:[NSString stringWithFormat:@"%li",[tempButton.titleLabel.text integerValue] - 1] forState:UIControlStateNormal];
            tempButton.tag = 0;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
//            UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"TeleNews Pro" message:@"No se puede conectar a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
//            [alert show];
            NSLog(@"Error: %@", (NSDictionary *)operation.responseObject);
        }];
    }
}


#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (info) {
        return 6;
    }else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (info) {
        if (indexPath.row == 0) {
            return 120.0;
        }else if(indexPath.row == 1 || indexPath.row == 2){
            return 44.0;
        }else if (indexPath.row == 3 || indexPath.row == 4){
            if (indexPath.row == 3) {
                CGFloat offsetSection;
                NSString*string=self.serviceDescription;
                NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]};
                CGRect rect = [string boundingRectWithSize:CGSizeMake(282, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                CGFloat height = rect.size.height;
                
                offsetSection = 31 + height + 9;
                return offsetSection;
            }else{
                CGFloat offsetSection;
                NSString*string=serviceInfo[@"address"];
                NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0]};
                CGRect rect = [string boundingRectWithSize:CGSizeMake(282, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
                CGFloat height = rect.size.height;
                
                offsetSection = 31 + height + 9;
                return offsetSection;
            }
        }else{
            CGFloat offsetSection;
            NSString*string=[NSString stringWithFormat:@"Manager Name: %@\nEmail: %@\nPhone: %@",serviceInfo[@"managerName"],serviceInfo[@"email"],serviceInfo[@"phone"]];
            NSDictionary *attributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0]};
            CGRect rect = [string boundingRectWithSize:CGSizeMake(282, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
            CGFloat height = rect.size.height;
            
            offsetSection = height + 170;
            return offsetSection;
        }
    }else{
        if (indexPath.row == 0) {
            return 120.0;
        }else if(indexPath.row == 1 || indexPath.row == 2){
            return 44.0;
        }else if (indexPath.row >= 3){
            return 250.0;
        }
    }
    return 120.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString* cellIdentifier = @"Cell";

        ServiceHeaderTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.serviceName.text = self.serviceName;
        cell.serviceCategory.text = self.serviceCategory;
        
        if ([serviceInfo[@"isRecommendedByMe"] integerValue] == 0) {
            [cell.buttonRecommended setTintColor:[UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0]];
            [cell.buttonRecommended setBackgroundColor:[UIColor whiteColor]];
            cell.buttonRecommended.tag = 0;
        }else{
            [cell.buttonRecommended setTintColor:[UIColor whiteColor]];
            [cell.buttonRecommended setBackgroundColor:[UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0]];
            cell.buttonRecommended.tag = 1;
        }
        cell.buttonRecommended.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cell.buttonRecommended setTitle:[NSString stringWithFormat:@"%li",[serviceInfo[@"recomendations"] integerValue]] forState:UIControlStateNormal];
        [cell.buttonRecommended addTarget:self action:@selector(recommendService:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([serviceInfo[@"isInMyFavorites"] integerValue] == 0) {
            [cell.save setTintColor:[UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0]];
            [cell.save setBackgroundColor:[UIColor whiteColor]];
            cell.save.tag = 0;
        }else{
            [cell.save setTintColor:[UIColor whiteColor]];
            [cell.save setBackgroundColor:[UIColor colorWithRed:69.0/255.0 green:146.0/255.0 blue:247.0/255.0 alpha:1.0]];
            cell.save.tag = 1;
        }
        [cell.save addTarget:self action:@selector(saveService:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *imageString = self.servicePhoto;
        NSRange range = [imageString rangeOfString:@"?dimension=thumbs"];
        if (range.location != NSNotFound) {
            imageString = [imageString substringWithRange:NSMakeRange(0, range.location)];
        }
        
        [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",imageString]] placeholderImage:nil];
        cell.profilePic.contentMode = UIViewContentModeScaleToFill;
        
        cell.save.imageView.contentMode = UIViewContentModeScaleAspectFit;

        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    }else if(indexPath.row == 1){
        static NSString* cellIdentifier = @"TabBar";
        
        ServiceTabBarTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.chat.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.staff.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.coupons.imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.referrals.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if (self.view.frame.size.height <= 568.0) {
            cell.chat.imageEdgeInsets = UIEdgeInsetsMake(-8, 31, 0, 31);
            cell.staff.imageEdgeInsets = UIEdgeInsetsMake(-13, 31, 0, 31);
            cell.coupons.imageEdgeInsets = UIEdgeInsetsMake(-8, 31, 0, 31);
            cell.referrals.imageEdgeInsets = UIEdgeInsetsMake(-8, 30, 0, 30);
        }else if (self.view.frame.size.height == 672.0){
            cell.chat.imageEdgeInsets = UIEdgeInsetsMake(-8, 42, 0, 42);
            cell.staff.imageEdgeInsets = UIEdgeInsetsMake(-13, 42, 0, 42);
            cell.coupons.imageEdgeInsets = UIEdgeInsetsMake(-8, 42, 0, 42);
            cell.referrals.imageEdgeInsets = UIEdgeInsetsMake(-8, 41, 0, 41);
        }

        return cell;
    }else if(indexPath.row == 2){
        static NSString* cellIdentifier = @"Cell1";
        
        ServiceSegmentedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        [cell.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Bold" size:18.0], NSForegroundColorAttributeName : [UIColor colorWithRed:48.0/255.0 green:46.0/255.0 blue:47.0/255.0 alpha:1.0]} forState:UIControlStateNormal];
        [cell.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"OpenSans-Bold" size:18.0], NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
        [cell.segmentedControl addTarget:self action:@selector(segmentedIndex:) forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }else if ((indexPath.row == 3 && info)|| (indexPath.row == 4 && info)){
        static NSString* cellIdentifier = @"Cell2";
        
        ServiceDescriptionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        if (indexPath.row == 3) {
            cell.nameDescription.text = @"Service description";
            cell.labelDescription.text = self.serviceDescription;
        }else{
            cell.nameDescription.text = @"Address";
            cell.labelDescription.text = serviceInfo[@"address"];
        }
        
        
        return cell;
        
    }else if(indexPath.row >= 3 && feed){
        static NSString* cellIdentifier = @"FeedCell";
        
        ServiceFeedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        return cell;
    }else{
        static NSString* cellIdentifier = @"Cell3";
        
        ServiceLocationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.map.delegate = self;
        cell.map.showsCompass = YES;
        cell.map.showsTraffic = YES;
        cell.map.showsScale = YES;
        cell.map.showsUserLocation = YES;
        
        if (![serviceInfo[@"location"] isEqual:[NSNull null]]) {
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([serviceInfo[@"location"][@"lat"] floatValue], [serviceInfo[@"location"][@"lng"] floatValue]);
            
            MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
            pin.title = self.serviceName;
            pin.coordinate = coordinate;
            
            [cell.map showAnnotations:@[pin] animated:NO];
        }
        
        cell.labelOthers.text = [NSString stringWithFormat:@"Manager Name: %@\nEmail: %@\nPhone: %@",serviceInfo[@"managerName"],serviceInfo[@"email"],serviceInfo[@"phone"]];
        cell.labelOthers.lineBreakMode = NSLineBreakByCharWrapping;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(ServiceHeaderTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2;
        cell.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
        cell.profilePic.layer.borderWidth = 2.0;
        cell.profilePic.layer.masksToBounds = YES;
        
        cell.buttonRecommended.layer.cornerRadius = cell.buttonRecommended.frame.size.width/2;
        cell.buttonRecommended.layer.borderColor = [UIColor clearColor].CGColor;
        cell.buttonRecommended.layer.borderWidth = 2.0;
        cell.buttonRecommended.layer.masksToBounds = YES;
        
        cell.save.layer.cornerRadius = cell.save.frame.size.width/2;
        cell.save.layer.borderColor = [UIColor clearColor].CGColor;
        cell.save.layer.borderWidth = 2.0;
        cell.save.layer.masksToBounds = YES;
    }
}

#pragma mark - SegmentedControl

- (void)segmentedIndex:(id)sender {
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            NSLog(@"Info");
            info = YES;
            feed = NO;
            [self.myTableView reloadData];
            break;
        case 1:
            NSLog(@"Feed");
            info = NO;
            feed = YES;
            [self fetchFeed:nil];
            [self.myTableView reloadData];
            break;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

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

@interface ServiceProfileViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MKMapViewDelegate>{
    BOOL info;
    BOOL feed;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ServiceProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            return 80.0;
        }else{
            CGFloat offsetSection;
            NSString*string=@"BiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbss";
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
    
        cell.buttonRecommended.imageView.contentMode = UIViewContentModeScaleAspectFit;
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
        }else{
            cell.nameDescription.text = @"Address";
        }
        
        cell.labelDescription.text = @"labelDescription";
        
        return cell;
        
    }else if(indexPath.row >= 3 && feed){
        static NSString* cellIdentifier = @"FeedCell";
        
        ServiceFeedTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        return cell;
    }else{
        static NSString* cellIdentifier = @"Cell3";
        
        ServiceLocationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        //cell.textLabel.text = [NSString stringWithFormat:@"Row %i",indexPath.row+1];
        cell.map.delegate = self;
        cell.map.showsCompass = YES;
        cell.map.showsTraffic = YES;
        cell.map.showsScale = YES;
        cell.map.showsUserLocation = YES;
        
        CLLocationCoordinate2D bakeryPlazaABCoordinate = CLLocationCoordinate2DMake(21.016870, -89.584487);

        MKPointAnnotation *bakeryPlazaABAnnotation = [[MKPointAnnotation alloc] init];
        bakeryPlazaABAnnotation.title = @"Bakery Plaza Altabrisa";
        bakeryPlazaABAnnotation.coordinate = bakeryPlazaABCoordinate;
        
        [cell.map showAnnotations:@[bakeryPlazaABAnnotation] animated:NO];
        
        cell.labelOthers.text = @"BiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbssBiodcbjsbdbjsdhbfjashbdfjasdhfbss";
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
            [self.myTableView reloadData];
            break;
    }
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

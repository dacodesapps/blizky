//
//  FollowersFollowingViewController.m
//  Blizky
//
//  Created by Carlos Vela on 25/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "FollowersFollowingViewController.h"
#import "FollowersFollowingTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import <Security/Security.h>
#import "KeychainItemWrapper.h"
#import "ProfileViewController.h"

@interface FollowersFollowingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation FollowersFollowingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.fromWhereTitle;
    
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Follow Action

-(void)unfollowUser:(id)sender{
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //NSString*sttr = [NSString stringWithFormat:@"%li",(long)[sender tag]]
    NSDictionary*params = @{@"friendId":[NSNumber numberWithInteger:[sender tag]]};
    
    NSLog(@"%@",[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/removeFriend?access_token=%@",[self idUser],[self authToken]]);
    [manager POST:[NSString stringWithFormat:@"http://69.46.5.166:3002/api/Customers/%@/removeFriend?access_token=%@",[self idUser],[self authToken]] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
        NSDictionary*temp = (NSDictionary *)responseObject;
        NSLog(@"%@",temp);
        [self.myTableView reloadData];
        self.myTableView.hidden = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
//        UIAlertView*alert=[[UIAlertView alloc] initWithTitle:@"Blizky" message:@"No se puede conectar a internet" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
//        [alert show];
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.followingsOrFollowers count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    FollowersFollowingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.username.text = [NSString stringWithFormat:@"%@ %@",self.followingsOrFollowers[indexPath.row][@"firstName"],self.followingsOrFollowers[indexPath.row][@"lastName"]];
    cell.descriptionCell.text = @"Bio";

    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",self.followingsOrFollowers[indexPath.row][@"photoUrl"]]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            cell.profilePic.image=image;
        }
    }];
    cell.followButton.tag = [self.followingsOrFollowers[indexPath.row][@"id"] integerValue];
    [cell.followButton addTarget:self action:@selector(unfollowUser:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell layoutIfNeeded];
    [cell setNeedsLayout];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(FollowersFollowingTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2;
    cell.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
    cell.profilePic.layer.borderWidth = 2.0;
    cell.profilePic.layer.masksToBounds = YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.fromWhereTitle isEqualToString:@"Following"]) {
//        UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"Blizky" message:@"What do you want to do?" delegate:nil cancelButtonTitle:@"Unfollow" otherButtonTitles:@"Block", nil];
//        [alert show];
//    }else{
//        UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"Blizky" message:@"What do you want to do?" delegate:nil cancelButtonTitle:@"Unfollow" otherButtonTitles: nil];
//        [alert show];
//    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showProfile" sender:self];
    });
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showProfile"]) {
        NSIndexPath* indexPath = [self.myTableView indexPathForSelectedRow];
        ProfileViewController* destinationController = segue.destinationViewController;
        destinationController.idUserProfile = self.followingsOrFollowers[indexPath.row][@"id"];
    }
}


@end

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
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2;
    cell.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
    cell.profilePic.layer.borderWidth = 2.0;
    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",self.followingsOrFollowers[indexPath.row][@"photoUrl"]]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            cell.profilePic.image=image;
        }
    }];
    
    [cell layoutIfNeeded];
    [cell setNeedsLayout];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.fromWhereTitle isEqualToString:@"Following"]) {
        UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"Blizky" message:@"What do you want to do?" delegate:nil cancelButtonTitle:@"Unfollow" otherButtonTitles:@"Block", nil];
        [alert show];
    }else{
        UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"Blizky" message:@"What do you want to do?" delegate:nil cancelButtonTitle:@"Unfollow" otherButtonTitles: nil];
        [alert show];
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

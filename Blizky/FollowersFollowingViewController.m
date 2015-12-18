//
//  FollowersFollowingViewController.m
//  Blizky
//
//  Created by Carlos Vela on 25/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "FollowersFollowingViewController.h"
#import "FollowersFollowingTableViewCell.h"

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
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    FollowersFollowingTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.username.text = @"Carlos Vela";
    cell.descriptionCell.text = @"shbxjsdcbdjsahchjbdsjhcbsdjhcbsdhcbasjbdsajchsdbcjadshbcdsajhbdajchd";
    cell.profilePic.layer.cornerRadius = cell.profilePic.frame.size.width/2;
    cell.profilePic.layer.borderColor = [UIColor clearColor].CGColor;
    cell.profilePic.layer.borderWidth = 2.0;
    
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

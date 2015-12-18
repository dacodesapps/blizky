//
//  AddViewController.m
//  Blizky
//
//  Created by Carlos Vela on 25/11/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import "AddViewController.h"
#import "FollowersFollowingTableViewCell.h"

@interface AddViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *addContacts;
@property (weak, nonatomic) IBOutlet UIButton *addFacebook;
@property (weak, nonatomic) IBOutlet UIButton *requests;

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Add Friend";
    
    self.addContacts.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.addFacebook.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.requests.imageView.contentMode = UIViewContentModeScaleAspectFit;

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  NoticeboardViewController.m
//  Blizky
//
//  Created by Dacodes on 11/01/16.
//  Copyright © 2016 Dacodes. All rights reserved.
//

#import "NoticeboardViewController.h"
#import "NoticeboardTableViewCell.h"
#import "NoticeBoard2TableViewCell.h"

@interface NoticeboardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation NoticeboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"OpenSans-Bold" size:18.0f],NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:243.0/255.0 green:44.0/255.0 blue:55.0/255.0 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    
    self.title = @"Noticeboard";
    
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
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
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row % 2 == 0){
        return 346.0;
    }else{
        return 190.0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
//    //[cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",response[indexPath.row][@"photoUrl"]]] placeholderImage:nil];
//    [cell.profilePic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://69.46.5.166:3002%@",response[indexPath.row][@"photoUrl"]]] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image) {
//            cell.profilePic.image=image;
//        }
//    }];
//    cell.profilePic.contentMode = UIViewContentModeScaleToFill;
//    cell.username.text = response[indexPath.row][@"serviceName"];
//    cell.descriptionHome.text = response[indexPath.row][@"description"];
//    cell.distanceCategory.text = response[indexPath.row][@"category"][@"name"];
//    cell.friends.text = [NSString stringWithFormat:@"%li friends",[response[indexPath.row][@"friendsRecomendations"] integerValue]];
//    cell.buttonRecommended.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [cell.buttonRecommended setTitle:[NSString stringWithFormat:@"%li",[response[indexPath.row][@"recomendations"] integerValue]] forState:UIControlStateNormal];
    if (indexPath.row % 2 == 0) {
        static NSString* cellIdentifier = @"Cell";
        NoticeboardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.date.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    }else{
        static NSString* cellIdentifier = @"Cell2";
        NoticeBoard2TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.date.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [cell layoutIfNeeded];
        [cell setNeedsLayout];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(NoticeboardTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.servicePic.layer.cornerRadius = 10;
    cell.servicePic.layer.borderColor = [UIColor clearColor].CGColor;
    cell.servicePic.layer.borderWidth = 2.0;
    cell.servicePic.layer.masksToBounds = YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"showNoticeboard" sender:self];
    });
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

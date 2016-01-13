//
//  SideMenuDacodes.h
//  Blizky
//
//  Created by Dacodes on 28/12/15.
//  Copyright © 2015 Dacodes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuDacodes : UIView <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic,strong) NSString*firstName;
@property (nonatomic,strong) NSString*lastName;
@property (nonatomic,strong) NSString*profilePic;
@property (nonatomic,strong) NSString*email;
@property (nonatomic, assign) BOOL load;
@property (nonatomic,assign) BOOL accountButtonToggled;

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer;
- (void)reloadTable;
- (void)showMenu;

@end

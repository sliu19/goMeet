//
//  GroupChatTableView.h
//  chatTest
//
//  Created by Simin Liu on 5/2/15.
//  Copyright (c) 2015 LPP. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GroupChatTableView : UITableView<UITableViewDelegate , UITableViewDataSource>



@property (strong,nonatomic)NSArray* messageHistory;
@end

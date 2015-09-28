//
//  SearchTableViewCell.h
//  challenge GitHub
//
//  Created by Matheus Vechietin on 26/09/15.
//  Copyright (c) 2015 Matheus Vechietin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;

@end

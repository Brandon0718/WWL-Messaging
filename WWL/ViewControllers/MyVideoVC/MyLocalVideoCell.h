//
//  MyLocalVideoCell.h
//  WWL
//
//  Created by Kristoffer Yap on 6/9/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLocalVideoCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iv_thumb;
@property (weak, nonatomic) IBOutlet UILabel *lbl_file_name;
@property (weak, nonatomic) IBOutlet UIView *view_back;
@property (weak, nonatomic) IBOutlet UILabel *lbl_size;

-(void) configureCell:(NSString*) fileName basePath:(NSURL*) basePath;

@end

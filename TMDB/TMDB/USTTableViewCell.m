//
//  USTTableViewCell.m
//  TMDB
//
//  Created by Vladimír Slavík on 28/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import "USTTableViewCell.h"
#import "USTAppUtils.h"

@interface USTTableViewCell ()
@property(nonatomic, weak) IBOutlet UILabel* textLabelCustom;
@property(nonatomic, weak) IBOutlet UILabel* detailTextLabelCustom;
@end

@implementation USTTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textLabelCustom.text = @"";
    self.textLabelCustom.hidden = YES;
    self.textLabelCustom.textColor = RGBCOLORTINT;
    
    
    self.detailTextLabelCustom.text = @"";
    self.detailTextLabelCustom.hidden = YES;
    self.detailTextLabelCustom.textColor = RGBCOLORCONTRAST;
    
    self.contentView.backgroundColor    = RGBCOLORMAJOR;
    self.backgroundView.backgroundColor = RGBCOLORMAJOR;
    self.backgroundColor = self.contentView.backgroundColor;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCellWithTitle:(NSString*)textLabel value:(NSString*)detailTextLabel {
    
    self.textLabelCustom.hidden         = NO;
    self.textLabelCustom.text           = textLabel;
    self.detailTextLabelCustom.hidden   = NO;
    self.detailTextLabelCustom.text     = detailTextLabel;
}

@end

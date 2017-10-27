//
//  USTTableViewCellParagraph.m
//  TMDB
//
//  Created by Vladimír Slavík on 31/01/2017.
//  Copyright © 2017 Usertech. All rights reserved.
//

#import "USTTableViewCellParagraph.h"
#import "USTAppUtils.h"

@interface USTTableViewCellParagraph ()

@property (nonatomic, weak) IBOutlet UILabel* paragraph;

@end

@implementation USTTableViewCellParagraph

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.paragraph.textColor = RGBCOLORCONTRAST;
}

- (void) configureCellWithText:(NSString*)text{
    
    self.paragraph.text = text;
}
@end

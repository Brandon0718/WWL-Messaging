//
//  NSString+custom.h
//  WWL
//
//  Created by Kristoffer Yap on 5/21/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (custom)

-(NSURL*) getImageURL;
-(NSString*) getFilteredMessage:(NSString*) username;

-(UIImage*) getNewsTypeImage;
@end

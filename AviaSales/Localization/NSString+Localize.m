//
//  NSString+Localize.m
//  AviaSales
//
//  Created by Alex on 04/01/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

#import "NSString+Localize.h"

@implementation NSString (Localize)

- (NSString *)localize {
    return NSLocalizedString(self, "");
}

@end


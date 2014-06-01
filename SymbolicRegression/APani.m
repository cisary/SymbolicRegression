//
//  APani.m
//  SymbolicRegression
//
//  Created by Michal Cisarik on 5/22/14.
//  Copyright (c) 2014 Michal Cisarik. All rights reserved.
//

#import "APani.h"

@implementation APani

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    
    NSRect full = NSMakeRect(0, 0, 300, 300);
    [[NSColor blueColor]set];
    NSRectFill(full);
    
}

@end

//
//  TwoDimArray.m
//  Capstone Proect
//
//  Created by Lilit Avetisyan on 4/18/18.
//  Copyright © 2018 Lil. All rights reserved.
//

#import "TwoDimArray.h"

//
@implementation TwoDimArray
-(id) initWithRows: (int) rows cols: (int) cols values: (NSArray*) values
{

        if (rows * cols != [values count])
        {
           
            return nil;
        }
        
        self.numRows = rows;
        self.numCols = cols;
        self.backingStore = [values copy];
    return self;
}
-(int) objectAtRow: (int) row col: (int) col
{
    if (col >= self.numCols)
    {
        // raise same exception as index out of bounds on NSArray.
        // Don't need to check the row because if it's too big the
        // retrieval from the backing store will throw an exception.
    }
    NSUInteger index = row * self.numCols + col;
//    NSLog(@"%@", [self.backingStore objectAtIndex: index]);
    return [[self.backingStore objectAtIndex: index] intValue] ;
}
@end

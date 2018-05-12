//
//  TwoDimArray.h
//  Capstone Proect
//
//  Created by Lilit Avetisyan on 4/18/18.
//  Copyright © 2018 Lil. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol TwoDimArray
@end

@interface TwoDimArray : NSObject

@property (nonatomic) NSArray* backingStore;
@property (nonatomic) int numRows;
@property (nonatomic) int numCols;

-(id) initWithRows: (int) rows cols: (int) cols values: (NSArray*) values;
-(int) objectAtRow: (int) row col: (int) col;
@end


//
//  ColumnProjectionSmootheningViewController.m
//  Capstone Proect
//
//  Created by Lilit Avetisyan on 5/22/18.
//  Copyright © 2018 Lil. All rights reserved.
//

#import "ColumnProjectionSmootheningViewController.h"
#import "CroppedSymbolViewController.h"

@interface ColumnProjectionSmootheningViewController (){
    
    NSMutableArray* smoothenedArrCols;
    NSMutableArray* projectionPicksArr;
    NSMutableArray* distanceBetweenPicks;
    
    UIImage* croppedImage;
}

@end

@implementation ColumnProjectionSmootheningViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.title = @"Smooth fnc";
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Back";
    self.navigationItem.backBarButtonItem = barButton;
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Crop" style:UIBarButtonItemStylePlain target:self action:@selector(cropPhoto)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    croppedImage = nil;
    
    distanceBetweenPicks = [[NSMutableArray alloc] init];
    projectionPicksArr = [[NSMutableArray alloc] init];
    smoothenedArrCols = [[NSMutableArray alloc] init];
    [self smoothenArr];
    [self getPicks];
}

-(void)getPicks{
//    NSLog(@"Smoothened array values: %@", smoothenedArrCols);
    
    for (int i = 1; i < smoothenedArrCols.count-1; i++) {
        if([smoothenedArrCols[i] doubleValue] > [smoothenedArrCols[i-1] doubleValue]){
            if ([smoothenedArrCols[i] doubleValue] > [smoothenedArrCols[i+1] doubleValue]) {
                [projectionPicksArr addObject:[NSNumber numberWithInt:i]];
            }
        }
    }
    
    NSLog(@"Projection Picks Indexes: %@", projectionPicksArr);
    
    
    for (int i = 1; i < projectionPicksArr.count; i++) {
        int difference = [projectionPicksArr[i] intValue] - [projectionPicksArr[i-1] intValue];
        [distanceBetweenPicks addObject:[NSNumber numberWithInt:difference]];
        
    }
    
    NSLog(@"Distance between picks: %@", distanceBetweenPicks);
    
    NSArray* sortedDistance = [self quickSort:distanceBetweenPicks];
    
    NSLog(@"Distance between picks sorted: %@", sortedDistance);
    
    int midValue = [sortedDistance[sortedDistance.count/2] intValue];
    
    NSLog(@"The mid element is: %d", midValue);
    
    
    int point1 = 0, point2 = 0;
    for (int i = 1; i < projectionPicksArr.count; i++) {
        if ([projectionPicksArr[i] intValue] - [projectionPicksArr[i-1] intValue] == 60 ) {
            
            point1 = [projectionPicksArr[i - 1] intValue];
            point2 = [projectionPicksArr[i +1] intValue];
            NSLog(@"The region of the row is between these lenghty points:\nPoint1: %d \nPoint2: %d", point1, point2);
        }
    }
    
    
    CGRect cropRect = CGRectMake(point1, 0, 60, self.image.size.height);
    
    
    croppedImage = [self croppIngimageByImageName:cropRect];
    
}

-(void)smoothenArr{
    //  create new arr, based on the inital rows Array
    //    NSMutableArray* newRowsArr = [[NSMutableArray alloc] init];
    //everything to be stored here
    NSMutableArray* newSmallArr = [[NSMutableArray alloc] init];
    //  seperate each 21st element of the inital array and assign it to newSmallArr
    
    for (int i = 0; i < 20; i++) {
        [smoothenedArrCols addObject:_clmns[i]];
    }
    
    for (int i = 20; i < _clmns.count-20; i++) {
        //        // rows[i-10] - rows[i+10]: range to find mean
        for (int j = i-20; j < i+20; j++) {
            [newSmallArr addObject:_clmns[j]];
        }
        
        
        
        double meanElement = [self findMean:newSmallArr];
        [newSmallArr removeAllObjects];
        [smoothenedArrCols addObject:[NSNumber numberWithDouble:meanElement]];
    }
    
    for (int i = (int)_clmns.count-20; i< _clmns.count; i++) {
        [smoothenedArrCols addObject:_clmns[i]];
        
    }
    
    // should create the new projection.... should
    [self createProjection:smoothenedArrCols];
    
    
}

-(double)findMean:(NSMutableArray*) arr{
    double sum = 0;
    for (int i = 0; i < arr.count; i++) {
        sum += [arr[i] doubleValue];
    }
    return sum/arr.count;
}

#pragma mark Image Cropping


- (UIImage *)croppIngimageByImageName:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.image CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return cropped;
}


#pragma mark QUICK sort

-(NSArray *)quickSort:(NSMutableArray *)unsortedDataArray
{
    
    NSMutableArray *lessArray = [[NSMutableArray alloc] init];
    NSMutableArray *greaterArray =[[NSMutableArray alloc] init] ;
    if ([unsortedDataArray count] <1)
    {
        return nil;
    }
    int randomPivotPoint = arc4random() % [unsortedDataArray count];
    NSNumber *pivotValue = [unsortedDataArray objectAtIndex:randomPivotPoint];
    [unsortedDataArray removeObjectAtIndex:randomPivotPoint];
    for (NSNumber *num in unsortedDataArray)
    {
        
        if (num < pivotValue)
        {
            [lessArray addObject:num];
        }
        else
        {
            [greaterArray addObject:num];
        }
    }
    NSMutableArray *sortedArray = [[NSMutableArray alloc] init] ;
    [sortedArray addObjectsFromArray:[self quickSort:lessArray]];
    [sortedArray addObject:pivotValue];
    [sortedArray addObjectsFromArray:[self quickSort:greaterArray]];
    return sortedArray;
}


-(void)cropPhoto{
    CroppedSymbolViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CroppedSymbolViewController"];
    vc.image = croppedImage;
    
    [self.navigationController pushViewController:vc animated:NO];
}


-(void)createProjection: (NSMutableArray*) arr{
    for (int i = 0; i < arr.count; i++) {
//        float width = self.view.frame.size.width;
        float lineWidth = [arr[i] doubleValue];
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 30+i, lineWidth, 1 )];
        NSLog(@"cols[i] :%f", lineWidth);
        NSLog(@"cols :%lu", (unsigned long)arr.count);
        [line setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:line];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

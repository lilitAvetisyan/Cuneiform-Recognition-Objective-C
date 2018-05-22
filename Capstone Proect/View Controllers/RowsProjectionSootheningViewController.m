//
//  RowsFFTVisualizationViewController.m
//  Capstone Proect
//
//  Created by Lilit Avetisyan on 5/15/18.
//  Copyright © 2018 Lil. All rights reserved.
//

#import "RowsProjectionSootheningViewController.h"
#import "Complex.h"
#import "CroppedPhotoViewController.h"
#include <math.h>

@interface RowsProjectionSootheningViewController (){
    NSMutableArray* finalFunctionG;
    NSMutableArray* inputArr;
    NSMutableArray* sumOfSquares;
    double omega; // num of rows, yani
    
    
    NSMutableArray* smoothenedArrRows;
    NSMutableArray* projectionPicksArr;
    NSMutableArray* distanceBetweenPicks;
    
    UIImage* croppedImage;
}

@end

@implementation RowsProjectionSootheningViewController

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
    smoothenedArrRows = [[NSMutableArray alloc] init];
    [self smoothenArr];
    [self getPicks];
    
    
    //Es sax petq chekav bayc reportum kgres
    inputArr = [[NSMutableArray alloc] init];
    finalFunctionG = [[NSMutableArray alloc] init];
    sumOfSquares = [[NSMutableArray alloc] init];
    
//    [self transformProjectionToComplex];
//    [self discreteFourierTrasnform];
//    [self getFirstRowIndexes];
    
    
}
-(void)getPicks{
    NSLog(@"Smoothened array values: %@", smoothenedArrRows);
    
    for (int i = 1; i < 812; i++) {
        if([smoothenedArrRows[i] doubleValue] > [smoothenedArrRows[i-1] doubleValue]){
            if ([smoothenedArrRows[i] doubleValue] > [smoothenedArrRows[i+1] doubleValue]) {
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
        if ([projectionPicksArr[i] intValue] - [projectionPicksArr[i-1] intValue] == 51 ) {
            
             point1 = [projectionPicksArr[i - 1] intValue];
             point2 = [projectionPicksArr[i +1] intValue];
            NSLog(@"The region of the row is between these points:\nPoint1: %d \nPoint2: %d", point1, point2);
        }
    }
    
    double stDev = [self standardDeviationOf:distanceBetweenPicks];
    
    CGRect cropRect = CGRectMake(0, point2-stDev, self.image.size.width, 51+stDev);
    

    croppedImage = [self croppIngimageByImageName:cropRect];
    
}

-(void)smoothenArr{
    NSMutableArray* newSmallArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        [smoothenedArrRows addObject:_rows[i]];
    }
    
    for (int i = 10; i < _rows.count-10; i++) {
        for (int j = i-10; j < i+10; j++) {
            [newSmallArr addObject:_rows[j]];
        }
        double meanElement = [self findMean:newSmallArr];
        [newSmallArr removeAllObjects];
        [smoothenedArrRows addObject:[NSNumber numberWithDouble:meanElement]];
    }
    for (int i = (int)_rows.count-10; i< _rows.count; i++) {
        [smoothenedArrRows addObject:_rows[i]];

    }
    [self createProjection:smoothenedArrRows];
}

#pragma mark mean and standard dev
- (double)standardDeviationOf:(NSMutableArray *)array
{
//    if(![array count]) return nil;
    
    double mean = [self findMean:array] ;
    double sumOfSquaredDifferences = 0.0;
    
    for(NSNumber *number in array)
    {
        double valueOfNumber = [number doubleValue];
        double difference = valueOfNumber - mean;
        sumOfSquaredDifferences += difference * difference;
    }
    
    return sqrt(sumOfSquaredDifferences / [array count]);
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
//        quickSortCount++; //This is required to see how many iterations does it take to sort the array using quick sort
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
    CroppedPhotoViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CroppedPhotoViewController"];
    vc.image = croppedImage;
    
    [self.navigationController pushViewController:vc animated:NO];
}
#pragma mark FFT NOT NEEDED

-(void)transformProjectionToComplex{
    for (int i = 0; i < _rows.count; i++) {
        Complex* complex = [[Complex alloc] init];
        complex.re = i;
        complex.im = [_rows[i] doubleValue];
        [inputArr addObject:complex];
    }
}

-(void)discreteFourierTrasnform{
    int n = (int)inputArr.count;
    double s = 1/(sqrt((double)n));
    for (int k = 0; k < n; k++) { // foreach output element
        double sumreal = 0;
        double sumimag = 0;
        for (int t = 0; t < n; t++) { //for each input element
            double angle = 2 * M_PI * t * k / n;
            sumreal += [inputArr[t] re] *cos(angle) + [inputArr[t] im]*sin(angle);
            sumimag +=  [inputArr[t] im] * cos(angle) - [inputArr[t] re] * sin(angle);
        }
        Complex* complex = [[Complex alloc] init];
        complex.re = s * sumreal;
        complex.im = s * sumimag;
        complex.sumOfSquares =sqrt(complex.re * complex.re + complex.im * complex.im) ;
        [sumOfSquares addObject: [NSNumber numberWithDouble: complex.sumOfSquares]];
        [finalFunctionG addObject:complex];        
    }
}

-(void)findOmega{
    double max = 0;
    for (int i = 1; i < finalFunctionG.count/2; i ++) {
        Complex* c = finalFunctionG[i];
        if (max < c.sumOfSquares) {
            NSLog(@"sum of squares %f",c.sumOfSquares);
            max = c.sumOfSquares;
            omega = i;
        }
    }
    
}

-(void)getFirstRowIndexes{
    // get rows and omega
    // create dictionary from rows - "index":"value"
    NSMutableDictionary *rowsDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < _rows.count; i++) {
        NSString* key = [NSString stringWithFormat:@"%d",i];
        [rowsDict setValue:_rows[i] forKey:key];
    }
    // sort the dictionary by "value"-s
    NSArray* sortedKeys = [rowsDict keysSortedByValueUsingComparator:^(id first, id second) {
        return [first compare:second];
    }];
    // get first omega qanaki "index":"value"-s
    // extract the "index"-es in a new array

    for (int j = 0; j < omega; j++) {
        NSLog(@"Index of min element: %@",sortedKeys[j]);
    }
    // take first two minimal points' indexes
    // crop the photo accordingly

    
    
    
}


-(void)createProjection: (NSMutableArray*) arr{
    for (int i = 0; i < arr.count; i++) {
        float width = self.view.frame.size.width;
        float lineWidth = width*width/[arr[i] doubleValue];
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 30+i, lineWidth, 1 )];
        NSLog(@"rows[i] :%f", lineWidth);
        NSLog(@"rows.count :%lu", (unsigned long)arr.count);
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

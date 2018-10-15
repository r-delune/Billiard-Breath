#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSNumber * gameType;
@property (nonatomic, retain) NSDate * gameDate;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * power;
@property (nonatomic, retain) NSNumber * bestStrength;
@property (nonatomic, retain) NSString * gameDirection;
@property (nonatomic, retain) User *user;

@end

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CMSSession;
@class CMSSpeakerAvatar;

@interface CMSSpeaker : NSManagedObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSSet *sessions;

@property (nonatomic, strong) CMSSpeakerAvatar *avatar;

+ (instancetype)findById:(NSString *)id inContext:(NSManagedObjectContext *)context;
+ (instancetype)insertInContext:(NSManagedObjectContext *)context;

- (void)populateFromDictionary:(NSDictionary *)dict;

@end

@interface CMSSpeaker (CoreDataGeneratedAccessors)

- (void)addSessionsObject:(CMSSession *)value;
- (void)removeSessionsObject:(CMSSession *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;

@end

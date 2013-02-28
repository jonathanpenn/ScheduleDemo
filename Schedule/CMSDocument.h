#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CMSDocument : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly) NSURL *persistentStoreURL;

+ (instancetype)sharedDocument;
- (NSManagedObjectContext *)newChildContextWithConcurrencyType:(NSManagedObjectContextConcurrencyType)type;

- (BOOL)initializeDocument:(NSError **)error;
- (BOOL)deleteAndReset:(NSError **)error;
- (BOOL)save:(NSError **)error;
- (NSURL *)applicationDocumentsDirectory;

@end

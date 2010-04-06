//
//  chocolate_rainAppDelegate.m
//  chocolate-rain
//
//  Created by Stephen Sugden on 10-04-03.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"

@implementation AppController

@synthesize window;
@synthesize daemon;
@synthesize torrents;
@synthesize managedObjectContext;

+ (void)initialize
{
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject:@"http://localhost/RPC2" forKey:@"url"];
	[defaultValues setObject:@"/" forKey:@"remoteRoot"];
	[defaultValues setObject:[NSNumber numberWithInt:1] forKey:@"browseRemote"];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
	[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaultValues];
}

- (id)init 
{
	self = [super init];
	daemon = [[rtDaemon alloc] init];
	return self;
}

-(IBAction) showPreferencePanel: (id) sender
{
	if (!preferenceController) {
		preferenceController = [[NSWindowController alloc] initWithWindowNibName:@"Preferences"];
	}
	[preferenceController showWindow:self];
}

-(IBAction) stopSelected: (id) sender
{
	DLog(@"Not implemented");
}

-(IBAction) startSelected: (id) sender
{
	DLog(@"Not Implemented");
}


-(IBAction) viewDidChange: (id) sender
{
	DLog(@"Selected view %@", [viewSelector titleOfSelectedItem]);
	[daemon requestMethod:@"download_list" 
				withParameter:[[viewSelector titleOfSelectedItem] lowercaseString] 
				  andDelegate:self];
}

////// XMLRPCConnectionDelegate methods
// Called on ANY response from XMLRPC server
- (void)request: (XMLRPCRequest *)request didReceiveResponse: (XMLRPCResponse *)response
{
	DLog(@"Received hashlist:\n%@", [response object]);
	NSMutableArray *hashList = [[response object] mutableCopy];
	NSMutableArray *newTorrents = [NSMutableArray new];
	for(NSString *hash in hashList){
		[newTorrents addObject:[[rtTorrent alloc] initWithSHA1:hash andDaemon:daemon]];
	}
	[torrents setContent:newTorrents];
	DLog(@"Set torrents:\n%@", torrents);
}

- (void)request: (XMLRPCRequest *)request didFailWithError: (NSError *)error
{
	DLog(@"Request %A failed with error: %A", request, error);
}

- (void)request: (XMLRPCRequest *)request didReceiveAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
	DLog(@"Challenge response not implemented");
}

- (void)request: (XMLRPCRequest *)request didCancelAuthenticationChallenge: (NSURLAuthenticationChallenge *)challenge
{
	DLog(@"Challenge response not implemented");
}

// Big ol copy'n'paste:
/**
 Returns the support directory for the application, used to store the Core Data
 store file.  This code uses a directory named "havealook" for
 the content, either in the NSApplicationSupportDirectory location or (if the
 former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportDirectory {
	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"havealook"];
}


/**
 Creates, retains, and returns the managed object model for the application 
 by merging all of the models found in the application bundle.
 */

- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel) return managedObjectModel;
	
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.  This 
 implementation will create and return a coordinator, having added the 
 store for the application to it.  (The directory for the store is created, 
 if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	
    if (persistentStoreCoordinator) return persistentStoreCoordinator;
	
    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSAssert(NO, @"Managed object model is nil");
        NSLog(@"%@:%s No model to generate a store from", [self class], _cmd);
        return nil;
    }
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupportDirectory = [self applicationSupportDirectory];
    NSError *error = nil;
    
    if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] ) {
		if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory,error]));
            NSLog(@"Error creating application support directory at %@ : %@",applicationSupportDirectory,error);
            return nil;
		}
    }
    
    NSURL *url = [NSURL fileURLWithPath: [applicationSupportDirectory stringByAppendingPathComponent: @"storedata"]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: mom];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType 
												  configuration:nil 
															URL:url 
														options:nil 
														  error:&error]){
        [[NSApplication sharedApplication] presentError:error];
        [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
        return nil;
    }    
	
    return persistentStoreCoordinator;
}

/**
 Returns the managed object context for the application (which is already
 bound to the persistent store coordinator for the application.) 
 */

- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext) return managedObjectContext;
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator: coordinator];
	
    return managedObjectContext;
}

/**
 Implementation of the applicationShouldTerminate: method, used here to
 do exactly nothing, but may be useful if we want to prevent closing before
 e.g. a torrent finishes transferring.
 */

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    return NSTerminateNow;
}


/**
 Implementation of dealloc, to release the retained variables.
 */

- (void)dealloc {
	
    [window release];
    [managedObjectContext release];
    [persistentStoreCoordinator release];
    [managedObjectModel release];
	
    [super dealloc];
}

@end

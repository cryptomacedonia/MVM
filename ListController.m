//
//  ListController.m
//  Music Video Maker
//
//  Created by Igor Jovcevski on 5/16/16.
//  Copyright © 2016 Woowave. All rights reserved.
//

#import "ListController.h"
#import "AppDelegate.h"
@interface ListController ()
{
    NSMutableArray * dataArray;
    NSMutableArray * objectArray;
    NSMutableArray * allFoundFiles;
}
@end

@implementation ListController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tracks=[NSMutableArray new];
   
    NSImage *backgroundImage = [NSImage imageNamed:@"texture"];
    NSColor *backgroundColor = [NSColor colorWithPatternImage:backgroundImage];
    self.tableView.backgroundColor = backgroundColor;
    [[self tableView] registerForDraggedTypes:[NSArray arrayWithObject:(NSString*)kUTTypeFileURL]];
    [_bottomButton setTitle:@"Import Media"];
    allFoundFiles = [NSMutableArray new];
    dataArray = [NSMutableArray new];
    objectArray = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(receiveDemofilePath:) name:@"addUrl" object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(demoCheck) name:@"demoCheck" object:nil];
    // [_arrayController setContent:objectArray];
 //   NSImage * thumb=[NSImage imageNamed:@"img"];
  //  dataArray = [@[@{@"thumb":@"img",@"fileName":@"img_390.mov jhjh dsjkh skjfdhsf kjhsdf ksjdf kjsdf",@"status":@"ready"}] mutableCopy];
    [self demoCheck];
   
   // if ([button.title isEqualToString:@"Subscribe to Import"])
    
    // Do view setup here.
}
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row 

    {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            [self showActionSynchronize];
        });
        return 45;
        
    }
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{

    
    return objectArray.count;
}

-(void) demoCheck
{
    BOOL isthisDemo = [[NSUserDefaults standardUserDefaults] boolForKey:@"demo"];
   // NSString *  importAllowed = PFUser[@"IMPORT"];
//    BOOL importAllowed = [[PFUser currentUser][@"ALLACCESS"] boolValue];
//    if (!importAllowed)
//        _bottomButton.title = @"Subscribe to Import";
//else
      [_bottomButton setTitle:@"Import Media"];
    
    
    
    
    
    
}

-(BOOL) areallFilesProcessed
{
    BOOL result = YES;
    for (int i=0;i<objectArray.count;i++)
    {
        
         if(![[objectArray objectAtIndex:i] clipstatus])
             result=NO;
        
        
        
    }
    if (!self.isMusicAdded)
        result = NO;
    
    
    if (_numberoftotalfiles>objectArray.count)
        return NO;
//    if (result)
//        [DJProgressHUD dismiss];
    return result;
    
}
-(void) showActionSynchronize
{
  
   if([self areallFilesProcessed])
        {
//            [DJProgressHUD dismiss];
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
                [_bottomButton setTitle:@"Synchronize"];
              BOOL demo =  [[NSUserDefaults  standardUserDefaults] boolForKey:@"demo"];
                int tipplayedtimes = [[[NSUserDefaults  standardUserDefaults] objectForKey:@"firsttip"] intValue];
               if (tipplayedtimes<2)
               {
                   [doo showToasMsg:@"Once all the files are processed and the Synchronize button shows up on the bottom of the list, you can proceed to next phase where you will be editing your footage ! Now Click the SYNCHRONIZE!" inView:self.view forDuration:7];
                   tipplayedtimes=tipplayedtimes+1;
                   [[NSUserDefaults  standardUserDefaults] setObject:[NSString stringWithFormat:@"%i",tipplayedtimes] forKey:@"firsttip"];
                 //  NSRect buttonFrameRelativeToScreen = [_bottomButton.window convertRectToScreen:_bottomButton.frame];
                //   float x = buttonFrameRelativeToScreen.origin.x + (buttonFrameRelativeToScreen.size.width / 2);
                 //  float y = buttonFrameRelativeToScreen.origin.y + (buttonFrameRelativeToScreen.size.height / 2);
                 //  dispatch_async(dispatch_get_main_queue(), ^{
                 //      [doo moveMouseToLocationX:x Y:y andClickIt:YES];
                 //  });
                 
                   
                   
               }
            });


        }
}

- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    NSTableCellView *result;
    
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
      if ([tableColumn.identifier isEqualToString:@"filenameColumn"])
      {
       result = [tableView makeViewWithIdentifier:@"filenameCell" owner:self];
           // result.textField.stringValue = [dataArray objectAtIndex:row][@"fileName"];
          result.textField.stringValue = [[objectArray objectAtIndex:row] filePath];
          
      }
        else if ([tableColumn.identifier isEqualToString:@"thumbColumn"])
        {
        result = [tableView makeViewWithIdentifier:@"thumbCell" owner:self];
           // [result.imageView setImage:[NSImage imageNamed:[dataArray objectAtIndex:row][@"thumb"]]];
            NSImageView * imageView = [result viewWithTag:100];
            [imageView setImage:[[objectArray objectAtIndex:row] thumbImage]];
           
        }
            else if ([tableColumn.identifier isEqualToString:@"statusColumn"])
            {
                  result = [tableView makeViewWithIdentifier:@"statusCell" owner:self];
                NSString * booleanString = ([[objectArray objectAtIndex:row] clipstatus]) ? @"Ready     " : @"Not Ready";
                NSString * statusImage = ([[objectArray objectAtIndex:row] clipstatus]) ? @"greensmall" : @"redsmall";
                
                NSImageView * statusImageVie = [result viewWithTag:100];
                if (statusImage)
                [statusImageVie setImage:[NSImage imageNamed:statusImage]];
                result.textField.stringValue = booleanString;               // result.textField.stringValue = [[objectArray objectAtIndex:row] clipstatus];
            }
    
            else if ([tableColumn.identifier isEqualToString:@"timestampColumn"])
            {
                result = [tableView makeViewWithIdentifier:@"timestampCell" owner:self];
              //  result.textField.stringValue = [dataArray objectAtIndex:row][@"timestamp"];
                result.textField.stringValue = [NSString stringWithFormat:@"%@",[[objectArray objectAtIndex:row]getFormattedTimeStamp]];
                
            }
    
    
      return result;
}


- (BOOL)tableView:(NSTableView *)tableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes   toPasteboard:(NSPasteboard*)pboard
{
    NSLog(@"write rows with indexes");
    
    return NO;
}

- (NSDragOperation)tableView:(NSTableView *)aTableView validateDrop:(id < NSDraggingInfo >)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)operation
{
    //get the file URLs from the pasteboard
    NSPasteboard* pb = info.draggingPasteboard;
    
    //list the file type UTIs we want to accept
    NSArray* acceptedTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
    
  //  NSArray* urls = [pb readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]]
//                                      options:[NSDictionary dictionaryWithObjectsAndKeys:
//                                               [NSNumber numberWithBool:YES],NSPasteboardURLReadingFileURLsOnlyKey,
//                                               acceptedTypes, NSPasteboardURLReadingContentsConformToTypesKey,
//                                               nil]];
    NSArray* urls = [pb readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]]
                                      options:[NSDictionary dictionaryWithObjectsAndKeys:
                                               [NSNumber numberWithBool:YES],NSPasteboardURLReadingFileURLsOnlyKey,
                                               nil, NSPasteboardURLReadingContentsConformToTypesKey,
                                               nil]];
   
    
    //only allow drag if there is exactly one file
//    if(urls.count != 1)
//        return NSDragOperationNone;
    
    return NSDragOperationCopy;
}



-(void)openEachFileAt:(NSString*)path
{
    NSURL* file;
    NSDirectoryEnumerator* enumerator  = [[NSFileManager defaultManager] enumeratorAtURL:[NSURL fileURLWithPath:path]
                                                          includingPropertiesForKeys:[NSArray arrayWithObject:NSURLIsHiddenKey]
                                                                             options:NSDirectoryEnumerationSkipsPackageDescendants | NSDirectoryEnumerationSkipsHiddenFiles|NSDirectoryEnumerationSkipsSubdirectoryDescendants
                                                                        errorHandler:nil];
    
    BOOL isDirectory = NO;
  
    [[NSFileManager defaultManager] fileExistsAtPath:path
                                         isDirectory: &isDirectory];
    NSURL * tempDir = [NSURL fileURLWithPath:NSTemporaryDirectory()];
    if (isDirectory&&![[NSURL fileURLWithPath:path] isEqual:tempDir])
    {
        
    while (file = [enumerator nextObject])
    {
        
        // check if it's a directory
        BOOL isDirectory = NO;
        
        NSString* fullPath = [file path];
        [[NSFileManager defaultManager] fileExistsAtPath:[file path]
                                             isDirectory: &isDirectory];
        if (!isDirectory)
        {
              @autoreleasepool {
            // open your file (fullPath)…
            NSString * UTI = (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,(__bridge CFStringRef)[fullPath pathExtension],NULL);
          if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeMovie))
             [allFoundFiles addObject:[NSURL fileURLWithPath:fullPath]];
              }
        
        }
        else
        {
              @autoreleasepool {
            [self openEachFileAt: fullPath];
              }
        }
    }
    }
    else
    {
          @autoreleasepool {
        NSString * UTI = (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,(__bridge CFStringRef)[path pathExtension],NULL);
        if (UTTypeConformsTo((__bridge CFStringRef)UTI, kUTTypeMovie))
            [allFoundFiles addObject:[NSURL fileURLWithPath:path]];
          }
    }
        
}
-(NSArray*) getAllFiles:(NSArray*) urlS
{
  
    allFoundFiles = [NSMutableArray new];
    
    for (NSURL * oneUrl in urlS)
    {
        [self openEachFileAt:[oneUrl path]];
        
    }
    
    
    return [allFoundFiles mutableCopy];
    
    
}

- (BOOL) tableView: (NSTableView *) view
        acceptDrop: (id <NSDraggingInfo>) info
               row: (int) row
     dropOperation: (NSTableViewDropOperation) operation
{
    NSPasteboard *pboard = [info draggingPasteboard];
   //NSData *data = [pboard dataForType: @"NSGeneralPboardType"];
    
//    if (row > [records count])
//        return NO;
//    BOOL isthisDemo = [[NSUserDefaults standardUserDefaults] boolForKey:@"demo"];
//    if (isthisDemo)
//    {
//        
//        return NO;
//        
//    }
    
    if (nil == [info draggingSource]) // From other application
    {
        //get the file URLs from the pasteboard
        NSPasteboard* pb = info.draggingPasteboard;
        
        //list the file type UTIs we want to accept
        NSArray* acceptedTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
        
        NSArray* urls = [pb readObjectsForClasses:[NSArray arrayWithObject:[NSURL class]]
                                          options:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSNumber numberWithBool:YES],NSPasteboardURLReadingFileURLsOnlyKey,
                                                   nil, NSPasteboardURLReadingContentsConformToTypesKey,
                                                   nil]];
        
        if (urls.count)
        {
            AVAsset * asset = [WOO_AVURLAsset assetWithURL:[urls firstObject]];
            int videoTracks = (int)[[asset tracksWithMediaType:AVMediaTypeVideo] count];
            int audioTracks =(int)[[asset tracksWithMediaType:AVMediaTypeAudio] count];
            BOOL protectedContent =   [asset hasProtectedContent];
        if (urls.count==1&&!videoTracks&&audioTracks&&!protectedContent)
        {
            for (int i = objectArray.count-1;i>=0;i--)
            {
                Clip * oneClip = objectArray[i];
                if (oneClip.numberOfAudioTracks&&!oneClip.numberOfVideoTracks)
                   [ objectArray removeObjectAtIndex:i];
            }
              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                  
            [self addFiles:@[[urls firstObject]] atRow:row];
              });
                
            
        }
            else
            {
        
           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
         NSArray * allFolderFiles = [ self getAllFiles:urls];
      
        [self addFiles:allFolderFiles atRow:row];
           });
            }
        }
        
        return YES;
    }
    else if (self.tableView == [info draggingSource]) // From self
    {
        return NO;
    }
    else // From other documents
    {
              return NO;
    }
    return NO;
}

-(void) addFiles:(NSArray*) urls atRow:(int) row
{
  //  dispatch_queue_t serialQueue = dispatch_queue_create("com.aj.serial.queue", DISPATCH_QUEUE_SERIAL);
    // dispatch_async(serialQueue, ^{
    
  //  [doo showProgressWithMsg:@"Processing Files.. This may take couple of minutes or more.Please be patient."];
    
    for (int i=0;i<urls.count;i++)
    {
        
        WOO_AVURLAsset* asset = [WOO_AVURLAsset assetWithURL:urls[i]];
        if ([[asset tracksWithMediaType:AVMediaTypeAudio] count]&&![asset hasProtectedContent])
        {
            
        NSURL * oneFileUrl = urls[i];
        Clip * oneClip = [[Clip alloc] initWithFileUrl:oneFileUrl.path];
        oneClip.row = i;
        oneClip.showingTableView = self.tableView;
      //  oneClip.numberOfProcessedFiles = &_numberOfProcessedFiles;
        oneClip.numberOfVideoTracks= [[asset tracksWithMediaType:AVMediaTypeVideo] count];
        oneClip.numberOfAudioTracks = (int)[[asset tracksWithMediaType:AVMediaTypeAudio] count] ;
            if (!oneClip.numberOfVideoTracks&&oneClip.numberOfAudioTracks)
                self.isMusicAdded=YES;
            [objectArray addObject:oneClip];
            if (objectArray.count>1&&self.isMusicAdded)
                dispatch_sync(dispatch_get_main_queue(), ^(void) {
                    [_bottomButton setTitle:@"Processing.."];
                });

       [oneClip processThumbs];
            
            NSString * proxyPathIfThereIsOne= [NSString stringWithFormat:@"%@%@PROXY.MOV",NSTemporaryDirectory(),[oneClip generateMD5:oneClip.filePath]];
            WOO_AVURLAsset* proxyAsset = [WOO_AVURLAsset assetWithURL:[NSURL fileURLWithPath:proxyPathIfThereIsOne]];
            BOOL proxyExists = [[NSFileManager defaultManager]fileExistsAtPath:proxyPathIfThereIsOne];
            if (!proxyExists)
            {
               
                [oneClip makeProxywithWidth:320 andHeigh:180 withBlock:^(bool retBool) {
                    
                }];
                
            }
            
            if (!oneClip.alreadyAnalyzed)
            {
             dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [oneClip extractAudiofromMediaFile:oneClip.filePath withBlock:^(bool retBool) {
            NSLog(@"done");
            
            [oneClip  getAudioFingerPrints:5];
        }];
             });}
            
            dispatch_sync(dispatch_get_main_queue(), ^(void) {
               
                [_dragDropLabel setHidden:YES];
            });
        }
    }
    //  });
    
}

-(NSMutableDictionary *) prepareData:(NSURL*)url
{
    NSMutableDictionary * resDict = [NSMutableDictionary new];
    
    [resDict setObject:[url path] forKey:@"fileName"];
     [resDict setObject:@"Not Ready" forKey:@"status"];
    [ resDict setObject:[url path]  forKey:@"thumb"];
    return resDict;
    
}

- (void)keyDown:(NSEvent *)theEvent
{
    
    unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
    if(key == NSDeleteCharacter)
    {
        
        [self removeSectedRows];
        return;
    }
    
    [super keyDown:theEvent];
    
}
-(void) removeSectedRows
{

NSIndexSet *itemArray = [self.tableView selectedRowIndexes];
 [self.tableView removeRowsAtIndexes:itemArray withAnimation:NSTableViewAnimationEffectGap];
NSNumber *num;
    NSMutableArray *selectedItemsArray=[NSMutableArray array];
    [itemArray enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [selectedItemsArray addObject:[NSNumber numberWithInteger:idx]];
    }];
    for (int i=selectedItemsArray.count-1;i>=0;i--)
    {
     //   NSIndex * oneRow = itemArray[i];
        if ([[objectArray objectAtIndex:[selectedItemsArray[i] intValue]] numberOfAudioTracks]&&![[objectArray objectAtIndex:[selectedItemsArray[i] intValue]] numberOfVideoTracks])
        {
            self.isMusicAdded = NO;
//          dispatch_sync(dispatch_get_main_queue(), ^(void) {
            [self demoCheck];
        //  });
    }
        [objectArray removeObjectAtIndex:[selectedItemsArray[i] intValue] ];
    
         }
    
    
    
    

}


- (IBAction)sendFileButtonAction:(id)sender{
    NSButton * button = sender;
    BOOL isthisDemo = [[NSUserDefaults standardUserDefaults] boolForKey:@"demo"];
    if ([button.title isEqualToString:@"Subscribe to Import"])
        {
            
            NSLog(@"start subscription process!");
            
              [(AppDelegate *)[NSApp delegate] subscribeNow];
            
            
            
            
            
        }
    if ([button.title isEqualToString:@"Import Media"])
    {
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"demo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
   
    [openDlg setAllowedFileTypes:[NSArray arrayWithObjects:@"public.video",@"public.audio",@"public.sound",nil]];
    [openDlg setAllowsMultipleSelection:TRUE];
    [openDlg setAllowsOtherFileTypes:NO];
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection: YES];
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openDlg runModalForDirectory:nil file:nil] == NSOKButton )
    {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* files = [openDlg filenames];
        int row = MAX(objectArray.count-1,0);
        NSMutableArray * urls = [NSMutableArray new];
        // Loop through all the files and process them.
        for( int i = 0; i < [files count]; i++ )
        {
            NSString* fileName = [files objectAtIndex:i];
        //    [self log:fileName];
           [ urls addObject:[NSURL fileURLWithPath:fileName]];
            
            // Do something with the filename.
        }
        
        if (urls.count)
        {
            AVAsset * asset = [WOO_AVURLAsset assetWithURL:[urls firstObject]];
            int videoTracks = (int)[[asset tracksWithMediaType:AVMediaTypeVideo] count];
            int audioTracks =(int)[[asset tracksWithMediaType:AVMediaTypeAudio] count];
            if (urls.count==1&&!videoTracks&&audioTracks)
            {
                for (int i = objectArray.count-1;i>=0;i--)
                {
                    Clip * oneClip = objectArray[i];
                    if (oneClip.numberOfAudioTracks&&!oneClip.numberOfVideoTracks)
                        [ objectArray removeObjectAtIndex:i];
                }
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                    
                    [self addFiles:@[[urls firstObject]] atRow:row];
                });
                
                
            }
            else
            {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                    NSArray * allFolderFiles = [ self getAllFiles:urls];
                    
                    [self addFiles:allFolderFiles atRow:row];
                });
            }
        }

    }
    }
    else if ([button.title isEqualToString:@"Synchronize"])
    {
        NSLog(@"Synchronize action...");
        
        [self sync];
        
    }
}


-(void) sync
{
    Clip * audioClip;
   
    for (int i=0;i<objectArray.count;i++)
        if (![objectArray[i] numberOfVideoTracks])
        {
            audioClip = objectArray[i];
            
          
         
           
        }
    audioClip.matchedClips = [NSMutableArray new];
    _tracks = [NSMutableArray new];
    for (int i=0;i<objectArray.count;i++)
    {
        if (![audioClip isEqual:objectArray[i]])
        {
            
            [audioClip compareToClip:objectArray[i]];
            
            
            
            
            
        }
    
    }
    
    
    [self createStructure:audioClip.matchedClips];
    NSLog(@"total clips: %lu matched clips:%lu unmatched:%lu",(unsigned long)objectArray.count,(unsigned long)audioClip.matchedClips.count,objectArray.count-1-(unsigned long)audioClip.matchedClips.count);
    
}

-(void) createStructure:(NSArray*) data
{
    
    
    for (int i =0;i<data.count;i++)
    {
        NSMutableDictionary * oneSourceClip = [data[i] mutableCopy];
        BOOL sourceoffsetlessthanzero = NO;
        float sourceOffset = [oneSourceClip[@"offset"] floatValue]*192.0/8000.0;
        Clip * sourceClip = oneSourceClip[@"ClipObject"];
        CMTimeRange sourceTimerange = CMTimeRangeMake(CMTimeMake(sourceOffset*-1*1000.0, 1000),sourceClip.duration);
        
        if (sourceOffset>0)
        {   sourceoffsetlessthanzero=YES;
            sourceTimerange = CMTimeRangeMake(kCMTimeZero,CMTimeSubtract(sourceClip.duration, CMTimeMake(sourceOffset*1000.0, 1000)));
        }
        NSLog(@"clip duration:%f dest clip start: %f  end: %f", CMTimeGetSeconds(sourceClip.duration), CMTimeGetSeconds(sourceTimerange.start),CMTimeGetSeconds(sourceTimerange.duration)   );
        
        
      //    CMTimeRange oneSourceClipTimeRange = CMTimeRangeMake(CMTimeMake([oneSourceClip[@"offset"] intValue], 192),CMTimeMake([oneSourceClip[@"ClipObject"] durationInFrames],192));
        CMTimeRange oneSourceClipTimeRange = sourceTimerange;
         BOOL didwemanagetoinsertthisclip = NO;
        for (int j=0;j<_tracks.count;j++)
        {
            NSMutableArray * oneTrack = _tracks[j];
            BOOL isThereSpaceInThisTrack = YES;
            for (int k=0;k<oneTrack.count;k++)
            {
                NSDictionary * oneDestClip = oneTrack[k];
                BOOL destCLipsourceoffsetlessthanzero = NO;
                float destClipOffset = [oneDestClip[@"offset"] floatValue]*192.0/8000.0;
                Clip * destClip = oneDestClip[@"ClipObject"];
               // CMTimeRange destClipTimerange = CMTimeRangeMake(CMTimeMake(destClipOffset*1000.0, 1000),destClip.duration);
                 CMTimeRange destClipTimerange = CMTimeRangeMake(CMTimeMake([oneDestClip[@"start"] floatValue]*1000.0, 1000),CMTimeMake([oneDestClip[@"end"] floatValue] *1000.0, 1000));
                
              
//                if (destClipOffset<0)
//                {   destCLipsourceoffsetlessthanzero=YES;
//                    destClipTimerange = CMTimeRangeMake(kCMTimeZero,CMTimeSubtract(destClip.duration, CMTimeMake(destClipOffset*1000.0, 1000)));
//                }

             //   CMTimeRange oneDestClipTimeRange = CMTimeRangeMake(CMTimeMake([oneDestClip[@"offset"] intValue], 192),CMTimeMake(((float)[oneDestClip[@"ClipObject"] durationInFrames]*192.0/8000.0f)*1000,1000));
                NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");
                  NSLog(@"source clip start: %f  end: %f", CMTimeGetSeconds(sourceTimerange.start),CMTimeGetSeconds(sourceTimerange.duration)   );
                  NSLog(@"dest clip start: %f  end: %f", CMTimeGetSeconds(destClipTimerange.start),CMTimeGetSeconds(destClipTimerange.duration)   );
                CMTimeRange intersection = CMTimeRangeGetIntersection(oneSourceClipTimeRange, destClipTimerange) ;
                 NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");
                if (!CMTIMERANGE_IS_EMPTY(intersection))
                    isThereSpaceInThisTrack=NO;
                
                
            }
            
            if (isThereSpaceInThisTrack)
            {
                oneSourceClip[@"start"] = @(CMTimeGetSeconds(oneSourceClipTimeRange.start));
                oneSourceClip[@"end"] = @(CMTimeGetSeconds(CMTimeRangeGetEnd(oneSourceClipTimeRange)));
                [oneTrack addObject:oneSourceClip];
                didwemanagetoinsertthisclip = YES;
                break;
            }
            
            
            
            
            
        }
        
        if (!didwemanagetoinsertthisclip)
        {
            NSMutableArray * tr = [NSMutableArray new];
            oneSourceClip[@"start"] = @(CMTimeGetSeconds(oneSourceClipTimeRange.start));
            oneSourceClip[@"end"] = @(CMTimeGetSeconds(CMTimeRangeGetEnd(oneSourceClipTimeRange)));
            [tr addObject:oneSourceClip];
            [ _tracks addObject:tr];
            
            
            
        }
        
        
        
        
    }
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"offset"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    
    
    for (int i=0;i<_tracks.count;i++)
    {
    
        
        
        
        _tracks[i] = [[_tracks[i] sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
        
        
        
    }

    Clip * audioClip;
    
    for (int i=0;i<objectArray.count;i++)
        if (![objectArray[i] numberOfVideoTracks])
        {
            audioClip = objectArray[i];
            
            
            
            
        }
     CMTimeRange audioSourceClipTimeRange = CMTimeRangeMake(kCMTimeZero,CMTimeMake([audioClip  durationInFrames],192));
    NSDictionary * audioDict = @{@"start":@0,@"end":@(CMTimeGetSeconds(CMTimeRangeGetEnd(audioSourceClipTimeRange))),@"offset":@(0),@"ClipObject":audioClip};
    NSMutableArray * tr = [NSMutableArray new];
   
    [tr addObject:[audioDict mutableCopy]];
    [ _tracks addObject:tr];

    NSLog(@"%@",_tracks);
    
    [self createJsonSructure:_tracks];
    
}

-(void) createJsonSructure:(NSMutableArray *) tracks
{
    
    
    Clip * one = objectArray[0];
    NSString *json = [one makeJson:tracks];
    NSLog(@"%@", json);

    NSString *savePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"data.json"];

    NSError *error = nil;
    BOOL result = [json writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:&error];

    if(result)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showPlayWindow" object:nil];
    
}
-(void) receiveDemofilePath:(NSNotification*)notification
{
   
        NSDictionary* userInfo = notification.userInfo;
    NSMutableArray * fileURLs = userInfo[@"fileUrls"];
    _numberoftotalfiles = fileURLs.count;
 //   NSLog(@"receivedfile:%@",filePath);
   // [allFoundFiles addObject:[NSURL fileURLWithPath:filePath]];
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        [self addFiles:fileURLs  atRow:0];
       
    });
   
}

    @end

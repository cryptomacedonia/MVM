//
//  ViewController.m
//  playTableView
//
//  Created by Igor Jovcevski on 12/23/15.
//  Copyright © 2015 WoowaveTemplate. All rights reserved.
//

#import "ListViewController.h"
#import "WWCellCustom1.h"
#import "customTableRowView.h"
#import "customTableColumn.h"
#import "aafLib.hpp"



//@import QuartzCore;

@implementation ListViewController
{
 BOOL programmedSelection ;
      NSMutableDictionary *datDict;
    NSMutableArray * countedColumns;
    vector<AvidMediaFiles> eMovies;
}
- (void)tableView:(NSTableView *)tableView didClickedRow:(NSInteger)row {
  //  NSLog(@"clicked");
    // have fun
}

-(void) updateTables:(NSNotification*) notification
{
    [self refreshData];
  //  [_rightTableView reloadData];
   // [_leftTableView reloadData];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _KVOController = [FBKVOController controllerWithObserver:self];
    
     _playerWindowController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil ] instantiateControllerWithIdentifier:@"player"];
    [_playerWindowController showWindow:self];
    _playerWindowController.window.alphaValue = 0;
//    mediaFileObjC * media = _dataArray[self.leftTableView.selectedRow];
//    NSDictionary * dictionary = [self getMediaAccessData:media];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"setupMovie" object:nil userInfo:dictionary];
//    });

    
    // observe clock date property
    
    
    
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTables:) name:@"updateTables" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRows:) name:@"updateRows" object:nil];
    [_leftTableView setDraggingSourceOperationMask:NSDragOperationAll forLocal:NO];
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePreview:) name:@"changePreview" object:nil];
         
    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil]; // get a reference to the storyboard
    [self.view mouseDownCanMoveWindow];
   // _playerWindowController = [storyBoard instantiateControllerWithIdentifier:@"player"];
//    _myController = [storyBoard instantiateControllerWithIdentifier:@"player"]; // instantiate your window controller
  
   
//    //  [_myController showWindow:self];
//    [_listWindow.window addChildWindow:_myController.window ordered:NSWindowAbove];
//    [_myController showWindow:self];
//    // show the window
//    [_listWindow showWindow:self];

    
    
    
    
    NSRect frame = _rightTableView.headerView.frame;
    frame.size.height = 15;
    _rightTableView.headerView.frame = frame;
    
    frame = _leftTableView.headerView.frame;
    frame.size.height = 15;
    _leftTableView.headerView.frame = frame;
    
    
//    CALayer *viewLayer = [CALayer layer];
//    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(0.0, 0.0, 0.0, 0.4)]; //RGB plus Alpha Channel
//    [self.view setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
//    [self.view setLayer:viewLayer];
  
    [_leftTableView setBackgroundColor:[NSColor clearColor]];
      [_rightTableView setBackgroundColor:[NSColor clearColor]];
   datDict=[NSMutableDictionary new];
    countedColumns=[NSMutableArray new];
    programmedSelection= NO;
    _leftTableView.extendedDelegate=self;
    _rightTableView.extendedDelegate=self;
    _leftTableView.pairedTableView=_rightTableView;
    _rightTableView.pairedTableView=_leftTableView;
    
    [_leftScrollView setSynchronizedScrollView:_rightScrollView];
//    [_leftScrollView  setAcceptsTouchEvents:NO];
    _leftScrollView.uniqueId=100;
    [[_leftScrollView verticalScroller] setAlphaValue:0];
    
    [_rightScrollView setSynchronizedScrollView:_leftScrollView];
   // _tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    
    
  //file codec   frame rate, start time , end time , duration , resolution, audio rate, log, status, scene, shot
    
    
    NSDictionary * one = @{@"mainTextField":@"igor jovcevski",@"detailTextField":@"date of birth place of birth etc.",@"image":@"slika1.png",@"place":@"Skopje",@"planet":@"Earth",@"address":@"47 Standside Northampton",@"Carmodel":@"Peugeot"};
//    NSDictionary * two = @{@"mainTextField":@"anetta jovcevska",@"detailTextField":@"date of birth place of birth etc.",@"image":@"slika1.png",@"place":@"Skopje",@"planet":@"Earth",@"address":@"47 Standside Northampton",@"Carmodel":@"Peugeot"};
//    NSDictionary * three = @{@"mainTextField":@"goran jovcevski",@"detailTextField":@"date of birth place of birth etc.",@"image":@"slika1.png",@"place":@"Skopje",@"planet":@"Earth",@"address":@"47 Standside Northampton",@"Carmodel":@"Peugeot"};
//     NSDictionary * four = @{@"mainTextField":@"bianca jovcevska",@"detailTextField":@"date of birth place of birth etc.",@"image":@"slika1.png",@"place":@"Skopje",@"planet":@"Earth",@"address":@"47 Standside Northampton",@"Carmodel":@"Peugeot"};
    //[_dataArray addObject:one];
//    [_dataArray addObject:two];
//    [_dataArray addObject:three];
//       [_dataArray addObject:four];
    
//    NSMutableArray * columns;
//    
//    if (_dataArray.count)
//        columns=[[[_dataArray firstObject] allKeys] mutableCopy];
//    else
//        columns=@[@"Name"];
    customTableColumn * oneColumn = [_rightTableView.tableColumns objectAtIndex:0];
      customTableColumn * oneColumn2 = [_leftTableView.tableColumns objectAtIndex:0];
    [_rightTableView removeTableColumn:oneColumn];
    [_leftTableView removeTableColumn:oneColumn2];
    
//
//    for (NSString * columnName in self.parentController.activeColumns)
//    {
//     oneColumn=[[customTableColumn alloc] initWithIdentifier:@"customTableColumn"];
//        [[oneColumn headerCell] setStringValue:@"FPS"];
//         [oneColumn setColumnName:@"Details"];
//        [_rightTableView addTableColumn:oneColumn];
    oneColumn=[[customTableColumn alloc] initWithIdentifier:@"customTableColumn"];
    [[oneColumn headerCell] setStringValue:@"Source File"];
    [oneColumn headerCell].drawsBackground=YES;
    [oneColumn headerCell].backgroundColor=[NSColor blackColor];
    [oneColumn setColumnName:@"Source File"];
    [oneColumn setWidth:50];
    [_leftTableView addTableColumn:oneColumn];
    oneColumn=[[customTableColumn alloc] initWithIdentifier:@"customTableColumn"];
    [[oneColumn headerCell] setStringValue:@"Video"];
    [oneColumn headerCell].drawsBackground=YES;
    [oneColumn headerCell].backgroundColor=[NSColor blackColor];
    [oneColumn setColumnName:@"Video"];
    [oneColumn setWidth:50];
    [countedColumns addObject:@"Video"];
     [_rightTableView addTableColumn:oneColumn];
    
    oneColumn=[[customTableColumn alloc] initWithIdentifier:@"customTableColumn"];
    [[oneColumn headerCell] setStringValue:@"Audio Format"];
    [oneColumn headerCell].drawsBackground=YES;
    [oneColumn headerCell].backgroundColor=[NSColor blackColor];
    [oneColumn setColumnName:@"Audio Format"];
     [countedColumns addObject:@"Audio Format"];
       [_rightTableView addTableColumn:oneColumn];
    oneColumn=[[customTableColumn alloc] initWithIdentifier:@"customTableColumn"];
    [[oneColumn headerCell] setStringValue:@"Status"];
    [oneColumn headerCell].drawsBackground=YES;
    [oneColumn headerCell].backgroundColor=[NSColor blackColor];
    [oneColumn setColumnName:@"Status"];
    [countedColumns addObject:@"Status"];
    [_rightTableView addTableColumn:oneColumn];
    
//
//
//    }
//  customTableColumn * oneColumn3=[[customTableColumn alloc] initWithIdentifier:@"customTableColumn"];
//     [oneColumn3 setColumnName:@"Source File"];
//
//    [[oneColumn2 headerCell] setStringValue:@"Source File"];
//    [_leftTableView addTableColumn:oneColumn3];
   // [_tableView addTableColumn:oneColumn2];
    [self setHeaderCells];
    _leftTableView.delegate=self;
    _leftTableView.dataSource=self;
    _rightTableView.delegate=self;
    _rightTableView.dataSource=self;
   
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear
{
//    [self selectRow:2 highLightFillWithColor:  [NSColor colorWithRed:0.3 green:0.7 blue:0.1 alpha:0.5]highlightStrokeWithColor:[NSColor colorWithCalibratedWhite:.65 alpha:1.0] extendSelection:YES];
//    
//     [self selectRow:3 highLightFillWithColor:  [NSColor colorWithRed:0.3 green:0.1 blue:0.1 alpha:0.5]highlightStrokeWithColor:[NSColor colorWithCalibratedWhite:.65 alpha:1.0] extendSelection:YES];
//   
//    
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma tableView Delegate Methods
- (void)tableView:(NSTableView *)tableView
  willDisplayCell:(id)cell
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
    
    
    if ([cell isSelected])
        [cell setBackgroundColor:[NSColor yellowColor]];
    else
        [cell setBackgroundColor:[NSColor clearColor]];
   
}

-(IBAction)rowSelected:(id)sender
{
    
    
//    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:country forKey:@"Country"];
//    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"citiesListComplete" object:nil userInfo:dictionary];
    
    
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification
{
    
    
    
}
-(void)tableViewSelectionIsChanging:(NSNotification *)notification
{
    if (!programmedSelection)
    {
        WWNSTableView * selectedtableView = notification.object;
        _leftTableView.extendedDelegate=self;
        _rightTableView.extendedDelegate=self;
        NSMutableIndexSet * selectedRows = [selectedtableView selectedRowIndexes];
        
        WWNSTableView * pairedTableView = selectedtableView.pairedTableView;
        [pairedTableView deselectAll:nil];
        
        NSMutableIndexSet * pairedSelection = [[pairedTableView selectedRowIndexes] mutableCopy];
        
        [pairedSelection addIndexes:selectedRows];
        
        //[selectedtableView deselectAll:selectedRows];
        //  [pairedTableView deselectAll:selectedRows];
        programmedSelection=YES;
        [selectedtableView selectRowIndexes:pairedSelection byExtendingSelection:NO];
        
        [pairedTableView selectRowIndexes:pairedSelection byExtendingSelection:NO];
        programmedSelection=NO;
        
    }
    
    
//    NSLog(@"\n**********************************\n");
//    NSLog(@"window ->%ld\n",self.view.window.windowNumber);
//    NSLog(@"**********************************\n");
//    NSLog(@"********* selection changed ***********\n");
    
  

   
    
}

-(void) changePreview:(NSNotification*) notification
{
    NSDictionary * msg = notification.userInfo;
    NSNumber * number = msg[@"windowID"];
    if ([number longValue]==self.view.window.windowNumber)
    {
        _previewIsOn=[msg[@"previewEnabled"] boolValue];
    
        if (!_previewIsOn)
        {
            CGRect frejm = _playerWindowController.window.frame;
            frejm.origin.x=-200;
            [ self.view.window removeChildWindow:self.view.window.childWindows.firstObject];
            _playerWindowController=nil;
//            [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
//                context.duration = 0.5;
//                _playerWindowController.window.alphaValue = 0;
//                [_playerWindowController.window setFrame:frejm display:YES];
//            }
//                                completionHandler:^{
//                                   
//                                }];
            
               //[_playerWindowController.window setFrame:frejm display:YES];
            
            
        }
        else
        {
            
            
            
            
            
            
            
        }
    
    }
    
    
    
    
    
}


- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
   
    
    
    
    customTableRowView * rowView= [tableView rowViewAtRow:row makeIfNecessary:NO];
   
   if (!programmedSelection)
   {
       rowView.highlightedFillColor = defaultRowViewFillColor;
       rowView.highlightedStrokeColor = defaultRowViewStrokeColor;
       WWNSTableView * selectedtableView = tableView;
       _leftTableView.extendedDelegate=self;
       _rightTableView.extendedDelegate=self;
       NSMutableIndexSet * selectedRows = [selectedtableView selectedRowIndexes];
       
       WWNSTableView * pairedTableView = selectedtableView.pairedTableView;
       [pairedTableView deselectAll:nil];
       
       NSMutableIndexSet * pairedSelection = [[pairedTableView selectedRowIndexes] mutableCopy];
       
       [pairedSelection addIndexes:selectedRows];
       [pairedSelection removeAllIndexes];
       [pairedSelection addIndex:row];
       
       //[selectedtableView deselectAll:selectedRows];
       //  [pairedTableView deselectAll:selectedRows];
       programmedSelection=YES;
      // [selectedtableView selectRowIndexes:pairedSelection byExtendingSelection:NO];
       
       [pairedTableView selectRowIndexes:pairedSelection byExtendingSelection:NO];
       programmedSelection=NO;
      
   } else
   {
     
       
       
       
   }
    
//    Megapoint p;
//    [value getValue:&p];
    if (self.previewIsOn)
    {
          if (!_playerWindowController)
        {
              _playerWindowController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil ] instantiateControllerWithIdentifier:@"player"];
            mediaFileObjC * media = _dataArray[row];
            NSDictionary * dictionary = [self getMediaAccessData:media];
            //   Country *country = [[[Country alloc] init] autorelease];
            //Populate the country object however you want
            
            // NSDictionary *dictionary = [NSDictionary dictionaryWithObject:country forKey:@"Country"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"setupMovie" object:nil userInfo:dictionary];
            });
           

        }
        else
        {
            
           mediaFileObjC * media = _dataArray[row];
            NSDictionary * dictionary = [self getMediaAccessData:media];
              [[NSNotificationCenter defaultCenter] postNotificationName:@"setupMovie" object:nil userInfo:dictionary];
            
            
        }
        [_playerWindowController showWindow:self];
          _playerWindowController.window.alphaValue = 1;
        if (_playerWindowController.window.parentWindow!=self.view.window)
        { [self.view.window addChildWindow:_playerWindowController.window ordered:NSWindowBelow];
            CGRect frejm = _playerWindowController.window.frame;
            frejm.origin.x=self.view.frame.size.width-60;
            frejm.origin.y=self.view.frame.size.height+2;
            frejm.size.height =self.view.frame.size.height;
            
            
            
            [_playerWindowController.window setFrame:frejm display:YES];
               [_playerWindowController.window viewsNeedDisplay];
            
        }
        else
        {
            CGRect frejm = _playerWindowController.window.frame;
            frejm.origin.x=self.view.window.frame.origin.x+self.view.window.frame.size.width-80;
            frejm.origin.y=self.view.window.frame.origin.y+30;
            frejm.size.height =self.view.frame.size.height;
            
            [_playerWindowController.window viewsNeedDisplay];
            
            [_playerWindowController.window setFrame:frejm display:YES];
        }
        
        [self.view.window makeKeyAndOrderFront:nil];
        [self.view.window makeMainWindow];
        
        
    }
    
//    NSValue * mediaValue = [_dataArray[row] objectForKey:@"AvidMediaFiles"];
//    [mediaValue getValue:&media];
    programmedSelection = NO ;
    return YES;
    
    
    
    
}


//- (void)tableViewSelectionDidChange:(NSNotification *)notification
//{
//    [_tableView enumerateAvailableRowViewsUsingBlock:^(NSTableRowView *rowView, NSInteger row){
//        WWCellCustom1 *cellView = [rowView viewAtColumn:0];
//        if(rowView.selected){
//            [cellView.backGroundImage  setImage: [NSImage imageNamed:@"selectedCellBackground"]];
//        }else{
//               [cellView.backGroundImage  setImage: [NSImage imageNamed:@"unselectedCellBackground"]];
//        }
//    }];
//}

-(NSDictionary * ) getMediaAccessData:(mediaFileObjC*) media
{
    NSMutableArray * audioFiles=[NSMutableArray new];
    NSString       * videoFile=@"";
    NSString       * AMAFileSource=@"";
    if (media.audioFiles.count)
    {
        for (int i=0;i<media.audioFiles.count;i++)
            [audioFiles addObject: media.audioFiles[i]];
    }
    
    if (media.videoFiles.count)
        videoFile= media.videoFiles[0];
    
    if (media.VideoAndAudioTogetherFiles.count&&!media.videoFiles.count&&!media.audioFiles.count)
    {
        
        AMAFileSource = (media.VideoAndAudioTogetherFiles[0]);
        
        
    }
    
    if (media.AAFSequenceStructureInJson)
    {
        // find AMA mxf links
        
        
        
        
        
    }
    
    if (!media.AAFSequenceStructureInJson)
        media.AAFSequenceStructureInJson=@"";
    
    
    NSDictionary * retDict = @{@"AMASourceFile":AMAFileSource,@"audioFiles":audioFiles,@"videoFile":videoFile,@"windowNumber":@(self.view.window.windowNumber),@"AAFSequenceStructureInJson":media.AAFSequenceStructureInJson};
    return retDict;
    
}

-(void) selectRow:(int) row highLightFillWithColor:(NSColor*) highLightFillColor highlightStrokeWithColor:(NSColor*)   highLightStrokeColor   extendSelection:(BOOL)extendSelection
{
    programmedSelection = YES ;
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:row];
    [_leftTableView selectRowIndexes:indexSet byExtendingSelection:extendSelection];
    customTableRowView *customrow= [_leftTableView rowViewAtRow:row makeIfNecessary:NO];
    [_rightTableView selectRowIndexes:indexSet byExtendingSelection:extendSelection];
    

   
    customrow.highlightedFillColor=highLightFillColor;
    customrow.highlightedStrokeColor=highLightStrokeColor;
  //  [cell setBackgroundColor:[NSColor greenColor]];
    
    
    
    
}

//-(void)tableViewSelectionDidChange:(NSNotification *)aNotification {
//    
////    NSInteger selectedRow = [_tableView selectedRow];
////    customTableRowView *myRowView = [_tableView rowViewAtRow:selectedRow makeIfNecessary:NO];
////    [myRowView setEmphasized:NO];
//}

//- (BOOL)tableView:(NSTableView *)tableView should
//:(NSInteger)row
//{
//    
//    id cell= [tableView rowViewAtRow:row makeIfNecessary:NO];
//    [cell setBackgroundColor:[NSColor clearColor]];
//    return YES;
//    
//    
//    
//    
//}

-(NSView *)tableView:(WWNSTableView *)tableView viewForTableColumn:(customTableColumn *)tableColumn row:(NSInteger)row

 {
    
    // Retrieve to get the @"MyView" from the pool or,
    // if no version is available in the pool, load the Interface Builder version
    WWCellCustom1 *cell = [tableView makeViewWithIdentifier:@"WWCellCustom1" owner:self];

    // Set the stringValue of the cell's text field to the nameArray value at row
   // result.textField.stringValue = [self.dataArray objectAtIndex:row];
   // NSString * text = [[self.dataArray objectAtIndex:row] objectForKey:tableColumn.columnName];
     
    // NSLog(@"text value: %@",text);
   // if (text)
   // {
   // [cell.mainTextField setStringValue:[[self.dataArray objectAtIndex:row] objectForKey:tableColumn.columnName]];
     //   NSString * txt = [self columnValueForColumnName:tableColumn.columnName forEMovie:eMovies[row]];
   NSString *  txt = [self.dataArray[row] clipName];
     [self.dataArray[row] setRowNumber:row];
 //   NSError * error;
//     dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//         [self.dataArray[row] getThumbnail];
         [cell.image setImage:[self.dataArray[row] thumbnail]];
     NSArray * commentsKeys =[[self.dataArray[row] comments] allKeys];
//});
     
//     for (int i=0;i<commentsKeys.count;i++)
//     {
//         
//         
//         
//     }
      if (!txt.length)
      { txt=@"sample";
          mediaFileObjC * one = self.dataArray[row];
      
          
      }
        [cell.mainTextField setStringValue: txt];
        
//    }
//     else
//     {
//         [cell.mainTextField setStringValue:@" - "];   }
   // [cell.detailTextField setStringValue:[[self.dataArray objectAtIndex:row] objectForKey:@"detailTextField"]];
     if (![tableColumn.columnName isEqualToString:@"Source Clip"])
     {
         if ([[[self.dataArray[row] comments] allKeys] containsObject:tableColumn.columnName])
         [cell.mainTextField setStringValue:[[self.dataArray[row] comments] objectForKey:tableColumn.columnName]];
         mediaFileObjC * clip = self.dataArray[row];
          if ([tableColumn.columnName isEqualToString:@"Status"])
          {
//              [clip  already_Prepared_for_SyncWithBlock:^(bool retBool) {
//                  
//                  dispatch_async(dispatch_get_main_queue(), ^(){
//                       [cell.mainTextField setStringValue:@"READY"];
//                      
//                  });
//                 
//                  
//                  
//                  
//              }];
              
//              [cell.mainTextField setStringValue:@"READY"];
//              else
//                 [cell.mainTextField setStringValue:@"NOT READY"];
            //  NSLog(@"\n\n\n status->%@\n\n\n\n",clip.status);
          }
     }
    // Return the result
    return cell;
}

-(NSString *) columnValueForColumnName:(NSString *)columnName forEMovie:(AvidMediaFiles) eMovie
{
    for ( int i =0;i<eMovie.comments.size();i++)
    {
        
        if ([columnName isEqualToString:StringWToNSString(eMovie.comments[i].commentName)])
        {
            
            return StringWToNSString(eMovie.comments[i].commentName);
            
            
            
        }
            
        
        
    }
    
    if ([columnName isEqualToString:@"Source File"])
    {
        if (eMovie.videoAudioTogetherFiles.size())
        {
            NSString * sourceFile = [StringWToNSString(eMovie.videoAudioTogetherFiles[0].essencePath) lastPathComponent];
            return sourceFile ;
        }
        if (eMovie.pictureEssence.size())
            return StringWToNSString(eMovie.pictureEssence[0].Source_File);
        if (eMovie.audioEsences.size())
            return StringWToNSString(eMovie.audioEsences[0].Source_File);
     
        
    }
    
    
    
    return @"-";
    
}

- (NSTableRowView *)tableView:(NSTableView *)tableView
                rowViewForRow:(NSInteger)row {
    static NSString* const kRowIdentifier = @"RowView";
    customTableRowView* rowView = [tableView makeViewWithIdentifier:kRowIdentifier owner:self];
    if (!rowView) {
        // Size doesn't matter, the table will set it
        rowView = [[customTableRowView alloc] initWithFrame:self.view.frame];
        
        // This seemingly magical line enables your view to be found
        // next time "makeViewWithIdentifier" is called.
        rowView.identifier = kRowIdentifier;
        rowView.selectionHighlightStyle=NSTableViewSelectionHighlightStyleRegular;
        
    }
    if (row%2)
        rowView.odd=NO;
    else
        rowView.odd  =YES;
    // Can customize properties here. Note that customizing
    // 'backgroundColor' isn't going to work at this point since the table
    // will reset it later. Use 'didAddRow' to customize if desired.
    
    return rowView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    
    
    return self.dataArray.count;
   // return self.parentController.dataArray.count;
}
//AVAILABLECOLUMNS (@[@"AFD",@"Ancillary Data",@"ASC_SAT",@"ASC_SOP",@"Audio Bit Depth",@"Audio Format",@"Audio SR",@"Aux TC 24",@"Auxiliary link",@"Auxiliary TC1",@"Auxiliary TC2",@"Auxiliary TC3",@"Auxiliary TC4",@"Auxiliary TC5",@"Auxlnk Dur",@"Auxlnk Edge",@"Auxlnk End",@"Auxlnk Film",@"Cadence",@"Camera",@"Camroll",@"CFPS",@"Color",@"Color Space",@"Color Transformation",@"Creation Date",@"Disk label",@"DPX",@"Drive",@"Duration",@"End",@"Field Motion",@"Film TC",@"Format",@"FPS",@"Frame",@"iDataLink",@"Image Aspect Ratio",@"Image Framing",@"IN-OUT",@"lnk Dur",@"lnk Edge",@"lnk End",@"lnk Film",@"lnk Number",@"Journalist",@"KN Dur",@"KN End",@"KN Film",@"KN IN-OUT",@"KN Mark IN",@"KN Mark OUT",@"KN Start",@"LabRoll",@"Lock",@"LUT",@"Mark IN",@"Mark OUT",@"Marker",@"Master Dur",@"Master Edge",@"Master End",@"Master Film",@"Master Start",@"Modified Date",@"Offline",@"Perf",@"Pixel Aspect Ratio",@"Production",@"Project",@"Pullin",@"Pullout",@"Raster Dimension",@"Reel #",@"Reformat",@"S3D Alignment",@"S3D Channel",@"S3D Clip Name",@"S3D Contributors",@"S3D Eye Order",@"S3D Group Name",@"S3D Inversion",@"S3D InversionR",@"S3D Leading Eye",@"Scene",@"Shoot Date",@"Slip",@"Sound TC",@"Soundroll",@"Source File",@"Source Path",@"Start",@"Take",@"Tape",@"TapeID",@"TC 24",@"TC 25",@"TC 25PD",@"TC 30",@"TC 30 NP",@"Track Formats",@"Tracks",@"Transfer",@"UNC Path",@"Vendor Asset Description",@"Vendor Asset ID",@"Vendor Asset Keywords",@"Vendor Asset Name",@"Vendor Asset Price",@"Vendor Asset Rights",@"Vendor Asset Status",@"Vendor Download Master",@"Vendor Invoice ID",@"Vendor Name",@"Vendor Original Master",@"Vendor URL",@"VFX",@"VFX Reel",@"Video",@"Video File Format",@"VITC",@"Field Ordering",@"GFX-Video Level" ])

#pragma handleDragDropIntoTheTable
-(void) doSomethingWithDraggedFiles:(id) filenames
{
    NSLog(@"dosomethingwithdraggedfiles");
//    Video->H.264
//    Image Aspect Ratio->180:101
//    Video File Format->MOV
//    Audio Format->AAC
//    _acfparametersxml.ama.bin.0->6caede802de04e2f9f5d904b7a2c2f4a:Field Ordering:322655d50a5646ca9260d006f719b8a4:GFX-Video Level:
//    Source Setting->Custom Settings
//    Field Ordering->Progressive
//    GFX-Video Level->Expand video levels to graphic levels
//    Camera->cameraField
//    Production->ProductionFielf
//    TapeID->tapeIDField
//    Scene->SceneField
//    Shoot Date->shootDateField
//    UNC Path->UNCPathField
//    Journalist->JournalistField
//    LUT->LUTField
    
    if ([filenames isKindOfClass:[NSMutableDictionary class]])
         {
             [APICalls logMsgToTextFile:@"pasted is dictionary"];
                NSLog(@"pasted is dictionary");
             NSMutableArray * objects = [filenames objectForKey:@"mediaObjects"];
             NSMutableIndexSet * indexSet = [NSMutableIndexSet new];
             for (int i=0;i<objects.count;i++)
             {
                 // NSIndexPath * indexPath =[NSIndexPath indexPathWithIndex:i];
                 [indexSet addIndex:i];
             }
             
             
        //  [objects addObjectsFromArray:self.parentController.dataArray];
           
             
           //  self.dataArray = objects;
          //   [self.rightTableView insertRowsAtIndexes:indexSet withAnimation:NSTableViewAnimationEffectFade];
            
            // NSDictionary *dictionary = [NSDictionary dictionaryWithObject:country forKey:@"Country"];
             
         //    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteObjects" object:nil userInfo:filenames];
             
             
//             [self.leftTableView insertRowsAtIndexes:indexSet withAnimation:NSTableViewAnimationEffectFade];
//              [self.rightTableView selectRowIndexes:indexSet byExtendingSelection:YES];
//             [self.leftTableView selectRowIndexes:indexSet byExtendingSelection:YES];
//            [self.rightTableView reloadData];
//             [self.leftTableView reloadData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTables" object:nil];
             NSInteger numberOfRows = [self.rightTableView numberOfRows];
             
             if (numberOfRows > 0)
             {
                 [_rightTableView scrollRowToVisible:0];
                  [_leftTableView scrollRowToVisible:0];
                 
             }
           
             
             
             
             
         }
         else if ([filenames isKindOfClass:[NSMutableArray class]])
         {
              [APICalls logMsgToTextFile:@"pastedDict is Array"];
                NSLog(@"pastedDict is Array");
             for (NSString * filePath in (NSArray*)filenames)
             {
                 NSLog(@"file:%@",filePath);
                 
                 if ([filePath.pathExtension isEqualToString:@"aaf"])
                 {
                       NSLog(@"pastedDict is AAF");
                     wstring ws = NSStringToStringW(filePath);
                    // int t=importessence(ws);
                     wstring fajl =[self NSStringToStringW:filePath].c_str();
                //     const char* outfajl =  [[[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[[filePath lastPathComponent] stringByAppendingString:@"expored"]] UTF8String] ;
                  //   OpenAAFFile2((const aafCharacter *)fajl.c_str(), 1, outfajl);
                       NSLog(@"after import essence..");
                     
                     vector<AvidMediaFiles> res= getClips(ws);
                        NSLog(@"clips got");
                     NSMutableArray * newobjects=[NSMutableArray new];
                     dispatch_queue_t serialQueue = dispatch_queue_create("com.aj.serial.queue", DISPATCH_QUEUE_SERIAL);
                     
                     for (int i=0;i<res.size();i++)
                     {
                           NSLog(@"pastedDict is Array");
                       //  eMovies.push_back(res[i]);
                         mediaFileObjC * movie=[[mediaFileObjC alloc] init];
                                               //   [self.KVOController observe:movie keyPath:@"VideoAndAudioTogetherFiles" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(ClockView *clockView, Clock *clock, NSDictionary *change) {
                             
                             // update clock view with new value
//                             clockView.date = change[NSKeyValueChangeNewKey];
                       //  }];

                         
                         
                         movie= [APICalls convertToObjC:&res[i]];
                           NSLog(@"convert to COCOA object");
                         movie.windowNumber=@(self.view.window.windowNumber);
//                         dispatch_async( serialQueue, ^{
//                        [movie getThumbnail];
//                        });
//                         [self.KVOController observe:movie keyPath:@"VideoAndAudioTogetherFiles" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
//                             
//                             [movie getThumbnail];
//                         }];
//                         [self.KVOController observe:movie keyPath:@"videoFiles" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
//                             
//                             [movie getThumbnail];
//                         }];

                         if (movie)
                         [newobjects addObject:movie];
                         
                     
                     }
                     
                     
                   //  if([[filePath.pathExtension uppercaseString] isEqualToString:@"AAF"])
//                     {
//                         mediaFileObjC * movie=[[mediaFileObjC alloc] init];
//                         //   [self.KVOController observe:movie keyPath:@"VideoAndAudioTogetherFiles" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(ClockView *clockView, Clock *clock, NSDictionary *change) {
//                         
//                         // update clock view with new value
//                         //                             clockView.date = change[NSKeyValueChangeNewKey];
//                         //  }];
//                         
//                         movie.isthisAAFSequence=YES;
//                         AvidMediaFiles res;
//                         res.aafUrl=ws;
//                         movie= [APICalls convertToObjC:&res];
//                         
//                         NSLog(@"convert to COCOA object");
//                         movie.windowNumber=@(self.view.window.windowNumber);
//                         dispatch_async( serialQueue, ^{
//                             // need to make another method to get thumbnail from aaf sequence file
//                            // [movie getThumbnail];
//                         });
//                         if (movie)
//                             [newobjects addObject:movie];
//                         
//                         
//                     }
                     
                     
                     MASTERDATA * masterData = [MASTERDATA sharedInstance];
                     [masterData.dataArray addObjectsFromArray:newobjects];
                  //   [self.parentController.dataArray addObjectsFromArray:newobjects];
                     [self refreshData];
                     
                     
//                     for (int i=0;i<res.size();i++)
//                     {
//                         
//                         datDict=[NSMutableDictionary new];
//                         
//                         AvidMediaFiles essence = res[i];
//                         
//                         NSValue * essenceValue =   [NSValue valueWithBytes:&essence objCType:@encode(AvidMediaFiles)];
//                         [datDict setObject:essenceValue forKey:@"AvidMediaFiles"];
//                       //  [_dataArray addObject:[datDict copy]];
//                         
//                         NSMutableDictionary * dict =[NSMutableDictionary new];
//                         BOOL originalSourceReachable=NO;
//                         if (essence.videoAudioTogetherFiles.size())
//                         {
//                             NSLog(@"%@",StringWToNSString(essence.videoAudioTogetherFiles[0].essencePath));
//                             NSURL *theURL = [NSURL fileURLWithPath:StringWToNSString(essence.videoAudioTogetherFiles[0].essencePath)
//                                                        isDirectory:NO];
//                             NSError *err;
//                             bool test = [theURL checkResourceIsReachableAndReturnError:&err];
//                             if (!err)
//                                 originalSourceReachable=YES;
//                             
//                             
//                         }
//                         if (essence.videoAudioTogetherFiles.size()&&originalSourceReachable)
//                         {
//                             sourceMobInfo info = essence.videoAudioTogetherFiles[0];
//                             
//                             NSString* fPathString = StringWToNSString(essence.videoAudioTogetherFiles[0].essencePath);
//                             NSString * nm= [[[NSURL URLWithString:fPathString] path] lastPathComponent];
//                             if (nm)
//                             info.Source_File= NSStringToStringW(nm);
//                
//                             [datDict setObject:StringWToNSString(info.Source_File) forKey:@"Source File"];
//                             
//                             for ( int j=0;j<essence.comments.size();j++)
//                             {
//                                 [datDict setObject:StringWToNSString(essence.comments[j].commentValue) forKey:StringWToNSString(essence.comments[j].commentName)];
//                                 
//                                 
//                             }
//                             
//                             [datDict removeObjectForKey:@"_acfparametersxml.ama.bin.0"];
//                             
//                             
//                             
//                             //                    customTableColumn * oneColumn = [_rightTableView.tableColumns objectAtIndex:0];
//                             //                    customTableColumn * oneColumn2 = [_leftTableView.tableColumns objectAtIndex:0];
//                             //                    [_rightTableView removeTableColumn:oneColumn];
//                             //                    [_leftTableView removeTableColumn:oneColumn2];
//                             for (NSString * columnName in datDict.allKeys)
//                             {
//                                 
//                                 if (![countedColumns containsObject:columnName])
//                                 {   customTableColumn  * oneColumn=[[customTableColumn alloc] initWithIdentifier:@"customTableColumn"];
//                                     [[oneColumn headerCell] setStringValue:columnName];
//                                     [oneColumn headerCell].drawsBackground=YES;
//                                     [oneColumn headerCell].backgroundColor=[NSColor blackColor];
//                                     
//                                     [oneColumn setColumnName:columnName];
//                                     oneColumn.width=50;
//                                     [_rightTableView addTableColumn:oneColumn];
//                                     [countedColumns addObject:columnName];
//                                 }
//                                 else
//                                     NSLog(@"already exists:%@",columnName);
//                                 
//                                 
//                             }
//                             //                    customTableColumn * oneColumn3=[[customTableColumn alloc] initWithIdentifier:@"customTableColumn"];
//                             //                    [oneColumn3 setColumnName:@"Source File"];
//                             
//                             // [[oneColumn2 headerCell] setStringValue:@"Source File"];
//                             
//                             
//                             
//                         }
//                         else if (essence.audioEsences.size())
//                         {
//                             // NSString* fPathString =  StringWToNSString(essence.audioEsences[0].essencePath);
//                             
////                             sourceMobInfo info = essence.audioEsences[0];
////                             
////                             NSString* fPathString = StringWToNSString(essence.audioEsences[0].essencePath);
////                             NSString * nm= [[[NSURL URLWithString:fPathString] path] lastPathComponent];
////                             info.Source_File= NSStringToStringW(nm);
////                             if (nm)
////                             [datDict setObject:StringWToNSString(info.Source_File) forKey:@"Source File"];
////                             
////                             for ( int j=0;j<essence.comments.size();j++)
////                             {
////                                 [datDict setObject:StringWToNSString(essence.comments[j].commentValue) forKey:StringWToNSString(essence.comments[j].commentName)];
////                                 
////                                 
////                             }
////                             if ([datDict objectForKey:@"_acfparametersxml.ama.bin.0"])
////                                 [datDict removeObjectForKey:@"_acfparametersxml.ama.bin.0"];
////                             
////                             
////                          //   [_dataArray addObject:[datDict copy]];
////                             
////                             //                     customTableColumn * oneColumn = [_rightTableView.tableColumns objectAtIndex:0];
////                             //                     customTableColumn * oneColumn2 = [_leftTableView.tableColumns objectAtIndex:0];
////                             //                     [_rightTableView removeTableColumn:oneColumn];
////                             //                     [_leftTableView removeTableColumn:oneColumn2];
//                             
//                             for (NSString * columnName in datDict.allKeys)
//                             {
//                                 if (![countedColumns containsObject:columnName])
//                                 {   customTableColumn  * oneColumn=[[customTableColumn alloc] initWithIdentifier:@"customTableColumn"];
//                                     [[oneColumn headerCell] setStringValue:columnName];
//                                     [oneColumn headerCell].drawsBackground=YES;
//                                     [oneColumn headerCell].backgroundColor=[NSColor blackColor];
//                                     [oneColumn setColumnName:columnName];
//                                     oneColumn.width=50;
//                                     [_rightTableView addTableColumn:oneColumn];
//                                     [countedColumns addObject:columnName];
//                                 }
//                                 else
//                                     NSLog(@"already exists:%@",columnName);
//                                 
//                                 
//                             }
//                             //                     customTableColumn * oneColumn3=[[customTableColumn alloc] initWithIdentifier:@"customTableColumn"];
//                             //                     [oneColumn3 setColumnName:@"Source File"];
//                             
//                             //[[oneColumn2 headerCell] setStringValue:@"Source File"];
//                             
//                             
//                             
//                             
//                         }
//                         
//                         
//                         
//                         
//                         
//                     }
                     
                     
                 } else if ([filePath.pathExtension isEqualToString:@"mxf"])
                 {
                     wstring ws = NSStringToStringW(filePath);
                     // int t=importessence(ws);
                     wstring fajl =[self NSStringToStringW:filePath].c_str();
                     //     const char* outfajl =  [[[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:[[filePath lastPathComponent] stringByAppendingString:@"expored"]] UTF8String] ;
                     //   OpenAAFFile2((const aafCharacter *)fajl.c_str(), 1, outfajl);
                     NSLog(@"after import essence..");
                     
                     vector<AvidMediaFiles> res= getClips(ws);
                     NSLog(@"clips got");
                     NSMutableArray * newobjects=[NSMutableArray new];
                     dispatch_queue_t serialQueue = dispatch_queue_create("com.aj.serial.queue", DISPATCH_QUEUE_SERIAL);
                     
                     for (int i=0;i<res.size();i++)
                     {
                         NSLog(@"pastedDict is Array");
                         //  eMovies.push_back(res[i]);
                         mediaFileObjC * movie=[[mediaFileObjC alloc] init];
                         //   [self.KVOController observe:movie keyPath:@"VideoAndAudioTogetherFiles" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(ClockView *clockView, Clock *clock, NSDictionary *change) {
                         
                         // update clock view with new value
                         //                             clockView.date = change[NSKeyValueChangeNewKey];
                         //  }];
                         
                         
                         
                         movie= [APICalls convertToObjC:&res[i]];
                         NSLog(@"convert to COCOA object");
                         movie.windowNumber=@(self.view.window.windowNumber);
//                         dispatch_async( serialQueue, ^{
//                             [movie getThumbnail];
//                         });
                         //                         [self.KVOController observe:movie keyPath:@"VideoAndAudioTogetherFiles" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
                         //
                         //                             [movie getThumbnail];
                         //                         }];
                         //                         [self.KVOController observe:movie keyPath:@"videoFiles" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
                         //
                         //                             [movie getThumbnail];
                         //                         }];
                         
                         if (movie)
                             [newobjects addObject:movie];
                         
                         
                     }
                     
                     MASTERDATA * masterData = [MASTERDATA sharedInstance];
                     [masterData.dataArray addObjectsFromArray:newobjects];
                     //   [self.parentController.dataArray addObjectsFromArray:newobjects];
                     [self refreshData];

                     
                     
                     
                     
                     // [_dataArray addObject:one];
                 }
             }
             
             
             
             
             
         }
    
    
    

    
    
      [self setHeaderCells];
    
    [self refreshData];
    NSLog(@"end of do something");
    
}
-(const  wchar_t *)wcharFromString:(NSString *)string
{
    return  (const wchar_t *)[string cStringUsingEncoding:NSUTF8StringEncoding];
}
std::wstring NSStringToStringW ( NSString* Str )
{
    NSStringEncoding pEncode    =   CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingUTF32LE );
    NSData* pSData              =   [ Str dataUsingEncoding : pEncode ];
    
    return std::wstring ( (wchar_t*) [ pSData bytes ], [ pSData length] / sizeof ( wchar_t ) );
}

NSString* StringWToNSString ( const std::wstring& Str )
{
    NSString* pString = [ [ NSString alloc ]
                         initWithBytes : (char*)Str.data()
                         length : Str.size() * sizeof(wchar_t)
                         encoding : CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingUTF32LE ) ];
//    if (pString.length<2)
//        pString=@"50.0";
    return pString;
}
//-(const wchar_t *)wcharFromString:(NSString *)string { return (const wchar_t *)[string cStringUsingEncoding:NSUTF32LittleEndianStringEncoding]; }
-(NSString *)stringFromWchar:(const wchar_t *)charText
{
    //used ARC
    return [[NSString alloc] initWithBytes:charText length:wcslen(charText)*sizeof(*charText) encoding:NSUTF32LittleEndianStringEncoding];
}



-(void) setHeaderCells
{

    
    for (customTableColumn *column in [_rightTableView tableColumns]) {
        [column setHeaderCell:
         [[customHeaderCell alloc]
           initTextCell:[[column headerCell] stringValue]]
          ];
    }
    for (customTableColumn *column in [_leftTableView tableColumns]) {
        [column setHeaderCell:
         [[customHeaderCell alloc]
          initTextCell:[[column headerCell] stringValue]]
         ];
    }
    
}
- (BOOL)   tableView:(NSTableView *)pTableView
writeRowsWithIndexes:(NSIndexSet *)pIndexSetOfRows
        toPasteboard:(NSPasteboard*)pboard
{
//    // this allows us to drag rows around within the table
//    // we copy the row numbers to be dragged to the pasteboard.
//    NSData *zNSIndexSetData = [NSKeyedArchiver archivedDataWithRootObject:pIndexSetOfRows];
//    [pboard declareTypes:[NSArray arrayWithObject:MyPr/Users/Igor/Documents/band/Result-30-12-2015172980.01.aafivateTableViewDataType] owner:self];
//    [pboard setData:zNSIndexSetD/Users/Igor/Documents/band/P1040734-Small.movata forType:MyPrivateTableViewDataType];
  //  file://Users/Igor/Documents/band/P1040734-Small.mov/Users/Igor/Documents/band/P1040734-Small.aaf
    // this is to allow us toigor.mov drag string data to other applications, e.g. safari, bbedit
    // We don't do this if more than one row is selected
//    if ([pIndexSetOfRows count] > 1) {
//        return YE/Users/Igor/Documents/band/Result-30-12-2015172980.01.aafS;
//    } // end if
    
    NSMutableArray * retArray = [NSMutableArray new];
    NSIndexSet *selectedItems = pIndexSetOfRows;
    NSMutableDictionary * retDict = [NSMutableDictionary new];
    NSMutableArray *selectedItemsArray=[NSMutableArray array];
    NSMutableIndexSet * indexestodelete=[NSMutableIndexSet new];
    NSMutableArray * indexesTodeleteArray=[NSMutableArray new];
    [selectedItems enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        mediaFileObjC * mf = [self.dataArray objectAtIndex:idx];
        [retArray addObject:mf.MobId];
      //  [self.parentController.dataArray removeObjectAtIndex:idx];
        [indexestodelete addIndex:idx];
        [indexesTodeleteArray addObject:@(idx)];

    }];
  //  [self.parentController.dataArray removeObjectsAtIndexes:indexestodelete];
    NSLog(@"%@",self.parentController.dataArray);
//    [self.rightTableView removeRowsAtIndexes:indexestodelete withAnimation:NSTableViewAnimationEffectFade];
//      [self.leftTableView removeRowsAtIndexes:indexestodelete withAnimation:NSTableViewAnimationEffectFade];
  //  [retDict setObject:retArray forKey:@"indexes"];
 //   [retDict setObject:[NSString stringWithFormat:@"%ld",self.view.window.windowNumber] forKey:@"windowNumber"];
//    for (NSIndexPath * indexPath in pIndexSetOfRows)
//    {
//        
//        [retArray addObject:_dataArray[indexPath.item]];
//        
//        [_dataArray removeObjectAtIndex:indexPath.item];
//        
//        
//    }
    
//    [_rightTableView reloadData];
//    [_leftTableView reloadData];
    [retDict setObject:retArray forKey:@"mediaObjects"];
    [retDict setObject:@(self.view.window.windowNumber) forKey:@"windowNumber"];
    NSData *zNSIndexSetData =
    [NSKeyedArchiver archivedDataWithRootObject:retDict];
    [pboard declareTypes:[NSArray arrayWithObject:NSPasteboardTypeString]
                   owner:self];
    [pboard setData:zNSIndexSetData forType:NSPasteboardTypeString];
    
    
//    [pboard declareTypes:@[NSPasteboardTypeString] owner:self];
//    NSInteger zIndex   = [pIndexSetOfRows firstIndex];
//    NSString * zDataObj   = [self.dataArray objectAtIndex:zIndex];
//    NSString *zDataString = @"/Users/Igor/Documents/band/Result-30-12-2015172980.01.aaf";
//    [pboard setString:zDataString forType:NSPasteboardTypeString];
    
   
    return YES;
}
-(void) refreshData
{
    MASTERDATA * masterData=[MASTERDATA sharedInstance];
    
    _dataArray=[masterData getRowsForWindow:@(self.view.window.windowNumber)];
    
    [_rightTableView reloadData];
    [_leftTableView reloadData];
//    if (_dataArray.count)
//    {
////    mediaFileObjC * media = _dataArray[0];
////    NSDictionary * dictionary = [self getMediaAccessData:media];
////        _playerWindowController.movieSpecs = dictionary;
////        [_playerWindowController pass];
//        
//    }

    
    
    
}
- (void)keyDown:(NSEvent*)event {
    NSLog(@"A key has been pressed");
    if ([event keyCode]==124)
    {
        self.previewIsOn=YES;
        if (!_playerWindowController)
        {
            _playerWindowController = [[NSStoryboard storyboardWithName:@"Main" bundle:nil ] instantiateControllerWithIdentifier:@"player"];
            mediaFileObjC * media = _dataArray[self.leftTableView.selectedRow];
            NSDictionary * dictionary = [self getMediaAccessData:media];
            //   Country *country = [[[Country alloc] init] autorelease];
            //Populate the country object however you want
            
            // NSDictionary *dictionary = [NSDictionary dictionaryWithObject:country forKey:@"Country"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"setupMovie" object:nil userInfo:dictionary];
            });
            
            
        }
        else
        {
            [_playerWindowController showWindow:self];
            _playerWindowController.window.alphaValue = 1;
            
            mediaFileObjC * media = _dataArray[self.leftTableView.selectedRow];
            NSDictionary * dictionary = [self getMediaAccessData:media];
            _playerWindowController.movieSpecs = dictionary;
            [_playerWindowController pass];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                 [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseMovie" object:nil userInfo:dictionary];
//            });
           
            
          
        }
        
//        if (_playerWindowController.window.parentWindow!=self.view.window)
//        {
//            CGRect frejm = _playerWindowController.window.frame;
//            frejm.origin.x=self.view.window.frame.origin.x+self.view.window.frame.size.width-80;
//            frejm.origin.y=self.view.window.frame.origin.y+30;
//            frejm.size.height =self.view.frame.size.height;
//            frejm.size.width=frejm.size.height*1.5;
//              [_playerWindowController.window setFrame:frejm display:YES];
//            [self.view.window addChildWindow:_playerWindowController.window ordered:NSWindowBelow];
//            
//          
//            
//            
//        }
//        else
        {
            CGRect frejm = _playerWindowController.window.frame;
            frejm.origin.x=self.view.window.frame.origin.x+self.view.window.frame.size.width-80;
            frejm.origin.y=self.view.window.frame.origin.y+30;
            frejm.size.height =self.view.frame.size.height;
              frejm.size.width=frejm.size.height*1.20;
            
            
            [_playerWindowController.window setFrame:frejm display:YES];
        }
        
        [self.view.window makeKeyAndOrderFront:nil];
        [self.view.window makeMainWindow];
    
        
    }
    if ([event keyCode]==123)
    {
        self.previewIsOn=NO;
       // [ self.view.window removeChildWindow:self.view.window.childWindows.firstObject];
        _playerWindowController.window.alphaValue=0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pauseMovie" object:nil userInfo:nil];
     //   _playerWindowController=nil;
    }
    switch( [event keyCode] ) {
        case 126:       // up arrow
        case 125:       // down arrow
        case 124:       // right arrow
        case 123:       // left arrow
            NSLog(@"Arrow key pressed!");
            break;
        default:
            NSLog(@"Key pressed: %@", event);
            break;
    }
}
-(void) updateRows:(NSNotification*) notification
{
   
    NSDictionary * dict = notification.userInfo;
    if (dict)
    {
    int rowNumber = [[dict objectForKey:@"rowNumber"] intValue];
     NSLog(@"%d",rowNumber);
    if ([[dict objectForKey:@"windowNumber"] integerValue]==self.view.window.windowNumber)
    {
        NSIndexSet * set = [[NSIndexSet alloc] initWithIndex:rowNumber];
         NSIndexSet * setColumn = [[NSIndexSet alloc] initWithIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^{
         //   mediaFileObjC * mf =  self.dataArray[rowNumber];
           // NSLog(@"status=%@",mf.status);
           [_leftTableView reloadDataForRowIndexes:set columnIndexes:setColumn];
             [_rightTableView reloadDataForRowIndexes:set columnIndexes:setColumn];
            
        });
       
        
      //  [self refreshData];
        
        
        
        
        
        
        
        
        
    
        
    }
    
    
    }
    
    
    
}
-(std::wstring) NSStringToStringW :( NSString*) Str
{
    NSStringEncoding pEncode    =   CFStringConvertEncodingToNSStringEncoding ( kCFStringEncodingUTF32LE );
    NSData* pSData              =   [ Str dataUsingEncoding : pEncode ];
    
    return std::wstring ( (wchar_t*) [ pSData bytes ], [ pSData length] / sizeof ( wchar_t ) );
}

-(void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
   // _playerWindowController  =  segue.destinationController;
    
    
}
@end

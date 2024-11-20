//
//  WWNSTableView.m
//  playTableView
//
//  Created by Igor Jovcevski on 12/23/15.
//  Copyright © 2015 WoowaveTemplate. All rights reserved.
//

#import "WWNSTableView.h"

//#import "MasterDataObject.h"
@implementation WWNSTableView {
    BOOL highlight;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(BOOL)mouseDownCanMoveWindow
{
    
    return YES;
}

- (void) awakeFromNib {
    [self registerForDraggedTypes:@[NSFilenamesPboardType,NSPasteboardTypeString]];
    
}


- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
    return [self draggingEntered:sender];
}


#pragma GCC diagnostic ignored "-Wundeclared-selector"

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender {
    NSLog(@"performDragOperation in TableViewDropper.h");
    @try {
        NSPasteboard *pboard = [sender draggingPasteboard];
        NSArray *filenames = [pboard propertyListForType:NSFilenamesPboardType];
        //  NSArray *filenames2 = [pboard propertyListForType:NSPasteboardTypeString];
        NSData* interBinArrayPaste;
        if (pboard)
            interBinArrayPaste = [pboard dataForType:NSPasteboardTypeString];
        NSMutableDictionary * pastedDict;
        if (interBinArrayPaste)
            pastedDict = [NSKeyedUnarchiver unarchiveObjectWithData:interBinArrayPaste];
        
        
        if (pastedDict)
        {
            
            
            
            NSMutableArray * pastedArray =
            [pastedDict objectForKey:@"mediaObjects"];
            for (int i=0;i<pastedArray.count;i++)
            {
                NSString *      mobIdDragged =   pastedArray[i];
                
                

                
            }
            id delegate = [self delegate];
              NSLog(@"sending to delegate");
            if ([delegate respondsToSelector:@selector(doSomethingWithDraggedFiles:)]) {
                [delegate performSelector:@selector(doSomethingWithDraggedFiles:) withObject:pastedDict];
            }
            
            
        } else
        {
            
            id delegate = [self delegate];
               NSLog(@"sending to delegate");
            if ([delegate respondsToSelector:@selector(doSomethingWithDraggedFiles:)]) {
                [delegate performSelector:@selector(doSomethingWithDraggedFiles:) withObject:filenames];
            }
        }
        highlight=NO;
        [self setNeedsDisplay: YES];
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        
    }
     NSLog(@"return yes");
    return YES;
}


- (BOOL)prepareForDragOperation:(id)sender {
    NSLog(@"prepareForDragOperation called in TableViewDropper.h");
    return YES;
}


- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    if (highlight==NO) {
        NSLog(@"drag entered in TableViewDropper.h");
        highlight=YES;
        [self setNeedsDisplay: YES];
    }
    
    return NSDragOperationCopy;
}

- (void)draggingExited:(id)sender
{
    highlight=NO;
    
    [self setNeedsDisplay: YES];
    NSLog(@"drag exit in TableViewDropper.h");
}

@end

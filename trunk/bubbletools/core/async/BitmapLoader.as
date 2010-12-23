﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.core.async {	import bubbletools.core.library.BitmapFile;	import bubbletools.core.async.AsyncLoader;	import bubbletools.core.threading.Threaded;	import bubbletools.util.Debug;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Loader;	import flash.display.LoaderInfo;	import flash.display.Sprite;	import flash.events.*;	import flash.net.URLRequest;	import flash.system.LoaderContext;	// Loads a specified array of images, converts them to BitmapData and stores them in the library	public class BitmapLoader implements AsyncLoader {		private var bitmapFiles:Array;		private var returnClass:Object;		private var bitmaps:Array;		private var loadCounter:Number;		private var returnThreadId:Number;		private var imgLoader:Loader;		private var imgContext:LoaderContext;		private var imgInfo:LoaderInfo;		private var imgRequest:URLRequest;		public function setReturn(returnClass:Threaded):void {			this.returnClass = returnClass;		}		public function setParams(bitmapFiles:Array, returnClass:Threaded):void {			bitmaps = new Array();			loadCounter = 0;			this.bitmapFiles = bitmapFiles;			this.returnClass = returnClass;		}		public function startLoad():void {			returnThreadId = this.returnClass.getThreadId();			this.returnClass.setIncomplete();			Debug.output(this, "Starting Load of " + bitmapFiles.length + " items.");			loadNextItem();		}		public function extractBitmap(loadEvent:Event):void {			var myBitmapData:BitmapData = new BitmapData(imgLoader.width, imgLoader.height, true, 0x00000000);			try {				myBitmapData.draw(imgLoader);				Debug.output(this, "Completed load and draw of for " + BitmapFile(bitmapFiles[loadCounter]).getType());			} catch (e:Error) {				Debug.output(this, "Invalid bitmap data loaded");			}			bitmapFiles[loadCounter].setBitmapData(myBitmapData);			loadCounter++;			if (loadCounter < bitmapFiles.length) {				loadNextItem();			} else {				finishLoad();			}		}		public function loadNextItem():void {			if (bitmapFiles[loadCounter].isLoaded()) {				loadCounter++;				if (loadCounter < bitmapFiles.length) {					loadNextItem();				} else {					finishLoad();				}			} else {				imgLoader = new Loader();				imgContext = new LoaderContext();				imgContext.checkPolicyFile = true;				imgRequest = new URLRequest(bitmapFiles[loadCounter].getFileName());				imgLoader.contentLoaderInfo.addEventListener(Event.INIT, extractBitmap);				// Error handling				imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadFailed);				// Load request				imgInfo = LoaderInfo(imgLoader.contentLoaderInfo);				imgLoader.load(imgRequest, imgContext);			}		}		public function loadFailed(event:IOErrorEvent):void {			Debug.output(this, "[WARNING] BitmapLoader failed to load an image file from : " + bitmapFiles[loadCounter].getFileName());			loadCounter++;			if (loadCounter < bitmapFiles.length) {				loadNextItem();			} else {				finishLoad();			}		}		public function finishLoad():void {			returnClass.resumeOnThread(returnThreadId);			returnClass.completeLoad(bitmapFiles);		}	}}
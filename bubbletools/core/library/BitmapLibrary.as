﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.core.library {		import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Sprite;    	import flash.display.Stage;	import flash.display.Loader;	import flash.display.LoaderInfo;	import flash.net.URLRequest;		import bubbletools.core.threading.Requesting;	import bubbletools.core.library.IBitmapWrapper;	import bubbletools.core.library.BitmapFile;	import bubbletools.core.library.BitmapProxy;	import bubbletools.core.async.BitmapLoader;	import bubbletools.core.async.SWFLoader;	import bubbletools.util.Debug;		public class BitmapLibrary extends Requesting {			private var libname:String;		private var filenames:Array;		private var fileindex:Array;		private var filepath:String = "";		private var cacheUrl:String;		private var cachePath:String;		private var cacheLoaded:Boolean = false;		private var cacheExists:Boolean = false;		private var cacheLoader:SWFLoader;		private var cacheContainer:Sprite;		private var cachedBitmaps:Array;		private var pathProxies:Array;		private var bitmaps:Array;		private var bitmapProxies:Array;			public function BitmapLibrary(newLibName:String){						idName = "Bitmap_Library";			libname = newLibName;					bitmaps = new Array();				// List of BitmapFile objects			bitmapProxies = new Array();		// List of BitmapProxy objects					filenames = new Array();			// Array by number of files to load			fileindex = new Array();			// Array by name of files to load					pathProxies = new Array();		}		public function setPath(filepath:String):void {			this.filepath = filepath;		}		public function setCachePath(cachePath:String):void {			this.cachePath = cachePath;		}		public function setCacheUrl(cacheUrl:String):void {			cacheExists = true;			this.cacheUrl = cacheUrl;		}		public function addImagePathProxy(label:String, path:String):void {			pathProxies[label]=path;		}		public function getName():String {			return(libname);		}		public function addLoadedFile(bmpFile:BitmapFile):void {			bmpFile.setLoaded();			bitmaps[bmpFile.getType()] = bmpFile;		}		public function addBitmapFile(bmpFile:BitmapFile):void {					// Skip file addition if there is a file with the same ID that already has loaded bitmapData					var alreadyLoaded:Boolean = false			if(bitmaps[bmpFile.getType()] != null) {				if(bitmaps[bmpFile.getType()].getBitmapData() != null);				bmpFile.setLoaded();				alreadyLoaded = true;			}					if(!alreadyLoaded) {							// Check list for proxy pathing for this file						var useProxy:Boolean = false;				if(bmpFile.getFileName().indexOf("/") != -1) {					var bmpPath = bmpFile.getFileName().substr(0, bmpFile.getFileName().indexOf("/"));					if(pathProxies[bmpPath] != null) {						useProxy = true;					}				}				if(useProxy) {					bmpFile.addPath(pathProxies[bmpPath]);				} else {					bmpFile.addPath(filepath);				}						filenames.push(bmpFile);				fileindex[bmpFile.getType()] = bmpFile;			}		}				public function loadCache():void {			if(!cacheLoaded) {				cacheContainer = new Sprite;				var myLoader = new SWFLoader();				setHandler(cacheLoadComplete);				myLoader.setParams(cachePath+cacheUrl, cacheContainer, this, null);				myLoader.startLoad();			}		}				public function cacheLoadComplete(info:LoaderInfo):void {						cacheLoaded = true;			cachedBitmaps = Object(Loader(cacheContainer.getChildAt(0)).content).cacheArray;			for(var i:Number = 0; i<filenames.length; i++) {								var fileId:String = filenames[i].getType();								if(cachedBitmaps[fileId]) {					Debug.output(this, "Image: "+fileId + " exists in SWF cache");					filenames[i].setBitmapData(cachedBitmaps[fileId]);					filenames[i].setLoaded();				}							}						loadBitmaps();		}				public function loadBitmaps():void {			if(cacheExists && !cacheLoaded) {				loadCache();			} else {				if(filenames.length > 0) {					var myLoader = new BitmapLoader();					setHandler(bitmapsLoaded);					myLoader.setParams(filenames, this);					myLoader.startLoad();				} else {					Debug.output(this, "[BitmapLibrary] there were no bitmaps to load!");					setComplete();				}			}		}		public function bitmapsLoaded(bitmapArray):void {			Debug.output(this, "[BitmapLibrary] Finished load with array of "+bitmapArray.length+" bitmaps");			for(var i=0; i<bitmapArray.length; i++) {				bitmapArray[i].setLoaded();				bitmaps[bitmapArray[i].getType()] = bitmapArray[i];			}			filenames = new Array();			fileindex = new Array();		}		public function isQueuedForLoad(name:String):Boolean {			if(fileindex[name]) {				return true;			} else {				return false;			}		}		public function hasBitmap(bitmapId:String):Boolean {			if(bitmaps[bitmapId]) {				return true;			} else {				return false;			}		}		public function requestBitmap(bitmapId:String):Bitmap {			var wrapper:IBitmapWrapper = getBitmap(bitmapId);			var bitmapData:BitmapData = wrapper.getBitmapData();			var bitmap:Bitmap = new Bitmap(bitmapData, "auto", true);			if(wrapper.getProxyStatus()) {				BitmapProxy(wrapper).addUpdate(bitmap);			}			return(bitmap);		}		public function getBitmap(bitmapId:String):IBitmapWrapper {			if(bitmaps[bitmapId]) {				return(IBitmapWrapper(bitmaps[bitmapId]));			} else {				if(isQueuedForLoad(bitmapId)) {					if(bitmapProxies[bitmapId]) {						return IBitmapWrapper(bitmapProxies[bitmapId]);					} else {						var proxy:BitmapProxy = new BitmapProxy(fileindex[bitmapId]);						bitmapProxies[bitmapId] = proxy;						return IBitmapWrapper(proxy);					}								} else {					Debug.output(this, "[BitmapLibrary] requested bitmap '"+bitmapId+"' does not exist.");					return null;				}			}		}	}}
﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.core.async {	import flash.display.Loader;	import flash.system.LoaderContext;	import flash.system.ApplicationDomain;	import flash.display.LoaderInfo;	import flash.display.Sprite;	import flash.events.*;	import flash.net.URLRequest;	import bubbletools.core.threading.Threaded;	import bubbletools.core.async.AsyncLoader;	import bubbletools.util.Debug;	public class SWFLoader implements AsyncLoader {			private var swf:String;		private var swfContainer:Sprite;		private var returnClass:Object;		private var returnThreadId:Number;		private var swfLoader:Loader;		private var swfContext:LoaderContext;		private var swfInfo:LoaderInfo;		private var swfRequest:URLRequest;		private var swfApplicationDomain:ApplicationDomain;		private var swfParams:Array;				public function setReturn(returnClass:Threaded):void {			this.returnClass = returnClass;		}		public function setParams(swf:String, swfContainer:Sprite, returnClass:Threaded, swfParams:Array):void {			this.swf = swf;			this.swfContainer = swfContainer;			this.swfParams = swfParams;			this.returnClass = returnClass;		}		public function setApplicationDomain(swfApplicationDomain:ApplicationDomain):void {			this.swfApplicationDomain = swfApplicationDomain;		}		public function startLoad():void {			returnThreadId = this.returnClass.getThreadId();			this.returnClass.setIncomplete();			Debug.output(this, "[SWFLoader] Starting Load of "+swf);			doLoad();		}		public function doLoad():void {			swfLoader = new Loader();			swfContainer.addChild(swfLoader);						if(swfApplicationDomain) {				swfContext = new LoaderContext(false, swfApplicationDomain);			} else {				swfContext = new LoaderContext(false, new ApplicationDomain());				}				      	//swfContext.checkPolicyFile = true;			//swfContext.applicationDomain = new ApplicationDomain();						swfRequest = new URLRequest(swf);			swfLoader.contentLoaderInfo.addEventListener(Event.INIT, finishLoad);			swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadFailed);			swfInfo = LoaderInfo(swfLoader.contentLoaderInfo);			swfLoader.load(swfRequest, swfContext);					}				public function finishLoad(loadEvent:Event):void {			returnClass.resumeOnThread(returnThreadId);			returnClass.completeLoad(swfInfo);		}				public function loadFailed(event:IOErrorEvent):void {			Debug.output(this, "[WARNING] SWFLoader failed to load an SWF file from : "+swf);			returnClass.resumeOnThread(returnThreadId);			returnClass.errorLoading();		}	}}
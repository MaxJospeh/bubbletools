﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.ui.framework {	import bubbletools.core.library.BitmapLibrary;	import bubbletools.ui.eventing.*;	import bubbletools.ui.framework.ComponentView;	import bubbletools.ui.interfaces.IComponent;	import bubbletools.ui.interfaces.Reporter;	import bubbletools.ui.interfaces.UIControl;	import bubbletools.ui.main.BTCanvas;	import bubbletools.ui.main.ComponentTypes;	import bubbletools.ui.parameters.InterfaceParameters;	import bubbletools.util.Debug;	import bubbletools.util.Pointdata;	import bubbletools.util.UnitConversion;	import flash.display.StageDisplayState;	import flash.events.Event;	import flash.geom.ColorTransform;
	public class BTUI extends BTComponent implements Reporter {		public static var compile:Boolean = false;		private static var _instance:BTUI = null;		private static var _canvas:BTCanvas;		private var interfaceLibrary:BitmapLibrary;		private var pathProxies:Array;		private var idCounter:Number;		private var themeTintColor:ColorTransform;			// tint ColorTransform object, created from supplied color offset values in UIML file		private var themeOutlineColor:uint;					// outline color, created from supplied color in UIML file			private var themeBackgroundColor:uint;				// background color, created from supplied color in UIML file			private var themeTintSet:Boolean = false;		private var uiScaleType:String = "normal";		private var components:Array;						// list of all added UI components by name    		private var priorView:ComponentView; 				// Temporary holder for prior view if UI is reloaded with new UIML 		private var _plist:XML;								// XML property list provided in UIML <plist>		private var _cache:String;		//  =====================================================================================================		//  Reporter Implementation		//		public function makeEvent(eventType:String):UIEvent {			var newEvent:UIEvent = UIEventManager.instance().createUIEvent(id, componentType, eventType);			return (newEvent);		}		// Create the UI		public static function init(c:BTCanvas):void {			Debug.instance();			Debug.output(_instance, "Init");			_canvas = c;			if (_instance == null) {				_instance = new BTUI(null);				Debug.output(_instance, "Created");				_instance.createComponentView();			} else {				_instance.disableMouseEvents();				Debug.output(_instance, "Resetting UI");				Debug.clearHooks();				clear();				_instance.priorView = _instance.view;				_instance.view = null;				_instance.setMainUISize();				_instance.createComponentView();			}		}		public static function canvas():BTCanvas {			return _canvas;		}		// Access to the top-level BTComponent		public static function root():BTUI {			if (BTUI._instance != null) {				return _instance;			} else {				Debug.output(_instance, "Not yet created");				return null;			}		}		// plist		public static function plist():XML {			if (_instance._plist != null) {				return (_instance._plist);			} else {				Debug.output(_instance, "plist does not exist");				return null;			}		}		// cache url		public static function cache():String {			if (_instance._cache != null) {				return (_instance._cache);			} else {				Debug.output(_instance, "cache does not exist");				return null;			}		}		public static function store(_plist:XML):void {			_instance._plist = _plist;		}		public static function setCacheUrl(_cache:String):void {			_instance._cache = _cache;			_instance.interfaceLibrary.setCacheUrl(_cache);		}		//  Retrieves a component by Id		public static function component(id:String):BTComponent {			return (_instance.getComponentById(id));		}		// Nulls a component from associative array		public static function remove(id:String):void {			_instance.components[id] = null;		}		//  addResponder is the top-level method for assigning responders to components.  Responders must 		//  implement the UIControl interface.  To assign responders on a component to filter on 		//  events from only its subcomponents, use addResponderTo() instead on a given component.		//  Example: Window.addResponderTo(Button, ..class);		//  Only components that implement the Reporter interface are eligible to add responders.		public static function addResponder(id:String, interfaceResponse:UIControl):void {			var c:BTComponent = _instance.getComponentById(id);			if (c == null) {				Debug.output(_instance, "[WARNING] : requested component '" + id + "' does not exist.  Responder will not be added.")				return;			} else {				// Component adds the responder to itself				var r:Reporter;				try {					r = Reporter(c);					c.addResponderTo(r, interfaceResponse);				} catch (error:Error) {					Debug.output(_instance, "[WARNING] : requested component '" + id + "' is not a Reporter.  Responder will not be added.")				}			}		}		// Init		public function BTUI(parentComponent:BTComponent):void {			super(parentComponent);			id = "User_Interface";			globalParameters = new InterfaceParameters();			globalParameters.setLocation(new Pointdata(0, 0));			setMainUISize();			globalParameters.setColor(0x00FFFFFF);			globalParameters.setOutline(0);			idCounter = 0;			components = new Array();			components[id] = this;			componentType = "root";			allowSubcomponents = true;			interfaceLibrary = new BitmapLibrary("UI_Library");			themeTintColor = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);			themeOutlineColor = 0x000000;			pathProxies = new Array();		}		private function setMainUISize():void {			if ((_canvas._containerWidth != 0) && (_canvas._containerHeight != 0)) {				globalParameters.setSize(new Pointdata(_canvas._containerWidth, _canvas._containerHeight));			} else {				if (_canvas.stage) {					if ((_canvas.stage.stageWidth == 0) || (_canvas.stage.stageHeight == 0)) {						globalParameters.setSize(new Pointdata(1000, 1000));					} else {						globalParameters.setSize(new Pointdata(_canvas.stage.stageWidth, _canvas.stage.stageHeight));					}					_canvas.stage.addEventListener(Event.RESIZE, stageResized);				} else {					Debug.output(_instance, "Warning : expected Main class does not have a stage property.");					globalParameters.setSize(new Pointdata(1, 1));				}			}		}		public function stageResized(event:Event):void {			Debug.output(this, "stage resized");			if (uiScaleType == "fullbleed") {				resize(_canvas.stage.stageWidth, _canvas.stage.stageHeight);				registerExternal(this, makeEvent(UIEventType.UI_RESIZE));			}		}		// By default, the bitmap library uses a local path. Set this to override.		public static function setImagePath(imagePath:String):void {			Debug.output(_instance, "setting image path to : " + imagePath);			_instance.interfaceLibrary.setPath(imagePath);		}		public static function setCachePath(cachePath:String):void {			Debug.output(_instance, "setting cache path to : " + cachePath);			_instance.interfaceLibrary.setCachePath(cachePath);		}		// Set redirects for image filenames starting with a particular path		public static function addImagePathProxy(label:String, path:String):void {			// Debug.output(_instance, "adding image proxy path for '"+label+"' to '"+path+"'");			_instance.interfaceLibrary.addImagePathProxy(label, path);		}		// SSet redirects for UIML filenames starting with a particular path		public static function addUIMLPathProxy(label:String, path:String):void {			Debug.output(_instance, "adding UIML proxy path for '" + label + "' to '" + path + "'");			_instance.pathProxies[label] = path;		}		public static function proxyPath(UIML:String):String {			var useProxy:Boolean = false;			var path:String;			var result:String = UIML;			if (UIML.indexOf("/") != -1) {				path = UIML.substr(0, UIML.indexOf("/"));				if (_instance.pathProxies[path] != null) {					useProxy = true;				}			}			if (useProxy) {				result = _instance.pathProxies[path] + UIML;			}			return (result);		}		// Theme		public static function setTintColor(rgb:String):void {			var tintR:String = rgb.substr(0, 2);			var tintG:String = rgb.substr(2, 2);			var tintB:String = rgb.substr(4, 2);			// new color conversion - Uses percent of color, not color offset			var tintRDecimal:Number = 255 - UnitConversion.hexToDecimal(tintR);			var tintGDecimal:Number = 255 - UnitConversion.hexToDecimal(tintG);			var tintBDecimal:Number = 255 - UnitConversion.hexToDecimal(tintB);			// determine percent of each channel			var percentR:Number = tintRDecimal / 255;			var percentG:Number = tintGDecimal / 255;			var percentB:Number = tintBDecimal / 255;			setTintValues(percentR, percentG, percentB);		}		public static function setColor(rgb:String):void {			_instance.globalParameters.setColor(Number("0xFF" + rgb));			//_instance.getView().changeColor(Number("0xFF"+rgb));		}		public static function setTintValues(percentR:Number, percentG:Number, percentB:Number):void {			if (!_instance.themeTintSet) {				_instance.themeTintColor = new ColorTransform(1 - percentR, 1 - percentG, 1 - percentB, 1, 0, 0, 0, 0);				percentR = 1 - percentR;				percentG = 1 - percentG;				percentB = 1 - percentB;				Debug.output(_instance, "<TINT> color set as Red:" + percentR + " G:" + percentG + " B:" + percentB);				_instance.themeTintSet = true;			}		}		public static function setScaleType(uiScaleType:String):void {			_instance.uiScaleType = uiScaleType;		}		public static function tintColor():ColorTransform {			return (_instance.themeTintColor);		}		public static function setOutlineColor(color:uint):void {			_instance.themeOutlineColor = color;			Debug.output(_instance, "<OUTLINE> color set as " + color);		}		public static function setBackgroundColor(color:uint):void {			_instance.themeBackgroundColor = color;			Debug.output(_instance, "<BACKGROUND> color set as " + color);		}		public static function outlineColor():uint {			return (_instance.themeOutlineColor);		}		public static function backgroundColor():uint {			return (_instance.themeBackgroundColor);		}		// Bitmap Library		public static function library():BitmapLibrary {			return (_instance.interfaceLibrary);		}		/*		public function setImageLibrary(interfaceLibrary:BitmapLibrary) {			this.interfaceLibrary = interfaceLibrary;		}		public function getImageLibrary():BitmapLibrary {			return(interfaceLibrary);		}		*/		// Display		public static function fullscreen():void {			if (BTUI.canvas().stage.displayState == StageDisplayState.FULL_SCREEN) {				BTUI.canvas().stage.displayState = StageDisplayState.NORMAL;			} else {				BTUI.canvas().stage.displayState = StageDisplayState.FULL_SCREEN;			}		}		public static function lazyLoadComplete():void {			_instance.onViewImageDataReady();		}		// Global non-destructive redraw, updates view with components that have been added		public static function refreshView():void {			_instance.display();			if (_instance.priorView) {				BTUI.canvas().removeChild(_instance.priorView);				_instance.priorView = null;				_instance.resumeMouseEvents();			}		}		public static function setNativeSize():void {			if (_instance.uiScaleType == "fullbleed") {				if (BTUI.canvas().stage) {					_instance.resize(BTUI.canvas().stage.stageWidth, BTUI.canvas().stage.stageHeight);				} else {					Debug.output(_instance, "[WARNING] Main._stage does not exist");				}			}		}		public static function clear():void {			_instance.displayExists = false;			_instance.reset();			_instance.globalParameters = new InterfaceParameters();			_instance.globalParameters.setLocation(new Pointdata(0, 0));			_instance.idCounter = 0;			_instance.components = new Array();			_instance.interfaceLibrary = new BitmapLibrary("UI_Library");		}		// Components		public static function componentsList():Array {			return (_instance.components);		}		public function getComponentById(componentId:String):BTComponent {			if (components[componentId] != null) {				return (components[componentId]);			} else {				Debug.output(_instance, "[WARNING] Requested component (" + componentId + ") that does not exist.")				return null;			}		}		public static function createComponent(componentType:String, customId:String, componentParent:BTComponent):String {			var componentConstructor:Class = ComponentTypes.instance().getType(componentType).getConstructor();			var newComponent:IComponent = new componentConstructor(componentParent);			// Sets default ID for component if none is supplied			if (customId != null) {				componentConstructor(newComponent).setId(customId);			} else {				componentConstructor(newComponent).setId(componentType + _instance.idCounter++);			}			// Create Empty ComponentView			componentConstructor(newComponent).createComponentView();			_instance.components[componentConstructor(newComponent).getId()] = componentConstructor(newComponent);			return (newComponent.getId());		}	}}
﻿// bubbletools.* ===============================================================================// BubbleTools™ Web Application and User Interface Component Architecture for Actionscript 3// ©2007 Michael Szypula.  Any modifications to this file must keep this license block intact.// Developer : Michael Szypula// Contact : michael.szypula@gmail.com// License Information : Contact Developer to obtain license agreement.// =================================================================================================package bubbletools.util.javascript {	import flash.external.ExternalInterface;		public class Javascript {			public static var ISENABLED:Boolean = false;		public static var ALLOWED:Boolean = true;				private static var _instance:Javascript;				private var script:String;		private var jsLibrary:JavascriptLibrary;			public static function enable():void {			if (Javascript._instance == null) {				Javascript._instance = new Javascript();			}		}		public static function source(jsfilename:String):void {			_instance.jsLibrary.addJavascriptFile(new JavascriptFile(jsfilename));		}						public static function call(fn:String, args:Array):String { 						if(ExternalInterface.available && Javascript.ALLOWED) {								var jsReturn:String = "";								if(Javascript.ISENABLED) {					var js:JavascriptFunction = _instance.jsLibrary.jsFunction(fn);					if(js) {						if(args != null) {							jsReturn = js.execute(args);						} else {							jsReturn = js.execute(new Array());						}					} else {						trace("[Javascript] Function not found.");							jsReturn = "ERROR_NOT_FOUND";					} 				} else {					trace("[Javascript] Javascript parsing has not been enabled.  Functions will not execute.");					jsReturn = "ERROR_DISABLED";				}				return(jsReturn);                  						} else {     								trace("[Javascript] External interface is not available or not allowed on the host");								return null;			}		}                      				public static function library():JavascriptLibrary {			return(_instance.jsLibrary);		}		public function Javascript(){			Javascript.ISENABLED = true;			jsLibrary = new JavascriptLibrary();		}			}}
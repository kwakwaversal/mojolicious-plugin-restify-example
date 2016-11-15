/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	module.exports = __webpack_require__(1);


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var App_1 = __webpack_require__(2);
	document.addEventListener('DOMContentLoaded', function () {
	    var app = new App_1.App();
	    app.start();
	});


/***/ },
/* 2 */
/***/ function(module, exports, __webpack_require__) {

	"use strict";
	var __extends = (this && this.__extends) || function (d, b) {
	    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
	    function __() { this.constructor = d; }
	    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
	};
	var Backbone = __webpack_require__(5);
	var Marionette = __webpack_require__(3);
	var App = (function (_super) {
	    __extends(App, _super);
	    function App() {
	        console.log('call App#constructor');
	        _super.call(this);
	    }
	    App.prototype.onStart = function () {
	        console.log('call App#onStart');
	        this.container = new Marionette.Region({
	            el: '#app'
	        });
	        this.container.show(new SpecialView());
	    };
	    return App;
	}(Marionette.Application));
	exports.App = App;
	var BaseView = (function (_super) {
	    __extends(BaseView, _super);
	    function BaseView(options) {
	        _super.call(this, options);
	    }
	    BaseView.prototype.templateHelpers = function () {
	        var _this = this;
	        var contentTemplate = this.getOption("contentTemplate");
	        return {
	            content: function () { return contentTemplate ? contentTemplate(_this.model.toJSON()) : ""; },
	        };
	    };
	    return BaseView;
	}(Marionette.ItemView));
	var SpecialView = (function (_super) {
	    __extends(SpecialView, _super);
	    function SpecialView() {
	        _super.call(this, {
	            model: new Backbone.Model({
	                textOnlyFromSpecialView: "This Text can only be set by this special View"
	            })
	        });
	    }
	    return SpecialView;
	}(BaseView));


/***/ },
/* 3 */
/***/ function(module, exports) {

	module.exports = Marionette;

/***/ },
/* 4 */,
/* 5 */
/***/ function(module, exports) {

	module.exports = Backbone;

/***/ }
/******/ ]);
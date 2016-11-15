import * as _ from 'underscore';
import * as Backbone from 'backbone';
import * as Marionette from 'backbone.marionette';

class ScrabbliciousApp extends Marionette.Application {
  constructor() {
    console.log('initializing application');
    super();
  }
  // onStart() {
  // }
}

(function(): void {
  var app = new ScrabbliciousApp;
  app.start();
})();

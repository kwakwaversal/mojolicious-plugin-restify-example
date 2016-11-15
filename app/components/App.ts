import * as _ from 'underscore';
import * as Backbone from 'backbone';
import * as Marionette from 'backbone.marionette';

export class App extends Marionette.Application {
  private container: Marionette.Region;

  constructor() {
    console.log('call App#constructor');

    super();
  }

  onStart() {
    console.log('call App#onStart');

    this.container = new Marionette.Region({
      el: '#app'
    });

    this.container.show(new SpecialView());
    // this.addRegions({ mainRegion: "#app" });
  }
}

class BaseView extends Marionette.ItemView {
  private template:(...data:any[]) => string;

  constructor(options?:Backbone.ViewOptions) {
    super(options);

    // this.template  = _.template($('#base-tmpl').html());
    // this.tagname   = 'div';
    // this.className = 'base-div';

  }

  private templateHelpers():any {
    var contentTemplate:any = this.getOption("contentTemplate");
    return {
      content: () => contentTemplate ? contentTemplate(this.model.toJSON()) : "",
    };
  }
}

class SpecialView extends BaseView {
  private contentTemplate:(...data:any[]) => string;

  constructor() {
    // this.contentTemplate = _.template($('#special-tmpl').html());

    super( {
      model: new Backbone.Model({
        textOnlyFromSpecialView: "This Text can only be set by this special View"
      })
    });
  }
}

// export class navBarItemViewTemplate extends Marionette.ItemView {
//   constructor(options?: Backbone.ViewOptions) {
//     if (!options)
//       options = {};
//     options.template = "#navBarItemViewTemplate";
//     super(options);
//   }
// }

// export class RootView extends Marionette.LayoutView<any> {
//     private inputRegion: Marionette.Region;
//
//     constructor(options: any = {}) {
//         this.el = 'body';
//         super(options);
//
//         this.addRegions({
//             inputRegion: '#input-region'
//         });
//
//         this.inputRegion.show(new InputItemView());
//     }
// }

// https://github.com/kwilson/FluxTests/blob/0962aa71dfc8a7f693240563f4fcc18c53d27bb1/FluxTests/app/app.ts
// https://github.com/kashifjawed/CCTracking/blob/b87c4d0844b1e209cddb66adc5dd384c13234461/CCTrackingTS/CCTracking.WebClient/App.ts

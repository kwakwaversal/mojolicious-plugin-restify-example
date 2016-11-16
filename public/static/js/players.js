/* This example uses Mn v2.4.5 */

/*
 * This represents a row in the table
 */
const RowView = Mn.ItemView.extend({
    tagName: 'tr',
    template: '#row_template',
    serializeData: function() {
        return {
            model: this.model.toJSON(),
            // columns: this.collection.pluck('field'),
            columns: this.collection
        }
    },
});

/*
 * This represents the table.
 * It attaches to an existing element in the html
 */
const TableView = Mn.CompositeView.extend({
    childView: RowView,
    childViewContainer: 'tbody',
    childViewOptions: {},
    template: '#table_template',
    templateHelpers: function() {
        return { columns: this.columns }
    },
    initialize: function(options) {
        this.childViewOptions.collection = options.columns;
        this.columns = options.columns;
        this.listenTo(this.columns, 'change add', this.render);
    }
});


/*
 * This represents the entire page.
 * It attaches to an existing element in the html
 */
const PageView = Mn.View.extend({
    el: '#page',
    events: {
        'click .woop': 'woop',
    },
    initialize: function(options) {
        const table = new TableView({
            el: this.$('table'),
            columns: options.table_columns,
            collection: this.collection,
        });
        table.render();
    },
    woop: function() {
        console.log("wooped");
    }
});


/****************************************
 * exports
 ***************************************/
window.PageView = PageView;

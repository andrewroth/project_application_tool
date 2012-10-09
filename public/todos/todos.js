Ext.require(['Ext.data.*', 'Ext.grid.*']);

Ext.define('PrepItemCategory', {
    extend: 'Ext.data.Model',
    fields: [{
        name: 'id',
        type: 'int',
        useNull: true
    }, 'title'],
    validations: [{
        type: 'length',
        field: 'title',
        min: 1
    }]
});

Ext.onReady(function(){

    var store = Ext.create('Ext.data.Store', {
        autoLoad: true,
        autoSync: true,
        model: 'PrepItemCategory',
        proxy: {
            type: 'rest',
            url: '/prep_item_categories',
            reader: {
                type: 'json',
                root: 'data'
            },
            writer: {
                type: 'json'
            }
        }
    });
    
    var rowEditing = Ext.create('Ext.grid.plugin.RowEditing');
    
    var grid = Ext.create('Ext.grid.Panel', {
        renderTo: "todoUi",
        plugins: [rowEditing],
        width: 400,
        height: 400,
        frame: true,
        title: 'Categories',
        store: store,
        columns: [{
            text: 'ID',
            width: 40,
            sortable: true,
            dataIndex: 'id',
            renderer: function(v){
                if (Ext.isEmpty(v)) {
                    v = '&#160;';
                }
                return v;
            }
        }, {
            text: 'Title',
            flex: 1,
            sortable: true,
            dataIndex: 'title',
            field: {
                xtype: 'textfield'
            }
        }],
        dockedItems: [{
            xtype: 'toolbar',
            items: [{
                text: 'Add',
                handler: function() {
                    // empty record
                    store.insert(0, new PrepItemCategory());
                    rowEditing.startEdit(0, 0);
                }
            }, '-', {
                text: 'Delete',
                handler: function() {
                    var selection = grid.getView().getSelectionModel().getSelection()[0];
                    if (selection) {
                        store.remove(selection);
                    }
                }
            }]
        }]
    });
});

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

Ext.define('Project', {
    extend: 'Ext.data.Model',
    fields: [{
        name: 'id',
        type: 'int',
        useNull: true
    }, 'title']
});

Ext.define('PrepItem', {
    extend: 'Ext.data.Model',
    fields: [{
        name: 'id',
        type: 'int',
        useNull: true
      }, {
        name: 'deadline',
        type: 'date',
      }, {
        name: 'deadline_optional',
        type: 'boolean',
      }, {
        name: 'individual',
        type: 'boolean'
      }, {
        name: 'paperwork',
        type: 'boolean'
      }, 'title', 'description', 'prep_item_category_id', 'project_ids'
    ], validations: [{
      type: 'length',
      field: 'title',
      min: 1
    }, {
      type: 'length',
      field: 'description',
      min: 1
    }]
});

Ext.onReady(function() {

    function formatDate(value) {
        return value ? Ext.Date.dateFormat(value, 'M d, Y') : '';
    }

    var categoriesStore = Ext.create('Ext.data.Store', {
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
            },
        }
    });

    var prepItemsStore = Ext.create('Ext.data.Store', {
        autoLoad: true,
        autoSync: true,
        model: 'PrepItem',
        proxy: {
            type: 'rest',
            url: '/prep_items',
            reader: {
                type: 'json',
                root: 'data'
            },
            writer: {
                type: 'json'
            }
        }
    });

    var projectsStore = Ext.create('Ext.data.ArrayStore', {
        model: "Project",
        data: projectsData
    });

    var categoriesRowEditing = Ext.create('Ext.grid.plugin.RowEditing');
    
    var categoriesGrid = Ext.create('Ext.grid.Panel', {
        plugins: [categoriesRowEditing],
        width: 200,
        height: 400,
        frame: true,
        title: 'Categories',
        store: categoriesStore,
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
                xtype: 'textfield',
                allowBlank: false
            }
        }],
        dockedItems: [{
            xtype: 'toolbar',
            items: [{
                text: 'Add',
                handler: function() {
                    // empty record
                    categoriesStore.insert(0, new PrepItemCategory());
                    categoriesRowEditing.startEdit(0, 0);
                }
            }, '-', {
                text: 'Delete',
                handler: function() {
                    var selection = categoriesGrid.getView().getSelectionModel().getSelection()[0];
                    if (selection) {
                        categoriesStore.remove(selection);
                    }
                }
            }]
        }]
    });

    var prepItemRowEditing = Ext.create('Ext.grid.plugin.RowEditing');

    var prepItemGrid = Ext.create('Ext.grid.Panel', {
        plugins: [prepItemRowEditing],
        width: 700,
        height: 400,
        frame: true,
        title: 'Todos',
        store: prepItemsStore,
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
            text: 'Category',
            flex: 1,
            sortable: true,
            dataIndex: 'prep_item_category_id',
            editor: {
                  xtype: 'combobox',
                  store: categoriesStore,
                  displayField: 'title',
                  valueField: 'id',
                  editable: false,
                  multiSelect: false
           }, 
           renderer: function(value) {
             if (value != 0 && value != "") {
               record = categoriesStore.findRecord("id", value);
               if (record != null) {
                 return record.get('title');
               } else {
                 return value;
               }
             } else {
               return "";
             }
           }
        }, {
            text: 'Title',
            flex: 1,
            sortable: true,
            dataIndex: 'title',
            field: {
              xtype: 'textfield',
              allowBlank: false
            }
        }, {
            text: 'Description',
            flex: 1,
            sortable: true,
            dataIndex: 'description',
            field: {
              xtype: 'textfield',
              allowBlank: false
            }
        }, {
            text: 'Projects',
            flex: 1,
            sortable: true,
            dataIndex: 'project_ids',
            editor: {
                  xtype: 'combobox',
                  store: projectsStore,
                  queryMode: 'local',
                  displayField: 'title',
                  valueField: 'id',
                  editable: false,
                  multiSelect: true,
            },
            renderer: function(ids) {
              project_names = [];
              for (var i = 0; i < ids.length; i++) {
                record = projectsStore.findRecord("id", ids[i]);
                if (record != null) {
                  project_names.push(record.get('title'));
                }
              }
              return project_names.join(', ');
            }
        }, {
            text: 'Deadline',
            width: 80,
            sortable: true,
            dataIndex: 'deadline',
            renderer: formatDate,
            field: {
              xtype: 'datefield',
              format: 'm/d/y'
            }
        }/*, {
            text: 'Optional',
            width: 60,
            sortable: true,
            dataIndex: 'deadline_optional',
            field: {
              xtype: 'checkbox'
            },
        }*/, {
            text: 'Individual',
            width: 60,
            sortable: true,
            dataIndex: 'individual',
            field: {
              xtype: 'checkbox'
            }
        }, {
            text: 'Paperwork',
            width: 60,
            sortable: true,
            dataIndex: 'paperwork',
            field: {
              xtype: 'checkbox'
            }
        }],
        dockedItems: [{
            xtype: 'toolbar',
            items: [{
                text: 'Add',
                handler: function() {
                    // empty record
                    prepItemsStore.insert(0, new PrepItem());
                    prepItemRowEditing.startEdit(0, 0);
                }
            }, '-', {
                text: 'Delete',
                handler: function() {
                    var selection = prepItemGrid.getView().getSelectionModel().getSelection()[0];
                    if (selection) {
                        prepItemsStore.remove(selection);
                    }
                }
            }]
        }]
    });

    Ext.create('Ext.container.Container', {     
        renderTo: "todoUi",
        width: 900,
        layout: {
            type: 'hbox'
        },      
        items: [categoriesGrid, prepItemGrid],
    });

});

Ext.require(['*']);

var current_event_group_id;

var projectsStore;
var eventGroupResourceStore;
var copyStore;

Ext.define('Project', {
  extend: 'Ext.data.Model',
  fields: [{
    name: 'id',
    type: 'int',
    useNull: true
  }, 'title']
});

Ext.define('Resource', {
  extend: 'Ext.data.Model',
  fields: [{
    name: 'id',
    type: 'int',
    useNull: true
  }, 'title', 'description']
});

Ext.define('EventGroupResource', {
  extend: 'Ext.data.Model',
  fields: ['id', 'title', 'description']
});

Ext.onReady(function(){
  projectsStore = Ext.create('Ext.data.Store', {
    autoLoad: true,
    autoSync: true,
    model: 'Project',
    proxy: {
      type: 'rest',
      url: '/projects',
      reader: {
        type: 'json',
        root: 'data'
      },
      writer: {
        type: 'json'
      }
    }
  });

  eventGroupResourceStore = Ext.create('Ext.data.Store', {
    autoLoad: true,
    autoSync: true,
    model: 'Project',
    proxy: {
      type: 'rest',
      url: '/event_group_resources',
      reader: {
        type: 'json',
        root: 'data'
      },
      writer: {
        type: 'json'
      }
    }
  });

  var store = Ext.create('Ext.data.TreeStore', {
    proxy: {
      type: 'ajax',
      url: '/event_groups.js'
    },
    root: {
      text: 'Ext JS',
      id: 'roots',
      expanded: true
    },
    folderSort: true,
    sorters: [{
      property: 'text',
      direction: 'ASC'
    }]
  });

  copyStore = Ext.create('Ext.data.TreeStore', {
    proxy: {
      type: 'ajax',
      url: '/event_groups.js',
      extraParams: { resources: true }
    },
    root: {
      text: 'Ext JS',
      id: 'roots',
      expanded: true
    },
    folderSort: true,
    sorters: [{
      property: 'text',
      direction: 'ASC'
    }]
  });

  var copyTree = Ext.create('Ext.tree.Panel', {
    id: 'copyTree',
    store: copyStore,
    width: 424,
    height: 300,
    title: 'Copy Resources - Drag to Resources Grid',
    rootVisible: false,
    listeners: {
      itemClick: function(view, rec, item, index, eventObj) {
      }
    },
    viewConfig: {
      plugins: {
        ptype: 'treeviewdragdrop',
        dragGroup: 'copyDragGroup',
        dropGroup: 'resourcesDragGroup',
      },
      copy: true
    },
    /*,
    dockedItems: [{
      xtype: 'toolbar',
      items: [{
        text: 'New',
        handler: function() {
          jQuery.ajax('/event_groups/new').done(function(data) { details.body.update(data); })
          details.body.update("loading...");
        }
      }]
    }]*/
  });

  var tree = Ext.create('Ext.tree.Panel', {
    id: 'tree',
    store: store,
    width: 300,
    height: 600,
    title: 'Event Groups',
    rootVisible: false,
    listeners: {
      itemClick: function(view, rec, item, index, eventObj) {
        details.setTitle(rec.raw.text);
        current_event_group_id = rec.raw.id;
        /* set edit tab ajax url */
        details.items.getAt(0).loader.url = '/event_groups/' + current_event_group_id + '/edit';
        details.items.getAt(0).loader.load();
        /* set event group id for resources */
        eventGroupResourceStore.getProxy().extraParams = { event_group_id: current_event_group_id };
        eventGroupResourceStore.load();
      }
    },
    dockedItems: [{
      xtype: 'toolbar',
      items: [{
        text: 'New',
        handler: function() {
          jQuery.ajax('/event_groups/new').done(function(data) { details.body.update(data); })
          details.body.update("loading...");
        }
      }]
    }]
  });

  var resourcesRowEditing = Ext.create('Ext.grid.plugin.RowEditing');

  var resourcesGrid = Ext.create('Ext.grid.Panel', {
    width: 424,
    height: 300,
    frame: true,
    title: "Resources",
    store: eventGroupResourceStore,
    viewConfig: {
      plugins: [{
          ptype: 'gridviewdragdrop',
          dropGroup: 'copyDragGroup',
          dragGroup: 'resourcesDragGroup'
        }//,
        //resourcesRowEditing
      ],
      listeners: {
        drop: function(node, data, dropRec, dropPosition) {
          //var dropOn = dropRec ? ' ' + dropPosition + ' ' + dropRec.get('name') : ' on empty view';
          //console.log("Drag from right to left", 'Dropped ' + data.records[0].get('name') + dropOn);
          data.records.each(function(record, i) { 
            debugger;
            data_split = record.data.id.split('_');
            eg_id = data_split[0];
            eg_resource_id = data_split[1];
            resource_id = data_split[2];
            /* this is a shortcut - just use ajax to create the node and reload the list.  I'm sure it can
            * be done better using extjs store to send the new data.. but right now I just need this working. 
            * */
            Ext.Ajax.request({
              method: 'POST',
              url: '/event_group_resources',
              params: { event_group_id: current_event_group_id, eg_resource_id: eg_resource_id, 
                title: record.data.title, description: record.data.description, resource_id: resource_id }
            });
          });
          eventGroupResourceStore.load();
        }
      }
    },
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
      text: 'Size',
      flex: 1,
      sortable: true,
      dataIndex: 'size',
      field: {
        xtype: 'textfield',
        allowBlank: false
      }
    }],
    dockedItems: [{
      xtype: 'toolbar',
      items: [{
        text: 'Delete',
        handler: function() {
          var selection = resourcesGrid.getView().getSelectionModel().getSelection()[0];
          if (selection) {
            eventGroupResourceStore.remove(selection);
          }
        }
      }]
    }]
  });

  var resourcesPanel = Ext.create('Ext.Panel', {
    title: "Resources",
    width: 850,
    layout: {
      type: 'table',
      columns: 2,
    },
    items: [
      resourcesGrid, copyTree,
    {
      title: "Upload",
      html: "3",
      colspan: "2",
      width: 848
    }]
  });

  //var details = Ext.create('Ext.tree.tabPanel', {
  var details = Ext.createWidget('tabpanel', {
    width: 850,
    height: 600,
    title: 'Event Group',
    items: [{
      title: 'Edit',
      loader: {
        url: '/inital.html',
        contentType: 'html',
        loadMask: true
      },
      listeners: {
        activate: function(tab) {
          // can't figure out how to get the selected tree id - thought the following line would work but no dice
          //tab.loader.url = '/event_groups/' + tree.getSelectionModel().getSelectedNode();
          tab.loader.url = '/event_groups/' + current_event_group_id + '/edit';
          tab.loader.load();
        }
      }
    },
      resourcesPanel
    ]
  });

  Ext.create('Ext.container.Container', {
    renderTo: "eventGroupUI",
    width: 1150,
    height: 600,
    frame: true,
    layout: {
      type: 'hbox'
    },
    items: [tree, details],
  });
});

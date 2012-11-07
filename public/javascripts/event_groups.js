Ext.require(['*']);

var tree_id;

Ext.onReady(function(){
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
        tree_id = rec.raw.id;
        details.getActiveTab().loader.url = '/event_groups/' + tree_id + '/edit';
        details.getActiveTab().loader.load();
        /*
        jQuery.ajax('/event_groups/edit/' + rec.raw.id).done(function(data) { details.body.update(data); });
        details.body.update("loading...");
        */
      }
    },
    viewConfig: {
      plugins: {
        ptype: 'treeviewdragdrop',
        appendOnly: true
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
          tab.loader.url = '/event_groups/' + tree_id + '/edit';
          tab.loader.load();
        }
      }
    },{
      title: 'Resources',
      html: 'html'
    }]
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

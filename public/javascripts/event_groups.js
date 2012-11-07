Ext.require(['*']);

Ext.onReady(function(){
  var store = Ext.create('Ext.data.TreeStore', {
    proxy: {
      type: 'ajax',
      url: '/event_groups.js'
    },
    root: {
      text: 'Ext JS',
      id: 'src',
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
    width: 200,
    height: 600,
    title: 'Event Groups',
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

  var details = Ext.create('Ext.tree.Panel', {
    width: 950,
    height: 600,
    title: 'Details'
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

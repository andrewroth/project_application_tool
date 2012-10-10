Ext.Loader.setConfig({enabled: true});

Ext.require([
    'Ext.grid.*',
    'Ext.data.*',
    'Ext.util.*',
    'Ext.tip.QuickTipManager',
    'Ext.ux.CheckColumn',
    'Ext.ux.LiveSearchGridPanel',
]);

Ext.onReady(function() {    
    Ext.QuickTips.init();
        
    /**
     * Custom function used for column renderer
     * @param {Object} val
     */
    function change(val){
        if(val > 0){
            return '<span style="color:green;">' + val + '</span>';
        }else if(val < 0){
            return '<span style="color:red;">' + val + '</span>';
        }
        return val;
    }

    /**
     * Custom function used for column renderer
     * @param {Object} val
     */
    function pctChange(val){
        if(val > 0){
            return '<span style="color:green;">' + val + '%</span>';
        }else if(val < 0){
            return '<span style="color:red;">' + val + '%</span>';
        }
        return val;
    }        
    
    
    // create the data store
    var store = Ext.create('Ext.data.ArrayStore', {
        fields: fields,
        data: profileData,
        sortOnLoad: true,
        sorters: { property: 'name', direction: 'DESC' },
    });
    
    console.log(columns);

    // create the Grid, see Ext.
    Ext.create('Ext.ux.LiveSearchGridPanel', {
        store: store,
        columnLines: true,
        canSearchRegularExpression: false,
        /*
        columns: [
            {
                text     : 'Name',
                flex     : 1,
                sortable : false, 
                dataIndex: 'company'
            },
            {
                text     : 'Project', 
                width    : 75, 
                sortable : true, 
                renderer : 'usMoney', 
                dataIndex: 'price'
            },
            {
                text     : 'Change', 
                width    : 75, 
                sortable : true, 
                dataIndex: 'change',
                renderer: change
            },
            {
                text     : '% Change', 
                width    : 75, 
                sortable : true, 
                dataIndex: 'pctChange',
                renderer: pctChange
            },
            {
                text     : 'Last Updated', 
                width    : 85, 
                sortable : true, 
                dataIndex: 'lastChange'
            }
        ],*/
        columns: columns,
        height: 600,
        width: "100%",
        title: 'Live Search Grid',
        selMode: {
          selType: 'cellmodel'
        },
        renderTo: 'grid-example',
        viewConfig: {
            stripeRows: true
        }
    });
});

// Remove list items.
$('body').delegate(".remove", "click", function() {
    var list = $(this).attr('list');

    //retrieve the context
    var context = ko.contextFor(this);
    var parentArray = context.$parent[list];

    //remove the data (context.$data) from the appropriate array on its parent (context.$parent)
    parentArray.remove(context.$data);
 
    return false;
});

// Add list items.
$('body').delegate(".insert", "click", function() {
    var list = $(this).attr('list');

    //retrieve the context
    var context = ko.contextFor(this);

    var newItem = prompt("Enter new entry for " + list + ': ');

    if (newItem != '' && newItem != null) {
      context.$data[list].push(newItem);
    };
 
    return false;
});

//function save() {
//  $(). ko.toJSON(DotRubyViewModel);
//}

function save() {
  //var json = ko.toJSON(dotrubyInstance);
  var json = JSON.stringify( ko.toJS(dotrubyInstance), null, 2 );
  $('#lastSavedJson').val(json);
};


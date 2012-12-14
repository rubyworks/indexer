DotRuby = {

  viewModel: function(data) {
    var self = this;
    var data = DotRuby.prepareData(data);

    self.name            = ko.observable(data.name);
    self.title           = ko.observable(data.title);
    self.version         = ko.observable(data.version);
    self.codename        = ko.observable(data.codename);
    self.summary         = ko.observable(data.summary);
    self.description     = ko.observable(data.description);
    self.created         = ko.observable(data.created);
    self.date            = ko.observable(data.date);
    self.organization    = ko.observable(data.organization);
    self.suite           = ko.observable(data.suite);
    self.install_message = ko.observable(data.install_message);

    self.authors         = ko.observableArray(data.authors);
    self.repositories    = ko.observableArray(data.repositories);
    self.requirements    = ko.observableArray(data.requirements);
    self.dependencies    = ko.observableArray(data.dependencies);
    self.conflicts       = ko.observableArray(data.conflicts);
    self.alternatives    = ko.observableArray(data.alternatives);
    self.resources       = ko.observableArray(data.resources);
    self.copyrights      = ko.observableArray(data.copyrights);
    self.load_path       = ko.observableArray(data.load_path);

    self.addResource     = function(){
      this.resources.push(new DotRuby.resourceModel( {label: '', uri: ''} ));
    };

    self.addRepository   = function(){
      this.repositories.push(new DotRuby.repositoryModel( {label: '', uri: '', scm: ''} ));
    };

    self.addRequirement  = function(){
      this.requirements.push(new DotRuby.requirementModel( {name: '', version: '', development: false, groups: [], engines: [], platforms: []} ));
    };

    self.addDependency   = function(){
      this.dependencies.push(new DotRuby.dependencyModel( {name: '', version: '', development: false, groups: [], engines: [], platforms: []} ));
    };

    self.addCopyright    = function(){
      this.copyrights.push(new DotRuby.copyrightModel( {holder: '', year: '', license: ''} ));
    };

    self.addAuthor       = function(){
      this.authors.push(new DotRuby.authorModel( {name: '', email: '', website: ''} ));
    };

    self.addAlternative  = function(){
      this.alternatives.push('');
    };

    self.addConflict     = function(){
      this.conflicts.push('');
    };

    self.addLoadpath     = function(){
      this.load_path.push('');
    };

    self.json            = function(){
      // @todo Convert resources back to mapping
      ko.toJSON(this) 
    };
  },

  authorModel: function(data) {
    var self = this;
    self.name    = ko.observable(data.name);
    self.email   = ko.observable(data.email);
    self.website = ko.observable(data.website);
    self.roles   = ko.observableArray(data.roles);
  },

  repositoryModel: function(data) {
    var self = this;
    self.label = ko.observable(data.label);
    self.uri   = ko.observable(data.uri);
    self.scm   = ko.observable(data.scm);
  },

  requirementModel: function(data) {
    var self = this;
    self.name        = ko.observable(data.name);
    self.version     = ko.observable(data.version);
    self.groups      = ko.observableArray(makeArray(data.groups));
    self.platforms   = ko.observableArray(makeArray(data.platforms));
    self.engines     = ko.observableArray(makeArray(data.engines));
    self.development = ko.observable(data.development);
    self.repository  = ko.observable(data.repository);
  },

  dependencyModel: function(data) {
    var self = this;
    self.name        = ko.observable(data.name);
    self.version     = ko.observable(data.version);
    self.groups      = ko.observableArray(makeArray(data.groups));
    self.engines     = ko.observableArray(makeArray(data.engines));
    self.platforms   = ko.observableArray(makeArray(data.platforms));
    self.development = ko.observable(data.development);
    self.repository  = ko.observable(data.repository);
  },

  resourceModel: function(data) {
    var self = this;
    self.label = ko.observable(data.label);
    self.uri   = ko.observable(data.uri);
  },

  copyrightModel: function(data) {
    var self = this;
    self.holder  = ko.observable(data.holder);
    self.year    = ko.observable(data.year);
    self.license = ko.observable(data.license);
  },

  // take raw hash and convert elements to models
  // also ensure all fields are accounted for
  prepareData: function(data) {
    newData = {
      name: '',
      version: '0.0.0',
      date: '',
      title: '',
      organization: '',
      summary: '',
      description: '',
      requirements: [],
      dependencies: [],
      alternatives: [],
      repositories: [],
      resources: [],
      authors: [],
      copyrights: []
    };

    _.each(data, function(val, key){
      newData[key] = val;
    });

    newData.resources = _.map(data.resources, function(v,k){
      return(new DotRuby.resourceModel({'label': k, 'uri': v}));
    });

    newData.requirements = _.map(data.requirements, function(a){
      return(new DotRuby.requirementModel(a));
    });

    newData.dependencies = _.map(data.dependencies, function(a){
      return(new DotRuby.dependencyModel(a));
    });

    newData.repositories = _.map(data.repositories, function(x){
      return(new DotRuby.repositoryModel(x));
    });

    newData.authors = _.map(data.authors, function(x){
      return(new DotRuby.authorModel(x));
    });

    newData.copyrights = _.map(data.copyrights, function(x){
      return(new DotRuby.copyrightModel(x));
    });

    //newData.conflicts = _.map(data.conflicts, function(x){
    //  return(new DotRuby.confictModel(x));
    //});

    //newData.alternatives = _.map(data.alternatives, function(x){
    //  return(new DotRuby.copyrightModel(x));
    //});

    return newData;
  },

};

//DotRuby.resourceModel.create = function(){
//  return( new DotRuby.resourceModel({label: '', uri: ''}) );
//};

// support functions

function makeArray(value){
  if (typeof(value) == Array) {
    return value;
  } else {
    return _.compact([value]);
  }
};

function makeString(value){
  if (typeof(value) == String) {
    return value;
  } else {
    return '' + value;
  }
};


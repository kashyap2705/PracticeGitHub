Webruntime.define('lwc/childWebComponent', ['lwc'], function (lwc) { 'use strict';

  function tmpl($api, $cmp, $slotset, $ctx) {
    const {
      t: api_text,
      d: api_dynamic
    } = $api;
    return [api_text("The Value is : "), api_dynamic($cmp.value)];
  }

  var _tmpl = lwc.registerTemplate(tmpl);
  tmpl.stylesheets = [];
  tmpl.stylesheetTokens = {
    hostAttribute: "lwc-childWebComponent_childWebComponent-host",
    shadowAttribute: "lwc-childWebComponent_childWebComponent"
  };

  class ChildWebComponent extends lwc.LightningElement {
    constructor(...args) {
      super(...args);
      this.value = 100;
    }

    //reactive in nature 
    //public method
    handleValueChange() {
      this.value = 200;
    }

  }

  lwc.registerDecorators(ChildWebComponent, {
    publicMethods: ["handleValueChange"],
    track: {
      value: 1
    }
  });

  var childWebComponent = lwc.registerComponent(ChildWebComponent, {
    tmpl: _tmpl
  });

  return childWebComponent;

});

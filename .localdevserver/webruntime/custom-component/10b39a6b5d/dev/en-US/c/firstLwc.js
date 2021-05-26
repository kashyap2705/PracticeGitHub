Webruntime.define('lwc/firstLwc', ['lwc'], function (lwc) { 'use strict';

  function tmpl($api, $cmp, $slotset, $ctx) {
    const {
      d: api_dynamic
    } = $api;
    return [api_dynamic($cmp.myvar)];
  }

  var _tmpl = lwc.registerTemplate(tmpl);
  tmpl.stylesheets = [];
  tmpl.stylesheetTokens = {
    hostAttribute: "lwc-firstLwc_firstLwc-host",
    shadowAttribute: "lwc-firstLwc_firstLwc"
  };

  class FirstLwc extends lwc.LightningElement {
    constructor(...args) {
      super(...args);
      this.myvar = 'HelloWorld';
    }

  }

  lwc.registerDecorators(FirstLwc, {
    track: {
      myvar: 1
    }
  });

  var firstLwc = lwc.registerComponent(FirstLwc, {
    tmpl: _tmpl
  });

  return firstLwc;

});

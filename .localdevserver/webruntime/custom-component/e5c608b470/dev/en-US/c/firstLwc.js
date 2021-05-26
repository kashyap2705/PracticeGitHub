Webruntime.define('lwc/firstLwc', ['lwc'], function (lwc) { 'use strict';

  function tmpl($api, $cmp, $slotset, $ctx) {
    const {
      t: api_text,
      d: api_dynamic
    } = $api;
    return [api_text("Hello GitHub Kashyap Monday hii child branch!!!! "), api_dynamic($cmp.myvar)];
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

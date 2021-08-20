Webruntime.define('lwc/helloWorldComponent', ['lwc'], function (lwc) { 'use strict';

  function tmpl($api, $cmp, $slotset, $ctx) {
    const {
      t: api_text,
      d: api_dynamic
    } = $api;
    return [api_text("hii "), api_dynamic($cmp.Greeting), api_text(" !!!")];
  }

  var _tmpl = lwc.registerTemplate(tmpl);
  tmpl.stylesheets = [];
  tmpl.stylesheetTokens = {
    hostAttribute: "lwc-helloWorldComponent_helloWorldComponent-host",
    shadowAttribute: "lwc-helloWorldComponent_helloWorldComponent"
  };

  class HelloWorldComponent extends lwc.LightningElement {
    constructor(...args) {
      super(...args);
      this.Greeting = 'hiii';
    }

  }

  lwc.registerDecorators(HelloWorldComponent, {
    fields: ["Greeting"]
  });

  var helloWorldComponent = lwc.registerComponent(HelloWorldComponent, {
    tmpl: _tmpl
  });

  return helloWorldComponent;

});

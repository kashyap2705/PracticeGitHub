Webruntime.define('lwc/demo2', ['lwc'], function (lwc) { 'use strict';

  function tmpl($api, $cmp, $slotset, $ctx) {
    const {
      t: api_text,
      d: api_dynamic
    } = $api;
    return [api_text("Hi Anil, we are in demo 2 "), api_dynamic($cmp.demo2greeting)];
  }

  var _tmpl = lwc.registerTemplate(tmpl);
  tmpl.stylesheets = [];
  tmpl.stylesheetTokens = {
    hostAttribute: "lwc-demo2_demo2-host",
    shadowAttribute: "lwc-demo2_demo2"
  };

  class Demo2 extends lwc.LightningElement {
    constructor(...args) {
      super(...args);
      this.demo2greeting = 'From Js Demo2 ';
    }

  }

  lwc.registerDecorators(Demo2, {
    fields: ["demo2greeting"]
  });

  var demo2 = lwc.registerComponent(Demo2, {
    tmpl: _tmpl
  });

  return demo2;

});

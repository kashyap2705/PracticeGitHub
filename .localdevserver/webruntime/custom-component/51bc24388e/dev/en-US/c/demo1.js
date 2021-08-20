Webruntime.define('lwc/demo1', ['lwc'], function (lwc) { 'use strict';

  function tmpl($api, $cmp, $slotset, $ctx) {
    const {
      t: api_text,
      h: api_element
    } = $api;
    return [api_element("h1", {
      key: 0
    }, [api_text(" HIi Anil ")]), api_element("p", {
      key: 1
    }, [api_text(" welcome to demo class ")])];
  }

  var _tmpl = lwc.registerTemplate(tmpl);
  tmpl.stylesheets = [];
  tmpl.stylesheetTokens = {
    hostAttribute: "lwc-demo1_demo1-host",
    shadowAttribute: "lwc-demo1_demo1"
  };

  class Demo1 extends lwc.LightningElement {}

  var demo1 = lwc.registerComponent(Demo1, {
    tmpl: _tmpl
  });

  return demo1;

});

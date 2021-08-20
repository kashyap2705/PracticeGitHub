Webruntime.define('lwc/childCmp', ['lwc'], function (lwc) { 'use strict';

  function tmpl($api, $cmp, $slotset, $ctx) {
    const {
      t: api_text,
      h: api_element,
      d: api_dynamic,
      k: api_key,
      i: api_iterator
    } = $api;
    return [api_element("h1", {
      classMap: {
        "slds-text-heading_small": true
      },
      key: 0
    }, [api_text("List of Contacts")]), api_element("div", {
      classMap: {
        "slds-p-around_medium": true
      },
      key: 2
    }, api_iterator($cmp.lstContacts, function (contact) {
      return api_element("p", {
        key: api_key(1, contact)
      }, [api_dynamic(contact)]);
    }))];
  }

  var _tmpl = lwc.registerTemplate(tmpl);
  tmpl.stylesheets = [];
  tmpl.stylesheetTokens = {
    hostAttribute: "lwc-childCmp_childCmp-host",
    shadowAttribute: "lwc-childCmp_childCmp"
  };

  class ChildCmp extends lwc.LightningElement {
    constructor(...args) {
      super(...args);
      this.lstContacts = ["Weird Coder", "Red Devil", "Mystic Baba", "OneManArmy Baburao"];
    }

    // This method will add new Contact into Contact list.
    addContactToList(strContactName) {
      this.lstContacts.push(strContactName);
    }

  }

  lwc.registerDecorators(ChildCmp, {
    publicMethods: ["addContactToList"],
    track: {
      lstContacts: 1
    }
  });

  var childCmp = lwc.registerComponent(ChildCmp, {
    tmpl: _tmpl
  });

  return childCmp;

});

import { LightningElement, wire, api, track } from "lwc";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import fetchHistoryTrackingData from "@salesforce/apex/RelatedListController.fetchHistoryTrackingData";
import getIconName from "@salesforce/apex/RelatedListController.getIconName";
import { getRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import SecurityErrorMessage from "@salesforce/label/c.SecurityErrorMessage";
import zeroRecError from "@salesforce/label/c.zeroRecError";
//FIXME: Added by UDAY
//import { registerListener, fireEvent } from "c/pubsub";
import { CurrentPageReference } from 'lightning/navigation';
//import { refreshApex } from '@salesforce/apex';

const columns = [
  {
    label: "Name",
    fieldName: "nameUrl",
    type: "url",
    typeAttributes: {
      label: { fieldName: "Name" },
      target: "_self"
    },
    sortable: true
  },
  {
    label: "Date",
    fieldName: "CreatedDate",
    sortable: "true",
    type: "date",
    typeAttributes: {
      year: "numeric",
      month: "numeric",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit"
    }
  },
  {
    label: "Field",
    fieldName: "Field",
    sortable: "true"
  },
  {
    label: "User",
    fieldName: "User",
    sortable: "true"
  },
  {
    label: "Original Value",
    fieldName: "e_eat__Original_Value__c",
    sortable: "true"
  },
  {
    label: "New Value",
    fieldName: "e_eat__New_Value__c",
    sortable: "true"
  }
];
export default class eat_HistoryComponent extends NavigationMixin(
  LightningElement
) {
  iconName;
  tableElement;
  trackingData;
  rowLimit = 10;
  rowOffSet = 0;
  viewAll = false;
  showPlus = false;
  columns = columns;

  label = {
    SecurityErrorMessage,
    zeroRecError
  };

  @api recordId;
  @api objectApiName;
  @api viewAllClassic = false;
  @api RelatedListLabel;
  @api RelatedListIcon;
  @api noOfRecords;
  @track trackingDataSize;
  @api viewLimited = false;
  @api viewAllPage = false;
  @api viewAllLink = false;
  @api secondCall = false;
  @track ranger;
  @track left;
  @track top;
  @track error;
  @api relatedObjectpluralLabel;
  @api relatedObjectApiName;
  @api relatedObjectLabel;
  @api sObjectRecordName;
  @api fetchFields;
  @api sortBy;
  @api sortDirection;
  @api searchKey = '';
  @api securityError = false;
  @api zeroRecErrorMsg = false;
  @wire(CurrentPageReference) pageRef;
  rowLimit = 10;
  rowOffSet = 0;
  columns = columns;
  viewAll = false;
  connectedCallback() {
    this.loadData();
    //registerListener("refresh", this.handleRefresh, this);
  }

  handleRefresh() {
    // eslint-disable-next-line no-console
    console.log("Listening to Refresh for LWC");
    this.loadData();
  }
  handleSubmit(event) {
    alert("submit called--");
    event.preventDefault();
    const fields = event.detail.fields;
    this.template.querySelector("lightning-record-edit-form").submit(fields);
    this.clearEditMode();
    this.forceRefreshView();
  }

  forceRefreshView() {
    // eslint-disable-next-line no-console
    console.log('Calling Refresh from LWC');
    fireEvent(this.pageRef, 'refreshfromlwc', this.name);
}

  loadData() {
    return fetchHistoryTrackingData({
      recordId: this.recordId,
      objName: this.objectApiName,
      viewAllPage: this.viewAllPage,
      viewAllLink: this.viewAllLink,
      viewAllClassic: this.viewAllClassic,
      limitSize: this.rowLimit,
      offset: this.rowOffSet
    })
      .then((data) => {
        this.trackingData = data.auditTrackingList;
        this.trackingData = this.trackingData.map((row) => {
          return {
            ...row,
            User: row.CreatedBy.Name,
            Field: row.e_eat__Audit_Tracking_Field__r.Name
          };
        });
        this.trackingData = this.trackingData.map((record) =>
          Object.assign(
            {
              nameUrl:
                "/lightning/r/e_eat__Audit_Tracking_History__c/" +
                record.Id +
                "/view"
            },
            record
          )
        );
        this.trackingDataSize = this.trackingData.length;
        if (data.totalNumberOfRecords > 10 && !this.viewAllPage) {
          this.showPlus = true;
          this.viewAll = true;
        }
        if (data.totalNumberOfRecords <= 10 && !this.viewAllPage) {
          this.viewAllLink = false;
          this.viewAll = false;
        }
        if (data.totalNumberOfRecords > 10 && data.totalNumberOfRecords <= 20) {
          this.viewLimited = true;
          if (this.secondCall) {
            this.loadLimitedData();
          }
        }
        if (data.viewAllC) {
          this.viewAllLink = true;
        }
        if (this.trackingDataSize == 0) {
          this.zeroRecErrorMsg = true;
        }
      })
      .catch((error) => {
        this.securityError = true;
        this.viewAllLink = true;
      });
  }
  loadMoreData(event) {
    if (event.target) {
      event.target.isLoading = true;
    }
    this.tableElement = event.target;
    this.rowOffSet = this.rowOffSet + this.rowLimit;

    fetchHistoryTrackingData({
      recordId: this.recordId,
      objName: this.objectApiName,
      viewAllPage: this.viewAllPage,
      viewAllLink: this.viewAllLink,
      viewAllClassic: this.viewAllClassic,
      limitSize: this.rowLimit,
      offset: this.rowOffSet
    }).then((data) => {
      const currentData = this.trackingData;
      this.trackingData = this.trackingData.concat(data.auditTrackingList);
      this.trackingData = this.trackingData.map((row) => {
        return {
          ...row,
          User: row.CreatedBy.Name,
          Field: row.e_eat__Audit_Tracking_Field__r.Name
        };
      });
      this.trackingData = this.trackingData.map((record) =>
        Object.assign(
          {
            nameUrl:
              "/lightning/r/e_eat__Audit_Tracking_History__c/" +
              record.Id +
              "/view"
          },
          record
        )
      );
      this.trackingDataSize = this.trackingData.length;
      if (this.tableElement) {
        this.tableElement.isLoading = false;
      }
    });
  }
  loadLimitedData() {
    this.rowOffSet = this.rowOffSet + this.rowLimit;

    fetchHistoryTrackingData({
      recordId: this.recordId,
      objName: this.objectApiName,
      viewAllPage: this.viewAllPage,
      viewAllLink: this.viewAllLink,
      viewAllClassic: this.viewAllClassic,
      limitSize: this.rowLimit,
      offset: this.rowOffSet
    }).then((data) => {
      const currentData = this.trackingData;
      this.trackingData = this.trackingData.concat(data.auditTrackingList);
      this.trackingData = this.trackingData.map((row) => {
        return {
          ...row,
          User: row.CreatedBy.Name,
          Field: row.e_eat__Audit_Tracking_Field__r.Name
        };
      });
      this.trackingData = this.trackingData.map((record) =>
        Object.assign(
          {
            nameUrl:
              "/lightning/r/e_eat__Audit_Tracking_History__c/" +
              record.Id +
              "/view"
          },
          record
        )
      );
      this.trackingDataSize = this.trackingData.length;
    });
  }
  @wire(getIconName, { sObjectName: "$objectApiName" })
  gettingiconName({ error, data }) {
    if (data) {
      this.iconName = data;
    } else if (error) {
      this.error = JSON.stringify(error);
    }
  }
  @wire(getObjectInfo, { objectApiName: "$objectApiName" })
  objectInfo({ error, data }) {
    if (data) {
      this.relatedObjectpluralLabel = data.labelPlural;
      this.relatedObjectApiName = data.apiName;
      this.relatedObjectLabel = data.label;
    }
    if (error) {
      this.error = JSON.stringify(error);
    }
  }
  @wire(getRecord, {
    recordId: "$recordId",
    layoutTypes: ["Full"],
    modes: ["View"]
  })
  getRecordValue({ error, data }) {
    if (data) {
      this.fetchFields = data.fields;
      if (this.objectApiName === "Contact" || this.objectApiName === "Lead") {
        this.sObjectRecordName =
          this.fetchFields.FirstName.value +
          " " +
          this.fetchFields.LastName.value;
      } else if (this.objectApiName === "OpportunityLineItem") {
          this.sObjectRecordName =
            this.fetchFields.Opportunity.displayValue +
            " " +
            this.fetchFields.Product2.displayValue;
      } else if(this.fetchFields.Name !== undefined){
          this.sObjectRecordName = this.fetchFields.Name.value;
      } else {
          this.sObjectRecordName = 'Navigate to Parent Record';
      }
    }
    if (error) {
      this.error = JSON.stringify(error);
    }
  }
  navigateToDetailPage() {
    this[NavigationMixin.Navigate]({
      type: "standard__recordPage",
      attributes: {
        recordId: this.recordId,
        objectApiName: this.objectApiName,
        actionName: "view"
      }
    });
  }
  navigateToRecentListView() {
    console.log("RAGFHASGFK");
    if (this.viewAllClassic) {
      var url = "/" + "003" + "/o";
      window.open(url, "_self");
    } else {
      this[NavigationMixin.Navigate]({
        type: "standard__objectPage",
        attributes: {
          objectApiName: this.objectApiName,
          actionName: "list"
        },
        state: {
          filterName: "Recent"
        }
      });
    }
  }
  handleClick() {
    var defination = {
      componentDef: "c:eat_HistoryComponent",
      attributes: {
        recordId: this.recordId,
        objectApiName: this.objectApiName,
        viewAllPage: true,
        viewAllLink: true,
        secondCall: true
      }
    };
    this[NavigationMixin.Navigate]({
      type: "standard__webPage",
      attributes: {
        url: "/one/one.app#" + btoa(JSON.stringify(defination))
      }
    });
  }
  handleSortdata(event) {
    this.sortBy = event.detail.fieldName;
    this.sortDirection = event.detail.sortDirection;
    this.sortData(event.detail.fieldName, event.detail.sortDirection);
  }
  sortData(fieldname, direction) {
    let parseData = JSON.parse(JSON.stringify(this.trackingData));
    let keyValue = (a) => {
      return a[fieldname];
    };
    let isReverse = direction === "asc" ? 1 : -1;
    parseData.sort((x, y) => {
      x = keyValue(x) ? keyValue(x) : "";
      y = keyValue(y) ? keyValue(y) : "";
      return isReverse * ((x > y) - (y > x));
    });
    this.trackingData = parseData;
  }
}
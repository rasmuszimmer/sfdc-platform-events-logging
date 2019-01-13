import { LightningElement, api, track } from 'lwc';

export default class PlatformEventsLogOutput extends LightningElement {
    // Private properties
    @track logLines = [];
    _events = [];

    // Public properties
    @api
    get events() {
        return this._events;
    }
    set events(value) {
        this._events = value;
        this.mapEventPayLoads();
    }

    
    // Lifecycle hooks
    connectedCallback() {
        
    }

    renderedCallback() {

    }
    
    // Private methods
    mapEventPayLoads(){
        this.logLines = this._events.reduce(
            ( accumulator, event ) => {
                return accumulator.concat(
                    event.data.payload.Log_Lines__c.split('||')
                );
            },[]
        );
    }
}
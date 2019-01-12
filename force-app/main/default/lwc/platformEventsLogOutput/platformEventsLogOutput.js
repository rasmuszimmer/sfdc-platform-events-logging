import { LightningElement, api } from 'lwc';

export default class PlatformEventsLogOutput extends LightningElement {

    @api logEntries = [];

    @api
    log(logEntry) {
        this.logEntries.push(logEntry);
    }
}
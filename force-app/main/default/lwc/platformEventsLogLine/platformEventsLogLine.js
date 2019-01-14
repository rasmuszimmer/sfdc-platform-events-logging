import { LightningElement, api, track } from 'lwc';

export default class PlatformEventsLogLine extends LightningElement {
    
    @track transformedLogLine;
    @track isException;
    _logline = [];

    @api
    get logline() {
        return this._logline;
    }
    set logline(value) {
        this._logline = value;
        this.mapLine();
    }

    mapLine(){
        const logLineSplit = this._logline.split('|');
        const type = logLineSplit[0];
        this.isException = type === 'Exception'

        if(type === 'Trace'){
            this.transformedLogLine = {
                type,
                username: logLineSplit[1],
                systemTime: logLineSplit[2],
                className: logLineSplit[3],
                methodName: logLineSplit[4],
                currentDml: logLineSplit[5],
                currentSoql: logLineSplit[6],
                message: logLineSplit[7]
            }
        }else if(type === 'Exception'){
            this.transformedLogLine = {
                type,
                username: logLineSplit[1],
                systemTime: logLineSplit[2],
                message: logLineSplit[3],
                stackTraceString: logLineSplit[4]
            }
        }        
    }
}
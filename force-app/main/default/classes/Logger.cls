public class Logger {

    private static final String DATE_FORMAT = 'yyyy-MM-dd HH:mm:ss.SSS';

    private static List<String> logEntries;
    private static Integer totalLogSizeInChars;
    private static Integer maxLogSizeInChars = SObjectType.Debug_Event__e.Fields.Log_Lines__c.Length;

    static {
        reset();
        logTrace('*** New transaction started ***');
    }

    public static void logTrace(String message){
        System.debug(LoggingLevel.INFO, message);
        String trace = new DmlException().getStackTraceString().substringAfter('\n');
        String className = getClassName(trace);
        String methodName = getMethod(trace);
        String username = UserInfo.getUserName();
        Integer currentDML = Limits.getDmlStatements();
        Integer currentSOQL = Limits.getQueries();
        Datetime systemTime = Datetime.now();

        addLogEntry(
            String.format('Trace|{0}|{1}|{2}|{3}|{4}|{5}|{6}', 
            new String[]{
                username, 
                systemTime.format(DATE_FORMAT), 
                className, methodName, 
                String.valueOf(currentDML), 
                String.valueOf(currentSOQL), 
                message
            })
        );
    }

    public static void logException(Exception ex){
        String stackTraceString = ex.getStackTraceString();
        System.debug(LoggingLevel.ERROR, stackTraceString);
        Datetime systemTime = Datetime.now();
        String username = UserInfo.getUserName();
        String message = ex.getMessage();

        addLogEntry(
            String.format('Exception|{0}|{1}|{2}|{3}', 
            new String[]{username, systemTime.format(DATE_FORMAT), message, stackTraceString})
        );
    }

    public static void emit(){

        // Emit the log data via Platform Events
        EventBus.publish(
            new Debug_Event__e(
                Log_Lines__c = String.join(logEntries, '||').abbreviate(maxLogSizeInChars)
            ));

        reset();
    }

    // private static void transactionStart(){
    //     String username = UserInfo.getUserName();
    //     Datetime systemTime = Datetime.now();
    //     String message = '*** New transaction started ***';

    //     addLogEntry(
    //         String.format('TransactionStart|{0}|{1}|{2}', 
    //         new String[]{
    //             username, 
    //             systemTime.format(DATE_FORMAT), 
    //             message
    //         })
    //     );
    // }

    private static void addLogEntry(String logEntry){
        totalLogSizeInChars += logEntry.length();
        logEntries.add(logEntry);

        if(totalLogSizeInChars > maxLogSizeInChars){
            emit();
        }
    }

    private static String getClassName(String line){
        if (line.startsWith('Class.')){
            line = line.substringAfter('Class.');
        }
        
        return line.substringBefore(':').substringBeforeLast('.');
    }    

    private static String getMethod(String line){
        return line.substringBefore(':').substringAfterLast('.');
    }

    private static void reset(){
        logEntries = new List<String>();
        totalLogSizeInChars = 0;
    }
}

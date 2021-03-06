﻿# Configuration
$Config = @{
    # See Secure.ps1 for more details
    EncryptionKey = ''
    # This is where new accounts are stored. Reporting also relies on this database.
    MetaDirectoryConnectionString = ''
    # All logging is done to this database. Critical errors are also written to the event log.
    ADEventsConnectionString = ''
    # The server that runs the SSIS package for Active Directory import
    SqlAgentServer = ''
    # Configuration used for sending reports
    SmtpServer = ''
    SmtpFrom = ''
    SmtpSubject = ''
    SmtpBody = ''
    # Used to determine which accounts belongs to employees
    EmployeeUpnSuffix = 'example.com'
    # Sets a limit on how many tasks is processed each run. This limits the effect of bad input.
    Limits = @{
        Create = 100
        Expire = 50
        Unexpire = 50
        RemoveLicense = 50
        Delete = 50
        Update = 500
    }        
}

#Basic Poll
foreach ($RegisteredSQLs in dir -recurse SQLSERVER:\SQLRegistration\'Database Engine Server Group'\Development\ | where {$_.Mode -ne "d"} ) 
{ 
$dt=invoke-sqlcmd2 -ServerInstance $RegisteredSQLs.ServerName -database master `
-Query "SELECT @@SERVERNAME AS 'SERVERNAME'
		, NAME
  FROM master.sys.databases" -As 'DataTable'
}
$dt | Out-GridView


#With Up-Time and writing to a table.  See this post for additional scripts that you'll need:
#http://blogs.technet.com/b/heyscriptingguy/archive/2010/11/02/use-powershell-to-obtain-sql-server-database-sizes.aspx
#You can build the table yourself, I have faith in you ;-)
foreach ($RegisteredSQLs in dir -recurse SQLSERVER:\SQLRegistration\'Database Engine Server Group'\Development\ | where {$_.Mode -ne "d"} ) 
{
$dt=invoke-sqlcmd -query "SELECT	@@SERVERNAME AS 'InstanceName'
                            		, GETUTCDATE() 'WhenWasIAlive'
                            		, cpu_ticks
                            		, @@Version AS 'Version'
                              FROM [sys].[dm_os_sys_info]
                            " -database master -serverinstance $RegisteredSQLs.ServerName
Write-DataTable -ServerInstance "Win7NetBok" -Database StatInAdb -TableName ServerAliveReport -Data $dt -Username me -Password SomePassword
} #EndOfTheRegisteredServerLoop
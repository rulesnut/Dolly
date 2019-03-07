$user = 'tavi'
$pass = 'Sfjl888'
$MySQLHost = 'localhost'
$database = 'dolly'

function Connect-MySQL([string]$user,[string]$pass,[string]$MySQLHost,[string]$database) { 
  # Load MySQL .NET Connector Objects 
  [void][system.reflection.Assembly]::LoadWithPartialName("MySql.Data") 

  # Open Connection 
  $connStr = "server=" + $MySQLHost + ";port=3306;uid=" + $user + ";pwd=" + $pass + ";database="+$database+";Pooling=FALSE" 
  $conn = New-Object MySql.Data.MySqlClient.MySqlConnection($connStr)
  $conn.Open()
  return $conn
}

function Disconnect-MySQL($conn) {
  $conn.Close()
}

function Execute-MySQLNonQuery($conn, [string]$query) { 
  $command = $conn.CreateCommand()                  # Create command object
  $command.CommandText = $query                     # Load query into object
  $RowsInserted = $command.ExecuteNonQuery()        # Execute command
  $command.Dispose()                                # Dispose of command object
  if ($RowsInserted) { 
    return $RowInserted 
  } else { 
    return $false 
  } 
} 

# So, to insert records into a table 
$query = "INSERT INTO test (id, name, age) VALUES (1, 'Joe', 33)" 
$Rows = Execute-MySQLNonQuery $conn $query 
Write-Host $Rows " inserted into database"












<#
Param(
  [Parameter(
  Mandatory = $true,
  ParameterSetName = '',
  ValueFromPipeline = $true)]
  [string]$Query
  )
$MySQLAdminUserName = 'tavi'
$MySQLAdminPassword = 'Sfjl888'
$MySQLDatabase = 'dolly'
$MySQLHost = 'localhost'
$ConnectionString = "server=" + $MySQLHost + ";port=3306;uid=" + $MySQLAdminUserName + ";pwd=" + $MySQLAdminPassword + ";database="+$MySQLDatabase
Try {
  [void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
  $Connection = New-Object MySql.Data.MySqlClient.MySqlConnection
  $Connection.ConnectionString = $ConnectionString
  $Connection.Open()
  $Command = New-Object MySql.Data.MySqlClient.MySqlCommand($Query, $Connection)
  $DataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($Command)
  $DataSet = New-Object System.Data.DataSet
  $RecordCount = $dataAdapter.Fill($dataSet, "data")
  $DataSet.Tables[0]
  }
Catch {
  Write-Host "ERROR : Unable to run query : $query `n$Error[0]"
 }
Finally {
  $Connection.Close()
  }
#>

<#
$dbServer = 'postgres'
$dbuser = 'postgres'
$dbPass = 'Sfjl888'




$DBConnectionString = "Driver={PostgreSQL};Server=$dbServer;Port=5432;Uid=$dbUser;Pwd=$dbPass;"
$DBConn = New-Object System.Data.Odbc.OdbcConnection;
$DBConn.ConnectionString = $DBConnectionString;
$DBConn.Open();
$DBCmd = $DBConn.CreateCommand();
$DBCmd.CommandText = $script;
$DBCmd.ExecuteReader();
$DBConn.Close();

exit

<#
function Get-ODBCData{  
    param(
          [string]$query,
          [string]$dbServer = "10.1.1.64",   # DB Server (either IP or hostname)
          [string]$dbName   = "inventorydb", # Name of the database
          [string]$dbUser   = "postgres",    # User we'll use to connect to the database/server
          [string]$dbPass   = "postgres"     # Password for the $dbUser
         )

    $conn = New-Object System.Data.Odbc.OdbcConnection
    $conn.ConnectionString = "Driver={PostgreSQL Unicode(x64)};Server=$dbServer;Port=5432;Database=$dbName;Uid=$dbUser;Pwd=$dbPass;"
    $conn.open()
    $cmd = New-object System.Data.Odbc.OdbcCommand($query,$conn)
    $ds = New-Object system.Data.DataSet
    (New-Object system.Data.odbc.odbcDataAdapter($cmd)).fill($ds) | out-null
    $conn.close()
    $ds.Tables[0]
}
}



  [void][system.reflection.Assembly]::LoadWithPartialName("MySql.Data")
<#
function Test-SQLConnection
{    
    [OutputType([bool])]
    Param
    (
        [Parameter(Mandatory=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0)]
        $ConnectionString
    )
    try
    {
        $sqlConnection = New-Object System.Data.SqlClient.SqlConnection $ConnectionString;
        $sqlConnection.Open();
        $sqlConnection.Close();

        return $true;
    }
    catch
    {
        return $false;
    }
}


Test-SQLConnection "Data Source=localhost;database=dolly;User ID=tavi;Password=Sfjl888;"
exit
#>

<#
## MySQL Connection Details
#$user = 'tavi' ; $pass = 'Sfjl888' ; $MySQLHost = 'localhost:3306' ; $database = 'dolly'
$user = 'tavi' ; $pass = 'Sfjl888' ; $MySQLHost = 'localhost' ; $database = 'dolly'

function Connect-MySQL([string]$user,[string]$pass,[string]$MySQLHost,[string]$database) { 
  # Load MySQL .NET Connector Objects 
  [void][system.reflection.Assembly]::LoadWithPartialName("MySql.Data")

  # Open Connection
  $connStr = "server=" + $MySQLHost + ";port=3306;uid=" + $user + ";pwd=" + $pass + ";database="+$database+";Pooling=FALSE" 
  $conn = New-Object MySql.Data.MySqlClient.MySqlConnection($connStr)
  $conn.Open()
  return $conn
}

Connect-MySQL tavi, Sfjl888, localhost, dolly
exit

function Execute-MySQLNonQuery($conn, [string]$query) { 
  $command = $conn.CreateCommand()                  # Create command object
  $command.CommandText = $query                     # Load query into object
  $RowsInserted = $command.ExecuteNonQuery()        # Execute command
  $command.Dispose()                                # Dispose of command object
  if ($RowsInserted) { 
    return $RowInserted 
  } else { 
    return $false 
  } 
} 

function Disconnect-MySQL($conn) { $conn.Close() }

fff $conn
exit

$infileName ="62.OLG.Oct29.txt"
#. D:\Documents\WindowsPowershell\sql.ps1 -Query "INSERT INTO  "$infileName" INTO TA:bBLE spin"
#$query = "INSERT INTO test (id, name, age) VALUES (1, 'Joe', 33)" 

#>L




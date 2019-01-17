Clear-Host
## How to get the last 5

     ## Variables
##▼▼
Set-Variable 'AllowExit'	-value 0
Set-Variable 'BetLo'
Set-Variable 'BetMed'
Set-Variable 'BetHi'
Set-Variable 'BetLold'
Set-Variable 'BetMold'
Set-Variable 'BetHold'
Set-Variable 'BetMethod'
Set-Variable 'BetZone'
Set-Variable 'Cash'
Set-Variable 'CashOld'
Set-Variable 'CashLo'		-value 0
Set-Variable 'CashHi'		-value 0
#Set-Variable 'PercentLo'
#Set-Variable 'PercentMed'
#Set-Variable 'PercentHi'
#Set-Variable 'CountLo'
#Set-Variable 'CountMed'
#Set-Variable 'CountHi'
#Set-Variable 'ColorLo'
#Set-Variable 'ColorMed'
#Set-Variable 'ColorHi'
Set-Variable 'OpeningBet'
Set-Variable 'SaveToFile'	-value 0
Set-Variable 'Site'			-value 0
Set-Variable 'Units'
Set-Variable 'ValidSpin'

$Gob = [system.collections.arrayList] @()
$Timer =  [system.diagnostics.stopwatch]::startnew()
$WinRA = [system.collections.arrayList] @()
$LastRA = @()

##▲
     ## Functions
## Initialize
##▼▼
Function F-Initialize {
	If ( $BetZone -eq 12 ) {
		$script:BetLo  = $OpeningBet
		$script:BetMed = $OpeningBet
		$script:BetHi  = 0
	}	Elseif ($Betzone -eq 13 ) {
		$script:BetLo  = $OpeningBet
		$script:BetMed = 0
		$script:BetHi  = $OpeningBet
	} Else {
		$script:BetLo  = 0
		$script:BetMed = $OpeningBet
		$script:BetHi  = $OpeningBet
	}
}	##▲	END FUNCTION
## Spin Validate
##▼▼
Function F-SpinValidate {
	If ( $AllowExit ) { If ( $spin -eq 't' -OR $spin -eq 'tt' -OR $spin -eq 'rr' ) { exit } }
	If ( $spin -match '^[0-9]$' -OR $spin -match '^[1-2][0-9]$' -OR $spin -match '^[3][0-6]$' )  {
	} Else { Write-Host -f Red " [ NOT VALID NUMBER ]"  ; Start-Sleep 1 ; Clear-Host ; Continue ; }
}	##▲	END FUNCTION
## Update
##▼▼
Function F-Update {
	$script:BetLold = $BetLo
	$script:BetMold = $BetMed
	$script:BetHold = $BetHi
	## WinOrLose
	##▼▼
	Switch ( $Gob[-1] ) {
		{ $_ -in 0 } {
			If ( $BetZone -eq 12 ) { [void] $WinRA.Add('L12') ; BREAK }
			If ( $BetZone -eq 13 ) { [void] $WinRA.Add('L13') ; BREAK }
			If ( $BetZone -eq 23 ) { [void] $WinRA.Add('L23') ; BREAK }
		}
		{ $_ -in 1..12 } {
			If ( $BetZone -eq 12 ) { [void] $WinRA.Add('W12') ; BREAK }
			If ( $BetZone -eq 13 ) { [void] $WinRA.Add('W13') ; BREAK }
			If ( $BetZone -eq 23 ) { [void] $WinRA.Add('L23') ; BREAK }
		}
		{ $_ -in 13..24 } {
			 If ( $BetZone -eq 12 ) { [void] $WinRA.Add('W12') ; BREAK }
			 If ( $BetZone -eq 13 ) { [void] $WinRA.Add('L13') ; BREAK }
			 If ( $BetZone -eq 23 ) { [void] $WinRA.Add('W23') ; BREAK }
		}
		{ $_ -in 25..36 } {
			 If ( $BetZone -eq 12 ) { [void] $WinRA.Add('L12') ; BREAK }
			 If ( $BetZone -eq 13 ) { [void] $WinRA.Add('W13') ; BREAK }
			 If ( $BetZone -eq 23 ) { [void] $WinRA.Add('W23') ; BREAK }
		}
	}	##	END Switch
	##▲	END WinOrLose
	## Cash
	##▼▼
		$script:CashOld = $script:Cash
	If ( $WinRA[-1].Substring(0,1)-eq 'L' ){
		$script:Cash = $script:Cash - ($BetLo + $BetMed + $BetHi)
	} Else {
		$script:Cash = $script:Cash + ( ($BetLo + $BetMed + $BetHi )  / 2  )
	}
	If ( $Cash -le $CashLo ) {
		$script:CashLo = $Cash
	} ElseIf ( $Cash -gt $CashHi ) {
		$script:CashHi = $Cash
	}	
	##	▲	END Cash
	## Bets
	##▼▼
	If ( $BetMethod -eq 'Up2' ) {
		Switch ( $WinRA[-1] ) {
			## Lose
			{ $_ -eq 'L12' } { $script:BetLo  = $BetLo +  ( 2 * $Units ) ; $script:BetMed = $BetMed + ( 2 * $Units ) }
			{ $_ -eq 'L13' } { $script:BetLo  = $BetLo +  ( 2 * $Units ) ; $script:BetHi  = $BetHi  + ( 2 * $Units ) }
			{ $_ -eq 'L23' } { $script:BetMed = $BetMed + ( 2 * $Units ) ; $script:BetHi  = $BetHi  + ( 2 * $Units ) }
			## Win
			{ $_ -eq 'W12' } {
				$script:BetLo  --
				$script:BetMed --
				If ($BetLo  -le $OpeningBet ) { $script:BetLo  = $OpeningBet }
				If ($BetMed -le $OpeningBet ) { $script:BetMed = $OpeningBet }
			}
			{ $_ -eq 'W13' } {
				$script:BetLo --
				$script:BetHi --
				If ($BetLo -le $OpeningBet ) { $script:BetLo = $OpeningBet }
				If ($BetHi -le $OpeningBet ) { $script:BetHi = $OpeningBet }
			}
			{ $_ -eq 'W23' } {
				$script:BetMed --
				$script:BetHi --
				If ($BetMed -le $OpeningBet ) { $script:BetMed = $OpeningBet }
				If ($BetHi -le $OpeningBet ) { $script:BetHi = $OpeningBet }
			}
			Default { Write-Host 'Houston... Bet Switch' ; exit }
		} ## 	END Switch
	}
	##	▲	END Bets
}	##▲	END F-Update
## Last
	##▼ ▼
Function F-Last( $el ) {
	$loCount = 0
	$medCount = 0
	$hiCount = 0
	$elName = ''
	$start = $Gob.Count - $el
	$end = $Gob.Count - 1
	Foreach ( $el in $Gob[$start..$end]) {
		Switch ( $el ) {
			{ $_ -in 0 } { BREAK }  ##	spin 0
			{ $_ -in 1..12 }  { $loCount ++  ; BREAK }	##	Lo
			{ $_ -in 13..24 } { $medCount ++ ; BREAK }	##	Med
			{ $_ -in 25..36 } { $hiCount ++  ; BREAK }	##	Hi
		}
		[int] $loPercent  = $loCount/$Gob[$start..$end].count*100
		[int] $medPercent  = $medCount/$Gob[$start..$end].count*100
		[int] $hiPercent  = $hiCount/$Gob[$start..$end].count*100
	} 	## END Foreach
	## Get Lowest Percent, Highest Percent and Color
	$colorRA =  $loPercent, $medPercent, $hiPercent
	$minValue = [int]($colorRA | measure -Minimum).Minimum
	$maxValue = [int]($colorRA | measure -Maximum).Maximum
	$minIndex = $colorRA.IndexOf($minValue)
	$maxIndex = $colorRA.IndexOf($maxValue)
	$loColor = "cyan"
	$medColor = "cyan"
	$HiColor = "cyan"
	If ( $minIndex -eq 0 ) { $loColor  = 'Red' }
	If ( $minIndex -eq 1 ) { $medColor = 'Red' }
	If ( $minIndex -eq 2 ) { $hiColor  = 'Red' }
	If ( $maxIndex -eq 0 ) { $loColor  = 'Green' }
	If ( $maxIndex -eq 1 ) { $medColor = 'Green' }
	If ( $maxIndex -eq 2 ) { $hicolor  = 'Green' }
	$val = "" | Select-Object -Property loCount, medCount,HiCount,loPercent, medPercent, hiPercent, loColor, medColor, hiColor,el
	$val.loCount = $loCount
	$val.medCount = $medCount
	$val.hiCount = $hiCount
	$val.loPercent = $loPercent
	$val.medPercent = $medPercent
	$val.hiPercent = $hiPercent
	$val.loColor = $loColor
	$val.medColor = $medColor
	$val.hiColor = $hiColor
	$val.el = $el
	return $val
}	##	▲	END Function

     ## Display
##▼ ▼
Function F-Display {
	##	Bet Number
##▼▼
	Write-Host -n -f DarkGray "`n  Bet: "
	Write-Host -n -f DarkGray $Gob.count
	$gap =  $Gob.count.ToString().Length
	Write-Host -n $( " " * ( 9 - $gap ) )
##▲
	##	Time
##▼▼
	Write-Host -n -f DarkGray "Time: "
	Write-Host -Object ('{0}:{1}' -f ( '{0:0}' -f $Timer.Elapsed.Hours ) , ( '{0:00}' -f $Timer.Elapsed.Minutes ) ) -nonewline -f DarkGray
##▲
	##	Cash
##▼▼
	Write-Host -n -f DarkGray "      Cash: "
	If ( $Cash -ge 0 ) { Write-Host -f Green ( '{0:C0}' -f $Cash ) } Else { Write-Host -f Red ( '{0:C0}' -f $Cash ) }
##▲
	## Low / High
##▼▼
	Write-host -n -f DarkGray '  Low: '
	Write-host -n -f DarkGray ( '{0:C0}' -f $CashLo )
	$gap = ( '{0:C0}' -f $CashLo ).length
	Write-Host -n  $( " " * ( 7 - $gap ) )
	Write-host -n -f DarkGray '  High: '
	Write-host  -f DarkGray ( '{0:C0}' -f $CashHi )
##▲
	## Previous Bets
##▼▼
	Write-Host -f darkcyan "  Lo     Med     Hi     Dolly"
	Switch ( $Betzone ) {
		12	{
			Write-Host -n -f DarkGray ' ' $BetLold
			$gap =  $BetLold.ToString().Length
			Write-host -n ( " " * ( 7 - $gap ) )
			Write-Host -n  -f DarkGray $BetMold
			$gap =  $BetMold.ToString().Length
			Write-host -n ( " " * ( 17 - $gap ) )
			}
		13	{ 
			Write-Host -n  -f DarkGray ' ' $BetLold
			$gap =  $BetLold.ToString().Length
			Write-host -n ( " " * ( 15 - $gap ) )
			Write-Host -n  -f DarkGray $BetHold
			$gap =  $BetHold.ToString().Length
			Write-host -n ( " " * ( 9 - $gap ) )
			}
		23	{  
			Write-Host -n  -f DarkGray '        ' $BetMold
			$gap =  $BetMold.ToString().Length
			Write-host -n ( " " * ( 8 - $gap ) )
			Write-Host -n  -f DarkGray $BetHold
			$gap =  $BetHold.ToString().Length
			Write-host -n  -f DarkGray ( " " * ( 9 - $gap ) )
			}
		Default { Write-Host 'Houston... Previous Bets Switch' ; exit }
	}
##▲
	## Dolly
##▼▼
	Write-host -n  -f magenta $Gob[-1]
	$gap = [Math]::Floor([Math]::Log10( $Gob[-1]  + 1 ) )
	If ( $Gob[-1] -eq 0 ) { $gap = 1 } Else { $gap = [Math]::Floor([Math]::Log10( $Gob[-1] ) + 1) }
	Write-Host -n $( " " * ( 6 - $gap ) )
##▲
	## You Won/Lost
##▼▼
	$oldBetTotal = ( $BetLold + $BetMold + $BetHold )
	If ( $WinRA[-1].Substring(0,1)-eq 'L' ) { ## Lost
		$_cashLost = '{0:C0}' -f -$oldBetTotal
		fff -n -f red 'Lost: '
		$_cashLost = '{0:C0}' -f -$oldBetTotal
		fff -n -f red $_cashLost
	} Else {                                  ## Won
		fff -n -f green ' Won: '
		$_cashWon = '{0:C0}' -f ( $oldBetTotal / 2 )
		fff -n -f green  $_cashWon
	}
##▲
	## Line
	Write-Host -f DarkGray  "`n " $("_" * 40)`n
	## Percentages
	[array]::sort( $LastRA )
	Write-Host -f darkcyan "  Lo        Med        Hi"
	Foreach ( $item in $LastRA ) {
		If ( $Gob.count -ge $item) {
			$RA = F-Last $item
			##	Lo
			fff -n '  '
			fff -n -f DarkGray "$($RA.loCount) "
			fff -n -f $RA.loColor   $RA.loPercent
			fff -n -f $RA.loColor "%"
			$gap = ( $RA.loCount.ToString().Length + $RA.loPercent.ToString().Length )
			Write-Host -n $( " " * ( 8 - $gap ) )
			##	Med
			fff -n -f DarkGray "$($RA.medCount) "
			fff -n -f $RA.medColor   $RA.medPercent
			fff -n -f $RA.medColor "%"
			$gap = ( $RA.medCount.ToString().Length + $RA.medPercent.ToString().Length )
			Write-Host -n $( " " * ( 8 - $gap ) )
			##	Hi
			fff -n -f DarkGray "$($RA.hiCount) "
			fff -n -f $RA.hiColor   $RA.hiPercent
			fff -n -f $RA.hiColor "%"
			$gap = ( $RA.hiCount.ToString().Length + $RA.hiPercent.ToString().Length )
			Write-Host -n $( " " * ( 8 - $gap ) )
			fff -f y "Last $item"
		}
	}

}##▲	END Display

## Settings
$AllowExit	= 1
$SaveToFile	= 0
$Site			= 'OLG'
$BetZone		= 12
$OpeningBet	= 5
$Units		= 1
$BetMethod	= 'Up2'
$LastRA		= 4,5,6,12,18,24,36,60

## Start Main
F-Initialize
While (1) {
	If ( $Gob.count -eq 0 ) { Write-Host  "`n BetZone: $BetZone  Units: $Units Inital Bet: $OpeningBet"; Write-Host -n "    " } Else { F-Display }
	$spin  = Read-Host -Prompt "`n`n`n`n$(" " * (10)) Enter Spin"
	F-SpinValidate
	Clear-Host
	[Void] $Gob.Add( $spin )
	F-UpDate
	If ( $SaveToFile ) {
	## Add Content 	▼ ▼
		$DataPath = 'D:\GitHub\Dolly' ; $TheDate =  Get-Date -UFormat %b%e ; $Ext = 'txt'
		$DataFile  =  ($DataPath + "\" + $Site + "." + $TheDate + "." + $Ext)
		If ($Site ) { $spin | Add-Content $DataFile }
	}
##▲
}



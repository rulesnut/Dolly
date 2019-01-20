Clear-Host
#TODO
		## progressive bets?   half progressive?  Martingale ??
#TODO

	  ## Variables
#region##▼▼
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
Set-Variable 'Mode'			-value 'Play'
Set-Variable 'OpeningBet'
Set-Variable 'Pace'
Set-Variable 'SaveToFile'	-value 0
Set-Variable 'Site'			-value 0
Set-Variable 'Units'
Set-Variable 'ValidSpin'

$Gob = [system.collections.arrayList] @()
$Timer =  [system.diagnostics.stopwatch]::startnew()
$WinRA = [system.collections.arrayList] @()
$LastRA = @()

#endregion##▲

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
	##▼▼
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
## Abstract
##▼▼
Function F-Abstract {
	<#
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
#>
}	##▲	END F-Abstract
     ## Display
##▼▼
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
	Write-Host -n -f DarkGray "     Cash: "
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
			Write-Host -n -f yellow ' ' $BetLold
			$gap =  $BetLold.ToString().Length
			Write-host -n ( " " * ( 7 - $gap ) )
			Write-Host -n  -f yellow $BetMold
			$gap =  $BetMold.ToString().Length
			Write-host -n ( " " * ( 17 - $gap ) )
			}
		13	{ 
			Write-Host -n  -f yellow ' ' $BetLold
			$gap =  $BetLold.ToString().Length
			Write-host -n ( " " * ( 15 - $gap ) )
			Write-Host -n  -f yellow $BetHold
			$gap =  $BetHold.ToString().Length
			Write-host -n ( " " * ( 9 - $gap ) )
			}
		23	{  
			Write-Host -n  -f yellow '        ' $BetMold
			$gap =  $BetMold.ToString().Length
			Write-host -n ( " " * ( 8 - $gap ) )
			Write-Host -n  -f yellow $BetHold
			$gap =  $BetHold.ToString().Length
			Write-host -n  -f yellow ( " " * ( 9 - $gap ) )
			}
		Default { Write-Host 'Houston... Previous Bets Switch' ; exit }
	}
##▲
	## Dolly
##▼▼
	Write-host -n  -f magenta $Gob[-1]
	$gap = [Math]::Floor([Math]::Log10( $Gob[-1]  + 1 ) )
	If ( $Gob[-1] -eq 0 ) { $gap = 1 } Else { $gap = [Math]::Floor([Math]::Log10( $Gob[-1] ) + 1) }
	Write-Host -n $( " " * ( 5 - $gap ) )
##▲
	## You Won/Lost
##▼▼
	$oldBetTotal = ( $BetLold + $BetMold + $BetHold )
	If ( $WinRA[-1].Substring(0,1)-eq 'L' ) { ## Lost
		$_cashLost = '{0:C0}' -f -$oldBetTotal
		Write-Host -n -f red 'Lost: '
		$_cashLost = '{0:C0}' -f -$oldBetTotal
		Write-Host -n -f red $_cashLost
	} Else {                                  ## Won
		Write-Host -n -f green 'Won: '
		$_cashWon = '{0:C0}' -f ( $oldBetTotal / 2 )
		Write-Host -n -f green  $_cashWon
	}
##▲
	## Line
	Write-Host -f DarkBlue  `n$("_" * 36)`n
	## Percentages
	[array]::sort( $LastRA )
	Write-Host -f darkcyan "  Lo        Med       Hi"
	Foreach ( $item in $LastRA ) {
		If ( $Gob.count -ge $item) {
			$RA = F-Last $item
			##	Lo
			Write-Host -n '  '
			Write-Host -n -f DarkGray "$($RA.loCount) "
			Write-Host -n -f $RA.loColor   $RA.loPercent
			Write-Host -n -f $RA.loColor "%"
			$gap = ( $RA.loCount.ToString().Length + $RA.loPercent.ToString().Length )
			Write-Host -n $( " " * ( 8 - $gap ) )
			##	Med
			Write-Host -n -f DarkGray "$($RA.medCount) "
			Write-Host -n -f $RA.medColor   $RA.medPercent
			Write-Host -n -f $RA.medColor "%"
			$gap = ( $RA.medCount.ToString().Length + $RA.medPercent.ToString().Length )
			Write-Host -n $( " " * ( 6 - $gap ) )
			##	Hi
			Write-Host -n -f DarkGray "$($RA.hiCount) "
			Write-Host -n -f $RA.hiColor   $RA.hiPercent
			Write-Host -n -f $RA.hiColor "%"
			$gap = ( $RA.hiCount.ToString().Length + $RA.hiPercent.ToString().Length )
			Write-Host -n $( " " * ( 6 - $gap ) )
			Write-Host -f DarkGray "Last $item"
		}
	}
	Write-Host -f DarkBlue  $("_" * 36)`n
	Write-Host -n  -f DarkGray `n'  BET:'
	Write-Host -f DarkGray "      Lo      Med      Hi"
	Write-Host -n  -f White  "  $"
	Write-Host -n	$($BetLo + $BetMed + $BetHi)
	$gap = $( $BetLo + $BetMed + $BetHi ).ToString().Length
	Write-Host -n $( " " * ( 9 - $gap ) )
	If ( $Betzone -eq 12) {
		fff -n -f yellow $BetLo
		$gap = $BetLo.ToString().Length
		Write-Host -n $( " " * ( 10 - $gap ) )
		fff -n -f yellow $BetMed
	}
	If ( $Betzone -eq 13) {
		fff -n -f yellow $BetLo
		$gap = $BetLo.ToString().Length
		Write-Host -n $( " " * ( 17 - $gap ) )
		fff -n -f yellow $BetHi
	}
	If ( $Betzone -eq 23) {
		fff -n -f yellow "       " $BetMed
		$gap = $BetMed.ToString().Length
		Write-Host -n $( " " * ( 9 - $gap ) )
		fff -n -f yellow $BetHi
	}
#	$gap = $BetMed.ToString().Length
#	Write-Host -n $( " " * ( 11 - $gap ) )
#	fff -n $BetHi


}##▲	END Display

#$Mode = 'Audit'
$AllowExit	= 1
$BetZone = 23
$OpeningBet	= 5
$Units		= 1
$BetMethod	= 'Up2'
$Site			= '888'

## Start Main
If ( $Mode -eq 'Play') {
	## Play Settings
##▼▼
	$SaveToFile	= 0
	$LastRA		= 6,12,18,24
##▲
	##	Play
	F-Initialize
	While (1) {
		If ( $Gob.count -eq 0 ) { Write-Host  "`n BetZone: $BetZone  Units: $Units Inital Bet: $OpeningBet"; Write-Host -n "    " } Else { F-Display }
		$spin  = Read-Host -Prompt "`n`n`n$(" " * (10)) Enter Spin"
		F-SpinValidate
		Clear-Host
		[Void] $Gob.Add( $spin )
		F-UpDate
		If ( $SaveToFile ) {
		## Add Content 	▼▼
			$DataPath = 'D:\GitHub\Dolly' 
			$TheDate =  Get-Date -UFormat %b%e ; $Ext = 'txt'
			$DataFile  =  ($DataPath + "\" + $Site + "." + $TheDate + "." + $Ext)
			If ($Site ) { $spin | Add-Content $DataFile }
		}
##▲
	}
} Else {
	## Audit Settings
##▼ ▼
	$LastRA		= 6,12,18,24,36,42,48
	$FileDate = 'Oct29'
#	$Pace = 'Manual'
#	$Pace = 1
	$Pace = 'Turbo'
	$ContentFile = Get-ChildItem -af 62*
##▲
	##	Audit
	[System.Collections.ArrayList] $Data = Get-Content $ContentFile
	F-Initialize
	##	Foreach Spin
	##	▼ ▼
	Foreach ( $Spin in $Data ) {
		[Void] $Gob.Add( $Spin )
		F-Update
		If ( $Pace -ne 'Turbo' ) {
			F-Display
		}
		If ( $Pace -eq  'Turtle' ) { Read-Host "`n`n`n`n$(" " * (10)) Next" }
		If ( $Pace -eq  'Turbo' ) {  }
		If ( $Pace -eq  1 ) { Sleep 1  }
		Clear-Host
	}
#	for ($i = 0 ; $i -lt $Rob.Length;  $i ++ ) {
#		fff $Rob[$i]
#	}
#	return $val
	
		#	If ($UseSwitching ) { $OB.AutoSwitch( $Pace ) }

		## ▲
	#if ( Test-Path $OutputFile ) { 		Remove-Item $OutputFile	}
	#$CsvName = ( $Dir + $SiteName + '.' + $FileDate + '.csv')
	#If ( $DataFirstLine -gt $DataLastLine ) { Write-Host -f r "`n`n        `$DataFirstLine is greater than `$DataLastLine, Ya Dufus  `n`n " ; exit; }
	#If ( $DataLastLine -ge $RawData.Count ) { $DataLastLine = $RawData.Count }
	#[Array] $Data = $RawData[ ($DataFirstLine-1)..($DataLastLine -1 )]
	#If ( $DataLastLine -eq $RawData.Count ) { $DataLastLine = 'EOF' }
	#If ( $UseSwitching  -eq 0 ) { $Switch = "No" } Else { $Switch = "Yes" }
	#	F-UpDate
	#	F-Display
	#	F-Abstract

	##	Summary
	$Rob = "" | Select-Object -Property site,date, startLine, endLine,units,spins, switching, tracking, '%Limit',lowest, highest, cash

	$Rob.site			= $site
	$Rob.date			= 999999
	$Rob.startLine		= 9999999
	$Rob.endLine		= 9999999
	$Rob.units			= 9999999
	$Rob.spins			= 9999999
	$Rob.switching		= 9999999
	$Rob.tracking		= 9999999
	$Rob.'%Limit'		= 9999999
	$Rob.lowest			= 9999999
	$Rob.highest		= 9999999
	$Rob.cash			= 9999999
	$Rob | Format-Table *
$Sec = '{0:00}' -f ($Timer.Elapsed.Seconds)
$Min = '{0:00}' -f ($Timer.Elapsed.Minutes)
Write-Host  "`n`n     Runtime:" ( '{0}:{1}' -f $Min,$Sec ) "`n" -nonewline -f DarkGray
}	##	END ELSE	END	END	END	END



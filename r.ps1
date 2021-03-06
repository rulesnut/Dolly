﻿Clear-Host
#>
## Play or Audit	√
$Mode = 'AUDIT'
#$Mode = 'P'
If ( $Mode -eq 'P' ) {
##▼▼  PLAY
##	Play Variables
##▼▼
If ($Mode -eq 'P') {
	Set-Variable 'Cash'				-value 0
	Set-Variable 'CashHi'			-value 0
	Set-Variable 'CashLo'			-value 0
	Set-Variable 'WinOrLose'
	Set-Variable 'Bet'				-value 100
	Set-Variable 'BetOld'
	Set-Variable 'Row1sum'	-value 0
	Set-Variable 'Row4sum'	-value 0
	Set-Variable 'Row7sum'	-value 0
	Set-Variable 'Row10sum'	-value 0
	Set-Variable 'Row13sum'	-value 0
	Set-Variable 'Row16sum'	-value 0
	Set-Variable 'Row19sum'	-value 0
	Set-Variable 'Row22sum'	-value 0
	Set-Variable 'Row25sum'	-value 0
	Set-Variable 'Row28sum'	-value 0
	Set-Variable 'Row31sum'	-value 0
	Set-Variable 'Row34sum'	-value 0
	$Gob = [system.collections.arrayList] @()
	$Timer =  [system.diagnostics.stopwatch]::startnew()
	$BetMethodRA = [Ordered] @{ 0 = '9 Numbers' ; 1 = 'Up2' ; 2 = 'Method11' ; 3 = 'Paroli3' ; 4 = 'Paroli5' ; 5 = 'UpDown' ; 6 = 'DoubleThenHalfPlus' ; }
	$RedBlackHash = [Ordered] @{
			##▼▼
		0  = 'green'
		1	= 'red'
		2	= 'black'
		3	= 'red'
		4	= 'black'
		5	= 'red'
		6	= 'black'
		7	= 'red'
		8	= 'black'
		9	= 'red'
		10	= 'black'
		11	= 'black'
		12 = 'red'
		13	= 'black'
		14	= 'red'
		15	= 'black'
		16	= 'red'
		17	= 'black'
		18	= 'red'
		19	= 'red'
		20 = 'black'
		21 = 'red'
		22 = 'black'
		23 = 'red'
		24 = 'black'
		25 = 'red'
		26 = 'black'
		27 = 'red'
		28 = 'black'
		29 = 'black'
		30 = 'red'
		31 = 'black'
		32 = 'red'
		33 = 'black'
		34 = 'red'
		35 = 'black'
		36 = 'red'
	}	
##▲
}
##▲
##	Play Functions
##▼▼
If ($Mode -eq 'P' ) {
## Play Calculations Functions
##▼▼
##	SpinValidate		Play Calculation
##▼▼
Function F-SpinValidate ($spin) {
	IF ( $spin -match '^[0-9]$' -OR $spin -match '^[1-2][0-9]$' -OR $spin -match '^[3][0-6]$' ) {}
	ELSEIF ( $spin -eq 't' -AND $AllowExit -eq 'Yes' ) { EXIT }
	ELSEIF ( $spin -eq 'save' ) {
		$DataPath = 'D:\GitHub\Dolly'; $TheDate =  Get-Date -UFormat %b%e ; $Ext = 'txt' ; $DataFile  =  ($DataPath + "\" + $Site + "." + $TheDate + "." + $Ext)
		$script:Gob | Add-Content $DataFile ; EXIT }
	ELSE { Write-Host -f Red " [ INVALID ENTRY ]"  ; Start-Sleep 1 ; Clear-Host ; CONTINUE }
}		
##▲

## WinOrLose			Play Calculation
##▼▼
Function F-WinOrLose {
	Switch ( $BetMethod ) {
		'9 Numbers' {
			IF ( $Gob[-1] -notin $The9NumbersRA ) {
				$script:WinOrLose = 'L'   ## Lost
			} ElseIf ( $Gob[-1] -eq $The9NumbersRA[0] ) {
				$script:WinOrLose = 'S'  ## SmallWin
			} ElseIf ( $Gob[-1] -eq $The9NumbersRA[1] ) {
				$script:WinOrLose = 'S'  ## SmallWin
			} ElseIF ( $Gob[-1] -eq $The9NumbersRA[2] ) {
				$script:WinOrLose = 'S'  ## SmallWin
			} ElseIF ( $Gob[-1] -eq $The9NumbersRA[3] ) {
				$script:WinOrLose = 'B'  ## BigWin
			} ElseIF ( $Gob[-1] -eq $The9NumbersRA[4] ) {
				$script:WinOrLose = 'B'  ## BigWin
			} ElseIF ( $Gob[-1] -eq $The9NumbersRA[5] ) {
				$script:WinOrLose = 'B'  ## BigWin
			} ElseIF ( $Gob[-1] -eq $The9NumbersRA[6] ) {
				$script:WinOrLose = 'S'  ## SmallWin
			} ElseIF ( $Gob[-1] -eq $The9NumbersRA[7] ) {
				$script:WinOrLose = 'S'  ## SmallWin
			} ElseIF ( $Gob[-1] -eq $The9NumbersRA[8] ) {
				$script:WinOrLose = 'S'  ## SmallWin
			}
		}
	}
}


##▲

## UpDateBets			Play Calculation
##▼▼
Function F-UpDateBets {
	If ( $Mode -eq 'P' ){
		Switch ( $BetMethod ) {
			'9 Numbers' {
				$script:BetOld = $Bet
				Switch ( $WinOrLose ) {
					'L' { $script:Bet = ( $Bet + $Units ) ; BREAK } ## LOST
					'B' { $script:Bet = ( $Bet - ( 5 * $Units )) ; BREAK } ##  Big Win
					'S' { $script:Bet =  ($Bet - ( 2 * $Units )) ; BREAK } ## Small Win
					Default { Write-Host "Houston.... " $UpDateBets ; exit }
				}##  end switch
				If ( $script:Bet -le $OpeningBet ) { $script:Bet = $OpeningBet } ## Can't go lower than OpeningBet
			}## END 9 Numbers
			'OTHER BET METHODS'{}
		}## end switch
		If ( $script:Bet -le $OpeningBet ) { $script:Bet = $OpeningBet } ## Can't go lower than OpeningBet
	}
}
##▲

## UpDateCash			Play Calculation
##▼▼
Function F-UpDateCash {
	Switch ( $BetMethod ) {
		'9 Numbers' {
			Switch ( $WinOrLose ) {
				'L' { $script:Cash = ( $Cash + ( -$BetOld * 2 ) ) ; BREAK } ##  Lost
				'B' { $script:Cash = ( $Cash + ( 10 * $BetOld )) ; BREAK } ##  Big Win
			   'S' { $script:Cash =  ($Cash + ( 4 * $BetOld )) ; BREAK } ## Small Win
			}
		}
   }
	If ( $script:Cash -gt $script:CashHi ) {
		$script:CashHi = $script:Cash	
	}
	If ( $script:Cash -lt $script:CashLo ) {
		$script:CashLo = $script:Cash	
	}
}
##▲

##▲
## Play Display Functions
##▼▼
##	Cash					Display
##▼▼
Function F-Cash {
	If ( $Gob.Count -gt 0 ) {
		If ( $Cash -ge 0 ) { $color = 'Green'  } Else { $color = 'Red' }
		$_CashHi = '{0:C0}' -f $CashHi
		$_CashLo = '{0:C0}' -f $CashLo
		$_Cash = '{0:C0}' -f $Cash
		Write-Host -n -f DarkGray `n' Hi: '
		Write-host -n -f DarkGray $_CashHi
		Write-Host -n  $( " " * ( 8 - $_CashHi.ToString().Length ) )
		Write-Host -n -f DarkGray 'Low: '
		Write-host -n -f DarkGray $_CashLo
		Write-Host -n $( " " * ( 17 - ( $_CashLo.ToString().Length + ( $( '{0:C0}' -f $_Cash ) ).ToString().Length ) ) )  #gap √
		Write-Host -n -f $color  'Cash: '
		Write-host -n -f $color $_Cash
	}
}	
##▲

##	Hand Number			Display
##▼▼
Function F-Hand {
	Write-Host -n -f DarkGray "`n Hand: "
	Write-Host -n -f DarkGray $($Gob.count + 1)
	Write-Host -n $( " " * ( 4 - ( $Gob.count + 1 ).ToString().Length ) )
}
##▲

##	Time					Display
##▼▼
Function F-Time {
	Write-Host -n -f DarkGray "  Time: "
	Write-Host -Object ('{0}:{1}' -f ( '{0:0}' -f $Timer.Elapsed.Hours ) , ( '{0:00}' -f $Timer.Elapsed.Minutes ) ) -n -f DarkGray
}
##▲

##	Dolly					Display
##▼▼
Function F-Dolly {
	If ( $Gob.Count -eq 1 ) {
		Write-Host -n $( " " * ( 10 - $Gob[-1].ToString().Length ) )
		Write-Host -n -f DarkGray ' Dolly: '
		Write-Host -n  -f yellow $Gob[-1]
	}
	If ( $Gob.Count -gt 1 ) {
		Write-Host -n $( " " * ( 8 - ( $Gob[-1].ToString().Length + $Gob[-2].ToString().Length ) ) )
		Write-Host -n -f DarkGray '['
		Write-Host -n -f DarkGray $Gob[-2]
		Write-Host -n -f DarkGray ']'
		Write-Host -n -f DarkGray ' Dolly: '
		Write-Host -n  -f yellow $Gob[-1]
	}
}	
##▲

##	Tale					Display
##▼▼
Function F-Tale {
	If ( $Gob.Count -gt 0 ){
		Write-Host -n `n$( " " * 5 )
		Write-Host -n -f DarkGray $BetOld
		Write-Host -n ( " " *  6 )
		Write-Host -n -f DarkGray $BetOld
		If ( $WinOrLose -eq 'l' ) {
			Write-Host -n $( " " * ( 20 - ( $BetOld.ToString().Length + $BetOld.ToString().Length + ( $( '{0:C0}' -f ( $BetOld * -2 ) ) ).ToString().Length ) ) ) #gap √
			Write-Host -n -f darkred 'Bet Lost: ';
			Write-Host -f darkred $( '{0:C0}' -f ( $BetOld * -2 ) )   ## Lost	√
		} Else {
			If ( $WinOrLose -eq 's' ) {
				Write-Host -n $( " " * ( 19 - ( $BetOld.ToString().Length + $BetOld.ToString().Length + ( $( '{0:C0}' -f ( $BetOld * 5 ) ) ).ToString().Length ) ) ) #gap √
				Write-Host -n -f darkgreen 'Small Win: '
				Write-Host -f darkGreen   $( '{0:C0}' -f ( $BetOld * 4 ) ) ## Small Win
			} Else {
				Write-Host -n $( " " * ( 20 - ( $BetOld.ToString().Length + $BetOld.ToString().Length + ( $( '{0:C0}' -f ( $BetOld * 10 ) ) ).ToString().Length ) ) ) #gap √
				Write-Host -n -f darkgreen ' Big Win: '
				write-Host -f darkGreen   $( '{0:C0}' -f ( $BetOld * 10 ) )  ## Big Win
			}
		}

	}
}	
##▲

##	Percentages			Display
##▼▼
Function F-Percent {
	If ( $Gob.Count -gt 0 ){
		$Line1=1,2,3;$Line4=4,5,6;$Line7=7,8,9;$Line10=10,11,12;$Line13=13,14,15;$Line16=16,17,18;$Line19=19,20,21;$Line22=22,23,24;$Line25=25,26,27;$Line28=28,29,30;$Line31=31,32,33;$Line34=34,35,36
		Switch ( $Gob[-1] ) {
			{ $_ -in $Line1 } { $script:Row1sum++; BREAK }
			{ $_ -in $Line4 } { $script:Row4sum++; BREAK }
			{ $_ -in $Line7 } { $script:Row7sum++; BREAK }
			{ $_ -in $Line10 } { $script:Row10sum++; BREAK }
			{ $_ -in $Line13 } { $script:Row13sum++; BREAK }
			{ $_ -in $Line16 } { $script:Row16sum++; BREAK }
			{ $_ -in $Line19 } { $script:Row19sum++; BREAK }
			{ $_ -in $Line22 } { $script:Row22sum++; BREAK }
			{ $_ -in $Line25 } { $script:Row25sum++; BREAK }
			{ $_ -in $Line28 } { $script:Row28sum++; BREAK }
			{ $_ -in $Line31 } { $script:Row31sum++; BREAK }
			{ $_ -in $Line34 } { $script:Row34sum++; BREAK }
		}
## THIS IS UPDATING INCORRECTLY	
		Write-Host `n
		Write-Host -n -f darkcyan ' Line  1	1-3		'; Write-Host -n -f Darkcyan  $Row1Sum' '; Write-Host  -f Darkgray ('{0:P0}' -f $($Row1Sum/$Gob.Count))
		Write-Host -n -f darkcyan ' Line  4	4-6		'; Write-Host -n -f Darkcyan  $Row4Sum' '; Write-Host  -f Darkgray ('{0:P0}' -f $($Row4Sum/$Gob.Count))
		Write-Host -n -f darkcyan ' Line  7	7-10		'; Write-Host -n -f Darkcyan  $Row7Sum' '; Write-Host  -f Darkgray ('{0:P0}' -f $($Row7Sum/$Gob.Count))
		Write-Host -n -f darkcyan ' Line 10	10-12		'; Write-Host -n -f Darkcyan  $Row10Sum' '; Write-Host  -f Darkgray ('{0:P0}' -f $($Row10Sum/$Gob.Count))
		Write-Host -n -f darkcyan ' Line 13	13-15		'; Write-Host -n -f Darkcyan  $Row13Sum' '; Write-Host  -f Darkgray ('{0:P0}' -f $($Row13Sum/$Gob.Count))
		Write-Host -n -f darkcyan ' Line 16	16-21		'; Write-Host -n -f Darkcyan  $Row16Sum' '; Write-Host  -f Darkgray ('{0:P0}' -f $($Row16Sum/$Gob.Count))
		Write-Host -n -f darkcyan ' Line 19	19-24		'; Write-Host -n -f Darkcyan  $Row19Sum' '; Write-Host  -f Darkgray ('{0:P0}' -f $($Row19Sum/$Gob.Count))
		Write-Host -n -f darkcyan ' Line 22	22-27		'; Write-Host -n -f Darkcyan  $Row22Sum' '; Write-Host  -f Darkgray ('{0:P0}' -f $($Row22Sum/$Gob.Count))
		Write-Host -n -f darkcyan ' Line 25	25-30		'; Write-Host -n -f Darkcyan  $Row25Sum' '; Write-Host  -f Darkgray ('{0:P0}' -f $($Row25Sum/$Gob.Count))
		Write-Host -n -f darkcyan ' Line 28	28-33		'; Write-Host -n -f Darkcyan  $Row28Sum' '; Write-Host  -f Darkgray ('{0:P0}' -f $($Row28Sum/$Gob.Count))
		Write-Host -n -f darkcyan ' Line 31	31-36		'; Write-Host -n -f Darkcyan  $Row31Sum' '; Write-Host  -f Darkgray ('{0:P0}' -f $($Row31Sum/$Gob.Count))
		Write-Host -n -f darkcyan ' Line 34	34-36		'; Write-Host -n -f Darkcyan  $Row34Sum' '; Write-Host  -f Darkgray ('{0:P0}' -f $($Row34Sum/$Gob.Count))

	}
}	
##▲

##	Bets					Display
##▼▼
Function F-Bets {
	Switch ( $BetMethod ) {
		'9 Numbers' {
			If ( $Gob.Count -gt 0 ) {
				$set1 = "$9NumberStart|$($9Numberstart + 3)"
				$set2 = "$($9Numberstart + 3)|$($9Numberstart + 6)"
				##	Text Line
##▼▼
				If ( $9NumberStart -le 7 ) { Write-Host -n $( " " * 7 ) } Else { Write-Host -n $( " " * 6 ) } # Blank Before Anything
				Write-Host -n  -f DarkGray $set1
				If ( $9NumberStart -le 4 ) { Write-Host -n -f red  $( " " * 7 ) } Else { Write-Host -n $( " " * 5 ) } # Between Sets
				Write-Host -n  -f DarkGray $set2
				If ( $9NumberStart -eq 1 ) { Write-Host -n -f red  $( " " * 12 ) } Else { Write-Host -n $( " " * 11 ) } # Before word Total
				Write-Host -f DarkGray 'Total Bet'
##▲
				## Bets
				Write-Host
				Write-Host -n $( " " * 8 )
				Write-Host -n -f White $script:Bet;
				If ( $script:Bet.ToString().Length -eq 1 ) { Write-Host -n $( " " * 9 ) } Else { Write-Host -n $( " " * (10 - $script:Bet.ToString().Length ) ) } # Between Sets
				Write-Host -n -f White $script:Bet;
				$tt = '{0:C0}' -f ( $script:Bet * 2 )
				Write-Host -n $( " " * ( 23 - ( $script:Bet.ToString().Length + $tt.ToString().Length ) ) ) # Blank Before Total
				Write-Host -f Cyan $tt
			}
		}	
	}	
}	
##▲

## End Play Functions ____________________________________________________________________________

##▲
}
##▲
## Play Initialize
##▼▼

## Play Initialize Setup
##▼▼
If ( $Mode -eq 'P' ) {
## Allow Exit
	$AllowExit = 'Yes'
#$AllowExit = 'No'

## Write to Disk
	$WriteToDisk = 'No'
#$WriteToDisk = 'Yes'

## Site
	$Site =  '888'

## Opening Bet
	$OpeningBet = 1
	$Bet = $OpeningBet
	$BetOld = $OpeningBet

## Units
	$Units = 1

## Bet Method
	$BetMethod = $BetMethodRA[0]

	If ( $BetMethod -eq $BetMethodRA[0] ) { ## 9Numbers
##▼▼ 
		$9NumbersChoiceRA = [system.collections.arrayList] @( 1, 4, 7,10,13,16,19,22,25,28 ) # Can only use these numbers
																			## 0  1  2  3  4  5  6  7  8  9
		## Pick A Start Number
		$9NumberStart = $9NumbersChoiceRA[5] ## Valid ( 0-9 ) from Line Above
		Function GetThe9Numbers ( $startNumber ) {
			$script:BetSpot1 = $9NumberStart
			$script:BetSpot2 = ($9NumberStart + 1)
			$script:BetSpot3 = ($9NumberStart + 2)
			$script:BetSpot4 = ($9NumberStart + 3)
			$script:BetSpot5 = ($9NumberStart + 4)
			$script:BetSpot6 = ($9NumberStart + 5)
			$script:BetSpot7 = ($9NumberStart + 6)
			$script:BetSpot8 = ($9NumberStart + 7)
			$script:BetSpot9 = ($9NumberStart + 8)
		}	
		# This selects the 9 numbers we will be betting
		GetThe9Numbers 9NumberStart
		If ( $BetMethod -eq $BetMethodRA[0] ) { ## 9Numbers
			$The9NumbersRA = @()
			$The9NumbersRA += $BetSpot1
			$The9NumbersRA += $BetSpot2
			$The9NumbersRA += $BetSpot3
			$The9NumbersRA += $BetSpot4
			$The9NumbersRA += $BetSpot5
			$The9NumbersRA += $BetSpot6
			$The9NumbersRA += $BetSpot7
			$The9NumbersRA += $BetSpot8
			$The9NumbersRA += $BetSpot9
		}
		$Bet = $OpeningBet
		$Row1Sum=0;$Row4Sum=0;$Row7Sum=0;$Row10Sum=0;$Row13Sum=0;$Row16Sum=0;$Row19Sum=0;$Row22Sum=0;$Row25Sum=0;$Row28Sum=0;$Row31Sum=0;$Row34Sum=0

	}##▲  END METHOD 9NUMBERS
	If ( $BetMethod -eq $BetMethodRA[1] ) {}
	If ( $BetMethod -eq $BetMethodRA[2] ) {}
	If ( $BetMethod -eq $BetMethodRA[3] ) {}
	If ( $BetMethod -eq $BetMethodRA[4] ) {}
	If ( $BetMethod -eq $BetMethodRA[5] ) {}
	If ( $BetMethod -eq $BetMethodRA[6] ) {}

}## END Play Initialize

##▲

## Play Initialize Display
##▼▼
If ( $Mode -eq 'P' ) {
	$SetupRA = [Ordered] @{
		'	Play or Audit' = ":  $Mode"
		'	Allow Exit'    = ":  $AllowExit"
		'	Write to Disk' = ":  $WritetoDisk"
		'	Website'	      = ":  $Site"
		'	Bet Method'    = ":  $BetMethod"
		'	Betting On'		= ":  $The9NumbersRA"
		'	Units'			= ":  $Units"
		'	Opening Bet'	= ":  $OpeningBet"
		'	Total Bet'		= ":  $($OpeningBet * 2 )"
	}

	$SetupRA | Format-Table -HideTableHeaders -Autosize

	Function F-Read-HostCustom {
		Param ( $stuff )
		Write-Host $stuff -nonewline
		$Host.UI.ReadLine()
	}
	$YN =  F-Read-HostCustom "`n`n	Everthing OK?   "
	If ($YN -eq  'n') { Exit }	
	Clear-Host
}
##▲ END Play Initialize Display
##▲ End Play Initialize
## Play Execution
##▼▼


If ( $Mode -eq 'P' ) {
	While (1) {
		F-Cash
		##Line
		Write-Host -f darkcyan  `n$("_" * 41)
		F-Hand
		F-Time
		F-Dolly
		F-Tale
		F-Percent
		##Line
		Write-Host -f darkcyan  `n$("_" * 41)`n
		F-Bets
		## READ
		$spin  = Read-Host -Prompt "`n`n`n$(" " * (10)) Enter Spin"
		F-SpinValidate $spin
		[Void] $Gob.Add( $spin )
		F-WinOrLose
		F-UpDateBets
		F-UpDateCash
		Clear-Host
	}	## END WHILE LOOP
}
##▲

##▲
} Else {
#▼ ▼  AUDIT
## Variables
##▼▼
$WinLose = [system.collections.arrayList] @()
$Bet = $BetOld = $OpeningBet = 0
$Cash = $CashOld = $CashHi = $CashLo = 0
$Gob = [system.collections.arrayList] @()
$Timer =  [system.diagnostics.stopwatch]::startnew()
$BetMethodHash = [Ordered] @{ 0 = '2 Lines' ; 1 = 'Other1' ; 2 = 'Other2' ; 3 = 'Other3' } ; $__BetMethodHash  = F-Line
###	 4 = 'Other' ; 5 = 'Other' ; 6 = 'Other' ; 7 = 'Other'  
###	 8 = 'MartinGale' ; 9 = 'Fibonaci' <# 0,1,1,2,3,5,8,13,21,35,55,89,144,233,377 #> ; 10 = 'Paroli' ;
###	 11 = '2WinsAddHalf' ; 12 = 'UpDown' ; 13 = 'Flat'; 14 = 'D`Alembert' ; 15 = 'Oscar'; 16 = 'Patrick'; 17 = 'Kelly'  } ;
$PG = 'D:\PostgreSQL\11\bin\psql.exe'
$SpinNames  = [system.collections.arrayList] @()
$SpinSites = [system.collections.arrayList] @()
$SpinCounts = [system.collections.arrayList] @()
[system.collections.arrayList]$SpinTables = . $PG -U Tavi -h localhost -p 5432 -d'roulette' -t -c  "SELECT tablename FROM pg_catalog.pg_tables where tablename ~ 's\d[0-9]\d[0-9]*' ORDER by tablename "
$SpinTables.RemoveAt($SpinTables.Count-1); $SpinTables = $SpinTables.trim()  ## GOT ALL THE SPIN TABLES
Foreach ($item in $SpinTables ) { $split = $item.split("_") ; [Void]$SpinNames.Add($split[0]) ; [Void]$SpinSites.Add($split[1]) ; [Void]$SpinCounts.Add($split[2]) }
$AllData = [system.collections.arrayList] @()
Foreach ($item in $SpinTables ) {
	[system.collections.arrayList]$SpinData = . $PG -U Tavi -h localhost -p 5432 -d'roulette' -t -c "SELECT spins FROM $item "	
	$SpinData.RemoveAt($SpinData.Count-1); $SpinData = $SpinData.trim()
	[Void]$script:AllData.Add($SpinData)
}
##▲
## Functions
##▼▼
Function Execute-Main {
	If ( $Pick = 0 ) {
	} Else {
		Foreach  ( $i in $Data ) {
#Write-Progress -Activity "Search in Progress" -Status "$i% Complete:" -PercentComplete $i;
			F-UpdateStatus
			F-UpdateCash
			F-UpdateBets
			F-MainDisplay
#   $t = read-host; If ($t -eq 't' ) { Write-Host ; Write-Host; Write-Host; exit }
			sleep .5
		}
		F-Results
		F-ResultsDisplay
	}
}
	## Stats Functions Buried in Main Display
Function F-Stats          	{ ##▼▼
	## Cash Less than 
#	If ( $CashLo -le -200 ) {  ## 200 :: killed in  197, 419, NOT 62, killed 96,  killed 549,
#			exit	
#	}
	## Win Or Lose
	##▼▼
	Switch ( $BetMethod ) {
		{ $_ -eq 0 } { ## 2 Lines
			Switch ( $Gob[-1] ) {
				{ $_ -notin $BetRA } { ## Lose
						$script:WinLose += 'L'
						BREAK
					}
				{ $_ -in $BetRA[0..2] -OR  $_ -in $BetRA[-3..-1]  }
					{	
						$script:WinLose += 'S'
						BREAK
					}
				{ $_ -in $BetRA[3..6]  }
					{	
						$script:WinLose += 'B'
						BREAK
					}
				Default { exit }
			}
		}	
		{ $_ -eq 1 } { ## Other
			Switch ( $Gob[-1] ) {
				{ $_ -in $BetRA }
					{	
						$script:WinLose += 'W'
						BREAK
					}
			}
		}	
		Default {
			Clear-Host
			Write-Host -n -f r `n'	 Undefined WinLose for '
			Write-host -n  -f White "Bet Method $BetMethod"
			Write-Host -n -f r ' at Line : '; $__WinLoseFunction = F-Line
			Write-Host -f y  ( $__WinLoseFunction - 5 )`n`n`n`n`n  ; exit }
	} ##	END Switch BetMethod
	##▲ END WinOrLose
}
##▲
	## Main Loop Functions
Function F-UpdateStatus				{ ##▼▼
	[Void] $Gob.Add( $i )
	$script:BetOld = $script:Bet
	$script:CashOld = $script:Cash
	## Win Or Lose
	##▼▼
	Switch ( $BetMethod ) {
		{ $_ -eq 0 } { ## 2 Lines
			Switch ( $Gob[-1] ) {
				{ $_ -notin $BetRA } { ## Lose
						$script:WinLose += 'L'
						BREAK
					}
				{ $_ -in $BetRA[0..2] -OR  $_ -in $BetRA[-3..-1]  }
					{	
						$script:WinLose += 'S'
						BREAK
					}
				{ $_ -in $BetRA[3..6]  }
					{	
						$script:WinLose += 'B'
						BREAK
					}
				Default { exit }
			}
		}	
		{ $_ -eq 1 } { ## Other
			Switch ( $Gob[-1] ) {
				{ $_ -in $BetRA }
					{	
						$script:WinLose += 'W'
						BREAK
					}
			}
		}	
		Default {
			Clear-Host
			Write-Host -n -f r `n'	 Undefined WinLose for '
			Write-host -n  -f White "Bet Method $BetMethod"
			Write-Host -n -f r ' at Line : '; $__WinLoseFunction = F-Line
			Write-Host -f y  ( $__WinLoseFunction - 5 )`n`n`n`n`n  ; exit }
	} ##	END Switch BetMethod
	##▲ END WinOrLose

} ##▲
Function F-UpDateCash						{ ##▼▼
	Switch ( $BetMethod ) {
		'0' {
			Switch ( $WinLose[-1] ) {
				'L' { $script:Cash = ( $Cash + ( -$Bet * 2 ) )   ; BREAK } ##  Lost
				'B' { $script:Cash = ( $Cash + ( 10 * $BetOld )) ; BREAK } ##  Big Win
			   'S' { $script:Cash =  ($Cash + ( 4 * $BetOld ))  ; BREAK } ## Small Win
			}
		}
   }
	If ( $script:Cash -gt $script:CashHi ) {
		$script:CashHi = $script:Cash	
	}
	If ( $script:Cash -lt $script:CashLo ) {
		$script:CashLo = $script:Cash	
	}
}
##▲                                 j
Function F-UpDateBets						{ ##▼▼
	Switch ( $BetMethod ) {
		'0' {
			Switch ( $WinLose[-1] ) {
				'L' { $script:Bet = ( $Bet + $Units ) ; BREAK } ## LOST
				'B' { $script:Bet = ( $Bet - ( 5 * $Units )) ; BREAK } ##  Big Win
				'S' { $script:Bet =  ($Bet - ( 2 * $Units )) ; BREAK } ## Small Win
				Default { Write-Host "Houston....  UpDateBets " ; exit }
			}##  end switch
			If ( $script:Bet -le $OpeningBet ) { $script:Bet = $OpeningBet } ## Can't go lower than OpeningBet
		}
		'OTHER BET METHODS'{}
	}## end switch
	If ( $script:Bet -le $OpeningBet ) { $script:Bet = $OpeningBet } ## Can't go lower than OpeningBet
}
##▲
Function F-MainDisplay				 { ##▼▼
	Clear-host
	Switch ( $BetMethod ) {
		'0' {
	#		Write-Host -f DarkGray "12345678901234567 20 234567 30 234567 40 234567 50 234567 60 234567 70 234567 80 234567 90 23456 100"
			Write-Host -n -f DarkGray `n' Units: ' ; Write-Host -n  -f DarkGray $Units ' '
			Write-Host -n -f DarkGray 'Open: ' ; Write-Host -n -f DarkGray $OpeningBet ' '
			Write-Host -n -f DarkGray 'Site: ' ; Write-Host -n -f DarkGray $Site ' '
			Write-Host -n -f DarkGray 'Date: ' ; Write-Host -n -f DarkGray $RetDate ' '
			Write-Host -n -f DarkGray "Hand: "
			Write-Host -n $Gob.count
			Write-Host -n -f DarkGray "/"
			Write-Host -n -f DarkGray $Pick
			Write-Host -n $( " " * ( 5 - ( ($Gob.Count).ToString().Length ) ) )  #gap √
			Write-Host -n -f DarkGray 'Dolly: '
			Write-Host -n -f yellow $Gob[-1]
		#	Write-Host -n $( " " * ( 3 - ( ($Gob[-1]).ToString().Length ) ) )
			If ( $WinLose[-1] -eq 'L' ) {$WL = '  Lost     ' ;  Write-Host -n -f red $WL }
			If ( $WinLose[-1] -eq 'B' ) {$WL = '  Big Win  ' ;  Write-Host -n -f green $WL }
			If ( $WinLose[-1] -eq 'S' ) {$WL = '  Small Win' ;  Write-Host -n -f green $WL }
			##	Cash
			If ( $Cash -ge 0 ) { $color = 'Green'  } Else { $color = 'Red' }
			$_CashHi = '{0:C0}' -f $CashHi
			$_CashLo = '{0:C0}' -f $CashLo
			$_Cash = '{0:C0}' -f $Cash
			Write-Host -n -f Red '   Low: '
			Write-host -n -f Red $_CashLo
			Write-Host -n $( " " * ( 10 - ( $_CashLo.ToString().Length ) ) )  #gap √
			Write-Host -n -f Green '  Hi: '
			Write-host -n -f Green $_CashHi
			Write-Host -n  $( " " * ( 10 - $_CashHi.ToString().Length ) )
			Write-Host -n -f $color  'Cash: '
			Write-host -f $color $_Cash
			Write-Host -f darkcyan  $("_" * 140)	## Solid Line
			## History
			Write-Host -n -f DarkGray `n' Spin:    '
			Write-Host -n $BetOld
			Write-Host -n $( " " * ( 6 - ( $BetOld.ToString().Length ) ) )
			Write-Host -n $BetOld
			If ( $WinLose[-1] -eq 'L' ) {  ## Lost
				Write-Host -n $( " " * ( 6 - ( $BetOld.ToString().Length ) ) )
				Write-Host -n -f Red 'Bet Lost: '
				$wl = 'Bet Lost: '
				Write-Host -n -f Red ('{0:C0}' -f ( -$BetOld * 2 ) )
			} Else {   ## Win
				If ( $WinLose[-1] -eq 'B' ) { ## Big Win
					Write-Host -n $( " " * ( 6 - ( $BetOld.ToString().Length ) ) )
					Write-Host -n -f green   'BIG WIN: '
					Write-Host -n -f green ('{0:C0}' -f ( $BetOld * 10 ) )
				} Else {  ## Small Win
					Write-Host -n $( " " * ( 6 - ( $BetOld.ToString().Length ) ) )
					Write-Host -n -f green   'Small Win: '
					Write-Host -n -f green ('{0:C0}' -f ( $BetOld * 4 ) )
				}
			}
			Write-Host '           Cash Was: '$cashold
			
			## stats functions
			F-Stats
			Write-Host -f darkcyan  $("_" * 140)	## Solid Line
			Write-Host
			## Current Bets
			Write-Host -f DarkGray ' Next Bet:'`n
			$gap = ( ($BetRA[0]).ToString().Length + ($BetRA[0]).ToString().Length )
			Write-Host -n $( " " * ( 12 - $gap ) )
			Write-Host -n -f yellow "$($BetRA[0])-$($BetRA[5])"
			Write-Host -n  $( " " * 5  )
			Write-Host -f yellow "$($BetRA[3])-$($BetRA[8])"
			$gap = ($BetRA[0]).ToString().Length
			Write-Host -n $( " " * ( 12 - $gap ) )
			Write-host -n $Bet
			$gap = ( ($BetRA[5]).ToString().Length + ($BetRA[3]).ToString().Length + $Bet.ToString().Length )
			Write-Host -n $( " " * ( 14 - $gap ) )
			Write-Host -n $Bet
			$gap = ($Bet).ToString().Length
			Write-Host -n -f r  $( " " * ( 10 - $gap ) )
			Write-Host -n  $( '{0:C0}' -f  $( $Bet * 2 ) )
			Write-Host  ("`n " * 3)
		}## END $BetMethod  0
	} ## END Switch
} ##▲ END Function Display
	## Event Functions
Function F-Verify_Pick								 { ##▼▼
	If ( $Pick -eq 0 -OR ( -NOT( @( $SpinCounts -contains $Pick) ) ) ) {
		If  ( $Pick -eq 0 ) { } Else {
		Clear-Host; Write-Host -f r  `n'		Pick Data Failure'`n;
		Write-Host -n '	Invalid Selection at line: '
		Write-host  -f c  $__Pick `n
		Write-Host -n '	Valid Choices are: '
		Write-Host -f y  $SpinCounts`n`n
		exit
		}
	}
}

##▲
Function F-Verify_BetMethod				{ ##▼▼
	If ( $BetMethod -notin $BetMethodHash.Keys ) {
		Clear-Host;
		Write-Host -f r  `n'		 Bet Method Failure'`n
		Write-Host -n '	Invalid Selection at Line: '
		Write-Host -f c  $__BetMethod `n
		Write-Host -n '	Valid Selections at line: '
		Write-Host -f y  $__BetMethodHash`n`n
		exit
	}
}

##▲
Function F-Verify_2Lines_Start	{ ##▼▼
	$script:ValidStartRA = 1,4,7,10,13,16,19,22,25,28 ; $script:__ValidStartRA = F-Line
	If ( $2Lines_Start -notin $ValidStartRA ) {
		Clear-Host;
		Write-Host -f r  `n'		 Bet Method Failure'`n
		Write-Host -n '	Invalid Selections at Line: '
		Write-Host -f c  $__2Lines_Start `n
		Write-Host -n '	Valid Choices at line: '
		Write-Host -f y  $__ValidStartRA`n`n
		exit
	}
	Switch ( $2Lines_Start ) {
		1	{ $script:BetRA = 0..9 }
		4	{ $script:BetRA = 4..12 }
		7	{ $script:BetRA = 7..15 }
		10	{ $script:BetRA = 10..18 }
		13	{ $script:BetRA = 13..21 }
		16	{ $script:BetRA = 16..24 }
		19	{ $script:BetRA = 19..27 }
		22	{ $script:BetRA = 22..30 }
		25	{ $script:BetRA = 25..33 }
		28	{ $script:BetRA = 28..36 }
	}
}
##▲
Function Run-Setup												{ ##▼▼
	$script:bet = $OpeningBet
	If ( $Pick -eq 0 ) {
		$script:Site = 'All'
		$script:RetDate = 'All'
		$script:RecCount = 'All'
		$script:data = $AllData
	} Else {
		$script:PickIndex = (0..($SpinCounts.Count-1)) | where {$SpinCounts[$_] -eq $Pick} # Get PickIndex of selected pick
		$y =  "20" + $SpinNames[$PickIndex].substring(1,2)
		$m =  $SpinNames[$PickIndex].substring(3,2)
		$d =  $SpinNames[$PickIndex].substring(5,2)
		$script:RetDate = ( ("20" + $SpinNames[$PickIndex].substring(1,2)) + '-' + ( $SpinNames[$PickIndex].substring(3,2) ) + '-' + ( $SpinNames[$PickIndex].substring(5,2) ) )
		$script:Site = $SpinSites[$PickIndex]
		$script:RecCount = $SpinCounts[$PickIndex]
		$script:data = $AllData[$PickIndex]
	}
	## $ViewSetupPage
##▼▼
	If ($ViewSetupPage) {
		Clear-Host
		Write-Host -f y `n'                     Audit Setup'
		Write-Host -f y   '                     ==========='
		## Site
		$gap =  'Site:  '.ToString().Length
		Write-Host -n -f DarkGray $( " " * ( 28 - $gap ) ) 'Site:  '
		Write-Host $Site
		## Date
		$gap =  'Retrieval Date:  '.ToString().Length
		Write-Host -n -f DarkGray $( " " * ( 28 - $gap ) ) 'Retrieval Date:  '
		Write-Host $RetDate
		## Record Count
		$gap =  'Record Count:  '.ToString().Length
		Write-Host -n -f DarkGray $( " " * ( 28 - $gap ) ) 'Record Count:  '
		Write-Host $RecCount
		## Betting Units
		$gap =  'Betting Units:  '.ToString().Length
		Write-Host -n -f DarkGray $( " " * ( 28 - $gap ) ) 'Betting Units:  '
		Write-Host $('{0:C0}' -f $Units)
		## Opening Bet
		$gap =  'Opening Bet:  '.ToString().Length
		Write-Host -n -f DarkGray $( " " * ( 28 - $gap ) ) 'Opening Bet:  '
		Write-Host $('{0:C0}' -f $OpeningBet)
		
		## Write to Disk
		$gap = 'Write to Disk:  '.ToString().Length
		Write-Host -n -f DarkGray $( " " * (28 - $gap ) ) 'Write to Disk:  '
		IF ( $WriteToDisk ) { Write-Host 'Yes' } Else { Write-Host  'No' }
		
		## Bet Method
		$gap =  'Bet Method:  '.ToString().Length
		Write-Host -n -f DarkGray $( " " * ( 28 - $gap ) ) 'Bet Method:  '
		Write-Host $BetMethodHash[0]
		
		## 2 Lines Start
		If ( $BetMethod -eq 0  ) {
			$gaptag =  'Betting On:  '
			$gap =  'Betting On:  '.ToString().Length
			Write-Host -n $( " " * ( 29 - $gap ) )
			Write-Host -n -f DarkGray 'Betting On:  '
			Write-Host -n "$2Lines_Start-$($2Lines_Start + 8)"
		}
			##  Good to Go
			$YN =  F-Read-HostCustom "`n`n		      OK ?   "
			If ($YN -eq  'n') { Exit }	
			Clear-Host ; Write-Host
	} ##▲
} ##▲
Function F-Read-HostCustom	   	{ ##▼▼
	Param ( $stuff )
	Write-Host $stuff -nonewline
	$Host.UI.ReadLine()
}
##▲
	## Result Functions
Function F-Results								 { ##▼▼
	$script:SpinTotal = $Gob.count
	#$Results = "" | Select-Object -Property  Site, Month, Day, Year, Open, Units, Method, Spins, Track , 'Switch%', Lowest, Highest, Cash
	$Script:Results = '' | Select-Object -Property  Site, Units, Opening , Method, SpinTotal, CashLo, CashHi, Cash,Date
	$Results.Site		= $Site
	$Results.Units	   = $Units
	$Results.Method	= $BetMethod
	$Results.SpinTotal	= $SpinTotal
	$Results.CashLo	= $CashLo
	$Results.CashHi	= $CashHi
	$Results.Cash	= $Cash
	$Results.Opening	= $OpeningBet
	$Results.Date		=  $RetDate
	Foreach ( $item in $Results) {
		fff $item
	}
	
#	fff $Results
	#3sleep 5
#	Write-Host $Results.Site
#	Write-Host $Results.Units
#	Write-Host $Results.Method
#	Write-Host $Results.SpinTotal
#	Write-Host $Results.CashLo
#	Write-Host $Results.CashHi
 #  Write-Host $Results.Cash


	<#
	$WriteOB.Month		= $FileNameRA[2]
	$WriteOB.Day		= $FileNameRA[3]
	$WriteOB.Year		= $FileNameRA[4]
	$WriteOB.Open	   = $OpeningBet
	$WriteOB.Units	   = $Units
	$WriteOB.Method	= $BetMethod
	$WriteOB.Spins		= $Gob.Count
	#$WriteOB.'Switch%'	= $S
	#$WriteOB.Track		= $T
	$WriteOB.Lowest		= $CashLo
	$WriteOB.Highest	= $CashHi
	$WriteOB.Cash		= $Cash
	Write-Host $WriteOB
	$CsvName	 = ( 'CSV' + '.' + $Count + '.' + $Site + '.' + $mn + '.' + $yr + '.csv')
	[object]$WriteOB | export-csv -append $CsvName -NoTypeInformation
#>


} ##▲ END Function Results
Function F-ResultsDisplay	 { ##▼▼
	Write-Host -f DarkCyan `n"  Results:"`n
	Write-Host -n -f DarkGray '  Site: '
	Write-Host -n $Results.Site
	Write-Host -n -f DarkGray '  Date: '
	Write-Host -n $Results.Date
	Write-Host -n -f DarkGray  '  Units: '
	Write-Host -n $Results.Units
	Write-Host -n -f DarkGray  '  Open '
	Write-Host -n $Results.Opening
	Write-Host -n -f DarkGray  '  Bet Method: '
	Write-Host -n $Results.Method
	Write-Host -n -f DarkGray  '  Count: '
	Write-Host -n $Results.SpinTotal
	Write-Host -n -f Red  '  Lo: '
	Write-Host -n -f Red $Results.CashLo
	Write-Host -n -f Green  '  Hi: '
	Write-Host -n -f Green $Results.CashHi
	Write-Host -n -f DarkGray  '  Cash: '
	If ($Cash -ge 0 ) {
		$cashcolor = 'Green'
	} Else {
		$cashcolor = 'Red'
	}
	 Write-Host -n -f $cashcolor $Results.Cash


} ##▲ END Function Results

##▲
##	0 for ALL	OR	 419 62 96 549 137 302 132 82 165 275 400 37
$Pick				= 37		<#	Pick single table from PostgreSQL	... 0 for ALL #> ; $__Pick = F-Line; F-Verify_Pick
$OpeningBet		= 1
$Units			= 1
$BetMethod		= 0		<#	Select Bet Method	#> ; $__BetMethod = F-Line ; F-Verify_BetMethod <# Verify Variable #>
$2Lines_Start	= 16		<#	Number of Line for Bet	#> ; $__2Lines_Start = F-Line ; F-Verify_2Lines_Start <# Verify Variable #>
$WriteToDisk	= 0		<#	Save Results to a file	#>;  ##	In Progress
$ViewSetupPage	= 1		<#	Show Setup Screen	#> ; # $__SetupScreen = F-Line 
Run-Setup
Execute-Main

#$Results = "" | Select-Object -Property Table, Site, Open, Units, Method, Spins, Track , 'Switch%', Lowest, Highest, Cash

#. $PG -U Tavi -h localhost -p 5432 -d'roulette' -c "INSERT INTO recap (site) VALUES ('891' )"
<#
If ( $WriteToDisk ) {
##▼▼
	Write-Host 'Writing to Disk'
	$WriteOB = "" | Select-Object -Property  Site, Month, Day, Year, Open, Units, Method, Spins, Track , 'Switch%', Lowest, Highest, Cash
	$WriteOB.Site		= $FileNameRA[1]
	$WriteOB.Month		= $FileNameRA[2]
	$WriteOB.Day		= $FileNameRA[3]
	$WriteOB.Year		= $FileNameRA[4]
	$WriteOB.Open	   = $OpeningBet
	$WriteOB.Units	   = $Units
	$WriteOB.Method	= $BetMethod
	$WriteOB.Spins		= $Gob.Count
	#$WriteOB.'Switch%'	= $S
	#$WriteOB.Track		= $T
	$WriteOB.Lowest		= $CashLo
	$WriteOB.Highest	= $CashHi
	$WriteOB.Cash		= $Cash
	Write-Host $WriteOB
	$CsvName	 = ( 'CSV' + '.' + $Count + '.' + $Site + '.' + $mn + '.' + $yr + '.csv')
	[object]$WriteOB | export-csv -append $CsvName -NoTypeInformation
}

##▲
#>
} ##▲	END MODE
Write-Host -n -f DarkCyan `n`n`n`n`n`n"  Script Time " ( '{0}:{1}:{2}' -f (  '{0:00}' -f $Timer.Elapsed.Hours ) , ( '{0:00}' -f $Timer.Elapsed.Minutes )  , ( '{0:00}' -f $Timer.Elapsed.Seconds )  )
##▼▼ OLD stuff
##**********************************************************************************************************************	
<#	
##▼▼
##▼▼
##▼▼
##▼▼
##▼▼

	## Initialie()
##▼▼
	Function Call-Initialie {
		If ( $Betone -eq 12 ) {
			$script:BetLo  = $OpeningBet
			$script:BetMed = $OpeningBet
			$script:BetHi  = 0
			$script:Cash = 0
			$script:CashHi = 0
			$script:CashLo = 0
		}	Elseif ($Betone -eq 13 ) {
			$script:BetLo  = $OpeningBet
			$script:BetMed = 0
			$script:BetHi  = $OpeningBet
			$script:Cash = 0
			$script:CashHi = 0
			$script:CashLo = 0
		} Else {
			$script:BetLo  = 0
			$script:BetMed = $OpeningBet
			$script:BetHi  = $OpeningBet
			$script:Cash = 0
			$script:CashHi = 0
			$script:CashLo = 0
		}
	}	##▲	END Call-Initialie()
	## Spin Validate()
##▼▼
	Function Call-SpinValidate {
		If ( $AllowExit ) { If ( $spin -eq 't' -OR $spin -eq 'tt' -OR $spin -eq 'rr' ) { exit } }
		if ( $spin.ToString().Length -eq 0 ){ Write-Host -f Red " [ INVALID ENTRY ]"  ; Start-Sleep 1 ; Clear-Host ; Continue ; }
		If ( $spin.substring(0,1) -eq 's' )   {
			$message = "You are already in that Betone, Dufus"
			If ( $spin -eq 's12' ) {
				If ( $script:Betone -eq '12' ) { Write-Host -f Red $Message ; Start-Sleep 1 ; Clear-Host ; Continue }
					$script:Betone = 12
					$script:BetLo	 = $BetHi
					$script:BetMed	 = $BetHi
					$script:BetLold = $BetHi
					$script:BetMold = $BetHi
					$script:BetHi	 = 0
					$script:BetHold = 0
					Clear-Host ; Continue ;
			} ElseIf ($spin -eq 's13' ) {
				If ( $script:Betone -eq '13' ) { Write-Host -f Red $Message ; Start-Sleep 1 ; Clear-Host ; Continue }
					$script:Betone = 13
					$script:BetLo	 = $BetMed
					$script:BetHi	 = $BetMed
					$script:BetLold = $BetMed
					$script:BetHold = $BetMed
					$script:BetMed	 = 0
					$script:BetMold = 0
					Clear-Host ; Continue ;
			} ElseIf ($spin -eq 's23' ) {
				If ( $script:Betone -eq '23' ) { Write-Host -f Red $Message ; Start-Sleep 1 ; Clear-Host ; Continue }
					$script:Betone = 23
					$script:BetMed	 = $BetLo
					$script:BetHi	 = $BetLo
					$script:BetMold = $BetLo
					$script:BetHold = $BetLo
					$script:BetLo	 = 0
					$script:BetLold = 0
					Clear-Host ; Continue ;
			} Else { Write-Host -f Red " [ INVALID CHANGE SPIN ENTRY ]"  ; Start-Sleep 1 ; Clear-Host ; Continue ; }
		}
		If ( $spin -match '^[0-9]$' -OR $spin -match '^[1-2][0-9]$' -OR $spin -match '^[3][0-6]$' )  {
		} Else { Write-Host -f Red " [ INVALID ENTRY ]"  ; Start-Sleep 1 ; Clear-Host ; Continue ; }
	}	##▲	END Call-SpinValidate()
	## Update()
##▼ ▼
	Function Call-Update {
		$script:BetLold = $BetLo
		$script:BetMold = $BetMed
		$script:BetHold = $BetHi
		## WinOrLose
		##▼▼
		Switch ( $Gob[-1] ) {
			{ $_ -in 0 } {
				If ( $Betone -eq 12 ) { [void] $WinRA.Add('L12') ; BREAK }
				If ( $Betone -eq 13 ) { [void] $WinRA.Add('L13') ; BREAK }
				If ( $Betone -eq 23 ) { [void] $WinRA.Add('L23') ; BREAK }
			}
			{ $_ -in 1..12 } {
				If ( $Betone -eq 12 ) { [void] $WinRA.Add('W12') ; BREAK }
				If ( $Betone -eq 13 ) { [void] $WinRA.Add('W13') ; BREAK }
				If ( $Betone -eq 23 ) { [void] $WinRA.Add('L23') ; BREAK }
			}
			{ $_ -in 13..24 } {
				If ( $Betone -eq 12 ) { [void] $WinRA.Add('W12') ; BREAK }
				If ( $Betone -eq 13 ) { [void] $WinRA.Add('L13') ; BREAK }
				If ( $Betone -eq 23 ) { [void] $WinRA.Add('W23') ; BREAK }
			}
			{ $_ -in 25..36 } {
				If ( $Betone -eq 12 ) { [void] $WinRA.Add('L12') ; BREAK }
				If ( $Betone -eq 13 ) { [void] $WinRA.Add('W13') ; BREAK }
				If ( $Betone -eq 23 ) { [void] $WinRA.Add('W23') ; BREAK }
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
			## UpDown
		##▼ ▼
		If ( $BetMethod -eq 'UpDown' ) {
			Switch ( $WinRA[-1] ) {
				## Lose
				{ $_ -eq 'L12' } { $script:BetLo  = $BetLo +  ( 2 * $Units ) ; $script:BetMed = $BetMed + ( 2 * $Units ) }
				{ $_ -eq 'L13' } { $script:BetLo  = $BetLo +  ( 2 * $Units ) ; $script:BetHi  = $BetHi  + ( 2 * $Units ) }
				{ $_ -eq 'L23' } { $script:BetMed = $BetMed + ( 2 * $Units ) ; $script:BetHi  = $BetHi  + ( 2 * $Units ) }
				## Win
				{ $_ -eq 'W12' } {
					$script:BetLo--
					$script:BetMed--
					If ($BetLo  -le $OpeningBet ) { $script:BetLo  = $OpeningBet }
					If ($BetMed -le $OpeningBet ) { $script:BetMed = $OpeningBet }
				}
				{ $_ -eq 'W13' } {
					$script:BetLo--
					$script:BetHi--
					If ($BetLo -le $OpeningBet ) { $script:BetLo = $OpeningBet }
					If ($BetHi -le $OpeningBet ) { $script:BetHi = $OpeningBet }
				}
				{ $_ -eq 'W23' } {
					$script:BetMed--
					$script:BetHi--
					If ($BetMed -le $OpeningBet ) { $script:BetMed = $OpeningBet }
					If ($BetHi -le $OpeningBet ) { $script:BetHi = $OpeningBet }
				}
				Default { Write-Host 'Houston... Bet Up2' ; exit }
			} ## 	END Switch
		}##	▲	END UP2
			## Up2
		##▼▼
		If ( $BetMethod -eq 'Up2' ) {
			Switch ( $WinRA[-1] ) {
				## Lose
				{ $_ -eq 'L12' } { $script:BetLo  = $BetLo +  ( 2 * $Units ) ; $script:BetMed = $BetMed + ( 2 * $Units ) }
				{ $_ -eq 'L13' } { $script:BetLo  = $BetLo +  ( 2 * $Units ) ; $script:BetHi  = $BetHi  + ( 2 * $Units ) }
				{ $_ -eq 'L23' } { $script:BetMed = $BetMed + ( 2 * $Units ) ; $script:BetHi  = $BetHi  + ( 2 * $Units ) }
				## Win
				{ $_ -eq 'W12' } {
					$script:BetLo--
					$script:BetMed--
					If ($BetLo  -le $OpeningBet ) { $script:BetLo  = $OpeningBet }
					If ($BetMed -le $OpeningBet ) { $script:BetMed = $OpeningBet }
				}
				{ $_ -eq 'W13' } {
					$script:BetLo--
					$script:BetHi--
					If ($BetLo -le $OpeningBet ) { $script:BetLo = $OpeningBet }
					If ($BetHi -le $OpeningBet ) { $script:BetHi = $OpeningBet }
				}
				{ $_ -eq 'W23' } {
					$script:BetMed--
					$script:BetHi--
					If ($BetMed -le $OpeningBet ) { $script:BetMed = $OpeningBet }
					If ($BetHi -le $OpeningBet ) { $script:BetHi = $OpeningBet }
				}
				Default { Write-Host 'Houston... Bet Up2' ; exit }
			} ## 	END Switch
		}##	▲	END UP2
			## DoubleThenHalfPlus
		##▼▼
		If ( $BetMethod -eq 'DoubleThenHalfPlus' ) {
			If ( $WinCount -eq 1 ) {
				Switch ( $WinRA[-1] ) {
					## Win
					{ $_ -eq 'W12' } {
						$script:BetLo  = ( $Units * 2 )
						Write-Host $script:BetLo

						$script:BetMed = ( $Betmed * 2 )
						$script:WinCount++
					}
					{ $_ -eq 'W13' } { $script:BetLo  = ( $BetLo * 2  ) ; $script:BetHi  = ( $BetHi  * 2 )
						#TODO
					}
					{ $_ -eq 'W23' } { $script:BetMed = ( $BetMed * 2 ) ; $script:BetHi  = ( $BetHi  * 2 )
						#TODO
					}
					## Lose
					{  $_ -eq ( 'W12' -OR 'W13' -OR 'W23' ) } {
						$Losecount++ ;
					}
					Default { Write-Host 'Houston... Bet DoubleThenHalfPlus' ; exit }
				} ## 	END Switch
			} ## END IF
			If ( $WinCount -eq 2 ) {
				Switch ( $WinRA[-1] ) {
					## Win
					{ $_ -eq 'W12' } {
						$script:BetLo  = ( $BetLo / 4 )
						$script:BetLo  = ( $BetLo + ($BetLo * .5 ) )
						Write-Host $script:BetLo
		#				$script:BetLo  = ( $BetLo * 1.5 )

						$script:BetMed = ( $Betmed * 2 )
						$script:WinCount = 0 
					}
					{ $_ -eq 'W13' } { $script:BetLo  = ( $BetLo * 2  ) ; $script:BetHi  = ( $BetHi  * 2 )
						#TODO
					}
					{ $_ -eq 'W23' } { $script:BetMed = ( $BetMed * 2 ) ; $script:BetHi  = ( $BetHi  * 2 )
						#TODO
					}
					## Lose
					{  $_ -eq ( 'W12' -OR 'W13' -OR 'W23' ) } {
						$Losecount++ ;
					}
					Default { Write-Host 'Houston... Bet DoubleThenHalfPlus' ; exit }
				} ## 	END Switch
			} ## END IF
	
	
	
	
	
	
		##############################################################################
		}##	▲	END DoubleThenHalfPlus
			## Paroli
		##▼▼
<#	
	You place your first $5 bet and win $5. You place your second bet of $10.
	You win with the second bet and place your third bet of $20. You win with
	the third bet and this is your stopping point for the Paroli betting system.
	You will then proceed back to the original bet of $5 and continue to use the
	system throughout the game. You may try for four or five wins in a row but
	it will be harder to complete the sequence. If you were to lose at any time
	you go back to your original starting bet and begin the sequence over again
#>
<#	
		If ( $BetMethod -eq 'Paroli' ) {
			Switch ( $WinRA[-1] ) {
				## Win
				{ $_ -eq 'W12' } {
					If ( $ParoliCount -lt $ParoliLimit ) {
					 $script:BetLo  = ( $BetLo * 2 )  ;
					 $script:BetMed  = ( $BetMed * 2 )  ;
					 $script:ParoliCount++
					} Else {
						$script:BetLo = $OpeningBet
						$script:BetMed = $OpeningBet
					}
				}
				{ $_ -eq 'W13' } {
					If ( $ParoliCount -lt $ParoliLimit ) {
					 $script:BetLo  = ( $BetLo * 2 )  ;
					 $script:BetHi  = ( $BetHi * 2 )  ;
					 $script:ParoliCount++
					} Else {
						$script:BetLo = $OpeningBet
						$script:BetHi = $OpeningBet
					}
				}
				{ $_ -eq 'W23' } {
					If ( $ParoliCount -lt $ParoliLimit ) {
					 $script:BetMed  = ( $BetMed * 2 )  ;
					 $script:BetHi  = ( $BetHi * 2 )  ;
					 $script:ParoliCount++
					} Else {
						$script:BetMed = $OpeningBet
						$script:BetHi = $OpeningBet
					}
				}
				## Lose
				{ $_ -eq 'L12' } {
					$script:BetLo = $OpeningBet
					$script:BetMed = $OpeningBet
				}
				{ $_ -eq 'L13' } {
					$script:BetLo = $OpeningBet
					$script:BetHi = $OpeningBet
				}
				{ $_ -eq 'L23' } {
					$script:BetMed = $OpeningBet
					$script:BetHi = $OpeningBet
				}
				Default { Write-Host 'Houston... Bet Paroli' ; exit }
			} ## 	END Switch
		}##	▲	END UP2
		##	▲	END Bets
	}	##▲	END Call-Update()
	## Last()
			##▼▼
		Function Call-Last( $el ) {
			$loCount = 0
			$medCount = 0
			$hiCount = 0
			$elName = ''
			$start = $Gob.Count - $el
			$end = $Gob.Count - 1
			Foreach ( $el in $Gob[$start..$end]) {
				Switch ( $el ) {
					{ $_ -in 0 } { BREAK }  ##	spin 0
					{ $_ -in 1..12 }  { $loCount++  ; BREAK }	##	Lo
					{ $_ -in 13..24 } { $medCount++ ; BREAK }	##	Med
					{ $_ -in 25..36 } { $hiCount++  ; BREAK }	##	Hi
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
		}	##	▲	END LAST()
	## SwitchBets()
##▼▼
	Function Call-SwitchBets ( $T , $S )  {
		[int] $lo = 0
		[int] $med = 0
		[int] $hi = 0
		## Get Percentages
		Foreach ( $i in $Gob[-$T..-1] ) {
			If ( $i -in 1..12 )  { $lo++ }
			ElseiF ( $i -in 13..24 ) { $med++}
			ElseIf ( $i -in 25..36 ) { $hi++ }
			[int] $Plo = ( $lo / $T * 100 )
			[int] $Pmed = ( $med / $T * 100 )
			[int] $Phi = ( $hi / $T * 100 )
		}
		## Get Betone
		## DisplaySwitch()
			##▼▼
		Function Call-DisplaySwitch {
			If ( $Mode -eq 'Play') {
				Clear-Host
				Write-Host -f y  ("`n`nBets Have Switched !!!!!!!!!!!!!!!!!!!!!!`n`n" *  2 )`n
				Read-Host
				Clear-Host
			}
		}	##	▲	END DisplaySwitch()
		Switch ( $Betone ) {
			{ $_ -eq 12 -AND $Plo -le $S  } {
				$script:Betone = 23
				$script:BetHi = $BetLo
				$script:BetHold = $BetLold
				$script:Betlo = 0
				$script:BetLold = 0
				Call-DisplaySwitch
				BREAK
			}
			{ $_ -eq 12 -AND $Pmed -le $S  } {
				$script:Betone = 13
				$script:BetHi = $BetMed
				$script:BetHold = $BetMold
				$script:Betmed = 0
				$script:BetMold = 0
				Call-DisplaySwitch
				BREAK
			}
			{ $_ -eq 13 -AND $Plo -le $S  } {
				$script:Betone = 23
				$script:BetMed = $BetLo
				$script:BetMold = $BetLold
				$script:BetLo = 0
				$script:BetLold = 0
				Call-DisplaySwitch
				BREAK
			}
			{ $_ -eq 13 -AND $Phi -le $S  } {
				$script:Betone = 12
				$script:BetMed = $BetHi
				$script:BetMold = $BetHold
				$script:BetHi = 0
				$script:BetHold = 0
   			Call-DisplaySwitch
   			BREAK
			}
			{ $_ -eq 23 -AND $Pmed -le $S  } {
				$script:Betone = 13
				$script:BetLold = $BetMold
				$script:BetLo = $BetHi
				$script:BetMed = 0
				$script:BetMold = 0
				Call-DisplaySwitch
				BREAK
			}
			{ $_ -eq 23 -AND $Phi -le $S  } {
				$script:Betone = 12
				$script:BetLold = $BetHold
				$script:BetLo = $BetHi
				$script:BetHold = 0
				$script:BetHi = 0
				Call-DisplaySwitch
				BREAK
			}
		}
	}	##▲	END Call-SwitchBets
	## Display()
##▼▼
	Function Call-Display {
		## Tracking/Switching
##▼▼
		Write-Host -n -f darkGray `n' Tracking Spins: '
		Write-Host -n $T
		Write-Host -n -f darkGray '    Switching: '
		If ($S -lt 0 ) { Write-Host 'Never' } Else { Write-Host $S`% }
		Write-Host -f DarkGray  $("_" * 38)
##▲
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
		Write-Host -n -f DarkGray "   Cash: "
		If ( $Cash -ge 0 ) { Write-Host -f Green ( '{0:C0}' -f $Cash ) } Else { Write-Host -f Red ( '{0:C0}' -f $Cash ) }
##▲
		## Low / High
##▼▼
		Write-host -n -f DarkGray '  Low: '
		Write-host -n -f DarkGray ( '{0:C0}' -f $CashLo )
		Write-Host -n  $( " " * 5 )
		Write-host -n -f DarkGray 'High: '
		Write-host -n -f DarkGray ( '{0:C0}' -f $CashHi )
		Write-Host -n  $( " " * 5 )
		Write-host -f DarkGray $BetMethod

##▲
		## Previous Bets
##▼▼
		Write-Host -f darkcyan "  Lo     Med     Hi    Dolly"
		Switch ( $Betone ) {
			12	{
				Write-Host -n -f yellow ' ' $BetLold
				$gap =  $BetLold.ToString().Length
				Write-host -n ( " " * ( 7 - $gap ) )
				Write-Host -n  -f yellow $BetMold
				$gap =  $BetMold.ToString().Length
				Write-host -n ( " " * ( 15 - $gap ) )
				}
			13	{ 
				Write-Host -n  -f yellow ' ' $BetLold
				$gap =  $BetLold.ToString().Length
				Write-host -n ( " " * ( 15 - $gap ) )
				Write-Host -n  -f yellow $BetHold
				$gap =  $BetHold.ToString().Length
				Write-host -n ( " " * ( 7 - $gap ) )
				}
			23	{  
				Write-Host -n  -f yellow '        ' $BetMold
				$gap =  $BetMold.ToString().Length
				Write-host -n ( " " * ( 8 - $gap ) )
				Write-Host -n  -f yellow $BetHold
				$gap =  $BetHold.ToString().Length
				Write-host -n  -f yellow ( " " * ( 7 - $gap ) )
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
			Write-Host -n -f green ' Won: '
			$_cashWon = '{0:C0}' -f ( $oldBetTotal / 2 )
			Write-Host -n -f green  $_cashWon
		}
##▲
		## Line
		Write-Host -f DarkGray  `n$("_" * 38)`n
		## Percentages
##▼▼
		[array]::sort( $LastRA )
		Write-Host -f darkcyan "  Lo        Med       Hi"
		Foreach ( $item in $LastRA ) {
			If ( $Gob.count -ge $item) {
				$RA = Call-Last $item
				##	Lo
				Write-Host -n '  '
				Write-Host -n -f DarkGray "$($RA.loCount) "
				$gap = $($RA.locount).ToString().Length
				Write-Host -n $( " " * ( 2 - $gap ) )
				Write-Host -n -f $RA.loColor   $RA.loPercent
				Write-Host -n -f $RA.loColor "%"
				$gap = $RA.loPercent.ToString().Length
				Write-Host -n $( " " * ( 6 - $gap ) )
				##	Med
				Write-Host -n -f DarkGray "$($RA.medCount) "
				$gap = $($RA.medcount).ToString().Length
				Write-Host -n $( " " * ( 2 - $gap ) )
				Write-Host -n -f $RA.medColor   $RA.medPercent
				Write-Host -n -f $RA.medColor "%"
				$gap = $RA.medPercent.ToString().Length
				Write-Host -n $( " " * ( 6 - $gap ) )
				##	Hi
				Write-Host -n -f DarkGray "$($RA.hiCount) "
				$gap = $($RA.hiCount).ToString().Length
				Write-Host -n $( " " * ( 2 - $gap ) )
				Write-Host -n -f $RA.hiColor   $RA.hiPercent
				Write-Host -n -f $RA.hiColor "%"
				$gap = $RA.hiPercent.ToString().Length
				Write-Host -n $( " " * ( 5 - $gap ) )
				Write-Host -f DarkGray "Last $item"
			}
		}
		Write-Host -f DarkGray  $("_" * 38)`n
		Write-Host -n  -f DarkGray `n'  BET:'
		Write-Host -f DarkGray "      Lo      Med      Hi"
		Write-Host -n  -f White  "  $"
		Write-Host -n	$($BetLo + $BetMed + $BetHi)
		$gap = $( $BetLo + $BetMed + $BetHi ).ToString().Length
		Write-Host -n $( " " * ( 9 - $gap ) )
		If ( $Betone -eq 12) {
			Write-Host -n -f yellow $BetLo
			$gap = $BetLo.ToString().Length
			Write-Host -n $( " " * ( 8 - $gap ) )
			Write-Host -n -f yellow $BetMed
		}
		If ( $Betone -eq 13) {
			Write-Host -n -f yellow $BetLo
			$gap = $BetLo.ToString().Length
			Write-Host -n $( " " * ( 17 - $gap ) )
			Write-Host -n -f yellow $BetHi
		}
		If ( $Betone -eq 23) {
			Write-Host -n -f yellow "       " $BetMed
			$gap = $BetMed.ToString().Length
			Write-Host -n $( " " * ( 9 - $gap ) )
			Write-Host -n -f yellow $BetHi
		}
##▲
		## Paroli
		If ( $ParoliLimit -gt 0 ) {
			#	Write-Host `n'this is paroliCount' $ParoliCount
		}



#TODO mm

	}##▲	END Call-Display
	<#
	## Mode		Main Script
	If ( $Mode -eq 'Play') {
		##	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play
			##▼▼
		##	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play	Play
##▼ ▼
		Call-Initialie
		While (1) {
			If ( $Gob.count -eq 0 ) { Write-Host  "`n Betone: $Betone  Units: $Units Inital Bet: $OpeningBet"; Write-Host -n "    " } Else { Call-Display }
			$spin  = Read-Host -Prompt "`n`n`n$(" " * (10)) Enter Spin"
			## Validate
			Call-SpinValidate
			Clear-Host
			[Void] $Gob.Add( $spin )
			## Update
			Call-UpDate
			## Switching
			If ( $Gob.Count -ge $T ) { Call-SwitchBets $T $S }
			## Save to File
			If ( $SaveToFile ) {
				$DataPath = 'D:\GitHub\Dolly' 
				$TheDate =  Get-Date -UFormat %b%e ; $Ext = 'txt'
				$DataFile  =  ($DataPath + "\" + $Site + "." + $TheDate + "." + $Ext)
				If ($Site ) { $spin | Add-Content $DataFile }
			}
		}
##	▲	END PLAY
	} Else {
		##	Audit	Audit	Audit	Audit	Audit	Audit	Audit	Audit	Audit	Audit	Audit	Audit	Audit	Audit	Audit	Audit
##▼▼
		Call-Initialie
		Foreach ( $S in $ShiftPercent ) {
			Foreach ( $T in $TrackingLast ) {
				##	Foreach Spin
				Foreach ( $Spin in $Data ) {
					If ( $Pace -ne 'Turbo') {
						Clear-Host
					}
					[Void] $Gob.Add( $Spin )
					Call-Update
				##	Pace
					If ( $Pace -ne 'Turbo' ) { Call-Display }
					If ( $Pace -eq  'Manual' ) { Read-Host "`n`n`n`n$(" " * (10)) Next" }
					If ( $Pace -eq  'Turbo' ) { $LastRA = 99999  }
					If ( $Pace -eq  'Sleep' ) { Sleep $SleepTime }
					If ( $Gob.Count -ge $T ) {
						Call-SwitchBets $T $S
					}
				}## END Foreach Spin
				##	Summary
				$Rob = "" | Select-Object -Property Site, Date, Units, Open, Method, Spins, Track , 'Switch%', Lowest, Highest, Cash
				$splitRA = $GetData.Name.Split(".")
				$Rob.Site		= $splitRA[1]
				$Rob.Date		= $splitRA[2]
				$Rob.Units		= $Units
				$Rob.Open	   = $OpeningBet
				$Rob.Method		= $BetMethod
				$Rob.Spins		= $Gob.Count
				$Rob.'Switch%'	= $S
				$Rob.Track		= $T
				$Rob.Lowest		= $CashLo
				$Rob.Highest	= $CashHi
				$Rob.Cash		= $Cash
				If ( $Pace -ne 'Turbo' ) { $Rob | Format-Table * }
				$TotalLoops = ( $ShiftPercent.Count *  $TrackingLast.Count)
				$AuditCounter++
				[int]$progress =  ($AuditCounter/$TotalLoops)*100
				$Min = $Timer.Elapsed.Minutes
				Write-Host -n	-f y	"$progress`%     "
				Write-Host -n	-f c	"$AuditCounter of $TotalLoops     "
				Write-Host		-f w	"$Min Minutes"
				If ( $Pace -eq 'Turbo' ) { sleep 1 }
				If ( $Pace -eq 'Manual') { Read-Host }
				If ( $Pace -eq 'Sleep') { Sleep $SleepTime }
				##	Write Summary
				If ( $WriteSummary) {
					$CsvName	 = ( $splitRA[1] + '.' + $splitRA[2] + '.csv')
					[object]$Rob | export-csv -append $CsvName -NoTypeInformation
				}
			##	Reset Variables
			$Gob = [System.Collections.ArrayList] @() ;
			Call-Initialie
			}##	 END	FOREACH	$TRACKINGRA
		}##	 END	FOREACH	PercentLimit
		$Rob | Format-Table *
		##	Runtime
		$Sec = '{0:00}' -f ($Timer.Elapsed.Seconds)
		$Min = '{0:00}' -f ($Timer.Elapsed.Minutes)
		Write-Host  "`n`n     Runtime:" ( '{0}:{1}' -f $Min,$Sec ) "`n" -nonewline -f DarkGray
		##	▲	END AUDIT
	}##▲	END Mode
}## END MainScript

##	Settings	____________________________________________________________________________________________________
#<#
#	$Mode = 'Play'
	$SaveToFile = 0
#>

<#
#	$Mode = 'Audit'
		$Pace = 'Manual' ;
	#	$Pace = 'Sleep'; $SleepTime = .5
	#	$Pace = 'Turbo'
		$WriteSummary = 0
#>
##	Settings	____________________________________________________________________________________________________

<#
$AllowExit	= 1 ; $Site = '888' ; $Betone = 12 ; $OpeningBet = 5 ; $Units = 5 ;
# $ParoliLimit = 5;
#If ( $BetMethodRA -eq 'Paroli3' ) { $ParoliLimit = 3; }
#If ( $BetMethodRA -eq 'Paroli5' ) { $ParoliLimit = 5 ; }
If ( $Mode -eq 'Play' ) { ## Play
	$T = 9999  <#Tracking#> ;# $S = -33  <# SwitchPercent.. Negative= No Switching  #> ; $LastRA = 5,6,7,8,10,15,20,24,36,40 ; }
<#
If ( $Mode -eq 'Audit' ) { ## Audit
	Remove-Item *.csv -exclude "Save*"
	#	GetData  8 Choices:        62 OLG ,96 888 ,132 888 ,137 OLG,198 OLG,302,419 888 ,539 888
	# Notes on Choices
##▼▼
	<#

	62
		one 12.. no switching   Up2  $58
		one 13.. no switching   Up2  -$57
		one 23.. no switching   Up2  $57
		 4..40  and 4..40 took 23 minutes


	96

	132
	   Tracking POSITIVE  9, 5, 11, 36, 29, 30, 31,33, 4, 14, 19, 37, 38, 21, 27, 16, 34, 35, 40, 22, 32, 7, 1

	137
	   Tracking POSITIVE  12, 28, 29, 21, 27, 22, 24, 30, 31, 34, 36, 23, 32, 33, 35, 37, 40, 17, 25, 38, 9, 39, 11, 10, 19, 26, 18, 15, 14, 20

	198  4..40  and 4..40 took 26 minutes
	   Tracking POSITIVE  26,12,23,27, 7,33,32,34,35,36,9,25,37,39,11,38,40,13,8,10,28,14,4,31,6,16,22,24,15,21,20,

	
	302  4..40  and 4..40 took 26 minutes



	419
	539
		Betone 23 is the only one that makes money on its own.
	#>	
	##▲ 	END Notes
<#
	$GetData = Get-ChildItem -af 96* ; [System.Collections.ArrayList] $Data = Get-Content $GetData
	$LastRA = 6,18,36,50 ; #	$LastRA = 9999  ##	No Display of Percentages
#	$ShiftPercent = @(9999)  <# No Shifting #> ; $TrackingLast = @(9999)  <# No Tracking #>
#	$ShiftPercent = @(1..50) ;	$TrackingLast = @(4..50)
#	$ShiftPercent = @(18) ;	$TrackingLast = @(10)
#}	##	END Mode Audit

#>
##▲

## Mysql LOAD DATA
##▼▼

<#
LOAD DATA
    [LOW_PRIORITY | CONCURRENT] [LOCAL]
    INFILE 'file_name'
    [REPLACE | IGNORE]
    INTO TABLE tbl_name
    [PARTITION (partition_name [, partition_name] ...)]
    [CHARACTER SET charset_name]
    [{FIELDS | COLUMNS}
        [TERMINATED BY 'string']
        [[OPTIONALLY] ENCLOSED BY 'char']
        [ESCAPED BY 'char']
    ]
    [LINES
        [STARTING BY 'string']
        [TERMINATED BY 'string']
    ]
    [IGNORE number {LINES | ROWS}]
    [(col_name_or_user_var
        [, col_name_or_user_var] ...)]
    [SET col_name={expr | DEFAULT},
        [, col_name={expr | DEFAULT}] ...]

#>

##▲
## TODO list
##▼▼
<#

find a decent free website
check dns on namecheap
add on domain at infinityfree


$Working on:  
	write tracking value and switching value to screeen in audit
	write tracking value and switching value to screeen in audit
	further check audit mode
	save values for  12, 13, 23 with no tracking or switching to compare against
#>	


## Working Query
#. D:\Documents\WindowsPowershell\sql.ps1 -Query "select * from spin"

#TODO		## Need to add something that allows my to change manually 

	#TODO		## progressive bets?   half progressive?  Martingale ??
	#TODO		## Change paroli to take one press one

#>
##▲

 ## System Variables √
##▼▼
<#
Set-Variable 'AllowExit'	-value 0
Set-Variable 'AuditCounter'	-value 0
Set-Variable 'BetLo'
Set-Variable 'BetMed'
Set-Variable 'BetHi'
Set-Variable 'BetLold'
Set-Variable 'BetMold'
Set-Variable 'BetHold'
Set-Variable 'Betone'
Set-Variable 'Cash'
Set-Variable 'CashOld'
Set-Variable 'CashLo'		-value 0
Set-Variable 'CashHi'		-value 0
#Set-Variable 'Mode'			-value 'Play'
Set-Variable 'OpeningBet'
Set-Variable 'Pace'
Set-Variable 'ParoliCount'	-value 0
Set-Variable 'ParoliLimit'	-value 3
Set-Variable 'SaveToFile'	-value 0
Set-Variable 'Site'			-value 0
Set-Variable 'Units'
Set-Variable 'ValidSpin'
Set-Variable 'WinCount'		-value 0
Set-Variable 'LoseCount'	-value 0

$RBhash = [Ordered] @{
		##▼▼
	0  = 'green'
	1	= 'red'
	2	= 'black'
	3	= 'red'
	4	= 'black'
	5	= 'red'
	6	= 'black'
	7	= 'red'
	8	= 'black'
	9	= 'red'
	10	= 'black'
	11	= 'black'
	12 = 'red'
	13	= 'black'
	14	= 'red'
	15	= 'black'
	16	= 'red'
	17	= 'black'
	18	= 'red'
	19	= 'red'
	20 = 'black'
	21 = 'red'
	22 = 'black'
	23 = 'red'
	24 = 'black'
	25 = 'red'
	26 = 'black'
	27 = 'red'
	28 = 'black'
	29 = 'black'
	30 = 'red'
	31 = 'black'
	32 = 'red'
	33 = 'black'
	34 = 'red'
	35 = 'black'
	36 = 'red'
}	
##▲
$Gob = [system.collections.arrayList] @()
$Timer =  [system.diagnostics.stopwatch]::startnew()
$WinRA = [system.collections.arrayList] @()
#$TrackingRA = [system.collections.arrayList] @()
$LastRA = @()
#>
##▲
##▲
## Just folding √
##▼▼
##▲


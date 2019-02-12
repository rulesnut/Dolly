Clear-Host ;

<#
$Working on:  
	write tracking value and switching value to screeen in audit
	write tracking value and switching value to screeen in audit
	further check audit mode
	save values for  12, 13, 23 with no tracking or switching to compare against
#>	


#TODO		## Need to add something that allows my to change manually 

	#TODO		## progressive bets?   half progressive?  Martingale ??
	#TODO		## Change paroli to take one press one

 ## Variables	√
##▼▼
Set-Variable 'AllowExit'	-value 0
Set-Variable 'AuditCounter'	-value 0
Set-Variable 'BetLo'
Set-Variable 'BetMed'
Set-Variable 'BetHi'
Set-Variable 'BetLold'
Set-Variable 'BetMold'
Set-Variable 'BetHold'
Set-Variable 'BetZone'
Set-Variable 'Cash'
Set-Variable 'CashOld'
Set-Variable 'CashLo'		-value 0
Set-Variable 'CashHi'		-value 0
Set-Variable 'Mode'			-value 'Play'
Set-Variable 'OpeningBet'
Set-Variable 'Pace'
Set-Variable 'ParoliCount'	-value 0
Set-Variable 'ParoliLimit'	-value 3
Set-Variable 'SaveToFile'	-value 0
Set-Variable 'Site'			-value 0
Set-Variable 'Units'
Set-Variable 'ValidSpin'

$Gob = [system.collections.arrayList] @()
$Timer =  [system.diagnostics.stopwatch]::startnew()
$WinRA = [system.collections.arrayList] @()
#$TrackingRA = [system.collections.arrayList] @()
$LastRA = @()

##▲
$MainScript = {
	## Initialize()
##▼▼
	Function Call-Initialize {
		If ( $BetZone -eq 12 ) {
			$script:BetLo  = $OpeningBet
			$script:BetMed = $OpeningBet
			$script:BetHi  = 0
			$script:Cash = 0
			$script:CashHi = 0
			$script:CashLo = 0
		}	Elseif ($Betzone -eq 13 ) {
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
	}	##▲	END Call-Initialize()
	## Spin Validate()
##▼▼
	Function Call-SpinValidate {
		If ( $AllowExit ) { If ( $spin -eq 't' -OR $spin -eq 'tt' -OR $spin -eq 'rr' ) { exit } }
		If ( $spin -match '^[0-9]$' -OR $spin -match '^[1-2][0-9]$' -OR $spin -match '^[3][0-6]$' )  {
		} Else { Write-Host -f Red " [ NOT VALID NUMBER ]"  ; Start-Sleep 1 ; Clear-Host ; Continue ; }
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
		##▼ ▼
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
				Default { Write-Host 'Houston... Bet Up2' ; exit }
			} ## 	END Switch
		}##	▲	END UP2
		## Double
		##▼▼
		If ( $BetMethod -eq 'Double' ) {
			Switch ( $WinRA[-1] ) {
				## Lose
				{ $_ -eq 'L12' } { $script:BetLo  = ( $BetLo + ( $BetLo * 2 ) ) ; $script:BetMed  = ( $BetMed + ( $Betmed * 2 ) ) }
				{ $_ -eq 'L13' } { $script:BetLo  = $BetLo +  ( 2 * $Units ) ; $script:BetHi  = $BetHi  + ( 2 * $Units ) }
				{ $_ -eq 'L23' } { $script:BetMed = $BetMed + ( 2 * $Units ) ; $script:BetHi  = $BetHi  + ( 2 * $Units ) }
				## Win
				{ $_ -eq 'W12' } {
					$script:BetLo = $OpeningBet
					$script:BetMed = $OpeningBet
				}
				{ $_ -eq 'W13' } {
					$script:BetLo = $OpeningBet
					$script:BetHi = $OpeningBet
				}
				{ $_ -eq 'W23' } {
					$script:BetMed = $OpeningBet
					$script:BetHi = $OpeningBet
				}
				Default { Write-Host 'Houston... Bet Double ' ; exit }
			} ## 	END Switch
		}##	▲	END UP2
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
	
		If ( $BetMethod -eq 'Paroli' ) {
			Switch ( $WinRA[-1] ) {
				## Win
				{ $_ -eq 'W12' } {
					If ( $ParoliCount -lt $ParoliLimit ) {
					 $script:BetLo  = ( $BetLo * 2 )  ;
					 $script:BetMed  = ( $BetMed * 2 )  ;
					 $script:ParoliCount ++
					} Else {
						$script:BetLo = $OpeningBet
						$script:BetMed = $OpeningBet
					}
				}
				{ $_ -eq 'W13' } {
					If ( $ParoliCount -lt $ParoliLimit ) {
					 $script:BetLo  = ( $BetLo * 2 )  ;
					 $script:BetHi  = ( $BetHi * 2 )  ;
					 $script:ParoliCount ++
					} Else {
						$script:BetLo = $OpeningBet
						$script:BetHi = $OpeningBet
					}
				}
				{ $_ -eq 'W23' } {
					If ( $ParoliCount -lt $ParoliLimit ) {
					 $script:BetMed  = ( $BetMed * 2 )  ;
					 $script:BetHi  = ( $BetHi * 2 )  ;
					 $script:ParoliCount ++
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
		}	##	▲	END LAST()
	## SwitchBets()
##▼▼
	Function Call-SwitchBets ( $T , $S )  {
		[int] $lo = 0
		[int] $med = 0
		[int] $hi = 0
		## Get Percentages
		Foreach ( $i in $Gob[-$T..-1] ) {
			If ( $i -in 1..12 )  { $lo ++ }
			ElseiF ( $i -in 13..24 ) { $med ++}
			ElseIf ( $i -in 25..36 ) { $hi ++ }
			[int] $Plo = ( $lo / $T * 100 )
			[int] $Pmed = ( $med / $T * 100 )
			[int] $Phi = ( $hi / $T * 100 )
		}
		## Get Betzone
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
		Switch ( $Betzone ) {
			{ $_ -eq 12 -AND $Plo -le $S  } {
				$script:BetZone = 23
				$script:BetHi = $BetLo
				$script:BetHold = $BetLold
				$script:Betlo = 0
				$script:BetLold = 0
				Call-DisplaySwitch
				BREAK
			}
			{ $_ -eq 12 -AND $Pmed -le $S  } {
				$script:BetZone = 13
				$script:BetHi = $BetMed
				$script:BetHold = $BetMold
				$script:Betmed = 0
				$script:BetMold = 0
				Call-DisplaySwitch
				BREAK
			}
			{ $_ -eq 13 -AND $Plo -le $S  } {
				$script:BetZone = 23
				$script:BetMed = $BetLo
				$script:BetMold = $BetLold
				$script:BetLo = 0
				$script:BetLold = 0
				Call-DisplaySwitch
				BREAK
			}
			{ $_ -eq 13 -AND $Phi -le $S  } {
				$script:BetZone = 12
				$script:BetMed = $BetHi
				$script:BetMold = $BetHold
				$script:BetHi = 0
				$script:BetHold = 0
   			Call-DisplaySwitch
   			BREAK
			}
			{ $_ -eq 23 -AND $Pmed -le $S  } {
				$script:BetZone = 13
				$script:BetLold = $BetMold
				$script:BetLo = $BetHi
				$script:BetMed = 0
				$script:BetMold = 0
				Call-DisplaySwitch
				BREAK
			}
			{ $_ -eq 23 -AND $Phi -le $S  } {
				$script:BetZone = 12
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
##▼ ▼
	Function Call-Display {
		## Tracking/Switching
##▼▼
		Write-Host -n -f darkGray `n' Tracking Spins: '
		Write-Host -n $T
		Write-Host -n -f darkGray '    Switching: '
		If ($S -lt 0 ) { fff 'Never' } Else { Write-Host $S`% }
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
		Switch ( $Betzone ) {
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
		If ( $Betzone -eq 12) {
			Write-Host -n -f yellow $BetLo
			$gap = $BetLo.ToString().Length
			Write-Host -n $( " " * ( 8 - $gap ) )
			Write-Host -n -f yellow $BetMed
		}
		If ( $Betzone -eq 13) {
			Write-Host -n -f yellow $BetLo
			$gap = $BetLo.ToString().Length
			Write-Host -n $( " " * ( 17 - $gap ) )
			Write-Host -n -f yellow $BetHi
		}
		If ( $Betzone -eq 23) {
			Write-Host -n -f yellow "       " $BetMed
			$gap = $BetMed.ToString().Length
			Write-Host -n $( " " * ( 9 - $gap ) )
			Write-Host -n -f yellow $BetHi
		}
##▲
		## Paroli
		If ( $ParoliLimit -gt 0 ) {
				fff `n'this is paroliCount' $ParoliCount
		}



#TODO mm

	}##▲	END Call-Display
	## Mode		Main Script
			##▼▼
	If ( $Mode -eq 'Play') {
							##	Play
##▼ ▼
		Call-Initialize
		While (1) {
			If ( $Gob.count -eq 0 ) { Write-Host  "`n BetZone: $BetZone  Units: $Units Inital Bet: $OpeningBet"; Write-Host -n "    " } Else { Call-Display }
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
							##	Audit
##▼▼
		Call-Initialize
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
				$AuditCounter ++
				[int]$progress =  ($AuditCounter/$TotalLoops)*100
				$Min = $Timer.Elapsed.Minutes
				fff -n	-f y	"$progress`%     "
				fff -n	-f c	"$AuditCounter of $TotalLoops     "
				fff		-f w	"$Min Minutes"
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
			Call-Initialize
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

	$Mode = 'Play'
		$SaveToFile = 0
	$Mode = 'Audit'
		$Pace = 'Manual' ;
	#	$Pace = 'Sleep'; $SleepTime = .5
	#	$Pace = 'Turbo'
		$WriteSummary = 0

##	Settings	____________________________________________________________________________________________________


$AllowExit	= 1 ; $Site = '888' ; $BetZone = 12 ; $OpeningBet = 5 ; $Units = 1 ;
$BetMethodRA = 'Up2' <# 0 #>, 'Double' <# 1 #>, 'Paroli3' <# 2 #>,'Paroli5' <# 3 #>; $BetMethod = $BetMethodRA[3] ; # $ParoliLimit = 5;
If ( $BetMethodRA -eq 'Paroli3' ) { $ParoliLimit = 3; }
If ( $BetMethodRA -eq 'Paroli5' ) { $ParoliLimit = 5 ; }
If ( $Mode -eq 'Play' ) { ## Play
	$T = 20  <#Tracking#> ; $S = 33  <# SwitchPercent.. Negative= No Switching  #> ; $LastRA = 5,6,7,8,10,15,20,24,36,40 ; }
If ( $Mode -eq 'Audit' ) { ## Audit
	Remove-Item *.csv -exclude "Save*"
	#	GetData  8 Choices:        62 OLG ,96 888 ,132 888 ,137 OLG,198 OLG,302,419 888 ,539 888
	# Notes on Choices
##▼▼
	<#

	62
		zone 12.. no switching   Up2  $58
		zone 13.. no switching   Up2  -$57
		zone 23.. no switching   Up2  $57
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
		Betzone 23 is the only one that makes money on its own.
	#>	
	##▲ 	END Notes
	$GetData = Get-ChildItem -af 96* ; [System.Collections.ArrayList] $Data = Get-Content $GetData
	$LastRA = 6,18,36,50 ; #	$LastRA = 9999  ##	No Display of Percentages
#	$ShiftPercent = @(9999)  <# No Shifting #> ; $TrackingLast = @(9999)  <# No Tracking #>
#	$ShiftPercent = @(1..50) ;	$TrackingLast = @(4..50)
	$ShiftPercent = @(18) ;	$TrackingLast = @(10)
}	##	END Mode Audit
& $MainScript

## Working Query
#. D:\Documents\WindowsPowershell\sql.ps1 -Query "select * from wp_users"

#>

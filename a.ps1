Clear-Host ; Write-Host;
## progressive  half progressive  double on loss
##	▼▼ Class Definition
Class Dozens {
	## Properties
	$TimerObj =  [system.diagnostics.stopwatch]::startnew() ; $Gob = [System.Collections.ArrayList] @() ; $WinsRA = [System.Collections.ArrayList] @()
	[int] $BetZone ; [int] $Tracking ; [int] $PercentLimit ; [int] $OpeningBet ; [int] $Units ;
	[int] $Bank ; [int] $HighBank ;  [int] $LowBank ; [int] $BetTotal ; [int] $BetLo ; [int] $BetMed ; [int] $BetHi ; [string] $WinLose ;
	## Methods
	[Void] WinOrLose() {	## ▼▼  √
		If ( ($this.Gob).Count -gt 0 ) {
			Switch ( $this.Gob[-1] ) {
				{ $_ -in 0 } { $this.WinLose = 'L' ; BREAK }  ##	Spin 0
				{ $_ -in 1..12 } {  ##	Spin Lo
					If  ( $this.BetZone -eq 12 ) { $this.WinLose = 'W'; BREAK }
					Elseif ( $this.BetZone -eq 13 ) { $this.WinLose = 'W' ; BREAK }
					Else { $this.WinLose = 'L'; BREAK }
				}
				{ $_ -in 13..24 } { ##	Spin Med
					If  ( $this.BetZone -eq 12 ) { $this.WinLose = 'W' }
					Elseif ( $this.BetZone -eq 13 ) { $this.WinLose = 'L' }
					Else {$this.WinLose = 'W'; BREAK }
				}
				{ $_ -in 25..36 } { ##	Spin Hi
					If  ( $this.BetZone -eq 12 ) { $this.WinLose = 'L' }
					Elseif ( $this.BetZone -eq 13 ) { $this.WinLose = 'W' }
					Else {$this.WinLose = 'W'; BREAK }
				}
			} ##	END Switch
				$this.WinsRA += $this.WinLose
		} ##	END If
	}	## ▲	END METHOD
	[Void] Bets( $Pace ) {	##	▼▼  √
		## Original Bet
		$lo = ($this.BetLo * $this.Units)
		$med = ($this.BetMed * $this.Units)
		$hi = ($this.BetHi * $this.Units)
		if ( ($this.Gob).Count -eq 0) {
			$lo =  $this.OpeningBet
			$med =  $this.OpeningBet
			$hi =  $this.OpeningBet
		}
		## Remove unused BetZone
		If ( $this.BetZone -eq 12 ){ Clear-Variable hi ; $this.BetHi  = 0 ; $hilen =  0 }
		If ( $this.BetZone -eq 13 ){ Clear-Variable med ; $this.BetMed = 0 ; $medlen = 0 }
		If ( $this.BetZone -eq 23 ){ Clear-Variable lo  ; $this.BetLo  = 0 ; $lolen =  0 }
		##	Calculate Bet Total
		$this.BetTotal =  $lo + $med + $hi
		$dollarsbet  = '{0:C0}' -f $this.BetTotal
		##	Display 
		If ( $Pace -gt 0 ) {
			Write-Host -f darkgreen "     Lo       Med       Hi          Bet"
			$lo  = '{0:0}' -f $lo
			If ( $lo -gt 0 ) {$len = $lo.tostring().length } Else { $len = 0 } 
			For ($i=1; $i -lt ( 8 - $len ) ; $i++) { Write-Host -no " " } ## Before Lo
			Write-Host -n -f White $lo
			If ( $med -gt 0 ) {$len = $med.tostring().length } Else { $len = 0 }
			For ($i=1; $i -lt ( 11 - $len ); $i++) { Write-Host -no " " } ## Before Med
			Write-Host -n -f White $med
			If ( $hi -gt 0 ) {$len = $hi.tostring().length } Else { $len = 0 } 
			For ($i=1; $i -lt ( 10 - $len ); $i++) { Write-Host -no " " } ## Before Hi
			Write-Host -n -f White $hi
			$len = $dollarsbet.tostring().length
			For ($i=1; $i -lt ( 14 - $len ); $i++) { Write-Host -no " " } ## Before DollarsBet
			Write-Host -n  -f White $dollarsbet
		} ##	End Pace	
	
	}	## ▲	END METHOD
	[Void] Cash( $Pace )	{	##	▼▼  √
	If ( $Pace -gt 0 ) {
			If ( $this.WinsRA[-1] -eq 'W' ){
				Write-Host -n -f Green ' You Won! ' ;
				Write-Host -n -f Green ($this.BetTotal/2) 
			} Else { 
				Write-Host -n -f   Red 'You Lost! ' ;
				Write-Host -n -f Red (-$this.BetTotal) 
			}
			Write-Host -n -f Darkgray  "    Cash: "
			$dollars  = '{0:C0}' -f $this.Bank
			If ( $this.Bank -ge 0 ) { $color = 'green' } Else { $color = 'red' }
			$len =  $Dollars.tostring().length
			For ( $i=1; $i -lt ( 7 - $len ) ; $i++ ) { Write-Host -no " " } # Spaces After 'Bank'
			Write-Host -n -f $color $dollars
			If ( ($this.Gob).Count -eq 0 ) {	# no bets so far
				$indent = 2
				$length = 39
				$color = 'DarkGray'
				for ($i=1; $i -lt $indent ; $i ++) { Write-Host -n -f $color " " }
				for ($i=1; $i -lt $length ; $i ++) { Write-Host -n -f $color "_" }
		}
	}
	}	## ▲	END METHOD
	[Void] HighLow( $Pace )	{	##	▼▼  √
		$lowcash = 0 ; $lowcashLen = 0 ; $highcash = 0 ; $highcashLen = 0 ;
		If ( $this.Gob.Count -gt 0 ) {
			If  ( ( [int] $this.Bank ) -le ( [int] $this.LowBank ) ) {
				$this.LowBank = $this.Bank
			} ElseIf  ( ( [int] $this.Bank ) -gt ( [int] $this.HighBank ) ) {
				$this.HighBank = $this.Bank
			}	
			IF ( $Pace -gt 0 ) {	
				Write-Host -n -f DarkGray '           Lo: '
				$lowcash  = '{0:C0}' -f $this.LowBank
				$lowcashLen =  $lowcash.tostring().length
				For ( $i=1; $i -lt ( 7 - $lowcashLen ) ; $i++ ) { Write-Host -no " " } ;  ##	Spaces After	'Lo:'   √
				Write-Host -n -f DarkGray  $lowcash
				For ( $i=1; $i -lt ( 7 - $lowcashLen ) ; $i++ ) { Write-Host -no " " } ;  ##	Spaces Before	'Hi'   √
				Write-Host -n -f DarkGray  'Hi: '
				$highcash  = '{0:C0}' -f $this.HighBank
				$highcashLen =  $highcash.tostring().length
				For ( $i=1; $i -lt ( 7 - $highcashLen ) ; $i++ ) { Write-Host -no " " } ;  ##	Spaces After	'Hi:'  √
				Write-Host  -f DarkGray  $highcash
			}	
		} ##	END If Gob.Count
	}	## ▲	END METHOD
	[Void] LastPrior( $Pace ) {	## ▼▼  √
		If ( $Pace -gt 0 ) {
			If ( ( $this.Gob ).Count -gt 0 ) {	
				##	Color
				If ( ($this.Gob).Count -gt 0 ) {
					$len = $this.Gob[-1].tostring().length
					For ( $i=1; $i -lt ( 5 - $len ) ; $i++ ) { Write-Host -no " " } ;  ##	Spaces After the word	'Last'
					Write-Host -n -f DarkGray '  Dolly: '
					Write-Host -n $this.Gob[-1]
					For ( $i=1; $i -lt 4 ; $i++ ) { Write-Host -no " " } ;  ##	Spaces After	Gob[-1]
				}
			}
#			If ( $Pace -eq  1 ) { Sleep 1 }
		}
	}	## ▲	END METHOD
	[Void] Last( $num, $Pace ) {	## ▼▼  √
		$loP = $medP = $hiP = $null  ## Percentage
		$PercentRA = $lop, $medP, $hiP
		$loCount = 0
		$medCount = 0
		$hiCount = 0
		##	Get Individual Count
		##	▼▼
		If ( $num  -eq 1 ) {
			Foreach ( $item in $this.Gob ) {
				Switch ( $item ) {
					{ $_ -in 0 } { BREAK }  ##	Spin 0
					{ $_ -in 1..12 }  { $loCount ++  ; BREAK }	##	Lo
					{ $_ -in 13..24 } { $medCount ++ ; BREAK }	##	Med
					{ $_ -in 25..36 } { $hiCount ++  ; BREAK }	##	Hi
				}
			}
			If ( ($this.Gob).Count -gt 0 ) {
				$loP  = ( $loCount /  ($this.Gob).Count )
				$medP  = ( $medCount /  ($this.Gob).Count )
				$hiP  = ( $hiCount /  ($this.Gob).Count )
			}
		} Else {
			If (  ($this.Gob).Count -ge 0 -AND ($this.Gob).Count -ge $num ) {
				Foreach ( $item in ( $this.Gob[-$num..-1]) ) {
					Switch ( $item ) { { $_ -in 0 } { BREAK }     ##	0
						{ $_ -in 1..12 }  { $loCount ++  ; BREAK }	##	Lo
						{ $_ -in 13..24 } { $medCount ++ ; BREAK }	##	Med
						{ $_ -in 25..36 } { $hiCount ++  ; BREAK }	##	Hi
					}
				}
					$loP  = ( $loCount /  $num )
					$medP = ( $medCount / $num )
					$hiP  = ( $hiCount /  $num )
			}
		}	##	▲ END INDIVIDUAL COUNT
		##	Display
		##	▼▼
		If ( $Pace -gt 0 ) {
			$loColor = $medColor = $hiColor = 'cyan'
			$PercentRA = $loP, $medP, $hiP
		## Highest
			IF ( ($loP -gt $medP ) -AND ( $loP -gt $hiP)  ) { $loColor  =  'Green' }
			IF ( ($medP -gt $loP ) -AND ( $medP -gt $hiP)  ) { $medColor  =  'Green' }
			IF ( ($hiP -gt $loP ) -AND ( $hiP -gt $medP)  ) { $hiColor  =  'Green' }
			## Lowest
			IF ( ($loP -lt $medP ) -AND ( $loP -lt $hiP)  ) { $loColor  =  'Red' }
			IF ( ($medP -lt $loP ) -AND ( $medP -lt $hiP)  ) { $medColor  =  'Red' }
			IF ( ($hiP -lt $loP ) -AND ( $hiP -lt $medP)  ) { $hiColor  =  'Red' }
			$loCount  = '{0:0}' -f  $loCount ; $medCount  = '{0:0}' -f  $medCount ; $hiCount  = '{0:0}' -f  $hiCount
			$loP  = '{0:P0}' -f  $loP ; $medP  = '{0:P0}' -f  $medP ; $hiP  = '{0:P0}' -f  $hiP
			If ( ( ($this.Gob).Count -gt 1 -AND $num -eq 1) -OR ($this.Gob).Count -ge $num ) {
				Write-Host
				## Lo
				$len = $loCount.Length ; For ( $i=1; $i -lt ( 7 - $len ) ; $i++ ) { Write-Host -no " " } ##	Spaces Before LoCount
				Write-Host -n -f DarkGray $loCount;
				$len = $loP.Length ; For ( $i=1; $i -lt ( 5 - $len ) ; $i++ ) { Write-Host -no " " } ##	Spaces Before LoP
				Write-Host -n -f $loColor $loP
				## Med
				$len = $medCount.Length ; For ( $i=1; $i -lt ( 7 - $len ) ; $i++ ) { Write-Host -no " " } ##	Spaces Before medCount
				Write-Host -n -f DarkGray $medCount
				$len = $medP.Length ; For ( $i=1; $i -lt ( 5 - $len ) ; $i++ ) { Write-Host -no " " } ##	Spaces Before medP
				Write-Host -n -f $medColor $medP
				## Med
				$len = $hiCount.Length ; For ( $i=1; $i -lt ( 7 - $len ) ; $i++ ) { Write-Host -no " " } ##	Spaces Before hiCount
				Write-Host -n -f DarkGray $hiCount
				$len = $hiP.Length ; For ( $i=1; $i -lt ( 5 - $len ) ; $i++ ) { Write-Host -no " " } ##	Spaces Before hiP
				Write-Host -n -f $hiColor $hiP
				## WinRate
				$winRate = $winCount = $text = $null
				If ( $num -eq 1 ){
					Foreach ($item in $this.WinsRA ) { If ($item -eq 'W' ) { $winCount ++ } }
					$WinRate ='{0:P0}' -f ($winCount / $this.Gob.Count)
					$len = $WinRate.Length ; For ( $i=1; $i -lt ( 6 - $len ) ; $i++ ) { Write-Host -no " " } ##	Spaces Before WinRate
					$text = ' ALL'
				} Else {
					Foreach ($item in $this.WinsRA[-$num..-1] ) { If ($item -eq 'W' ) { $winCount ++ } }
					$WinRate ='{0:P0}' -f ( $winCount / $this.Gob[-$num..-1].Count )
					$len = $WinRate.Length ; For ( $i=1; $i -lt ( 6 - $len ) ; $i++ ) { Write-Host -no " " } ##	Spaces Before WinRate
					$text = " $winCount/$num"
				}
				Write-Host -n -f Yellow $Winrate $text
#				If ( $Pace -eq  1 ) { Sleep 1 }
			}
		}	##	▲ END	 IF Pace
	}	## ▲	END METHOD
	[Void] Update() {	## ▼▼  √
		## Update Bank

		If ( $this.WinLose -eq 'W' ) {
			 $this.Bank += ($this.BetTotal/2) 
		 } Else {
		  $this.Bank += -$this.BetTotal
		 }
		## Update Bets
			If ( $this.WinLose -eq  'L' ) {
				$this.BetLo =  $this.BetLo + ( 2 * $this.Units )
				$this.BetMed =  $this.BetMed + ( 2 * $this.Units )
				$this.BetHi =  $this.BetHi + ( 2 * $this.Units )
			} Else {
				$this.BetLo --
				$this.BetMed --
				$this.BetHi --
			}
		If ( $this.BetLo -le $this.OpeningBet ) { $this.BetLo = $this.OpeningBet }
		If ( $this.BetMed -le $this.OpeningBet ) { $this.BetMed = $this.OpeningBet  }
		If ( $this.BetHi -le $this.OpeningBet ) { $this.BetHi = $this.OpeningBet  }
	}	## ▲	END METHOD
	[Void] Switching( $Spin ) {	##	▼▼  √
		$message = "You are already in that BetZone, Ya Dufus"
		If ( $Spin -eq 's12' ) {
			If ( $this.BetZone -eq '12' ) { Write-Host -f Red $Message ; Start-Sleep 2 ; Continue }
			$this.BetZone = 12
			$this.BetLo = $this.BetHi
			$this.BetMed = $this.BetHi
		} ElseIF ( $Spin -eq 's13' ) {
			If ( $this.BetZone -eq '13' ) { Write-Host -f Red $Message ; Start-Sleep 2 ; Continue }
			$this.BetZone = 13
			$this.BetLo = $this.BetMed
			$this.BetHi = $this.BetMed
		} ElseIF ( $Spin -eq 's23' ) {
			If ( $this.BetZone -eq '23' ) { Write-Host -f Red $Message ; Start-Sleep 2 ; Continue }
			$this.BetZone = 23
			$this.BetMed = $this.BetLo
			$this.BetHi = $this.BetLo
		}	
	}	## ▲	END METHOD
	[Void] NoHits() {	## ▼▼  √
		$NoHitsLo = $null; $NoHitsMed = $null ; $NoHitsHi = $null
		If ( ($this.Gob).Count -gt 0 ) {
			For ( $i = 0 ; $i -lt $this.Gob.Count ; $i ++ ) {
				If ( $this.Gob[$i] -eq 0 ) {
					$NoHitsLo ++ 
					$NoHitsMed ++ 
					$NoHitsHi ++ 
				}
				If ( $this.Gob[$i] -in 1..12 ) {
					$NoHitsLo = 0 
					$NoHitsMed ++ 
					$NoHitsHi ++ 
				}
				If ( $this.Gob[$i] -in 13..24 ) {
					$NoHitsLo  ++ 
					$NoHitsMed = 0
					$NoHitsHi ++ 
				}
				If ( $this.Gob[$i] -in 25..36 ) {
					$NoHitsLo  ++ 
					$NoHitsMed ++
					$NoHitsHi = 0
				}
			} ##	END Foreach
			$viewcntr = 10
			If ( $NoHitsLo -ge $viewcntr -OR $NoHitsMed -ge $viewcntr -OR  $NoHitsHi -ge $viewcntr ){
				Write-Host "`n`n`n"
				If ( $NoHitsLo -ge $viewcntr ) {
					Write-Host -n "  No Lo:  " ; Write-Host -f r $NoHitsLo
				}
				If ( $NoHitsMed -ge $viewcntr ) {
					Write-Host -n " No Med:  " ; Write-Host -f r $NoHitsMed
				}
				If ( $NoHitsHi -ge $viewcntr ) {
					Write-Host -n "  No Hi:  " ;  Write-Host -f r $NoHitsHi
				}
			} ##	END If
		} ##	END If
	}	## ▲	END METHOD
	[Void] AutoSwitch( $Pace ) {	## ▼▼  √
		[int] $HighSpins = $null
		[int] $MedSpins = $null
		[int] $LowSpins = $null
		[int] $ForeachIndex = 0
		[int]	$PercentLo = 0
		[int]	$PercentMed = 0
		[int]	$PercentHi = 0
		
		If ( $this.Gob.Count -ge $this.Tracking ) {
			Foreach ( $item in $this.Gob[-$this.Tracking..-1] ) {
				##	Lo
				If ( $item -in 1..12 )  { $LowSpins ++  ; }
				If ( $item -in 13..24 ) { $MedSpins ++  ; }
				If ( $item -in 25..36 ) { $HighSpins ++ ; }
				$PercentLo = ( $LowSpins / $this.Tracking * 100 )
				$PercentMed = ( $MedSpins / $this.Tracking * 100 )
				$PercentHi = ( $HighSpins / $this.Tracking * 100 )
			}
	
			$RA = [int] $this.BetLo, [int] $this.BetMed, [int] $this.BetHi
			$Max = ($RA | Measure -Maximum).Maximum
			
			If ( $PercentLo -lt $this.PercentLimit ) {
				$this.Betzone = 23
				[int]	$this.BetLo  = $Max
				[int] $this.BetMed = $Max
				[int]	$this.BetHi  = $Max
			}
			If ( $PercentMed -lt $this.PercentLimit ) {
				$this.Betzone = 13
				[int]	$this.BetLo  = $Max
				[int] $this.BetMed = $Max
				[int]	$this.BetHi  = $Max
			}
			If ( $PercentHi -lt $this.PercentLimit ) {
				$this.Betzone = 12
				[int]	$this.BetLo  = $Max
				[int] $this.BetMed = $Max
				[int]	$this.BetHi  = $Max
			}

			If ( $Pace -gt 0 ) {
				For ( $i = 0 ; $i -lt ( 2 ) ; $i ++ ) { Write-Host -no "`n" } ;  ##	Blank Lines	√
				Write-Host -n -f DarkGray '     Low: '; Write-Host -n $LowSpins
				Write-Host -n -f DarkGray '      Med: '; Write-Host -n $MedSpins
				Write-Host -n -f DarkGray '     High: '; Write-Host $HighSpins
				Write-Host  -n -f DarkGray "`n`n     Tracking: " ; Write-Host -n  $($this.Tracking) ;
				Write-Host -n -f DarkGray '     Switching Percent: ' ; Write-Host $this.PercentLimit
#			If ( $Pace -eq  1 ) { Sleep 1 }
			}
		} ##	END If Gob.Count
	}	## ▲	END METHOD
} ##	END Class
$OB = [Dozens]::new() ;
## ▲
##	Test Variables
$OB.BetZone = 12
$OB.OpeningBet = 1
$OB.Units = 1
#$InputSite = '888'; $InputDate = 'Nov4'	##  549 Spins	8:11
#$InputSite = '888'; $InputDate = 'Aug12'	##  419 Spins	6:04
#$InputSite = 'OLG'; $InputDate = 'Aug10'	##  198 Spins	2:37
$InputSite = 'OLG'; $InputDate = 'Nov11'	##  137 Spins	1:42
#$InputSite = '888'; $InputDate = 'Nov3'	##   96 Spins	1:00
#$InputSite = 'OLG'; $InputDate = 'Oct29'	##   67 Spins	0:37
$TrackingArray = 5,20,25,35
$PercentArray = 20,30,40
# OLG OCT 29
#1,8,7,22,9,13,31,31,3,23,6,4,11,6,30,18,24,21,25,32,18,5,24,5,20,29,4,9,32,18,34,9,20,26,2,23,25,6,14,17,1,13,15,1,20,11,25,16,22,28,10,27,23,36,15,35,34,26,2,22,35,18
#1,8,7,22,9,13,31,31,3,23,6,4,11,6,30,18,24,21,25,32,18,5,24,5,20,29,4,9,32,18,34,9,20,26,2,23,25,6,14,17,1,13,15,1,20,11,25,16,22,28,10,27,23,36,15,35,34,26,2,22
#1,8,7,22,9,13,31,31,3,23,6,4,11,6,30,18,24,21,25,32,18,5,24,5,20,29,4,9,32,18,34,9,20,26,2,23,25,6,14,17,1,13,15,1,20,11,25,16,22,28
#1,8,7,22,9,13,31,31,3,23,6,4,11,6,30,18,24,21,25,32,18,5,24,5,20,29,4,9,32,18,34,9,20,26,2,23,25,6,14,17
#1,8,7,22,9,13,31,31,3,23,6,4,11,6,30,18,24,21,25,32,18,5,24,5,20,29,4,9,32,18
#1,8,7,22,9,13,31,31,3,23,6,4,11,6,30,18,24,21,25,32
#1,8,7,22,9,13,31,31,3,23
$DataFirstLine = 1
$DataLastLine = 9999
$Switch = $UseSwitching = 0
$SaveResults = 0
$Pace = 1
##	▼ ▼ Pace
##	   0	'Turbo'
##		1 { 'Read-Host ' }
##		2 { 'Slower yet  ' }
##		3 { 'very slow '}
##		4 { ' Read-Host Each Line '}
## ▲
##	▼ ▼ Setup Data
$InputDir =  "D:\GitHub\Manual\"
$ResultsDir = "D:\GitHub\Auto\"
$RawDataFileName = ( $InputDir + $InputSite + "." + $InputDate + ".txt" )
$OutputFile = ( $ResultsDir + $InputSite + '.' + $InputDate + '.csv')
if ( Test-Path $OutputFile ) { 		Remove-Item $OutputFile	}
[System.Collections.ArrayList] $RawData = Get-Content $RawDataFileName
If ( $DataFirstLine -gt $DataLastLine ) { Write-Host -f r "`n`n        `$DataFirstLine is greater than `$DataLastLine, Ya Dufus  `n`n " ; exit; }
If ( $DataLastLine -ge $RawData.Count ) { $DataLastLine = $RawData.Count }
[Array] $Data = $RawData[ ($DataFirstLine-1)..($DataLastLine -1 )]
If ( $DataLastLine -eq $RawData.Count ) { $DataLastLine = 'EOF' }
If ( $UseSwitching  -eq 0 ) { $Switch = "No" } Else { $Switch = "Yes" }
$StartZone = $OB.BetZone ;

##	Data Sets
	#	62  Spins		OLG	Oct29
	#	96  Spins		888	Nov3
	#	137 Spins		OLG	Nov11
	#	198 Spins		OLG	AUG10
	#	419 Spins		888	Aug12
	#	549 Spins		888	Nov4
## ▲
## Core
Foreach ( $P in $PercentArray ) {
	$OB.PercentLimit = $P ;
	Foreach ( $T in $TrackingArray ) {
		$OB.Tracking = $T ;
		##	Reset Object
		$OB.Gob = [System.Collections.ArrayList] @() ; $OB.WinsRA = [System.Collections.ArrayList] @()
		$OB.BetLo  = $OB.OpeningBet ; $OB.BetMed = $OB.OpeningBet ;	$OB.BetHi = $OB.OpeningBet ;
		$OB.Bank = 0 ; $OB.LowBank = 0 ; $OB.HighBank = 0 ; $OB.BetTotal = 0
		##	Foreach Spin
		##	▼▼
		Foreach ( $Spin in $Data ) {
			Clear-Host ; Write-Host;
			$OB.Gob += $Spin ;
			$OB.WinOrLose() ;
			$OB.Bets( $Pace ) ;
			$OB.LastPrior( $Pace ) ; 
			$OB.Update() ;
			$OB.Cash( $Pace ) ; 
			$OB.HighLow( $Pace ) ;
			If ( $Pace -gt 0 ) {
				$OB.Last(1, $Pace ) ;
				$OB.Last(30, $Pace ) ;
				$OB.Last(24, $Pace ) ;
				$OB.Last(18, $Pace ) ;
				$OB.Last(15, $Pace ) ;
				$OB.Last(12, $Pace ) ;
				$OB.Last(6, $Pace )  ;
			}
			If ( $Pace -eq  1 ) { Read-Host "`n`n`n`n`n     Next" }
			If ($UseSwitching ) { $OB.AutoSwitch( $Pace ) }
#			If ( $Pace -eq 1 ) { Read-Host "`n`n    Next Spin" }
#			If ( $Pace -eq 2 ) { Sleep 1 }
		}
		## ▲
		##	Results To Screen
			##	Results Screen Hashtable	▼▼
		$ResultScreenHash = [Ordered] @{
			'   Site: '	=	$InputSite
			'Date: '			=	$InputDate
			'From Line: '	=	$DataFirstLine
			'To Line: '		=	$DataLastLine
			'Start Zone: '	=	$StartZone
			'Start Bet: '	=	$($OB.OpeningBet)
			'Units: '		=	$($OB.Units)
			'Spins: '		=	$($OB.Gob.Count)
			''					=  "`n`n"
			'Switching: '	=	$Switch
			'Tracking: '	=	$($OB.Tracking)
			'% Limit: '		=	$($OB.PercentLimit)
			'Lowest: '		=	$($OB.LowBank)
			'Highest: '		=	$($OB.HighBank)
			'Cash: '			=	$($OB.Bank)
		}	
		$ResultsScreen = ''
		$Results = ''
		## ▲
		foreach ( $item in $ResultScreenHash.GetEnumerator() ) {
			$ResultsScreen += $( $item.Name )
			$ResultsScreen += $( $item.Value )
			$ResultsScreen += "   "
		}
	#	If ( $Pace -gt 0  ) {Clear-Host; Write-Host ; }
	#	If ($Pace -gt 0 ) {
	#		Read-Host  "  Continue"
	#	}		
		##	Results To File
		If ( $SaveResults ) {
			##	Results Hashtable	▼▼
			$ResultsHash = [Ordered] @{
				Site				=	$InputSite
				Date				=	$InputDate
				'Start at Line'=	$DataFirstLine
				'End at Line'	=	$DataLastLine
				'Start Zone'	=	$StartZone
				'Start Bet'		=	$($OB.OpeningBet)
				Units				=	$($OB.Units)
				Spins				=	$($OB.Gob.Count)
				Switching		=	$Switch
				Tracking			=	$($OB.Tracking)
				'% Limit'		=	$($OB.PercentLimit)
				Lowest			=	$($OB.LowBank)
				Highest			=	$($OB.HighBank)
				Cash				=	$($OB.Bank)
			}	
			## ▲
			##	Write Header IF new File ▼▼
			If ( -NOT ( Test-Path -Path $OutputFile ) ) {
				$Header = ''
				foreach ($item in $ResultsHash.GetEnumerator() ) {
					$Header += $($item.Key)
					$Header += ","
				}
			$Header > $OutputFile
			}
			## ▲
			##	Save Result to CSV File ▼▼
			$Results = ''
			foreach ($item in $ResultsHash.GetEnumerator() ) {
				$Results += $($item.Value)
				$Results += ","
			}
			$Results >> $OutputFile
			$ResultsHash.Clear()
			##	▲
		} ##	▲ END IF SaveResults
	#		Read-Host 
	#		Sleep 1
	}	##	END ForEach Tracking
}	##	END ForEach Percentage
##	Display Alerts	▼▼
##	No Switching
If ( -NOT ( $UseSwitching ) ) { Write-Host -f y "`n     No Switching !" ;  }
##	No CSV
If ( -NOT ( $SaveResults ) ) { Write-Host -f y "`n     No Write to CSV !" ;  }
## Runtime
$Sec = '{0:00}' -f ($OB.TimerObj.Elapsed.Seconds)
$Min = '{0:00}' -f ($OB.TimerObj.Elapsed.Minutes)
If ($Min -eq 1 ) {
	Write-Host  "`n`n     Runtime:" ( '{0}:{1}' -f $Min,$Sec ) "`n" -nonewline -f DarkGray
}	
Write-Host  "`n`n     Runtime:" ( '{0}:{1}' -f $Min,$Sec ) "`n" -nonewline -f DarkGray
##	▲
		Write-Host "`n`n$ResultsScreen`n`n`n"
		Write-Host "`n`n$results`n`n`n`n`n"
##TODO  see if you can get a count on total spins for data
##TODO  see if you can get a count on total spins for data


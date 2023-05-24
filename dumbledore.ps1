[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

#Set console windows and buffer size, also disabling the scroll bar

$Host.UI.RawUI.WindowTitle = "Developed by @HollowGrid"

$consoleWidth = 100
$consoleHeight = 38

$WindowSize = New-Object System.Management.Automation.Host.Size ($consoleWidth, $consoleHeight)
$Host.UI.RawUI.WindowSize = $WindowSize

$BufferSize = New-Object System.Management.Automation.Host.Size ($consoleWidth, $consoleHeight)
$Host.UI.RawUI.BufferSize = $BufferSize

####### Here we will Enter The GLOBAL variables for ASCII ART so we dont store them inside the scripts functions
####### Remember to use @" "@ For the ASCII
##  KEEP IN MIND THIS USES ANSI Scape codes to give it color.

$mma = @"
`e[38;5;93m____________________________________________________________________________________________________`e[0m                                                           
`e[38;5;93m||`e[0m      `e[38;5;165mBAD-ToolKit v1.2`e[0m        `e[38;5;93m|`e[0m                                                   
`e[38;5;93m||`e[0m `e[38;5;165mhttps://github.com/`e[0m`e[38;5;118mHollowGrid`e[0m`e[38;5;93m|`e[0m
`e[38;5;93m||______________________________|`e[0m
`e[38;5;93m||`e[0m
`e[38;5;93m||`e[0m
`e[38;5;93m||`e[0m
`e[38;5;93m||`e[0m
`e[38;5;93m||`e[0m
`e[38;5;93m||`e[0m                                                      `e[38;5;171m1. Unlocker`e[0m        `e[38;5;171m2. AD Info Puller`e[0m
`e[38;5;93m||`e[0m `e[38;5;207m                     ██████╗`e[0m                          
`e[38;5;93m||`e[0m `e[38;5;171m                     ██╔══██╗`e[0m                        `e[38;5;171m3. GridWatch`e[0m       `e[38;5;171m4. `e[0m
`e[38;5;93m||`e[0m `e[38;5;165m                     ██████╔╝`e[0m                         
`e[38;5;93m||`e[0m `e[38;5;129m                     ██╔══██╗`e[0m                        `e[38;5;171m5.`e[0m                 `e[38;5;171m6.`e[0m
`e[38;5;93m||`e[0m `e[38;5;93m                     ██║  ██║`e[0m                        
`e[38;5;93m||`e[0m `e[38;5;57m                     ╚═╝  ╚═╝`e[0m                        `e[38;5;171m7. Exit`e[0m            `e[38;5;171m8. Reload Menu`e[0m
`e[38;5;93m||`e[0m
`e[38;5;93m||`e[0m `e[38;5;207m            ███╗   ██╗ ██████╗  ██████╗`e[0m                 
`e[38;5;93m||`e[0m `e[38;5;171m            ████╗  ██║██╔═══██╗██╔════╝`e[0m             
`e[38;5;93m||`e[0m `e[38;5;165m            ██╔██╗ ██║██║   ██║██║`e[0m                  
`e[38;5;93m||`e[0m `e[38;5;129m            ██║╚██╗██║██║   ██║██║`e[0m                  Use -h for help regarding the script.
`e[38;5;93m||`e[0m `e[38;5;93m            ██║ ╚████║╚██████╔╝╚██████╗`e[0m              
`e[38;5;93m||`e[0m `e[38;5;57m            ╚═╝  ╚═══╝ ╚═════╝  ╚═════╝`e[0m             
`e[38;5;93m||`e[0m
`e[38;5;93m||`e[0m
`e[38;5;93m||`e[0m
`e[38;5;93m||`e[0m
`e[38;5;93m||`e[0m
`e[38;5;93m||`e[0m
`e[38;5;93m||`e[0m `e[38;5;93m-/- Tools Loaded: 3`e[0m 
`e[38;5;93m|| -/-`e[0m 
`e[38;5;93m||__________________________________________________________________________________________________`e[0m
`e[38;5;93m||`e[0m                                                                                                 
`e[38;5;93m||__________________________________________________________________________________________________`e[0m

"@


#######
####### End of ASCII Variables


function Show-MainMenu {
    Clear-Host

    Write-Host $mma

    while ($true) {
        Write-Host -NoNewline "`e[38;5;118m BADT-/->`e[0m "
        $choice = (Read-Host).Replace(':', '')
        
        switch ($choice) {
            '1' {
                Run-LockedOutADUser
                Clear-Host
            }
            '2' {
                Run-FinderScript
                Clear-Host
                Write-Host $opt2a
            }
            '3' {
                R-Monitor
                Clear-Host
                Show-MainMenu
            }
            '4' {
                Write-Host "Nothing to see here yet... Under Development"
                Start-Sleep -Seconds 1
                Clear-Host
                Show-MainMenu
            }
            '5' {
                Write-Host "Nothing to see here yet... Under Development"
                Start-Sleep -Seconds 1
                Clear-Host
                Show-MainMenu
            }
            '6' {
                Write-Host "Nothing to see here yet... Under Development"
                Start-Sleep -Seconds 1
                Clear-Host
                Show-MainMenu
            }
            '7' {
                Write-Host "Exiting Script"
                Clear-Host
                exit
            }
            '8' {
                Clear-Host
                Show-MainMenu
            }
            default {
                Write-Host "Invalid Choice. Please try again."
                Start-Sleep -Seconds 2
                Clear-Host
                Show-MainMenu
            }
        }
    }
}


# Function for unlocking users
function Run-LockedOutADUser {
    Clear-Host
    Write-Host $opt1a
            
       do {
         try {
             # Get users that are locked out, excluding rXXpicker accounts
             $lockedOutUsers = search-adaccount -lockedout | Where-Object { $_.samaccountname -notmatch "r\d\dpicker|vEMP" } | Select-Object name, samaccountname, lockedout, passwordexpired
 
             # Check if any locked out users were found
             if ($lockedOutUsers) {
               # Display locked out users
               Write-Host "Locked Out Users:" -ForegroundColor Green
               $lockedOutUsers | Format-Table -AutoSize -Property @{Label="Name"; Expression={$_.name}}, @{Label="Username"; Expression={$_.samaccountname}}, @{Label="Locked Out"; Expression={$_.lockedout}}, @{Label="Password Expired"; Expression={$_.passwordexpired}} | Out-String
             }
            else {
                 Write-Host "No locked out users were found" -ForegroundColor Yellow
 
                 # Prompt user to continue or exit
                 do {
                     $choice = Read-Host "Do you want to Refresh (R) or exit (E)?"
                 } while (($choice -ne "R") -and ($choice -ne "E"))
 
                 if ($choice -eq "E") {
                     break
                 }
                 elseif ($choice -eq "R") {
                     Clear-Host
                     Run-LockedOutADUser
                  }
             }
 
             # Prompt for username to unlock
             $username = Read-Host "Enter the username to unlock (or type 'exit' to return to previous Menu)"
 
             if ($username -eq "exit") {
                 break
             }    
             elseif ($username -eq "R") {
                 Clear-Host
                 Run-LockedOutADUser
             }
             
 
             Write-Host "Unlocking account '$username'..." -ForegroundColor Green
 
             # Unlock specified user
             Unlock-ADAccount $username
 
             Write-Host "Account '$username' has been unlocked" -ForegroundColor Green
             Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 3)
             Clear-Host
             Run-LockedOutADUser
         }
         catch {
             # Catch any errors that occur
             Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
             Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 3)
             Clear-Host
             Run-LockedOutADUser
         }
     } while ($true)
 
     # Return to ADScriptMenu
     Show-MainMenu
 
 }

# Function to run Run-FinderScrip
function Run-FinderScript {
    Clear-Host
    Write-Host $opt2a    
# Loop until user enters "exit"
    while ($true) {
        # Prompt the user to enter the group name or type "exit" to quit
        $groupName = Read-Host "Enter the AD Group Name (or type 'exit' to quit)"

        # Exit the loop if user enters "exit"
        if ($groupName -eq "exit") {
            Show-MainMenu
        }

        # Check if the group exists in Active Directory
        $validGroup = $false
        while (-not $validGroup) {
            try {
                $group = Get-ADGroup $groupName -ErrorAction Stop
                $validGroup = $true
            } catch {
                Write-Host "Error: $($_.Exception.Message)"
                $groupName = Read-Host "Enter the group name (or type 'exit' to quit)"
                
                # Exit the loop if user enters "exit"
                if ($groupName -eq "exit") {
                    Show-MainMenu
                }
            }
        }

        # Get the members of the group
        $members = Get-ADGroupMember $group | Where-Object {$_.objectClass -eq 'user'}

        # Create an empty array to store the results
        $results = @()

        # Loop through each member and retrieve their email address
        foreach ($member in $members) {
            try {
                $user = Get-ADUser $member -Properties EmailAddress -ErrorAction Stop
                $results += [PSCustomObject]@{
                    Name = $user.Name
                    EmailAddress = $user.EmailAddress
                }
            } catch {
                if ($_.Exception.Message -like "*Cannot find an object in AD named:*") {
                    Write-Host "Error: AD Group has not been found"
                } else {
                    Write-Host "Error: $($_.Exception.Message)"
                }
                $groupName = Read-Host "Enter the group name (or type 'exit' to quit)"
                
                # Exit the loop if user enters "exit"
                if ($groupName -eq "exit") {
                    Show-MainMenu
                }
            }
        }

        # Create the directory for the results
        $directory = Join-Path $PSScriptRoot "Finder Results"
        New-Item -ItemType Directory -Path $directory -Force | Out-Null

        # Export the results to a CSV file with the group name in the filename
        $filename = "GroupMembers-$groupName.csv"
        $filePath = Join-Path $directory $filename

        try {
            $results | Export-Csv -Path $filePath -NoTypeInformation -ErrorAction Stop
            Write-Host "Results exported to file $filePath"
        } catch {
            Write-Host "Error exporting results to file: $($_.Exception.Message)"
        } 
    }
}


#function to run R-Monitor
function R-Monitor {
    $scriptPath = "C:\Scripts\Just scripts\R-Monitor.ps1"
    $workingDirectory = "C:\Scripts\Just scripts\"
    Start-Process pwsh.exe -ArgumentList "-NoExit", "-File `"$scriptPath`"" -WorkingDirectory $workingDirectory
}


Show-MainMenu
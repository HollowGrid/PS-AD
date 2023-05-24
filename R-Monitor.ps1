[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

#Set console windows and buffer size, also disabling the scroll bar

$Host.UI.RawUI.WindowTitle = "Developed by @HollowGrid"

$consoleWidth = 100
$consoleHeight = 38

$WindowSize = New-Object System.Management.Automation.Host.Size ($consoleWidth, $consoleHeight)
$Host.UI.RawUI.WindowSize = $WindowSize

$BufferSize = New-Object System.Management.Automation.Host.Size ($consoleWidth, $consoleHeight)
$Host.UI.RawUI.BufferSize = $BufferSize


## So Monitoring script since i been a bit bored
## We got AD monitoring, might soon add DHCP but i dont see a reason or logical why
## Might add a 10-15 sec pinger for important things as a moitoring tool in case a system goes down
## We have PRTG but why not do it the old fashion way

function R-Monitor {

    $refreshInterval = 15

    ## Pulls the amount of disabled users within AD
    function GetDisabledUserCount {
        $offlineDays = 45

        $thresholdDate = (Get-Date).AddDays(-$offlineDays).ToFileTime()
        $disabledAccounts = Get-ADUser -Filter {Enabled -eq $false -and LastLogonTimestamp -lt $thresholdDate} -Properties LastLogonTimestamp
        return $disabledAccounts.Count
    }

    ## Simple function to pull the amount of locke dout users
    function GetLockedOutAccountCounts {
        $lockedOutUsers = Search-ADAccount -LockedOut | Where-Object { $_.ObjectClass -eq 'user' -and $_.SamAccountName -notmatch "r\d\dpicker|vEMP" }
    
        $lockedOutCount = $lockedOutUsers | Measure-Object | Select-Object -ExpandProperty Count
    
        Write-Host "Locked Out Count: $lockedOutCount"
    }
    

    ## Total User count whos have a description Name and Last Name which are ussually real users
    ## More parameters could be added but kinda overboard 
    ## It can definetly be made better so feel free to add more
    function GetActiveCount {
        $startDate = (Get-Date).AddDays(-30)
        $users = Get-ADUser -Filter {
            LastLogonDate -ge $startDate -and
            ObjectClass -eq "user"
        } -Properties LastLogonDate |
            Where-Object { $null -ne $_.LastLogonDate   }
    
        return $users.Count
    }
    


    function GetNewUserCount {
        $initialStartDate = Get-Date -Year 2023 -Month 1 -Day 1 -Hour 1 -Minute 1 -Second 54
        $startDate = $initialStartDate
    
        $totalusers = Get-ADUser -Filter {whenCreated -ge $startDate} -SearchBase "DC=YOURDOMAIN,DC=com"
        $Total_userCount = $totalusers.Count
    
        return $Total_userCount
    }
    

    function GetDailyUserCount {
        $currentDate = Get-Date
        $startDate = Get-Date -Year $currentDate.Year -Month $currentDate.Month -Day $currentDate.Day -Hour 0 -Minute 0 -Second 0
        $endDate = $startDate.AddDays(1)
    
        $newUsers = Get-ADUser -Filter {whenCreated -ge $startDate -and whenCreated -lt $endDate} -SearchBase "DC=YOURDOMAIN,DC=com"
    
        $totalUserCount = $newUsers.Count
    
        $userData = @{
            UserCount = $totalUserCount
            Usernames = $newUsers.SamAccountName
        }
    
        return $userData
    }    
    

    function GetDailyUserNames {
        param (
            [Parameter(Mandatory = $true)]
            [DateTime]$date
        )
    
        $startDate = Get-Date -Year $date.Year -Month $date.Month -Day $date.Day -Hour 0 -Minute 0 -Second 0
        $endDate = $startDate.AddDays(1)
    
        $newUsers = Get-ADUser -Filter {whenCreated -ge $startDate -and whenCreated -lt $endDate} -SearchBase "DC=YOURDOMAIN,DC=com"
    
        $userNames = $newUsers | Select-Object -ExpandProperty Name
    
        $userNamesFormatted = $userNames | ForEach-Object {
            $_.PadRight(20)  # Adjust the width as per your preference
        }
    
        $index = 1
        foreach ($name in $userNamesFormatted) {
            $variableName = "Name$index"
            Set-Variable -Name $variableName -Value $name -Scope Global
            $index++
        }
    }
    
    # Usage: Call the function and provide the desired date
    $dateToCheck = Get-Date -Year 2023 -Month 5 -Day 23
    GetDailyUserNames -date $dateToCheck
    

    $lastUserCountRefresh = [DateTime]::MinValue
    $lastDisabledCountRefresh = [DateTime]::MinValue

    while ($true) {
        if ((Get-Date) -ge $lastUserCountRefresh.AddHours(1)) {
            $userCount = GetActiveCount
            $lastUserCountRefresh = Get-Date
        }
        if ((Get-Date) -ge $lastDisabledCountRefresh.AddHours(1)) {
            $disabledCount = GetDisabledUserCount
            $lastDisabledCountRefresh = Get-Date
        }

        $LockedOutUserss = GetLockedOutAccountCounts
        $userStats = GetDailyUserCount

    Clear-Host

$asciiArt = @"
`e[38;5;40m----------------------------------------------------------------------------------------------------`e[0m


         `e[38;5;196m:::=====`e[0m  `e[38;5;160m:::====`e[0m  `e[38;5;124m:::`e[0m `e[38;5;88m:::====`e[0m  `e[38;5;47m:::  ===  ===`e[0m `e[38;5;48m:::====`e[0m  `e[38;5;49m:::====`e[0m `e[38;5;50m:::=====`e[0m `e[38;5;51m:::  ===`e[0m
         `e[38;5;196m:::`e[0m       `e[38;5;160m:::  ===`e[0m `e[38;5;124m:::`e[0m `e[38;5;88m:::  ===`e[0m `e[38;5;83m:::  ===  ===`e[0m `e[38;5;84m:::  ===`e[0m `e[38;5;85m:::====`e[0m `e[38;5;86m:::`e[0m      `e[38;5;87m:::  ===`e[0m
         `e[38;5;196m=== =====`e[0m `e[38;5;160m=======`e[0m  `e[38;5;124m===`e[0m `e[38;5;88m===  ===`e[0m `e[38;5;119m===  ===  ===`e[0m `e[38;5;120m========`e[0m   `e[38;5;121m===`e[0m   `e[38;5;122m===`e[0m      `e[38;5;123m========`e[0m
         `e[38;5;196m===   ===`e[0m `e[38;5;160m=== ===`e[0m  `e[38;5;124m===`e[0m `e[38;5;88m===  ===`e[0m  `e[38;5;155m===========`e[0m  `e[38;5;156m===  ===`e[0m   `e[38;5;157m===`e[0m   `e[38;5;158m===`e[0m      `e[38;5;159m===  ===`e[0m
         `e[38;5;196m =======`e[0m  `e[38;5;160m===  ===`e[0m `e[38;5;124m===`e[0m `e[38;5;88m=======`e[0m    `e[38;5;191m==== ====`e[0m   `e[38;5;192m===  ===`e[0m   `e[38;5;193m===`e[0m    `e[38;5;194m=======`e[0m `e[38;5;195m===  ===`e[0m

           
`e[38;5;40m----------------------------------------------------------------------------------------------------`e[0m
|    Active Directory     |       Active Directory       |
|      User Counts        |     Daily Created Users      |
|=========================|==============================|                
|                         |   Users Created today: $($userStats.UserCount)    |
|   Disabled Users: $disabledCount   |                              |
|                         |==============================|     
|   Active Users: $userCount    |
|                         |
|   2023 New Users: $(GetNewUserCount)   |
|                         |
|=========================|


"@
        Write-Host $asciiArt

        Start-Sleep -Seconds $refreshInterval
    }
}

R-Monitor
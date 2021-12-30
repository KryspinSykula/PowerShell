<#
This can be used as base to create AD tool with menu.
#>
import-module ActiveDirectory


$menu1=@"
***********************************************
First menu
1
2 
3 
Q Quit
***********************************************


"@

$menu2=@"
**********************************************
Second menu
1 
2 
3 
B Back
**********************************************

"@

Clear-Host
Write-Host "Welcome in AD search script `n" -ForegroundColor Green
Write-Host 
sleep -Seconds 1

Do
{
    
    $choice = Read-Host $menu1 "Choose one option"     
    Switch ($choice) {
    "1" {        
        Write-Host "`nYou chose 1 what you'd like to do? `n"
        $SB=#put Search Base Here
        sleep -Seconds 1   
        do{  
         $choice=Read-Host $menu2 "Choose one option "
        switch ($choice) {
            "1" { Write-Host "First option" }
            "2"{Write-Host "Second option"}
            "3"{Write-Host "Third option"}
            "b"{Write-Host "`n" }
            Default {"Nothing `n" }
            
        }     
    }until($choice -eq "b")
}
    "2" {        
        Write-Host "`nYou chose 2 what you'd like to do? `n" 
        sleep -Seconds 1 
        do{  
            $SB=#put Search Base Here
            switch ($choice=Read-Host $menu2 "Choose one option " ) {
                "1" {Write-Host "First option"}
                "2"{Write-Host "Second option"}
                "3"{Write-Host "Third option"}
                "b"{Write-Host "`n" }
                Default {"Nothing `n" }
            }  
        }until($choice -eq "b")
    }
    "3" {        
        Write-Host "`nYou chose 3 what you'd like to do? `n" 
        sleep -Seconds 1   
        do{  
            $SB=#put Search Base Here
            switch ($choice=Read-Host $menu2 "Choose one option " ) {
                "1" {Write-Host "First option"}
                "2"{Write-Host "Second option"}
                "3"{Write-Host "Third option"}
                "b"{Write-Host "`n" }
                Default {"Nothing `n" }
            }
        }until($choice -eq "b")
    }
    "Q" {
        Write-Host "Quitting" -ForegroundColor Red; Clear-Host; return 
    }
    default {
        Write-Host "I don't understand what you want to do." -ForegroundColor Yellow
     }
    } #end switch

}Until ($choice -eq "q") 




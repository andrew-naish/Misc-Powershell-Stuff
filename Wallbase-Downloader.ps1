<#
 
.SYNOPSIS
    alpha.wallhaven.cc wallpaper downloader
 
.DESCRIPTION
    simple wget alternative to download wallpapers from alpha.wallhaven.cc
 
.EXAMPLE.
 
.NOTES
    author: Johannes Groiss
    version: 2
    contact: johannes@croix.at
 
.LINK
    http://croix.at
 
#>

#
# As above, all credits to Johannes Groiss. I have made a small edit to set the amount of pages to download.
#

$dir="C:\Users\andyn\Dropbox\Pictures\Wallpapers\Spaaace" ########## EDIT ME
$url = "https://alpha.wallhaven.cc/search?q=space&categories=100&purity=100&resolutions=1920x1080&sorting=random&order=desc"
 
# start page
$i=1
$pagesToScrape=5
 
$wc = New-Object Net.WebClient
$wc.UseDefaultCredentials = $true
$wc.Proxy.Credentials = $wc.Credentials
 
# login
$strLoginUrl = "http://alpha.wallhaven.cc/auth/login"
$user_agent = "Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; WOW64; Trident/6.0; MALNJS)"
$webRequest1 = Invoke-WebRequest "$strLoginUrl" -SessionVariable WebSession -UserAgent $user_agent #WebSession without a $!
$webForm = $webRequest1.Forms[0]  #You need the login forms of the page
 
# loop
while ($i -le $pagesToScrape) 
{
    # URL
    $url = $url +"&page="+$i 
 
    # Info
    "`n`nPAGE " +$i +"`n" +$url +"`n"
 
    # Web Request
    $web = Invoke-WebRequest $url
    $web = $web.Links | Where {$_.class -eq "preview"} | Sort-Object href -Unique
 
    foreach ($x in $web.href)
    {
        # Web Request
        $webWP = Invoke-WebRequest $x
 
        # get wallpaper url
        $webWPLink = $webWP.Images | Where {$_.id -eq "wallpaper"} | Select-Object src
        $webWPLink = "http:" +$webWPLink.src
 
        # get wallpaper name
        $Name=$webWPLink.Split("/")
        $webWPName = $Name[($Name.Count)-1]
 
        # create wallpaper download path
        $DownloadDir = $dir+"\"+$webWPName
 
        # test path
        if (Test-Path $DownloadDir)
        {
            # Info
            $webWPName +" already exists"
            continue 
        } #end if
 
        else
        {
            # Info
            "download " +$webWPName
 
            # Download
            $wc.DownloadFile($webWPLink, $DownloadDir)
        } #end else
    } #end foreach
    $i++
} #end while
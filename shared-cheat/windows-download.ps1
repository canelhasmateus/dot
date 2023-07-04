

$Urls = cat "../stream/articles.tsv" | ForEach-Object { 
    $_.Split()[3] 
} 


#$Urls = @("https://www.youtube.com/watch?v=a4L9GhldTHo")

$Urls | ForEach-Object -Parallel {
   
    function SHA($ClearString) {
    
        $hasher = [System.Security.Cryptography.HashAlgorithm]::Create('sha256')
        $hash = $hasher.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($ClearString))

        $hashString = [System.BitConverter]::ToString($hash)
        $hashString.Replace('-', '')
    }
     
    $Url = $_
    $Name = SHA $Url
    $Dest = "./resps/${Name}"
    $Resp = curl $Url 
    # write-Host $resp
    $Resp > $Dest 

} 


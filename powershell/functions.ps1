class Chkp_config{
  [ValidateRange(1,65525)]
  [int]$port=443
  [string]$URI
  [float]$Version = 1.6
  [string]$URL = $null
  [IPAddress]$DomainIP = $null
  $Headers = @{'Content-type'='application/json'}

  [void]SetURL(){
    $this.URL = "https://"+$this.URI+'/web_api/v'+$this.Version+'/'
  }

  Chkp_config([string]$uri, [IPAddress]$DomainIP, [int]$port, [float]$version){
    $this.URI = $uri
    $this.port = $port
    $this.Version = $version
    $this.DomainIP = $DomainIP
    $this.SetURL()
  }
  Chkp_config([string]$uri, [IPAddress]$DomainIP){
    $this.URI = $uri
    $this.port = 443
    $this.Version = 1.6
    $this.DomainIP = $DomainIP
    $this.SetURL()
    }
  Chkp_config([string]$uri, [int]$port){
    $this.URI = $uri
    $this.port = $port
    $this.DomainIP = $null
    $this.Version = 1.6
    $this.SetURL()
  }
  Chkp_config([string]$uri){
    $this.URI = $uri
    $this.DomainIP = $null
    $this.port= 443
    $this.Version= 1.6
    $this.SetURL()
  }
}
function Get-CheckPointSid{
  [CmdletBinding()]
  param(
    [Parameter(
	Mandatory = $true,
	HelpMessage = "User login"
    )]
    [String]
    $UserName = "admin",

    [Parameter(
	Mandatory = $false,
	HelpMessage = "User Password"
    )]
    [String]
    $Pass
    )
  $command = "login"
  if (-not($cconfig)){
    throw "There is not configuration object"
  }
  $CurrentURL = $cconfig.URL+$command
  $data = @{user=$UserName;
            password=$null;
          }
  if (-not ($Pass)){
	  $Pass = Read-Host -MaskInput "Please enter your SMS Password" 
    $data['password'] = $Pass
  }else{
    $data['password'] = $Pass
  }
  if ($cconfig.DomainIP){$data=$data+@{domain=$cconfig.DomainIP.IPAddressToString}}
  $jsondatasid=Invoke-RestMethod -SkipCertificateCheck -Uri $CurrentURL -Method Post -Body ($data|ConvertTo-Json) -ContentType "application/json" 
  #$response = Convertfrom-json -InputObject $jsondatasid
  return $jsondatasid.sid
}

function Get-ChkpAccessRuleBase{
  [CmdletBinding()]
  param(
  [Parameter(
  Mandatory = $true,
  HelpMessage = "SID Session ID")]
  [String]$SID,

  [Parameter(
  Mandtory = $true,
  HelpMessage = "Rule Name")]
  [String]$RuleName
  )
  write-host "hola mundo"
}

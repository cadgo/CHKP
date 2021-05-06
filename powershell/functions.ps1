class Chkp_config{
  [ValidateRange(1,65525)]
  [int]$port=443
  [string]$URI
  [float]$Version = 1.6
  [string]$URL = $null
  $Headers = @{'Content-type'='application/json'}

  [void]SetURL(){
    $this.URL = "https://"+$this.URI+'/web_api/v'+$this.Version+'/'
  }

  Chkp_config([string]$uri, [int]$port, [float]$version){
    $this.URI = $uri
    $this.port = $port
    $this.Version = $version
    $this.SetURL()
  }
  Chkp_config([string]$uri, [int]$port){
    $this.URI = $uri
    $this.port = $port
    $this.Version = 1.6
    $this.SetURL()
  }
  Chkp_config([string]$uri){
    $this.URI = $uri
    $this.port= 443
    $this.Version= 1.6
    $this.SetURL()
  }
}
function Get-CheckPointSid{
  [CmdletBinding()]
  param(
    [parameter(
    	Mandatory = $false,
	HelpMessage='Tne Domain IP'
    )]
    [IPAddress]
    $DomainIP,

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
  $data = @{"user"=$UserName;
            "password"=$null;
          }
  if (-not ($Pass)){
	  $Pass = Read-Host -MaskInput "Please enter your SMS Password" 
    $data['password'] = $Pass
  }else{
    $data['password'] = $Pass
  }
  if ($DomainIP){$data=$data+@{"domain"=$DomainIP}}
  #Write-Host $add_command
  $response = Invoke-RestMethod -SkipCertificateCheck -Uri $CurrentURL -Method Post -Body ($data|ConvertTo-Json) -ContentType "application/json"
  $response 
}

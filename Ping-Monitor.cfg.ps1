<# Ping-Monitor.cfg
	Define target hosts as array entries.
	Format: "Name:PrimaryAddress[:FallbackAddress]"
	No http://, https://, or ports — just plain host/IP.
#>

$domains = @(
    'Google:google.com',
    'Steam:155.133.226.10',
    'Twitch:twitch.tv'
)

# Optional external IP check service (string, not array)
$link = ""

$pingRequests = 4

$timeout_s = 60

. "$Folder\adomm.psfl.ps1"  # Load shared functions

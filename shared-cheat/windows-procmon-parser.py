values = [
"\Control Panel",
"\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge",
"\SOFTWARE\Microsoft\Input",
"\SOFTWARE\Microsoft\InputPersonalization",
"\SOFTWARE\Microsoft\Personalization",
"\SOFTWARE\Microsoft\PolicyManager\default\Wifi",
"\Software\Microsoft\Siuf\Rules",
"\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC",
"\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor",
"\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo",
"Windows Defender"
"\System\CurrentControlSet\Control\Session Manager\ResourcePolicies",
"\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost",
"\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager",
"\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled",
"\Software\Microsoft\Windows\CurrentVersion\Explorer",
"\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds",
"\Software\Microsoft\Windows\CurrentVersion\Holographic",
"\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection",
"\SOFTWARE\Microsoft\Windows\CurrentVersion\Search",
"\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize",
"\SOFTWARE\Policies\Microsoft\Windows\CloudContent",
"\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion",
"\SOFTWARE\Policies\Microsoft\Windows\DataCollection",
"\SOFTWARE\Policies\Microsoft\Windows\System",
"\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds",
"\SOFTWARE\Policies\Microsoft\Windows\Windows Search",
"\Microsoft\Windows\DeliveryOptimization",
"\SOFTWARE\Policies\Microsoft\WindowsStore",
"\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration",
"SOFTWARE\Microsoft\Windows\CurrentVersion\CloudExperienceHost",
"PolicyManager\default\DeliveryOptimization",
"SOFTWARE\Microsoft\Windows\DWM\ColorPrevalence"
]
from procmon_parser import load_configuration, dump_configuration, Rule, Column, RuleRelation, RuleAction
with open(r"C:\Users\Mateus\OneDrive\dot\windows\lib\ProcmonConfiguration.pmc", "rb") as f:
    config = load_configuration(f)


rules = []
for value in values:
    
    if value:
        rules.append( 
            Rule(Column.PATH, RuleRelation.CONTAINS, value, RuleAction.INCLUDE)
            )
        # rules.append( 
            # Rule(Column.DETAIL, RuleRelation.CONTAINS, str( value), RuleAction.INCLUDE)
            # )

config["FilterRules"] = rules

for rule in config["FilterRules"]:

    print( rule )
with open(r"C:\Users\Mateus\OneDrive\dot\windows\lib\ProcmonConfiguration1337.pmc", "wb") as f:
    dump_configuration(config, f)



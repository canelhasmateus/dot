use procmon to sniff registries -> automatically set background, fixed items, personalizations, bloatware

autoinstall wsl




Customize some Registry Keys, such as 

Explorer.exe -> File -> DropDown Items.
    
    Everything points to Computer\HKEY_CLASSES_ROOT.
    
    HKCR\lnkfile\shellex\ContextMenuHandlers\OpenContainingFolderMenu is very suspicious, and points to {37ea3a21-7493-4208-a011-7f9ea79ce9f5}.
    Opening said registry, located in HKCR\CLSID\{37ea3a21-7493-4208-a011-7f9ea79ce9f5}
    https://mickitblog.blogspot.com/2021/06/powershell-install-fonts.html


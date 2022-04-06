add-type -typeDefinition '

using System;
using System.Runtime.InteropServices;

public class Shell32_Extract {

  [DllImport(
     "Shell32.dll",
      EntryPoint        = "ExtractIconExW",
      CharSet           =  CharSet.Unicode,
      ExactSpelling     =  true,
      CallingConvention =  CallingConvention.StdCall)
  ]

   public static extern int ExtractIconEx(
      string lpszFile          , // Name of the .exe or .dll that contains the icon
      int    iconIndex         , // zero based index of first icon to extract. If iconIndex == 0 and and phiconSmall == null and phiconSmall = null, the number of icons is returnd
      out    IntPtr phiconLarge,
      out    IntPtr phiconSmall,
      int    nIcons
  );

}
'

$dllPath = "$env:SystemRoot\system32\imageres.dll"

[System.IntPtr] $phiconSmall = 0
[System.IntPtr] $phiconLarge = 0

$nofImages = [Shell32_Extract]::ExtractIconEx($dllPath, -1, [ref] $phiconLarge, [ref] $phiconSmall, 0)
$IconIndex = -108

$nofIconsExtracted = [Shell32_Extract]::ExtractIconEx($dllPath, -108, [ref] $phiconLarge, [ref] $phiconSmall, 1)

   if ($nofIconsExtracted -ne 2) {
      write-error "iconsExtracted = $nofIconsExtracted"
   }

   $iconSmall = [System.Drawing.Icon]::FromHandle($phiconSmall);
   $iconLarge = [System.Drawing.Icon]::FromHandle($phiconLarge);

   $bmpSmall = $iconSmall.ToBitmap()
   $bmpLarge = $iconLarge.ToBitmap()

   $iconIndex_0  = '{0,3:000}' -f $iconIndex

 #
 #  System.Drawing.Image.Save(), without specifying an encoder, stores
 #  the bitmap in png format.
 #
   $bmpLarge.Save("$(get-location)\small-$iconIndex_0.png");
   $bmpLarge.Save("$(get-location)\large-$iconIndex_0.png");

 #
 #  Use System.Drawing.Imaging.ImageFormat to specify a
 #  different format:
 #
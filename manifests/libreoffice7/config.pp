# https://wiki.documentfoundation.org/Deployment_and_Migration
class forthewin::libreoffice7::config (
  Integer $gm_object_cache_size = 12600000,
  Integer $gm_object_release_time = 600,
  Integer $gm_total_cache_size = 400000000,
  Integer $oo_drawing_engine = 20, 
  Integer $oo_writer = 20,
  Boolean $proxy_final = true,
  Enum['none', 'system'] $proxy_type = 'system',
  Boolean $use_hw_accel = false,
  Boolean $use_skia = false,
  Boolean $verbose = $forthewin::libreoffice7::verbose
  ) {

  $basereg = 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\LibreOffice'
  $canvas = "${basereg}\\org.openoffice.Office.Canvas"
  $common = "${basereg}\\org.openoffice.Office.Common"
  $inet = "${basereg}\\org.openoffice.Inet"

  if $verbose {
    info("[${trusted[certname]}] PARAMETERS:")
    info("[${trusted[certname]}] gm_object_cache_size   = ${gm_object_cache_size}")
    info("[${trusted[certname]}] gm_object_release_time = ${gm_object_release_time}")
    info("[${trusted[certname]}] gm_total_cache_size    = ${gm_total_cache_size}")
    info("[${trusted[certname]}] oo_drawing_engine      = ${oo_drawing_engine}")
    info("[${trusted[certname]}] oo_writer              = ${oo_writer}")
    info("[${trusted[certname]}] proxy_final            = ${proxy_final}")
    info("[${trusted[certname]}] proxy_type             = ${proxy_type}")
    info("[${trusted[certname]}] use_hw_accel           = ${use_hw_accel}")
    info("[${trusted[certname]}] use_skia               = ${use_skia}")
    info("[${trusted[certname]}] VARIABLES:")
    info("[${trusted[certname]}] basereg                = ${basereg}")
    info("[${trusted[certname]}] canvas                 = ${canvas}")
    info("[${trusted[certname]}] common                 = ${common}")
    info("[${trusted[certname]}] inet                   = ${inet}")
  }

  # Enable/disable Skia
  registry::value { "UseSkia":
    key   => "${common}\\VCL\\UseSkia",
    value => 'Value',
    data  => String($use_skia),
    type  => 'string',
  }
  ->
  registry::value { "ForceSkia":
    key   => "${common}\\VCL\\ForceSkia",
    value => 'Value',
    data  => 'false',
    type  => 'string',
  }
  ->
  registry::value { "ForceSkiaRaster":
    key   => "${common}\\VCL\\ForceSkiaRaster",
    value => 'Value',
    data  => 'false',
    type  => 'string',
  }
  ->
  registry::value { "DisableOpenGL":
    key   => "${common}\\VCL\\DisableOpenGL",
    value => 'Value',
    data  => 'true',
    type  => 'string',
  }

  # Set Cache
  registry::value { "Writer.OLE_Objects":
    key   => "${common}\\Cache\\Writer\\OLE_Objects",
    value => 'Value',
    data  => String($oo_writer),
    type  => 'string',
  }
  registry::value { "DrawingEngine.OLE_Objects":
    key   => "${common}\\Cache\\DrawingEngine\\OLE_Objects",
    value => 'Value',
    data  => String($oo_drawing_engine),
    type  => 'string',
  }
  registry::value { "TotalCacheSize":
    key   => "${common}\\Cache\\GraphicManager\\TotalCacheSize",
    value => 'Value',
    data  => String($gm_total_cache_size),
    type  => 'string',
  }
  registry::value { "ObjectCacheSize":
    key   => "${common}\\Cache\\GraphicManager\\ObjectCacheSize",
    value => 'Value',
    data  => String($gm_object_cache_size),
    type  => 'string',
  }
  registry::value { "ObjectReleaseTime":
    key   => "${common}\\Cache\\GraphicManager\\ObjectReleaseTime",
    value => 'Value',
    data  => String($gm_object_release_time),
    type  => 'string',
  }  
  
  # Enable/disable hardware graphics acceleration
  registry::value { "ForceSafeServiceImpl":
    key   => "${canvas}\\ForceSafeServiceImpl",
    value => 'Value',
    data  => String(!$use_hw_accel),
    type  => 'string',
  }

  # Set proxy
  registry::value { "ooInetProxyType.Value":
    key   => "${inet}\\Settings\\ooInetProxyType",
    value => 'Value',
    data  => $proxy_type ? {'none' => '0', 'system' => '1', default => '1'},
    type  => 'string',
  }
  ->
  registry::value { "ooInetProxyType.Final":
    key   => "${inet}\\Settings\\ooInetProxyType",
    value => 'Final',
    data  => String($proxy_final, '%d'),
    type  => 'dword',
  }


}
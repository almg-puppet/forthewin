class forthewin::flash::config {

  file {'mms.cfg':
    path    => $forthewin::flash::mmscfg_path,
    ensure  => file,
  }

}
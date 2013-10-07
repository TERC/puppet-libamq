define libamq::memoryUsage($value, $target = $name) {
  $query = "/beans/broker/systemUsage/systemUsage/memoryUsage/memoryUsage/#attribute/limit"
  xmlfile_modification { "${target}: set memoryUsage":
    file    => $target,
    changes => "set ${query} \"${value}\"",
    onlyif  => "get ${query} != \"${value}\"",
  }
}

define libamq::storeUsage($value, $target = $name) {
  $query = "/beans/broker/systemUsage/systemUsage/storeUsage/storeUsage/#attribute/limit"
  xmlfile_modification { "${target}: set storeUsage":
    file    => $target,
    changes => "set ${query} \"${value}\"",
    onlyif  => "get ${query} != \"${value}\"",
  }
}

define libamq::tempUsage($value, $target = $name) {
  $query = "/beans/broker/systemUsage/systemUsage/tempUsage/tempUsage/#attribute/limit"
  xmlfile_modification { "${target}: set tempUsage":
    file    => $target,
    changes => "set ${query} \"${value}\"",
    onlyif  => "get ${query} != \"${value}\"",
  }
}
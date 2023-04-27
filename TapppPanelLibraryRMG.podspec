Pod::Spec.new do |spec|

  spec.name         = "TapppPanelLibraryRMG"
  spec.version      = "0.0.1"
  spec.summary      = "A CocoaPods library written in Swift"

  spec.description  = "This will be test description for inmplememting pod file."

  spec.homepage     = "https://github.com/ravimaru2022/TapppPanelLibraryRMG.git"
  spec.license      =  'MIT'
  spec.author       = { "chandan" => "chandan.singh@tappp.com" }

  spec.ios.deployment_target = "12.1"
  spec.swift_version = "4.2"

  spec.source        = { :git => "https://github.com/ravimaru2022/TapppPanelLibraryRMG.git", :tag => "#{spec.version}" }
  spec.source_files  = "TapppPanelLibraryRMG/**/*.{h,m,swift}"
  spec.resources     = "TapppPanelLibraryRMG/**/*.{png, json, html, ico, map, ttf, js}"
  spec.resource_bundles = {
    'dist' => ['TapppPanelLibrary/dist/*.js',
               'TapppPanelLibrary/dist/*.txt',
               'TapppPanelLibrary/dist/*.ttf',
               'TapppPanelLibrary/dist/*.map',
               'TapppPanelLibrary/dist/*.html']

  }
end
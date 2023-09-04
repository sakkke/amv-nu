#!/usr/bin/env nu

def main [...file: string] {
  for $f in $file {
    let format_tags = get-format-tags $f
    let extension = $f | get-extension
    let dir = match $extension {
      'flac' => { [$format_tags.album_artist $format_tags.Album] },
      'm4a' => { [$format_tags.album_artist $format_tags.album] },
      _ => {
        print $"error: ($extension): extension not supported"
        exit 1
      }
    } | path join
    let file = match $extension {
      'flac' => { $"($format_tags.track) - ($format_tags.Title).($extension)" },
      'm4a' => { $"($format_tags.track) - ($format_tags.title).($extension)" }
    }
    let out = [$dir $file] | path join
    mkdir $dir
    mv $f $out
  }
}

def get-format-tags [file: string] {
  ffprobe -loglevel quiet -of json -show_entries format_tags=album,album_artist,title,track $file
  | from json
  | get format.tags
}

def get-extension [] {
  path parse | get extension
}

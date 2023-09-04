#!/usr/bin/env nu

def main [...file: string] {
  for $f in $file {
    let format_tags = get-format-tags $f
    let extension = $f | get-extension
    let dir = [$format_tags.album_artist $format_tags.album] | path join
    let file = $"($format_tags.track) - ($format_tags.title).($extension)"
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

#!/bin/bash

get_default_sink_name() {
  while IFS= read -r line; do
    if [[ $line == "Default Sink:"* ]]; then
      printf '%s\n' "${line#Default Sink: }"
      return 0
    fi
  done < <(pactl info)

  return 1
}

get_first_active_sink_id() {
  while IFS=$'\t' read -r _ sink_id _; do
    if [[ -n $sink_id ]]; then
      printf '%s\n' "$sink_id"
      return 0
    fi
  done < <(pactl list short sink-inputs)

  return 1
}

get_sink_name_by_id() {
  local target_id=$1

  while IFS=$'\t' read -r sink_id sink_name _; do
    if [[ $sink_id == "$target_id" ]]; then
      printf '%s\n' "$sink_name"
      return 0
    fi
  done < <(pactl list short sinks)

  return 1
}

sync_default_sink_to_active_stream() {
  local active_sink_id
  local active_sink_name
  local default_sink_name

  if ! active_sink_id=$(get_first_active_sink_id); then
    return 0
  fi

  if ! active_sink_name=$(get_sink_name_by_id "$active_sink_id"); then
    return 0
  fi

  if ! default_sink_name=$(get_default_sink_name); then
    return 0
  fi

  if [[ $active_sink_name != "$default_sink_name" ]]; then
    wpctl set-default "$active_sink_id"
  fi
}

sync_default_sink_to_active_stream

pactl subscribe | while IFS= read -r event_line; do
  case $event_line in
    *"on sink-input"*|*"on sink #"*|*"on server"*)
      sync_default_sink_to_active_stream
      ;;
  esac
done

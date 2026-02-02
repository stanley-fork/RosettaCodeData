#!/bin/bash

# Additional translation of dashes to underscores in variable names
# was performed later [RBE]

first_digit() {
  printf '%s\n' "${1:0:1}"
}

last_digit() {
  printf '%s\n' $(( $1 % 10 ))
}

bookend_number() {
  printf '%s%s\n' "$(first_digit "$@")" "$(last_digit "$@")"
}

is_gapful() {
  (( $1 >= 100 && $1 % $(bookend_number "$1") == 0 ))
}

gapfuls_in_range() {
  local gapfuls=()
  local -i i found
  for (( i=$1, found=0; found < $2; ++i )); do
    if is_gapful "$i"; then
      if (( found )); then
        printf ' ';
      fi
      printf '%s' "$i"
      (( found++ ))
    fi
  done
  printf '\n'
}

report_ranges() {
  local range
  local -i start size
  for range; do
    IFS=, read start size <<<"$range"
    printf 'The first %d gapful numbers >= %d:\n' "$size" "$start"
    gapfuls_in_range "$start" "$size"
    printf '\n'
  done
}

report_ranges 1,30 1000000,15 1000000000,10

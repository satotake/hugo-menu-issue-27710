#!/usr/bin/env bash

main() {
  declare counter=0
  declare max_iterations=200
  declare num_workers=4

  # Checkout correctly rendered version of public/index.html.
  git checkout --quiet public/index.html

  # Test.
  export "HUGO_NUMWORKERMULTIPLIER=${num_workers}"
  while git diff --exit-code public/index.html; do
    if [[ "$counter" -eq "${max_iterations}" ]]; then
      printf "\\nStopped testing after %s iterations (no errors).\\n" "${max_iterations}"
      exit 0
    fi
    ((counter++)) || true
    printf "\\rTesting: iteration #%s (will terminate upon failure or %s iterations)" "${counter}" "${max_iterations}"
    hugo --quiet
  done

  printf "\\nFailed after %s iterations.\\n" "${counter}"
  exit 1
}

set -euo pipefail
main "$@"

#!/bin/bash
set -e

cargo build --release --bin verify_contribution
for i in $(seq 1 6); do
  cargo run --release --bin verify_contribution wrap.json circuit_wrap_$((i - 1)).params circuit_wrap_$i.params
  cargo run --release --bin verify_contribution unwrap.json circuit_unwrap_$((i - 1)).params circuit_unwrap_$i.params
  cargo run --release --bin verify_contribution init-transfer.json circuit_init-transfer_$((i - 1)).params circuit_init-transfer_$i.params
  cargo run --release --bin verify_contribution complete-transfer.json circuit_complete-transfer_$((i - 1)).params circuit_complete-transfer_$i.params
done

#!/bin/bash
# DEPRECATED / no-op. The completion sound moved into pre-claim-gate.py
# (play_done_sound), which fires it ONLY when the stop is not blocked — i.e. when
# Claude is truly done. Playing here on every Stop event double-fired on pre-block
# stops. Removed from settings.json Stop array; kept as a no-op for safety.
exit 0

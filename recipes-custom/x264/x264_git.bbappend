# PIC can't be enabled for arm
INSANE_SKIP_${PN}_append_arm = " textrel"

#!/bin/bash
PROFILE="$1"
PROFILE_FILE="./profiles/${PROFILE}.env"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

#Output
RESULTS_DIR="./results/${PROFILE}"
REPORTS_DIR="./reports/${PROFILE}"
LOG_DIR="./logs/${PROFILE}"

start_test() {
	load_test_profile
	validate_required_vars
	create_output_directories
	print_test_info
	run_jmeter
}

load_test_profile() {
	validate_profile_exists

	set -a
	source "$PROFILE_FILE"
	set +a

    # Load local env (for dev use only)
	if [ -f "./env.local" ]; then
		set -a
		source ./env.local
		set +a
	fi
}

validate_profile_exists() {
	if [ ! -f "$PROFILE_FILE" ]; then
		echo "Unknown profile: $PROFILE"
		echo ""
		list_profiles
		exit 1
	fi
}

list_profiles() {
	echo "Available test profiles:"

	shopt -s nullglob
	files=(./profiles/*.env)

	if [ ${#files[@]} -eq 0 ]; then
		echo " (none found)"
		return
	fi

	for file in "${files[@]}"; do
		name=$(basename "$file" .env)
		echo " - $name"
	done
}

validate_required_vars() {
	: "${HOST:?}"
	: "${PORT:?}"
	: "${PROTOCOL:?}"
	: "${USER_LOAD:?}"
	: "${RAMP_SECONDS:?}"
	: "${DURATION_SECONDS:?}"
	: "${PACING_BASE_MILLIS:?}"
	: "${PACING_VARIANCE_MILLIS:?}"
	: "${ADMIN_USER:?}"
	: "${ADMIN_APPTOKEN:?}"
}

create_output_directories() {
	mkdir -p "$RESULTS_DIR" "$REPORTS_DIR" "$LOG_DIR"
}

print_test_info() {
	echo ""
	echo "============================================================"
	echo " Running load profile: ${PROFILE}"
	echo "============================================================"
	echo "Target        : ${PROTOCOL}://${HOST}:${PORT}"
    echo "Admin user    : ${ADMIN_USER}"
	echo "User load     : ${USER_LOAD}"
	echo "Ramp          : ${RAMP_SECONDS}s"
	echo "Duration      : ${DURATION_SECONDS}s"
    echo "Pacing base   : ${PACING_BASE_MILLIS}"
    echo "Pacing vari   : ${PACING_VARIANCE_MILLIS}"
	echo "============================================================"
	echo ""
}

run_jmeter() {
	jmeter -n \
		-t ./tests/crud-load.jmx \
		-JPROTOCOL="$PROTOCOL" \
		-JHOST="$HOST" \
		-JPORT="$PORT" \
		-JUSER_LOAD="$USER_LOAD" \
		-JRAMP_SECONDS="$RAMP_SECONDS" \
		-JDURATION_SECONDS="$DURATION_SECONDS" \
		-JPACING_BASE_MILLIS="$PACING_BASE_MILLIS" \
		-JPACING_VARIANCE_MILLIS="$PACING_VARIANCE_MILLIS" \
		-JADMIN_USER="$ADMIN_USER" \
		-JADMIN_APPTOKEN="$ADMIN_APPTOKEN" \
		-l "$RESULTS_DIR/${PROFILE}-${TIMESTAMP}.jtl" \
		-j "$LOG_DIR/${PROFILE}-${TIMESTAMP}.log" \
		-e -o "$REPORTS_DIR/${PROFILE}-${TIMESTAMP}"
}

start_test

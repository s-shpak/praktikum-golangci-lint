#! /bin/bash
set -e

cd "${1}"

main() {
    local REPORT_FILE="./golangci-lint/report.json"
    make golangci-lint-run > /dev/null 2> /dev/null

    local status=$(cat $REPORT_FILE | jq -r '.Issues | length')
    if [ $status -ne 0 ]; then
        echo "Исправьте проблемы, обнаруженные линтером: см. файл $REPORT_FILE"
        exit 1
    fi
}

main
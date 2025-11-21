#!/usr/bin/env bash
#
# Ansible Lint Script for Workstation Playbook
# Runs ansible-lint with consistent options across the project
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
LINT_TARGET=""
SHOW_HELP=false
VERBOSE=false
OFFLINE_MODE=""

# Function to display usage
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] [TARGET]

Run ansible-lint on the Workstation playbook or specific roles.

OPTIONS:
    -h, --help          Show this help message
    -v, --verbose       Enable verbose output
    -o, --offline       Run in offline mode (skip collection dependency installation)
    -r, --role ROLE     Lint a specific role (e.g., sublime_text)
    -a, --all-roles     Lint all roles individually

TARGETS:
    [none]              Lint the main workstation.yml playbook (default)
    playbook            Lint the main workstation.yml playbook
    role/ROLE_NAME      Lint a specific role
    roles               Lint all roles in the roles/ directory

EXAMPLES:
    $(basename "$0")                          # Lint main playbook
    $(basename "$0") -r sublime_text          # Lint sublime_text role
    $(basename "$0") -a                       # Lint all roles
    $(basename "$0") -o playbook              # Lint playbook in offline mode

EOF
}

# Function to print colored messages
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to lint a file or directory
run_lint() {
    local target="$1"
    local name="${2:-$target}"

    log_info "Linting: $name"

    if [ ! -e "$target" ]; then
        log_error "Target not found: $target"
        return 1
    fi

    local lint_cmd="ansible-lint"
    [ "$VERBOSE" = true ] && lint_cmd="$lint_cmd -v"
    [ -n "$OFFLINE_MODE" ] && lint_cmd="$lint_cmd $OFFLINE_MODE"

    if $lint_cmd "$target"; then
        log_success "Passed: $name"
        return 0
    else
        log_error "Failed: $name"
        return 1
    fi
}

# Function to lint all roles
lint_all_roles() {
    local failed_roles=()
    local passed_roles=()

    log_info "Linting all roles..."
    echo ""

    for role_dir in "$SCRIPT_DIR/roles"/*; do
        if [ -d "$role_dir" ]; then
            local role_name=$(basename "$role_dir")
            local role_tasks="$role_dir/tasks/main.yml"

            if [ -f "$role_tasks" ]; then
                if run_lint "$role_tasks" "Role: $role_name"; then
                    passed_roles+=("$role_name")
                else
                    failed_roles+=("$role_name")
                fi
                echo ""
            else
                log_warning "No tasks/main.yml found for role: $role_name"
            fi
        fi
    done

    # Summary
    echo ""
    echo "========================================"
    log_info "Lint Summary"
    echo "========================================"
    log_success "Passed: ${#passed_roles[@]} roles"
    if [ ${#passed_roles[@]} -gt 0 ]; then
        printf "  - %s\n" "${passed_roles[@]}"
    fi

    if [ ${#failed_roles[@]} -gt 0 ]; then
        log_error "Failed: ${#failed_roles[@]} roles"
        printf "  - %s\n" "${failed_roles[@]}"
        return 1
    fi

    return 0
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -o|--offline)
            OFFLINE_MODE="--offline"
            shift
            ;;
        -r|--role)
            if [ -z "${2:-}" ]; then
                log_error "Role name required for -r/--role option"
                exit 1
            fi
            LINT_TARGET="role/$2"
            shift 2
            ;;
        -a|--all-roles)
            LINT_TARGET="all-roles"
            shift
            ;;
        playbook|roles|role/*)
            LINT_TARGET="$1"
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Change to script directory
cd "$SCRIPT_DIR"

# Main execution
case "${LINT_TARGET:-playbook}" in
    playbook)
        log_info "Starting ansible-lint for workstation.yml"
        echo ""
        run_lint "workstation.yml" "Workstation Playbook"
        exit_code=$?
        ;;

    all-roles)
        lint_all_roles
        exit_code=$?
        ;;

    role/*)
        role_name="${LINT_TARGET#role/}"
        role_tasks="roles/$role_name/tasks/main.yml"
        run_lint "$role_tasks" "Role: $role_name"
        exit_code=$?
        ;;

    roles)
        run_lint "roles/" "All Roles Directory"
        exit_code=$?
        ;;

    *)
        log_error "Invalid target: $LINT_TARGET"
        usage
        exit 1
        ;;
esac

echo ""
if [ $exit_code -eq 0 ]; then
    log_success "All linting checks passed!"
else
    log_error "Linting failed. Please fix the issues above."
fi

exit $exit_code

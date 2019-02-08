# Generated by stubbs:add-option. Do not edit, if using stubbs.
# Created: Thu Feb  7 06:50:44 UTC 2019
#
#/ usage: mariadb:create  --arg <> [ --comment <>] [ --verbose <>] [ --register <>] [ --requires <>]  --debian <>  --mariadb <> [ --bind <127.0.0.1>] [ --hostname <mariadb>] 

# _rerun_options_parse_ - Parse the command arguments and set option variables.
#
#     rerun_options_parse "$@"
#
# Arguments:
#
# * the command options and their arguments
#
# Notes:
#
# * Sets shell variables for any parsed options.
# * The "-?" help argument prints command usage and will exit 2.
# * Return 0 for successful option parse.
#
rerun_options_parse() {
  
    unrecognized_args=()

    while (( "$#" > 0 ))
    do
        OPT="$1"
        case "$OPT" in
            --arg) rerun_option_check $# $1; ARG=$2 ; shift 2 ;;
            --comment) rerun_option_check $# $1; COMMENT=$2 ; shift 2 ;;
            --verbose) rerun_option_check $# $1; VERBOSE=$2 ; shift 2 ;;
            --register) rerun_option_check $# $1; REGISTER=$2 ; shift 2 ;;
            --requires) rerun_option_check $# $1; REQUIRES=$2 ; shift 2 ;;
            --debian) rerun_option_check $# $1; DEBIAN=$2 ; shift 2 ;;
            --mariadb) rerun_option_check $# $1; MARIADB=$2 ; shift 2 ;;
            --bind) rerun_option_check $# $1; BIND=$2 ; shift 2 ;;
            --hostname) rerun_option_check $# $1; HOSTNAME=$2 ; shift 2 ;;
            # help option
            -\?|--help)
                rerun_option_usage
                exit 2
                ;;
            # unrecognized arguments
            *)
              unrecognized_args+=("$OPT")
              shift
              ;;
        esac
    done

    # Set defaultable options.
    [[ -z "$BIND" ]] && BIND="$(rerun_property_get $RERUN_MODULE_DIR/options/bind DEFAULT)"
    [[ -z "$HOSTNAME" ]] && HOSTNAME="$(rerun_property_get $RERUN_MODULE_DIR/options/hostname DEFAULT)"
    # Check required options are set
    [[ -z "$ARG" ]] && { echo >&2 "missing required option: --arg" ; return 2 ; }
    [[ -z "$DEBIAN" ]] && { echo >&2 "missing required option: --debian" ; return 2 ; }
    [[ -z "$MARIADB" ]] && { echo >&2 "missing required option: --mariadb" ; return 2 ; }
    # If option variables are declared exportable, export them.

    # Make unrecognized command line options available in $_CMD_LINE
    if [ ${#unrecognized_args[@]} -gt 0 ]; then
      export _CMD_LINE="${unrecognized_args[@]}"
    fi
    #
    return 0
}


# If not already set, initialize the options variables to null.
: ${ARG:=}
: ${COMMENT:=}
: ${VERBOSE:=}
: ${REGISTER:=}
: ${REQUIRES:=}
: ${DEBIAN:=}
: ${MARIADB:=}
: ${BIND:=}
: ${HOSTNAME:=}
# Default command line to null if not set
: ${_CMD_LINE:=}


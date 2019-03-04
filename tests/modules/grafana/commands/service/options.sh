# Generated by stubbs:add-option. Do not edit, if using stubbs.
# Created: Mon Feb 18 11:27:08 UTC 2019
#
#/ usage: grafana:service  --arg <> [ --comment <>] [ --verbose <>] [ --register <>] [ --requires <>]  --version <>  --password <> 

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
            --version) rerun_option_check $# $1; VERSION=$2 ; shift 2 ;;
            --password) rerun_option_check $# $1; PASSWORD=$2 ; shift 2 ;;
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

    # Check required options are set
    [[ -z "$ARG" ]] && { echo >&2 "missing required option: --arg" ; return 2 ; }
    [[ -z "$VERSION" ]] && { echo >&2 "missing required option: --version" ; return 2 ; }
    [[ -z "$PASSWORD" ]] && { echo >&2 "missing required option: --password" ; return 2 ; }
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
: ${VERSION:=}
: ${PASSWORD:=}
# Default command line to null if not set
: ${_CMD_LINE:=}


# Generated by stubbs:add-option. Do not edit, if using stubbs.
# Created: Mon Jan 21 09:27:18 UTC 2019
#
#/ usage: configi:add-parameter  --parameter <>  --desc <>  --module <>  --command <>  --required <> [ --default <>] 

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
            --parameter) rerun_option_check $# $1; PARAMETER=$2 ; shift 2 ;;
            --desc) rerun_option_check $# $1; DESC=$2 ; shift 2 ;;
            --module) rerun_option_check $# $1; MODULE=$2 ; shift 2 ;;
            --command) rerun_option_check $# $1; COMMAND=$2 ; shift 2 ;;
            --required) rerun_option_check $# $1; REQUIRED=$2 ; shift 2 ;;
            --default) rerun_option_check $# $1; DEFAULT=$2 ; shift 2 ;;
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
    [[ -z "$PARAMETER" ]] && { echo >&2 "missing required option: --parameter" ; return 2 ; }
    [[ -z "$DESC" ]] && { echo >&2 "missing required option: --desc" ; return 2 ; }
    [[ -z "$MODULE" ]] && { echo >&2 "missing required option: --module" ; return 2 ; }
    [[ -z "$COMMAND" ]] && { echo >&2 "missing required option: --command" ; return 2 ; }
    [[ -z "$REQUIRED" ]] && { echo >&2 "missing required option: --required" ; return 2 ; }
    # If option variables are declared exportable, export them.

    # Make unrecognized command line options available in $_CMD_LINE
    if [ ${#unrecognized_args[@]} -gt 0 ]; then
      export _CMD_LINE="${unrecognized_args[@]}"
    fi
    #
    return 0
}


# If not already set, initialize the options variables to null.
: ${PARAMETER:=}
: ${DESC:=}
: ${MODULE:=}
: ${COMMAND:=}
: ${REQUIRED:=}
: ${DEFAULT:=}
# Default command line to null if not set
: ${_CMD_LINE:=}



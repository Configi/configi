# Generated by stubbs:add-option. Do not edit, if using stubbs.
# Created: Tue 05 Mar 2019 05:12:53 AM UTC
#
#/ usage: image:push  --arg <> [ --comment <>] [ --verbose <>] [ --register <>] [ --requires <>]  --host <>  --src <> [ --tag <latest>]  --dest <> 

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
            --host) rerun_option_check $# $1; HOST=$2 ; shift 2 ;;
            --src) rerun_option_check $# $1; SRC=$2 ; shift 2 ;;
            --tag) rerun_option_check $# $1; TAG=$2 ; shift 2 ;;
            --dest) rerun_option_check $# $1; DEST=$2 ; shift 2 ;;
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
    [[ -z "$TAG" ]] && TAG="$(rerun_property_get $RERUN_MODULE_DIR/options/tag DEFAULT)"
    # Check required options are set
    [[ -z "$ARG" ]] && { echo >&2 "missing required option: --arg" ; return 2 ; }
    [[ -z "$HOST" ]] && { echo >&2 "missing required option: --host" ; return 2 ; }
    [[ -z "$SRC" ]] && { echo >&2 "missing required option: --src" ; return 2 ; }
    [[ -z "$DEST" ]] && { echo >&2 "missing required option: --dest" ; return 2 ; }
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
: ${HOST:=}
: ${SRC:=}
: ${TAG:=}
: ${DEST:=}
# Default command line to null if not set
: ${_CMD_LINE:=}



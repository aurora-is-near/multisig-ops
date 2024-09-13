#!/bin/sh

Help() {
  # Display Help
  echo "Near CLI extension for interacting with multisig contracts"
  echo
  echo "Commands: add-proposal, approve-proposal, reject-proposal, get_proposal"
  echo
  echo "Syntax: near-multisig [h] <command>"
  echo "options:"
  echo "h     Print this Help."
  echo
}

case "$1" in
add-proposal)
  MULTISIG=$2
  PROPOSAL_ARGS=$3
  near contract call-function \
    as-transaction $MULTISIG add_proposal \
    file-args $PROPOSAL_ARGS
  ;;
approve-proposal)
  MULTISIG=$2
  PROPOSAL_ID=$3
  near contract call-function \
    as-transaction $MULTISIG act_proposal \
    json-args '{"id": '$PROPOSAL_ID', "action": "VoteApprove"}'
  ;;
reject-proposal)
  MULTISIG=$2
  PROPOSAL_ID=$3
  near contract call-function \
    as-transaction $MULTISIG act_proposal \
    json-args '{"id": '$PROPOSAL_ID', "action": "VoteReject"}'
  ;;
get-proposal)
  MULTISIG=$2
  PROPOSAL_ID=$3
  near contract call-function as-read-only $MULTISIG get_proposal json-args '{"id": '"$PROPOSAL_ID"'}'
  ;;
*)
  Help
  ;;
esac

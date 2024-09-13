# Multisig Ops

Operations meant to interface with different protocols at a larger,
trust minimized way by not relying on 3rd party web services.
Only requires `near-cli-rs` and `base64` for preparing args in FunctionCall proposals.

## 1. Register account

```bash
ACCOUNT="aura.sputnik-dao.near"
SIGNER="aurealis.near"
# register account in exchange contract
near contract call-function \
  as-transaction v2.ref-finance.near storage_deposit \
  json-args '{"account_id": "'$ACCOUNT'", "registration_only": false}' \
  prepaid-gas '100.0 Tgas' attached-deposit '0.1 NEAR' \
  sign-as $SIGNER network-config mainnet sign-with-keychain send
# register account in farm contract
near contract call-function \
  as-transaction boostfarm.ref-labs.near storage_deposit \
  json-args '{"account_id": "'$ACCOUNT'", "registration_only": false}' \
  prepaid-gas '100.0 Tgas' attached-deposit '0.1 NEAR' \
  sign-as $SIGNER network-config mainnet sign-with-keychain send
```

## 2. Transfer tokens

```bash
MULTISIG="warpdrive.sputnik-dao.near"
SIGNER="aurealis.near"
AMOUNT_X="4300000000000000000000"
CONTRACT="v2.ref-finance.near"
echo '{"receiver_id": "'$CONTRACT'", "amount": "'$AMOUNT_X'", "msg": ""}' | base64
near contract call-function \
  as-transaction $MULTISIG add_proposal \
  file-args ref-1-transfer-x.json \
  prepaid-gas '100.0 Tgas' attached-deposit '1 NEAR' \
  sign-as $SIGNER network-config mainnet sign-with-keychain send

AMOUNT_Y="125000000000000000000000000"
CONTRACT="v2.ref-finance.near"
echo '{"receiver_id": "'$CONTRACT'", "amount": "'$AMOUNT_Y'", "msg": ""}' | base64
near contract call-function \
  as-transaction $MULTISIG add_proposal \
  file-args ref-1-transfer-y.json \
  prepaid-gas '100.0 Tgas' attached-deposit '1 NEAR' \
  sign-as $SIGNER network-config mainnet sign-with-keychain send
```

## 3. Add liquidity

```bash
MULTISIG="aura.sputnik-dao.near"
SIGNER="aurealis.near"
# first amount is base token, second amount is quote token
AMOUNT_X="1000000000000000000000000"
AMOUNT_Y="1000000000000000000000000"
echo '{"pool_id": 1395,"amounts": ["'$AMOUNT_X'","'$AMOUNT_Y'"]' | base64
near contract call-function \
  as-transaction $MULTISIG add_proposal \
  file-args ref-2-add-liquidity.json \
  prepaid-gas '100.0 Tgas' attached-deposit '0.1 NEAR' \
  sign-as $SIGNER network-config mainnet sign-with-keychain send
```

## 4. Stake liquidity into farm

```bash
MULTISIG="aura.sputnik-dao.near"
SIGNER="aurealis.near"
CONTRACT="boostfarm.ref-labs.near"
AMOUNT_LP="36345742222015173627"
# amount of lp tokens to stake, can be queried with `get_pool_shares`
echo '{"receiver_id": "'$CONTRACT'","token_id": ":1395","amount": "'$AMOUNT_LP'","msg": "\"Free\""}' | base64
near contract call-function \
  as-transaction $MULTISIG add_proposal \
  file-args ref-3-stake-liquidity.json \
  prepaid-gas '100.0 Tgas' attached-deposit '0.1 NEAR' \
  sign-as $SIGNER network-config mainnet sign-with-keychain send
```

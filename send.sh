# reference https://developer.github.com/webhooks/

# generate a guid
guid=$(uuidgen)

event=push

# given the secret do sha1
secret=thisisaverysecret

mo events/$event.json.mo > payload.json

payload=payload.json

export GITHUB_EVENT=$event

export GITHUB_DELIVERY=$guid

# strip new lines from the payload to computer the correct signature
# this is because curl will strip those before sending the data
signature=$(cat $payload | tr -d '\n' |  openssl dgst -sha1 -hmac $secret | cut -d" " -f2)

export GITHUB_SIGNATURE=$signature

header=$(mktemp)

mo headers.mo > "$header"

curl -v --data @$payload -H @"$header" -X POST localhost:9000/hooks/redeploy-website-webhook

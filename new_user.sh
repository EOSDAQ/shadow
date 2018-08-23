user=$1
curl -X POST \
  http://127.0.0.1:18889/api/v1/acct/user \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'postman-token: 0e3331fb-867d-dd03-b2d0-24d4f89024e6' \
  -d '{
    "accountName":"'$user'",
    "email":"newro@eosdaq.com",
    "emailHash" : "abcdef"
}'
curl -X POST \
  http://127.0.0.1:18889/api/v1/acct/user/$user/confirmEmail \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/json' \
  -H 'postman-token: 74f0b313-09e4-b37e-2ce8-6fb5f69f046f' \
  -d '{
    "email":"newro@eosdaq.com",
    "emailHash" : "abcdef"
}'
key=`curl -X POST http://10.100.100.2:18889/api/v1/acct/user/$user/newOTP -H 'cache-control: no-cache' -H 'content-type: application/json' -H 'postman-token: e09a9f97-403e-f340-9911-df10612b0f5c' 2>&1 | grep OTPKey | awk -F'"' '{ print $4}'`
echo "key is " $key
code=`oathtool --base32 --totp "$key" -d 6`
curl -X POST http://10.100.100.2:18889/api/v1/acct/user/$user/validateOTP \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H 'postman-token: 5dd3cc05-5d0f-0a64-22b7-aa25adbb694b' \
  -d code=$code

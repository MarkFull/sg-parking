# curl https://data.gov.sg/dataset/bcd27325-b84c-45be-b13e-4d55e89f6cf7/download -L -o ura.zip && open ura.zip
# curl https://data.gov.sg/dataset/84e7dcf3-d1df-4870-be50-76cb29b644bc/download -L -o ura-capacity.zip && open ura-capacity.zip
curl -X GET \
  https://www.ura.gov.sg/uraDataService/insertNewToken.action \
  -H 'AccessKey: ' \
  -H 'cache-control: no-cache'
curl -X GET \
  'https://www.ura.gov.sg/uraDataService/invokeUraDS?service=Car_Park_Details' \
  -H 'AccessKey: ' \
  -H 'Token: token-here' \
  -o ura.json

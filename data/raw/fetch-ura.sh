# curl https://data.gov.sg/dataset/bcd27325-b84c-45be-b13e-4d55e89f6cf7/download -L -o ura.zip && open ura.zip
# curl https://data.gov.sg/dataset/84e7dcf3-d1df-4870-be50-76cb29b644bc/download -L -o ura-capacity.zip && open ura-capacity.zip
curl -X GET \
  https://www.ura.gov.sg/uraDataService/insertNewToken.action \
  -H 'AccessKey: c487282e-9e0d-4bcb-87c8-e47e9445d9f0' \
  -H 'cache-control: no-cache'
curl -X GET \
  'https://www.ura.gov.sg/uraDataService/invokeUraDS?service=Car_Park_Details' \
  -H 'AccessKey: c487282e-9e0d-4bcb-87c8-e47e9445d9f0' \
  -H 'Token: cbtcJA7k3R8veB658cNR0x7b4c-@46+StXRSj39+U7e87vj4bXPdeXdKM9RD2Bux7eF589Fd2JGu4S7cbfuJJfTw5T44Q5uYUuPE' \
  -o ura.json

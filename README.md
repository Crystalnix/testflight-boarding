# testflight-boarding

#### Small service for sending invitations to iOS application beta testing.

This project uses Ruby and written on Sinatra framework.

### iTunesConnect
Note that iTunes connect user must have Administrator or Application Manager role.

### Deployment
To deploy the application you have to specify the set of env variables:
- `APP_RAVEN_DSN` (it required for logging via Raven)
- `ITC_USER` (iTunes connect Apple ID)
- `ITC_PASSWORD` (iTunes connect password)
- `ITC_APP_ID` (iTunes connect application id)
- `ITC_APP_TESTER_GROUP` (iTunes connect beta testers group id)

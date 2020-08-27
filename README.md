# princesa

![princesa crown](./assets/docs/images/princess_crown.jpeg)

## testing
```
stack test
```
## running
### fire up infrastructure
```
docker-compose -f ./assets/docker-compose.yml up -d
```
#### access db
```
docker exec -it postgres_container psql -U princesa
```
### fire up application
```
stack run -- "--appMode=Cli"
stack run -- "--appMode=Normal"
```
## building
```
stack build
```
## cleaning
```
stack clean
```
## dev playground
```
stack ghci
```
## dev hot reload
```
ghcid
```

## API DOC => @TODO servant-doc
![princesa title](./assets/docs/images/princess_title.jpeg)
## Jobs
### get jobs > [Get /jobs]
```
curl http://localhost:8081/jobs
```
### create job > [POST /jobs]
```
curl -X POST http://localhost:8081/jobs -H 'Content-Type: application/json' -d '{"jobId": { "getJobId" : 1}, "jobDescription": "hola princesa"}'
```
### find job > [Get /jobs/:jobid]
```
curl http://localhost:8081/jobs/1
```

## Candidates
### get candidates > [Get /candidates]
```
curl http://localhost:8081/candidates
```
### create candidate > [POST /candidates]
```
curl -X POST http://localhost:8081/candidates -H 'Content-Type: application/json' -d '{"candidateId": { "getCandidateId" : 1}, "candidateDescription": "hola princesa"}'
```
### find candidate > [Get /candidates/:candidateid]
```
curl http://localhost:8081/candidates/1
```

![princesa image](./assets/docs/images/princess_image.jpeg)
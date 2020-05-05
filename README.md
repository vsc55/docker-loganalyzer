# Docker LogAnalyzer
Docker webapp [Adiscon LogAnalyzer](https://loganalyzer.adiscon.com/)
* Version: 4.1.10

## Create Container:
```bash
docker create --name LogAnalyzer --restart always -p 80:80/tcp -v /doker/data:/data vsc55/loganalyzer:latest
docker container start LogAnalyzer
```

## Run Container:
```bash
docker run -d --restart always -p 80:80/tcp -v /doker/data:/data vsc55/loganalyzer:latest
```

# Links:
Docker Hub: https://hub.docker.com/r/vsc55/loganalyzer

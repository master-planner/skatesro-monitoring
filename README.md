# Getting started

```bash
docker build -t skates-monitoring:1.2.0 -f monitoring.dockerfile .
docker run -it --rm -e AWS_ACCESS_KEY_ID=changeme -e AWS_SECRET_ACCESS_KEY=changeme skates-monitoring:1.1.0
```
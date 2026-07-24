# Seldon Custom model

Sandbox project for testing building a seldon class, and DockerImage.

This build wraps the seldon-core within the image.

This image is them used for the seldon Deployment.

## Install all packages

```bash
uv sync --locked
```


### TODO

* Decrease the final image size (1.5GB now).


Sample call to this model:

```bash
curl -v http://localhost:9000/api/v1.0/predictions \
    -H 'Content-Type: application/json' \
    -d '{"data": {"names": ["input"], "ndarray": ["data"]}}'
```

Port forward at the cluster:

```bash
k port-foward service/seldon-demo-model-classifier-classifier 9000:9000
```

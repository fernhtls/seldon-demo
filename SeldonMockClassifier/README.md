# Seldon Custom model

Sandbox project for testing building a seldon class, and DockerImage.

This build wraps the seldon-core within the image.

This image is them used for the seldon Deployment.

## Install all packages

```bash
uv sync --locked
```

## Build the image

```bash
podman build . -t seldon-mock-model:v1.0.0
```

## Post deployment example calls:

Sample call to this model:

```bash
curl -v http://localhost:9000/api/v1.0/predictions \
-H 'Content-Type: application/json' \
-d '{"data": {"names": ["sepal_length", "sepal_width", "petal_length", "petal_width"], "ndarray": [[5.1, 3.5, 1.4, 0.2]]}}'
```

```json
{"data":{"names":["t:0","t:1","t:2","t:3"],"ndarray":[[0.0,0.9815808136233183,0.0184191718806636,1.4496018178950113e-08]]},"meta":{"requestPath":{"classifier":"docker.io/library/seldon-mock-model:v1.0.0"}}}
```

```bash
curl -v http://localhost:9000/api/v1.0/predictions \
-H 'Content-Type: application/json' \
-d '{"data": {"names": ["sepal_length", "sepal_width", "petal_length", "petal_width"], "ndarray": [[0.1, 1.5, 5.4, 7.2]]}}'
```

```json
{"data":{"names":["t:0","t:1","t:2","t:3"],"ndarray":[[2.0,3.706771757685523e-12,2.0320340153976877e-10,0.9999999997930897]]},"meta":{"requestPath":{"classifier":"docker.io/library/seldon-mock-model:v1.0.0"}}}
```

## Minikube port-forward

Port forward at the cluster:

```bash
k port-foward service/seldon-demo-model-classifier-classifier 9000:9000
```

### TODO docker image improvements

* Decrease the final image size (1.5GB now).
* The image size is quite big, with most mlops images, that's one hte main issues.
* Image harden is not done, so we should be shipping binaries and using a harden `server` image, without terminal / tools and so on.

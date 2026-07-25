# Seldon Custom model

Sandbox project for testing building a seldon class, and DockerImage.

This build wraps the seldon-core within the image.

This image is them used for the seldon Deployment.

It's a multi-stage image, with harden distroless python.

## Install all packages

```bash
uv sync --locked
```

## Generate the model.joblib file

Navigate now to the directory `/training-and-model-package`.

Let's run the python `training` and `joblib` generator:

```bash
python training-and-model-package/generate_model.py
```

Or if you didn't source your new python venv, you can run with uv:

```bash
uv run python training-and-model-package/generate_model.py
```

This should generate a new `joblib` package file under the same directory: `/training-and-model-package/model.joblib`.

This package is reffered in `Dockerfile`, so if you generate the file in a different location, copy it to this same location or change the `Dockerfiile`.

```docker
...
COPY --chown=nonroot:nonroot --chmod=744 MyModel.py ./training-and-model-package/model.joblib .
...
```

## Build the image

```bash
podman build . -t seldon-mock-model:v1.0.0
```

We can run the model even though it's not deployed to `k8s`, so nothing injected from `seldon-core-controller`.

Run exposing `9000` port and do some test calls:

```bash
podman run -p 9000:9000 seldon-mock-model:v1.0.0
```

Example call:

```bash
curl -v http://localhost:9000/api/v1.0/predictions \
-H 'Content-Type: application/json' \
-d '{"data": {"names": ["sepal_length", "sepal_width", "petal_length", "petal_width"], "ndarray": [[5.1, 3.5, 1.4, 0.2]]}}'
```

```json
{"data":{"names":["t:0","t:1","t:2","t:3"],"ndarray":[[0.0,0.9815808136233183,0.0184191718806636,1.4496018178950113e-08]]},"meta":{}}
```

**Ps: On stopping the container, the pod still stays running, probably some master process is still up and running and the worker was killed (you'll see some log messages). If you see that the process is haning or not stopping at all just `podman kill <container-id>`. The stop/restart process on kubernetes with the seldon-core-controller works fine, so prabably the side-car seldon-core has some better control on the components and the main wrapper, and how to stop it properly.**

## Post deployment example calls (kubernetes calls with port-forward):

Kubernetes port-forward:

```bash
kubectl -n seldon-models port-forward services/seldon-demo-model-classifier-classifier 9000:9000
```
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

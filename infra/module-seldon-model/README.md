# Seldon Models

Module to deploy Seldon ML models.

It's mainly creating a CRD for seldon called `SeldonDeployment`.

Seldon inspects all namespaces with these resources and creates a kubernetes Deployment.

## Main variables / arguments to pass

**Ps: Variables without default values are mandatory**

| Variable | Description | Default |
| --- | --- | --- |
| `namespace` | Namespace used to deploy the SeldonModels. | - |
| `name` | Name of the deployment / model to be created. | - |
| `hpa_max_replicas` | Max replicas scaled by the HPA. | 3 |
| `hpa_min_replicas` | Min replicas maintained by the HPA. | 1 |
| `hpa_avg_cpu` | HPA cpu average threshold to scale up, so add new pods. | 70 |
| `hpa_avg_mem` | HPA memory average threshold to scale up, so add new pods. | 70 |
| `termination_grace_secs` | Pod termination grace period in seconds. | 1 |
| `container_name` | Container name that will run the model. | `classifier` |
| `resources_limits` | See resources documentation / example below. | `Check the variable here in the module.` |
| `resources_requests` | See resources documentation / example below. | `Check the variable here in the module.` |
| `graph` | See graph documentation / example below. | - |
| `image` | See image documentation / example below. | - |
| `node_affinity_label_key` | The node affinity label used to create the pods in the correct node pool. **DO NOT CHANGE IT**. | `purpose` |
| `node_affinity_label_value` | The node affinity value used to create the pods in the correct node pool. **DO NOT CHANGE IT**. | `seldon-models` |

### Resources

As we are using hpa (horizonal pod scalability), we need to specify the resources that the pods will be using like cpu / memory limits and requests.

As an example:

```
  resources_limits = {
    limits = {
      cpu    = "0.2"
      memory = "512Mi"
    }
  }
  resources_requests = {
    limits = {
      cpu    = "0.1"
      memory = "256Mi"
    }
  }
```

The module will yaml encode the var and inject into the CRD creation.

### Graph spec

A SeldonDeployment is a JSON or YAML file that allows you to define your graph of component images and the resources each of those images will need to run (using a Kubernetes PodTemplateSpec).

It's mainly the description on how we want the seldon core engine to manage / generate the endpoints for the given model.

As explained in the image spec, we can have the entire inference coming from a `modelUri` in GCS, or we can specificy whatever we need.

**The current implementation is only doing simple inferences. If we need more complex cases, with several endpoints, containers and etc
we will need to refactor the module to accomodate such changes, in this case, we would need to just be receiving almost the whole yaml / variable to be encoded to yaml, and embeded into the CRD.**

Inference graph docs:
* https://docs.seldon.io/projects/seldon-core/en/v1.1.0/graph/inference-graph.html#inference-graph).
* https://docs.seldon.io/projects/seldon-core/en/latest/servers/custom.html

### Image spec

In certain cases seldon provides us with a model specification, that can be passed to the `graph` spec as the argument `modelUri`

**In these cases, just pass the `image_spec` variable as `null`**

But when developing our own internal models, with custom libraries and logic, we will be building docker images.

For those cases we need to pass to the seldon deployment CRD the correct image and pull policy.

For those cases we can pass a variable / argument as the following:

```yaml
image_spec = {
    image = "eu.gcr.io/mymodel-seldon:0.1"
    imagePullPolicy = ""IfNotPresent"
}
```
The `image` argument will be our image uri to our Google Cloud Containers, but it can be a local `minikube` uri for the image as well, after building it and loading.

Images will need to be build for each environment (As we can test and tag images for each environment).

The `imagePullPolicy` doc can be checked [here](https://kubernetes.io/docs/concepts/containers/images/#updating-images).

# Testing your model with OPEN API / Swagger

We are using Ambassador as our ingress for seldon.

For testing your model when deployed port-forward the port `8443` from the ambassador ingress deployment:

```bash
kubectl -n ambassador port-forward deployment/yc-ml-ambassador-ingress 8443
```
Open your browser on `https://localhost:8443/seldon/<namespace>/<model>/api/v1.0/doc/`

**Ps: The swagger page depends on a gateway installation, like Ambassador, it's not seldon feature.**

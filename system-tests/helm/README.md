# Helm Charts for MVD
We have demonstrated a containerized deployment of the MVD in [system-tests/README.md](../README.md). In this section, 
we will be deploying the MVD using [kubernetes](https://kubernetes.io/docs/home/).
In addition, we have used [Helm](https://helm.sh/docs/) to manage all the Kubernetes YAML files.
The [./helm-charts](./helm-charts) folder contains the helm charts of the kubernetes components.


## Install Kind and Helm
For the deployment purpose we need,
* a kubernetes cluster, and
* helm installed

We have used [kind](https://kind.sigs.k8s.io/), to set up a local kubernetes cluster. Follow the kind official [user guide](https://kind.sigs.k8s.io/docs/user/quick-start/)
to install `kind` in your local environment.
Also, we will be using Helm, which can be installed following the [instructions](https://helm.sh/docs/intro/install/) provided in their official website.
Once they are installed properly, we can start with the cluster creation.

## MVD build tasks
Build `MVD` by running the following command from the root of the `MVD` project folder:
```bash
./gradlew build 
```
Then execute the following commands from the `MVD` root folder, to build the connector JAR and registration service JAR:
```bash
./gradlew -DuseFsVault="true" :launchers:connector:shadowJar
./gradlew -DuseFsVault="true" :launchers:registrationservice:shadowJar
```


## MVD UI
Clone the repository [edc-dashboard ](https://github.com/FraunhoferISST/edc-dashboard) and checkout
branch `helm_dashboard_changes`.

## Create Cluster
- Navigate to the helm directory ([/system-tests/helm](../../system-tests/helm)), `cd system-tests/helm/`

- Set the environment variable `MVD_UI_PATH` to the path of the DataDashboard repository.
```bash
export MVD_UI_PATH="/path/to/mvd-datadashboard"
```
- Run the following command to build the necessary images from [docker-compose.yml](./docker-compose.yml)
```bash
docker compose -f docker-compose.yml build
```
- Execute the following script to create a kubernetes cluster.
```bash
./kind-run.sh
```
[kind-run.sh](./kind-run.sh) is basically a bash script containing all the commands to,
* create a cluster with the configuration defined in [kind-cluster.yaml](./kind-cluster.yaml) file
* load the docker images to cluster
* apply ingress


## Run MVD
Execute the following command to check if ingress is ready,
```bash
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller
```
If condition is met, then execute the following command,
```bash
./run-mvd.sh
```
The file [run-mvd.sh](./run-mvd.sh) contains commands to install helm charts that will deploy the kubernetes
components for mvd in our cluster.


[//]: # (todo: some command to wait for the cli-tools to complete the task)

Check The container `cli-tools` if it has registered all participants successfully. Run `kubectl get pods`. Copy the
name of the `cli-tools` pod. Then execute `kubectl logs <cli-tools-pod>`. If it shows all the participants
(e.g. `company1`, `company2`, `company3`) are `ONBORDED`, then it has successfully registered all the participants.


### Company Data-dashboards
All the company-dashboards can be accessed with the following URLs,
*   company1-dashboard: <http:/localhost/company1-datadashboard/>
*   company2-dashboard: <http:/localhost/company2-datadashboard/>
*   company3-dashboard: <http:/localhost/company3-datadashboard/>

It may take some time initially to load all the data. After everything is loaded properly,
each company will have two assets in `assets` tab. Company1 and company2 will have six
assets in `catalog browser`. Company3 will display three assets in its `catalog browser`.


### Run A Standard Scenario Locally

1. Create a test document for company1:

    - Follow the instructions in `Run A Standard Scenario Locally` section of the root [README.md](https://github.com/FraunhoferISST/edc-mvd/blob/cc5cc02d8ca0ee69052ca765f611abe3ad82f5f8/README.md) file, to connect
      to storage account of company1.
    - Replace the `localhost:10000` with `localhost:31000`. If you are using a connection string,
      then use:
   ```bash
    DefaultEndpointsProtocol=http;AccountName=company1assets;AccountKey=key1;BlobEndpoint=http://127.0.0.1:31000/company1assets;
   ```

    - Follow the instructions there to create a container and to add a test file with name `text-document.txt`.

2. Request the file from company2:

    * Open the dashboard of the company2 <http:/localhost/company2-datadashboard/>
    * Go to `Catalog Browser` and select `Negotiate` on asset `test-document_company1`
    * Go to `Contracts` and click `Transfer` on the negotiated contract
    * Select `AzureStorage` from the dropdown and `Start transfer`
    * Wait for transfer complete message

3. Verify if the transfer was successful:
    * Connect to storage account of company2. The process will be same as company1. 
   Use account name `company2assets`
      and account key `key2`. If using a connection string, then use:
   ```bash
   DefaultEndpointsProtocol=http;AccountName=company2assets;AccountKey=key2;BlobEndpoint=http://127.0.0.1:31000/company2assets;
   ```

    * If the transfer is successful, then there will be a new container in `Blob containers` with files
      `test-document.txt` and `.complete`
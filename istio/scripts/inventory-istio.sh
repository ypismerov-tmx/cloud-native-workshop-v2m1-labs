git pull
oc apply -f - <<EOF
apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  name: default
  namespace: user9-istio-system 
spec:
  members:
    - user9-coolstore-dev
EOF
oc patch dc inventory -n user9-coolstore-dev --patch '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject":"true"}}}}}' --type=merge
oc apply -n user9-coolstore-dev -f $CHE_PROJECTS_ROOT/cloud-native-workshop-v2m1-labs/istio/inventory-inventory-gateway.yml
oc patch -n user9-coolstore-dev virtualservice/inventory --type='json' -p '[{"op":"add","path":"/spec/hosts","value": ["istio-ingressgateway-user9-istio-system.apps.cluster-4k8mv.4k8mv.sandbox1663.opentlc.com"]}]'
oc apply -n user9-coolstore-dev -f $CHE_PROJECTS_ROOT/cloud-native-workshop-v2m1-labs/istio/inventory-destination-rule-all.yaml

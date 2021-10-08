git pull
oc apply -f - <<EOF
apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  name: default
  namespace: user6-istio-system 
spec:
  members:
    - user6-inventory-dev
EOF
oc patch -n user6-coolstore-dev coolstore --patch '{"spec":{"template":{"metadata":{"annotations":{"sidecar.istio.io/inject:"true"}}}}' --type=merge
oc apply -n user6-coolstore-dev -f $CHE_PROJECTS_ROOT/cloud-native-workshop-v2m1-labs/istio/coolstore-inventory-gateway.yml
oc patch -n user6-coolstore-dev virtualservice/inventory --type='json' -p '[{"op":"add","path":"/spec/hosts","value": ["istio-ingressgateway-user6-istio-system.apps.cluster-4k8mv.4k8mv.sandbox1663.opentlc.com"]}]'
oc apply -n user6-coolstore-dev -f $CHE_PROJECTS_ROOT/cloud-native-workshop-v2m1-labs/istio/coolstore-destination-rule-all.yaml

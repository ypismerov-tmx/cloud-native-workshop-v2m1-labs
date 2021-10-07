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
oc apply -n user6-coolstore-dev -f $CHE_PROJECTS_ROOT/cloud-native-workshop-v2m1-labs/istio/inventory-gateway.yml
oc patch -n user6-inventory-dev virtualservice/inventory --type='json' -p '[{"op":"add","path":"/spec/hosts","value": ["istio-ingressgateway-user6-istio-system.apps.cluster-4k8mv.4k8mv.sandbox1663.opentlc.com"]}]'
